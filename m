From: Jackson Alberto <superj_2004@hotmail.com>
Subject: Question about using "Expect" from Netfilter hook
Date: Thu, 29 Jul 2010 13:58:03 -0400
Message-ID: <BAY121-W19EB6FC57269CBEAC35B8B9DA90@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bay0-omc2-s15.bay0.hotmail.com ([65.54.190.90]:12762 "EHLO
	bay0-omc2-s15.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756899Ab0G2SDU convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Jul 2010 14:03:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello!,

Is it possible to work with "expect" from a netfilter hook (not from a
conntrack helper)?

When I run the code below, I get:

BUG: unable to handle kernel NULL pointer dereference at (null)
IP [] nf_ct_expect_related_report+0x63/0x427
*pde =3D 3df8d067
Oops: 000 [#1] SMP

------

int np_exp(struct nf_conn *ct){
=A0 =A0 struct nf_conntrack_expect *exp;
=A0 =A0 struct nf_conntrack_tuple *tuple;

=A0 =A0 exp =3D nf_ct_expect_alloc(ct);
=A0 =A0     if(exp =3D=3D NULL){
=A0 =A0 =A0 =A0 printk("Couldn't allocate exp!\n");
=A0 =A0 =A0 =A0 return -1;
=A0 =A0     }

=A0 =A0     tuple =3D &ct->tuplehash[IP_CT_DIR_REPLY].tuple;

=A0 =A0     nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3=
num(ct),
                          &tuple->src.u3, &tuple->dst.u3, IPPROTO_TCP,
                          NULL, &tuple->dst.u.tcp.port);

        nf_ct_expect_put(exp);

=A0 =A0     return 1;
}

hook_func(...){
=A0 =A0     if(!(conntrack =3D nf_ct_get(sock_buff, &ctinfo)) ||
           !(master_conntrack =3D nf_ct_get(skb, &master_ctinfo))){
=A0 =A0 =A0 =A0         spin_unlock_bh(&np_lock);
=A0 =A0 =A0 =A0         return NF_ACCEPT; /* Couldn't get conntrack */
    }

    =A0 =A0 np_exp(conntrack);
}
 		 	   		 =20
_________________________________________________________________
Hotmail: Powerful Free email with security by Microsoft.
https://signup.live.com/signup.aspx?id=3D60969--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
