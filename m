From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH] remove ip_ct_refresh() abuse from the pptp conntrack
	helper (2/4)
Date: 06 Jun 2002 14:24:04 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1023365493.845.19.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-CDvvVQzI5e1DnzGmO2AL"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Netfilter-devel <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-CDvvVQzI5e1DnzGmO2AL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi again,

Here's the pptp helper patch, it's against the 020602 CVS, should apply
just fine as I havn't seen any updates to this module in the
netfilter-cvs list.

It replaces the ip_ct_refresh() abuse with the real deal.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.

--=-CDvvVQzI5e1DnzGmO2AL
Content-Disposition: attachment; filename=pptp-conntrack-nat_death.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=pptp-conntrack-nat_death.diff; charset=ISO-8859-15

--- netfilter/userspace/patch-o-matic/extra/pptp-conntrack-nat.patch.orig	T=
hu Jun  6 14:03:35 2002
+++ netfilter/userspace/patch-o-matic/extra/pptp-conntrack-nat.patch	Thu Ju=
n  6 14:05:17 2002
@@ -572,7 +572,7 @@
 diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ver' --exclude '.=
*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*~' linux-2.4.18-n=
ewnat/net/ipv4/netfilter/ip_conntrack_pptp.c linux-2.4.18-pptp3.01//net/ipv=
4/netfilter/ip_conntrack_pptp.c
 --- linux-2.4.18-newnat/net/ipv4/netfilter/ip_conntrack_pptp.c	Thu Jan  1 =
01:00:00 1970
 +++ linux-2.4.18-pptp3.01//net/ipv4/netfilter/ip_conntrack_pptp.c	Mon Apr =
 8 16:40:37 2002
-@@ -0,0 +1,540 @@
+@@ -0,0 +1,542 @@
 +/*
 + * ip_conntrack_pptp.c	- Version $Revision: 1.6 $
 + *
@@ -682,11 +682,13 @@
 +		if (!exp->sibling)
 +			continue;
 +
-+		DEBUGP("setting timeout of conntrack %p to 0\n",
++		DEBUGP("killing conntrack %p\n",
 +			exp->sibling);
 +		exp->sibling->proto.gre.timeout =3D 0;
 +		exp->sibling->proto.gre.stream_timeout =3D 0;
-+		ip_ct_refresh(exp->sibling, 0);
++
++		if (del_timer(&exp->sibling->timeout))
++			ip_ct_death_by_timeout((unsigned long)exp->sibling);
 +	}
 +
 +	return 0;

--=-CDvvVQzI5e1DnzGmO2AL--
