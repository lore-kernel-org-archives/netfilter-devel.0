From: Victor Stinner <victor.stinner@inl.fr>
Subject: iptables-save and /proc/net/ip_tables_names
Date: Thu, 18 Oct 2007 16:16:00 +0200
Message-ID: <200710181616.00944.victor.stinner@inl.fr>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_gq2FHD5iuRrLj7F"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp6-g19.free.fr ([212.27.42.36]:55418 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764006AbXJROQE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2007 10:16:04 -0400
Received: from smtp6-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp6-g19.free.fr (Postfix) with ESMTP id 98EAA5FE7A
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Oct 2007 16:16:01 +0200 (CEST)
Received: from marge.local (neu67-4-88-160-66-91.fbx.proxad.net [88.160.66.91])
	by smtp6-g19.free.fr (Postfix) with ESMTP id 7FFFB5FE4C
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Oct 2007 16:16:01 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--Boundary-00=_gq2FHD5iuRrLj7F
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I found a bug in iptables-save: when fopen("/proc/net/ip_tables_names") fails, 
iptables-save just exit with code 0 (success). I expected an error to make 
this command works together:
  $ iptables-save > /tmp/iptables-backup
  $ iptables (...)
  $ iptables-restore > /tmp/iptables-backup

The problem is that ip_tables module is not loaded before first iptables 
command.

Workaround: load iptables kernel modules before calling iptables-save or check 
that iptables-save is not empty.

Bugfix in iptables-save: exit with error code (1) on fopen failure => see 
attached patch proposition. The error message could be "iptables kernel 
module is not loaded (unable to open ...)" or something better. The most 
important point is the exit code to make my bash script work :-)

Victor Stinner
http://www.inl.fr/

--Boundary-00=_gq2FHD5iuRrLj7F
Content-Type: text/x-diff;
  charset="us-ascii";
  name="iptables-save-tables_names.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="iptables-save-tables_names.patch"

Index: iptables-save.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- iptables-save.c	(r=C3=A9vision 7079)
+++ iptables-save.c	(copie de travail)
@@ -242,7 +242,9 @@
=20
 	procfile =3D fopen("/proc/net/ip_tables_names", "r");
 	if (!procfile)
=2D		return 0;
+		exit_error(OTHER_PROBLEM,
+			   "Unable to open /proc/net/ip_tables_names: %s\n",
+			   strerror(errno));
=20
 	while (fgets(tablename, sizeof(tablename), procfile)) {
 		if (tablename[strlen(tablename) - 1] !=3D '\n')

--Boundary-00=_gq2FHD5iuRrLj7F--
