From: "billbonaparte" <programme110@gmail.com>
Subject: netfilter: NAT: do the optimization for getting curr_tuple in function nf_nat_setup_info
Date: Fri, 24 Oct 2014 12:01:42 +0800
Message-ID: <013f01cfef3f$3d4b31f0$b7e195d0$@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0140_01CFEF82.4B6F0E30"
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <linux-kernel@vger.kernel.org>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>,
	"'Patrick McHardy'" <kaber@trash.net>, <kadlec@blackhole.kfki.hu>,
	<davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33790 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaJXECN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 00:02:13 -0400
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multipart message in MIME format.

------=_NextPart_000_0140_01CFEF82.4B6F0E30
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all:
	In function nf_nat_setup_info, we need to get the current tuple
which is supposed to send to destination. 
    If we haven't done any NAT (SNAT or DNAT) for the tuple, then the
current tuple is equal to original tuple,
    otherwise, we should get current tuple by invoking
nf_ct_invert_tuplepr(curr_tuple, &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
    like the existing comment says:
    /* What we've got will look like inverse of reply. Normally
	 * this is what is in the conntrack, except for prior
	 * manipulations (future optimization: if num_manips == 0,
	 * orig_tp = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple)
	 */
	nf_ct_invert_tuplepr(&curr_tuple, 
			     &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
	
	So, since it is so, why don't we do the optimization for getting
current tuple ?
   
   As mentioned above, if we have not done DNAT for the tuple, then the
current tuple is equal to original tuple. 
   So I add the optimization as following:

+	if (!(ct->status & IPS_DST_NAT))  /* we do the optimization, as
mentioned above */
+		curr_tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+	else 
+		nf_ct_invert_tuplepr(curr_tuple,
 			     &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
	
	the attachment is the detailed diff. 

------=_NextPart_000_0140_01CFEF82.4B6F0E30
Content-Type: application/octet-stream;
	name="do the optimization for getting curr_tuple in function nf_nat_setup_info.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="do the optimization for getting curr_tuple in function nf_nat_setup_info.diff"

Index: nf_nat_core.c=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
--- nf_nat_core.c	(mainline version)=0A=
+++ nf_nat_core.c	(working copy)=0A=
@@ -358,7 +358,8 @@=0A=
 		  enum nf_nat_manip_type maniptype)=0A=
 {=0A=
 	struct net *net =3D nf_ct_net(ct);=0A=
-	struct nf_conntrack_tuple curr_tuple, new_tuple;=0A=
+	struct nf_conntrack_tuple orig_tuple, new_tuple;=0A=
+	struct nf_conntrack_tuple *curr_tuple =3D &orig_tuple;=0A=
 	struct nf_conn_nat *nat;=0A=
 =0A=
 	/* nat helper or nfctnetlink also setup binding */=0A=
@@ -378,14 +379,18 @@=0A=
 	/* What we've got will look like inverse of reply. Normally=0A=
 	   this is what is in the conntrack, except for prior=0A=
 	   manipulations (future optimization: if num_manips =3D=3D 0,=0A=
-	   orig_tp =3D=0A=
-	   conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple) */=0A=
-	nf_ct_invert_tuplepr(&curr_tuple,=0A=
+	   curr_tp =3D orig_tp =3D=0A=
+	   conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple) =0A=
+	*/=0A=
+	if (!(ct->status & IPS_DST_NAT)) /* we do the optimization, as =
mentioned above */=0A=
+		curr_tuple =3D &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;=0A=
+	else =0A=
+		nf_ct_invert_tuplepr(curr_tuple,=0A=
 			     &ct->tuplehash[IP_CT_DIR_REPLY].tuple);=0A=
 =0A=
-	get_unique_tuple(&new_tuple, &curr_tuple, ranges, ct, maniptype);=0A=
+	get_unique_tuple(&new_tuple, curr_tuple, ranges, ct, maniptype);=0A=
 =0A=
-	if (!nf_ct_tuple_equal(&new_tuple, &curr_tuple)) {=0A=
+	if (!nf_ct_tuple_equal(&new_tuple, curr_tuple)) {=0A=
 		struct nf_conntrack_tuple reply;=0A=
 =0A=
 		/* Alter conntrack table so will recognize replies. */=0A=
@@ -405,19 +410,20 @@=0A=
 		srchash =3D nat_hash_by_src(net, 0,=0A=
 				      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);=0A=
 		spin_lock_bh(&nf_nat_lock);=0A=

------=_NextPart_000_0140_01CFEF82.4B6F0E30--

