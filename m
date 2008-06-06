From: Krzysztof Oledzki <ole@ans.pl>
Subject: [Bug 10875] Oops in nf_nat_setup_info
Date: Fri, 6 Jun 2008 20:05:49 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806061931140.12641@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1014687766-1212775549=:12641"
Cc: bugme-daemon@bugzilla.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:38826 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbYFFSGG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 14:06:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1014687766-1212775549=:12641
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

Today I have been plaing with the conntrackd utility and noticed it is=20
very easy to trigger a kernel oops just by:

conntrackd -d
conntrackd -n
conntrackd -c
conntrackd -c

The oops is here: http://bugzilla.kernel.org/attachment.cgi?id=3D16414

I was trying to fix it with:

--- nf_nat_core.c=092008-06-06 19:55:25.000000000 +0200
+++ nf_nat_core.c=092008-05-07 01:22:34.000000000 +0200
@@ -153,7 +153,7 @@
         read_lock_bh(&nf_nat_lock);
         hlist_for_each_entry(nat, n, &bysource[h], bysource) {
                 ct =3D nat->ct;
-               if (ct && same_src(ct, tuple)) {
+               if (same_src(ct, tuple)) {
                         /* Copy source part from reply tuple. */
                         nf_ct_invert_tuplepr(result,
                                        &ct->tuplehash[IP_CT_DIR_REPLY].tup=
le);


However and I'm not able to find how nat->ct may become NULL in here and=20
unfortutunatelly this patch does not help too much as with above fix I get=
=20
a different Oops: http://bugzilla.kernel.org/attachment.cgi?id=3D16415

(gdb) l *nf_nat_setup_info+0x223
0x783e30de is in nf_nat_setup_info (net/ipv4/netfilter/nf_nat_core.c:154).
149             struct nf_conn_nat *nat;
150             struct nf_conn *ct;
151             struct hlist_node *n;
152
153             read_lock_bh(&nf_nat_lock);
154             hlist_for_each_entry(nat, n, &bysource[h], bysource) {     =
   <- here
155                     ct =3D nat->ct;
156                     if (ct && same_src(ct, tuple)) {
157                             /* Copy source part from reply tuple. */
158                             nf_ct_invert_tuplepr(result,

All accesses to bysource seem to be protected by the lock_bh so I have no=
=20
concept where to dig next. :( Any idea?

Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1014687766-1212775549=:12641--
