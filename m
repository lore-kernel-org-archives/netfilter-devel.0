From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER 07/32]: Add nf_inet_addr_cmp()
Date: Thu, 28 Feb 2008 13:19:57 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802281317360.4324@fbirervta.pbzchgretzou.qr>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
 <20080228115957.29267.35707.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36145 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbYB1MT7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:19:59 -0500
In-Reply-To: <20080228115957.29267.35707.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Feb 28 2008 13:00, Patrick McHardy wrote:
>+static inline int nf_inet_addr_cmp(const union nf_inet_addr *a1,
>+				   const union nf_inet_addr *a2)
>+{
>+	return a1->all[0] == a2->all[0] &&
>+	       a1->all[1] == a2->all[1] &&
>+	       a1->all[2] == a2->all[2] &&
>+	       a1->all[3] == a2->all[3];
>+}
>+

Humm... this might raise undefined/unexpected behavior for IPv4 addresses,
for which nf_inet_addr is not properly flattened (zeroed or all-ones,
or whatever static pattern you want to put in all[1],all[2],all[3]),
but the problem already existed before I guess:

> static inline int __nf_ct_tuple_src_equal(const struct nf_conntrack_tuple *t1,
> 					  const struct nf_conntrack_tuple *t2)
> { 
>-	return (t1->src.u3.all[0] == t2->src.u3.all[0] &&
>-		t1->src.u3.all[1] == t2->src.u3.all[1] &&
>-		t1->src.u3.all[2] == t2->src.u3.all[2] &&
>-		t1->src.u3.all[3] == t2->src.u3.all[3] &&
>+	return (nf_inet_addr_cmp(&t1->src.u3, &t2->src.u3) &&
> 		t1->src.u.all == t2->src.u.all &&
> 		t1->src.l3num == t2->src.l3num);
> }
>@@ -174,10 +171,7 @@ static inline int __nf_ct_tuple_src_equal(const struct nf_conntrack_tuple *t1,
> static inline int __nf_ct_tuple_dst_equal(const struct nf_conntrack_tuple *t1,
> 					  const struct nf_conntrack_tuple *t2)
> {
>-	return (t1->dst.u3.all[0] == t2->dst.u3.all[0] &&
>-		t1->dst.u3.all[1] == t2->dst.u3.all[1] &&
>-		t1->dst.u3.all[2] == t2->dst.u3.all[2] &&
>-		t1->dst.u3.all[3] == t2->dst.u3.all[3] &&
>+	return (nf_inet_addr_cmp(&t1->dst.u3, &t2->dst.u3) &&
> 		t1->dst.u.all == t2->dst.u.all &&
> 		t1->dst.protonum == t2->dst.protonum);
> }
>@@ -192,10 +186,7 @@ static inline int nf_ct_tuple_equal(const struct nf_conntrack_tuple *t1,
> static inline int nf_ct_tuple_mask_equal(const struct nf_conntrack_tuple_mask *m1,
> 					 const struct nf_conntrack_tuple_mask *m2)
> {
>-	return (m1->src.u3.all[0] == m2->src.u3.all[0] &&
>-		m1->src.u3.all[1] == m2->src.u3.all[1] &&
>-		m1->src.u3.all[2] == m2->src.u3.all[2] &&
>-		m1->src.u3.all[3] == m2->src.u3.all[3] &&
>+	return (nf_inet_addr_cmp(&m1->src.u3, &m2->src.u3) &&
> 		m1->src.u.all == m2->src.u.all);
> }
