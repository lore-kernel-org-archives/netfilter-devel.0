From: Maximilian Wilhelm <max@rfc2324.org>
Subject: Conntrackd segfaults
Date: Mon, 28 Apr 2008 23:43:30 +0200
Message-ID: <20080428214328.GB17500@outback.rfc2324.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rfc2324.org ([89.149.194.216]:50260 "EHLO rfc2324.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965640AbYD1WLM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:11:12 -0400
Received: from max by rfc2324.org with local rfc2324.org Mailserver
	id 1Jqb8F-000641-2A
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Apr 2008 23:43:33 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi!

After updating my firewalls to Debiab Etch + conntrackd (R.I.P. ct_sync=
!)
we saw conntrackd segfaulting on one of the machines. (I used
backported packages from Debian unstable for conntrackd + the two libra=
ries.)

We're using ALARM base synchronization.

This came out by hunting the bug:

| root@fw1[~]$ gdb /usr/sbin/conntrackd
| GNU gdb 6.4.90-debian
| Copyright (C) 2006 Free Software Foundation, Inc.
| GDB is free software, covered by the GNU General Public License, and =
you are
| welcome to change it and/or distribute copies of it under certain con=
ditions.
| Type "show copying" to see the conditions.
| There is absolutely no warranty for GDB.  Type "show warranty" for de=
tails.
| This GDB was configured as "i486-linux-gnu"...Using host libthread_db
| library "/lib/tls/libthread_db.so.1".
|=20
| (gdb) run
| Starting program: /usr/sbin/conntrackd
|=20
| Program received signal SIGSEGV, Segmentation fault.
| 0x00000000 in ?? ()
| (gdb) bt
| #0  0x00000000 in ?? ()
| #1  0xb7f21b89 in nfct_get_attr (ct=3D0x80f31a0, type=3DATTR_MASTER_I=
PV4_SRC) at api.c:292
| #2  0xb7f21c04 in nfct_get_attr_u32 (ct=3D0x80f31a0, type=3DATTR_MAST=
ER_IPV4_SRC) at api.c:339
| #3  0x08050cdc in __build_u32 (ct=3D0xb7f2a6a0, pld=3D0x25, attr=3D5)=
 at build.c:56
| #4  0x0805120e in build_netpld (ct=3D0x80f31a0, pld=3D0xbfa42254, que=
ry=3D0) at build.c:119
| #5  0x0804e9ad in mcast_send_sync (u=3D0x80be26c, ct=3D0x80f31a0, que=
ry=3D0) at sync-mode.c:346
| #6  0x0804caee in event_handler (type=3DNFCT_T_NEW, ct=3D0x80f31a0, d=
ata=3D0x0) at netlink.c:66
| #7  0xb7f21d2e in __callback (nlh=3D0xbfa43380, nfa=3D0xbfa432c0, dat=
a=3D0x807a9a8) at callback.c:33
| #8  0xb7f16d1b in nfnl_step (h=3D<value optimized out>, nlh=3D0xbfa43=
380) at libnfnetlink.c:1289
| #9  0xb7f16ef6 in nfnl_process (h=3D0x807a7f8, buf=3D0xbfa43380 "=EF=BF=
=BD, len=3D192) at libnfnetlink.c:1334
| #10 0xb7f18278 in nfnl_catch (h=3D0x807a7f8) at libnfnetlink.c:1487
| #11 0xb7f21153 in nfct_catch (h=3D0x807a940) at api.c:588
| #12 0x0804a71d in run () at run.c:195
| #13 0x0804a1bd in main (argc=3D1, argv=3DCannot access memory at addr=
ess 0x9
| ) at main.c:259
| (gdb) The program is running.  Exit anyway? (y or n) y

The problem seems to be that in

 libnetfilter-conntrack /src/conntrack/getter.c

in line 225

 get_attr get_attr_array[]

has no entry for

 ATTR_MASTER_IPV4_SRC

Maybe anybody who's in this magic can fix it :)

Ciao & Thanks
Max
--=20
	Follow the white penguin.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
