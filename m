From: Alex Ivanov <handler@ua.fm>
Subject: install patch-o-matic on fedora10
Date: Wed, 28 Jan 2009 16:59:42 +0200
Message-ID: <E1LSBtG-0006O1-2y@web07.mi6.kiev.ua>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=windows-1251
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from web01.mi6.kiev.ua ([91.198.36.2]:35001 "EHLO web01.mi6.kiev.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbZA1QIQ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Jan 2009 11:08:16 -0500
Received: from web07.mi6 ([10.0.0.19] helo=web07.mi6.kiev.ua)
	by web01.mi6.kiev.ua with esmtp (Exim 4.69)
	(envelope-from <handler@ua.fm>)
	id 1LSBtJ-0005a2-CT
	for netfilter-devel@vger.kernel.org; Wed, 28 Jan 2009 16:59:45 +0200
Received: from web by web07.mi6.kiev.ua with local (Exim 4.69)
	(envelope-from <handler@ua.fm>)
	id 1LSBtG-0006O1-2y
	for netfilter-devel@vger.kernel.org; Wed, 28 Jan 2009 16:59:42 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello!
I download patch-o-matic-20031219.tar.bz2, unpack it
To do:
=2E/runme extra
Hey! KERNEL_DIR is not set.
Where is your kernel? [/usr/src/linux]  /usr/src/kernels/2.6.27.5-117.f=
c10.i686/
Testing... nth.patch ALREADY APPLIED (0 rejects out of 2 hunks).
The base/nth patch:
   Author: Fabrice MARIE <fabrice@netfilter.org>
   Status: Works For Me.
  =20
   This option adds CONFIG_IP_NF_MATCH_NTH, which supplies a match
   module that will allow you to match every Nth packet encountered.
   By default there are 16 different counters that can be used.
  =20
   This match functions in one of two ways
=2E..
Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] y
Testing patch base/nth.patch...
Warning - no help text file could be found in either
/usr/src/kernels/2.6.27.5-117.fc10.i686//net/ipv4/netfilter/Config.help
or /usr/src/kernels/2.6.27.5-117.fc10.i686//Documentation/Configure.hel=
p
fgrep: /usr/src/kernels/2.6.27.5-117.fc10.i686//net/ipv4/netfilter/Conf=
ig.in: No such file or directory
Could not find place to slot in Config.in line
TEST FAILED: patch NOT applied.

but instead Config.in I have /usr/src/kernels/2.6.27.5-117.fc10.i686/ne=
t/ipv4/netfilter/Kconfig file
How I could change file name and instal this patch?

-- =F0=E5=EA=EB=E0=EC=E0 ----------------------------------------------=
-------------
=CF=EE=F2=EE=F0=EE=EF=E8=F1=FC =E7=E0=F0=E5=E3=E8=F1=F2=F0=E8=F0=EE=E2=E0=
=F2=FC =F1=E0=EC=FB=E9 =EA=EE=F0=EE=F2=EA=E8=E9 =EF=EE=F7=F2=EE=E2=FB=E9=
 =E0=E4=F0=E5=F1 @i.ua
http://mail.i.ua/reg - =E8 =EF=EE=EB=F3=F7=E8 1Gb =E4=EB=FF =F5=F0=E0=ED=
=E5=ED=E8=FF =EF=E8=F1=E5=EC

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
