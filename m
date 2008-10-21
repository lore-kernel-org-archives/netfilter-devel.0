From: Victor Stinner <victor.stinner@inl.fr>
Subject: iptables-save and ip6tables-save exit code with no tables
Date: Tue, 21 Oct 2008 11:36:49 +0200
Message-ID: <200810211136.49892.victor.stinner@inl.fr>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_xKa/I0K6ADbE+iR"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 141-53.206-83.static-ip.oleane.fr ([83.206.53.141]:38739 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbYJUKG2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2008 06:06:28 -0400
Received: from [192.168.33.170] (helo=bart.local)
	by fydelkass.inl.fr with esmtp (Exim 4.63)
	(envelope-from <victor.stinner@inl.fr>)
	id 1KsDfj-0002d4-AT
	for netfilter-devel@vger.kernel.org; Tue, 21 Oct 2008 11:37:03 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Boundary-00=_xKa/I0K6ADbE+iR
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

When I setup the firewall rules, I would like to be able to "rollback" to the 
previous valid state. I'm using this pseudo-code:
 iptables-save > previous_rules
 iptables-restore < new_rules
 on error:
    iptables-restore < previous_rules

First problem is that iptables-save doesn't load the needed kernel modules to 
get the table list. Second problem is that iptables-save (with no argument) 
exit with code 0 (success) even if /proc/net/ip_tables_names is empty.

In my pseudo-code: if previous_rule is empty, "iptables-restore < 
previous_rules" doesn't restore the previous status (iptables-restore does 
nothing with empty input). I have to check iptables-save exit code *and* that 
previous_rules is not empty.

If the kernel module ip_tables is loaded, /proc/net/ip_table_names exists but 
is empty. The module iptable_filter is needed to 
fill /proc/net/ip_table_names.

Same problems with ip6tables-save with /proc/net/ip6_tables_names, and modules 
ip6_tables and ip6table_filter.

Attached patch change iptables-save and ip6tables-save behaviour: if there is 
no table, print the message:
  iptables-save v1.4.1: /proc/net/ip_tables_names is empty
and the exit code is 1 (error).

The message may be changed for a better message :-)

Victor

--Boundary-00=_xKa/I0K6ADbE+iR
Content-Type: text/x-diff;
  charset="utf-8";
  name="iptables-save-exitcode.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="iptables-save-exitcode.patch"

Index: iptables-save.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- iptables-save.c	(r=C3=A9vision 7568)
+++ iptables-save.c	(copie de travail)
@@ -35,6 +35,7 @@
 static int for_each_table(int (*func)(const char *tablename))
 {
 	int ret =3D 1;
+	unsigned int count =3D 0;
 	FILE *procfile =3D NULL;
 	char tablename[IPT_TABLE_MAXNAMELEN+1];
=20
@@ -51,8 +52,13 @@
 				   tablename);
 		tablename[strlen(tablename) - 1] =3D '\0';
 		ret &=3D func(tablename);
+		count +=3D 1;
 	}
=20
+	if (!count)
+		exit_error(OTHER_PROBLEM,
+			"/proc/net/ip_tables_names is empty\n",
+			tablename);
 	return ret;
 }
=20
Index: ip6tables-save.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- ip6tables-save.c	(r=C3=A9vision 7568)
+++ ip6tables-save.c	(copie de travail)
@@ -37,6 +37,7 @@
 static int for_each_table(int (*func)(const char *tablename))
 {
 	int ret =3D 1;
+	unsigned int count =3D 0;
 	FILE *procfile =3D NULL;
 	char tablename[IP6T_TABLE_MAXNAMELEN+1];
=20
@@ -53,8 +54,13 @@
 				   tablename);
 		tablename[strlen(tablename) - 1] =3D '\0';
 		ret &=3D func(tablename);
+		count +=3D 1;
 	}
=20
+	if (!count)
+		exit_error(OTHER_PROBLEM,
+			"/proc/net/ip6_tables_names is empty\n",
+			tablename);
 	return ret;
 }
=20

--Boundary-00=_xKa/I0K6ADbE+iR--
