From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ipset: Backports for the nla_put_net64() API changes
Date: Fri, 1 Jul 2016 16:34:44 +0200
Message-ID: <20160701143444.GA20402@salvia>
References: <20160623102211.GA31272@hydrogen>
 <20160623103744.GA10764@salvia>
 <CAMQP0smTrOCvq6nXH3u5VLfLdj1nf7_D6760RCmCUx6DfrynNA@mail.gmail.com>
 <20160623180454.GA15678@salvia>
 <CAMQP0skT_L_pKrjYA+FfEj0Etz_DfY0wEPxv=Qsq+PyHOg1kyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33661 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbcGAOet (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2016 10:34:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0E0D11B1E01
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 16:34:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F12B064469
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 16:34:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D4D786447C
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 16:34:45 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAMQP0skT_L_pKrjYA+FfEj0Etz_DfY0wEPxv=Qsq+PyHOg1kyA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 24, 2016 at 05:55:09AM +0700, Neutron Soutmun wrote:
> On Fri, Jun 24, 2016 at 1:04 AM, Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
> > What is exactly the compilation error you get?
>=20
> =3D=3D=3D 8< =3D=3D=3D
> /usr/src/linux-headers-4.7.0-rc4-common/include/net/netlink.h:883:59:
> note: declared here
>  static inline int nla_put_net64(struct sk_buff *skb, int attrtype,
> __be64 value,
>                                                            ^
> In file included from
> /home/neutron/works/debian/mypkg/ipset/git/ipset/kernel/include/linux=
/netfilter/ipset/ip_set.h:458:0,
>                  from
> /home/neutron/works/debian/mypkg/ipset/git/ipset/kernel/net/netfilter=
/xt_set.c:19:
> /home/neutron/works/debian/mypkg/ipset/git/ipset/kernel/include/linux=
/netfilter/ipset/ip_set_counter.h:58:9:
> error: too few arguments to function =E2=80=98nla_put_net64=E2=80=99
>          nla_put_net64(skb, IPSET_ATTR_PACKETS,
>          ^
> =3D=3D=3D 8< =3D=3D=3D

Thanks for explaining, I let Jozsef handle this.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
