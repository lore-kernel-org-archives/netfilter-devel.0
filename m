From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iproute2: use automake
Date: Mon, 15 Nov 2010 23:30:46 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011152327430.3784@obet.zrqbmnf.qr>
References: <1289859785-3098-1-git-send-email-jengelh@medozas.de> <20101115142600.66a7e3c3@nehalam>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: stephen.hemminger@vyatta.com, netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58084 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756050Ab0KOWar (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:30:47 -0500
In-Reply-To: <20101115142600.66a7e3c3@nehalam>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-11-15 23:26, Stephen Hemminger wrote:

>On Mon, 15 Nov 2010 23:23:02 +0100
>Jan Engelhardt <jengelh@medozas.de> wrote:
>
>> 
>> The following changes since commit 3f5c1a01e6bc15593635705aa0b19dcac965be26:
>> 
>>   Update to 2.6.36 headers (2010-10-20 17:38:04 -0700)
>> 
>> are available in the git repository at:
>>   git://dev.medozas.de/iproute2 master
>> 
>> Jan Engelhardt (2):
>>       Fix up permissions on scripts
>>       build: start using Automake for building
>
>NAK. I agree with Alexey, automake is an abomination.

Not using something standardized is an affront to distributors,
and the build instructions just a sore for the eye:

# shortened
%build
make %{?_smp_mflags} LIBDIR=/usr/share CCOPTS="-D_GNU_SOURCE 
$RPM_OPT_FLAGS -Wstrict-prototypes -fPIC"

%install
install -d $RPM_BUILD_ROOT/{etc/,sbin/,usr/{sbin,share/man/man{3,8}}}
install -d $RPM_BUILD_ROOT/{/usr/include,%_libdir,/usr/share}
make install DESTDIR=$RPM_BUILD_ROOT LIBDIR=/usr/share
mv $RPM_BUILD_ROOT/usr/sbin/ip $RPM_BUILD_ROOT/sbin


LIBDIR=/usr/share, yeah I can see the flaw in that. But of course that 
is not the only one.

