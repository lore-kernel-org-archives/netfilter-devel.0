From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: Question about tcp reopen in tcp_in_window
Date: Thu, 17 Nov 2011 17:05:05 +0800
Message-ID: <4EC4CE41.2060003@cn.fujitsu.com>
References: <4EC4AF32.5050901@cn.fujitsu.com> <alpine.DEB.2.00.1111170904040.27634@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, xiaosuo@gmail.com
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58684 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755912Ab1KQJEZ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Nov 2011 04:04:25 -0500
In-Reply-To: <alpine.DEB.2.00.1111170904040.27634@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=E4=BA=8E 2011=E5=B9=B411=E6=9C=8817=E6=97=A5 16:07, Jozsef Kadlecsik =E5=
=86=99=E9=81=93:
> No, the connection entry won't be destroyed by nf_ct_kill. Why do you=
=20
> think so?
>=20

Thanks Jozsef Kadlecsik.
nf_ct will be destroy when tcp_packet return -NF_REPEAT to nf_conntrack=
_in.
nf_conntrack_in will call nf_conntrack_put to destroy nf_conn
nf_conntrack_in:

	ret =3D l4proto->packet(ct, skb, dataoff, ctinfo, pf, hooknum);
        if (ret <=3D 0) {
                /* Invalid: inverse of the return code tells
                 * the netfilter core what to do */
                pr_debug("nf_conntrack_in: Can't track with proto modul=
e\n");
                nf_conntrack_put(skb->nfct);
                skb->nfct =3D NULL;
                NF_CT_STAT_INC_ATOMIC(net, invalid);
                if (ret =3D=3D -NF_DROP)
                        NF_CT_STAT_INC_ATOMIC(net, drop);
                return -ret;
        }

I am wrong?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
