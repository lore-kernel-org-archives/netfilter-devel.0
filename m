From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: Performance issue due to constant "modprobes"
Date: Thu, 14 Apr 2011 00:07:31 -0700
Message-ID: <BANLkTincEe0_Fj89wJecgR5Up7CvS6ERtw@mail.gmail.com>
References: <4D9E45C2.7030805@wildgooses.com>
	<BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com>
	<4D9F41BA.1060509@wildgooses.com>
	<alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr>
	<4D9F98D3.5070802@wildgooses.com>
	<alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr>
	<4DA0C402.1090809@wildgooses.com>
	<alpine.LNX.2.01.1104100022500.27387@obet.zrqbmnf.qr>
	<BANLkTik3=XWQHH9au7434RTJuf_Rg2sYSw@mail.gmail.com>
	<4DA58A73.9030308@wildgooses.com>
	<alpine.LNX.2.01.1104131406130.25539@obet.zrqbmnf.qr>
	<4DA59881.1050501@wildgooses.com>
	<alpine.LNX.2.01.1104131441520.25539@obet.zrqbmnf.qr>
	<4DA5D346.5030303@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64478 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab1DNHHc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:07:32 -0400
Received: by wwa36 with SMTP id 36so1635167wwa.1
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2011 00:07:31 -0700 (PDT)
In-Reply-To: <4DA5D346.5030303@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Okay, so I've been doing some experimentation.
Based on this, my current belief is that ip6?tables will only attempt
to ever load either ip_tables or ip6_tables.

Indeed some greps on my almost pristine iptables git master source tree show:

$ egrep -r xtables_insmod .
./xtables.c:int xtables_insmod(const char *modname, const char
*modprobe, bool quiet)
./xtables.c:            ret = xtables_insmod(afinfo->kmod, modprobe, quiet);
./include/xtables.h.in:extern int xtables_insmod(const char *, const
char *, bool);

So xtables_insmod() is declared in xtables.h, defined in xtables.c and
called from one spot in xtables.c (within xtables_load_ko),
and afinfo->kmod will be either "ip_tables" or "ip6_tables" (depending
on whether afinfo is for AF_INET or AF_INET6).

$ egrep -r xtables_load_ko .
./ip6tables-save.c:
xtables_load_ko(xtables_modprobe_program, false);
./xtables.c:int xtables_load_ko(const char *modprobe, bool quiet)
./xtables.c:    xtables_load_ko(xtables_modprobe_program, true);
./iptables.c:   if (!*handle &&
xtables_load_ko(xtables_modprobe_program, false) != -1)
./ip6tables.c:  if (!*handle &&
xtables_load_ko(xtables_modprobe_program, false) != -1)
./iptables-save.c:
xtables_load_ko(xtables_modprobe_program, false);
./ip6tables-restore.c:
xtables_load_ko(xtables_modprobe_program, false);
./include/xtables.h.in:extern int xtables_load_ko(const char *, bool);
./iptables-restore.c:
xtables_load_ko(xtables_modprobe_program, false);

Which shows that ip6?tables{,-restore,-save} can all cause the load to
happen, as well as the revision compatibility checking code in
xtables.c.

Either way, the userspace iptables will only ever directly call
modprobe ip_tables or modprobe ip6_tables.
This is consistent with what I'm seeing in tests.

This can be disabled with -M '' parameter.
ie. "iptables -M '' -j SET --help" does not result in the iptables
userspace component loading any modules.

However, this does not prevent the kernel from loading modules.
And the kernel will attempt to load modules for any matches that we
attempt to access that it does not know about.

This should not be a problem with an iptables userspace once my patch
has been applied, since the kernel won't load modules we (userspace)
don't attempt to use, and once loaded they'll stay.  Since we can
assume that userspace doesn't attempt to use modules the kernel
doesn't have, we should relatively quickly reach steady state were all
modules userspace cares to use are already loaded, and no further load
attempts are issued.

Basically I believe that an iptables userspace binary with my patch,
called with -M '' should quickly settle into a mode were no further
modprobes (userspace or kernel initiated) ever happen.

The only exception is if you attempt to use iptables extensions which
aren't compiled for the kernel, but iptables-save won't do that, and
iptables-restore would fail if it did that (since obviously the
extension wouldn't exist and thus wouldn't be restorable).  Hence this
is not an exciting case (it's an error scenario which you shouldn't be
triggering during normal operation).

Ed: could you verify this hypothesis?  ie. that iptables with my
patch, when called with -M '' doesn't trigger repeated modprobes of
the same modules?

[I've verified that this is the behaviour I'm seeing, ie.
every invocation of "iptables -M '' -j SET" triggers two loads of
ipt_SET (which fails, since the kernel is to old), but only the first
invocation of "iptables -M '' -j CONNMARK" triggers a single load of
ipt_CONNMARK, afterwards further invocations don't trigger any module
loads, since the first load succeeded]

-- Maciej


PS. Alternatively one could replace the modprobe binary with a script
which does nothing for certain modules.
ie. something along the lines of:

cat <<EOF > /sbin/modprobe.skip
#!/bin/sh
[[ "$*" == "-q -- ipt_SET" ]] && exit 0
exec /sbin/modprobe "$@" ;;
EOF
chmod a+x /sbin/modprobe.skip
echo "/sbin/modprobe.skip" > /proc/sys/kernel/modprobe

-- Maciej Z.
