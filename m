From: Jan Engelhardt <jengelh@medozas.de>
Subject: Expectation not quite up to where I want it
Date: Sat, 4 Oct 2008 18:36:13 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810041816150.21891@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53216 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbYJDWgP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Oct 2008 18:36:15 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 55A971C461A7E
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Oct 2008 18:36:13 -0400 (EDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



I am not quite sure whether it is possible to even set up an
expectation when ctstate(ct) =3D=3D IP_CT_NEW, is it? Fact is, this pie=
ce
of code segfaults on me right away in nf_ct_expect_related(),
possibly because exp->master or so is NULL, causing bad things when
issuing nfct_help(exp->master) in nf_ct_expect_related.
Any hints?

    =E2=86=92   nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, PF_I=
NET6,=20
    =E2=86=92       =E2=86=92   (const union nf_inet_addr *)&iph->daddr=
,=20
    =E2=86=92       =E2=86=92   (const union nf_inet_addr *)&iph->saddr=
,=20
    =E2=86=92       =E2=86=92   IPPROTO_MH, NULL, &man);=20
    =E2=86=92   printk(KERN_INFO "expectation set up\n");=20
    =E2=86=92   nf_ct_dump_tuple(&exp->tuple);=20
    =E2=86=92   if (nf_ct_expect_related(exp) !=3D 0)=20
    =E2=86=92       =E2=86=92   printk(KERN_INFO "hm\n");=20
    =E2=86=92   nf_ct_expect_put(exp); /* yes no ? /
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
