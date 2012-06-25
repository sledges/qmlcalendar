# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.24.1
# 

Name:       qmlcalendar

# >> macros
# << macros

Summary:    Calendar application made with QML
Version:    0.15
Release:    1
Group:      Applications/System
License:    BSD
URL:        https://github.com/nemomobile/qmlcalendar/
Source0:    qmlcalendar-%{version}.tar.gz
Source100:  qmlcalendar.yaml
Requires:   libdeclarative-organizer
Requires:   mkcal >= 0.3.11-2
Requires:   systemd
Requires(preun): systemd
Requires(post): systemd
Requires(postun): systemd
BuildRequires:  pkgconfig(QtDeclarative)
BuildRequires:  pkgconfig(QtOrganizer)
BuildRequires:  qt-components-devel
BuildRequires:  desktop-file-utils

%description
Calendar application written using QML.


%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qmake 

make %{?jobs:-j%jobs}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake_install

# >> install post
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%preun
systemctl stop calenderr.service
# >> preun
systemctl stop calenderr.service
systemctl disable calenderr.service
# << preun

%post
systemctl daemon-reload
systemctl reload-or-try-restart calenderr.service
# >> post
systemctl --system daemon-reload
systemctl start calenderr.service
systemctl enable calenderr.service
# << post

%postun
systemctl daemon-reload
# >> postun
systemctl --system daemon-reload
# << postun

%files
%defattr(-,root,root,-)
/lib/systemd/system/calenderr.service
/opt/%{name}
%{_datadir}/icons/hicolor/80x80/apps/*.png
%{_datadir}/applications/*.desktop
# >> files
# << files
