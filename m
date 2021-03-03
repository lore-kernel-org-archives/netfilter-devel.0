Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2340C43142
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C14F760233
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353498AbhCDAEu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:04:50 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:62013 "EHLO smtp2-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1577897AbhCCSBb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Mar 2021 13:01:31 -0500
Received: from 141117PORT8 (unknown [IPv6:2a01:e0a:3f6:19b1:c535:e7a:7b0d:dec2])
        (Authenticated sender: linuxludo@free.fr)
        by smtp2-g21.free.fr (Postfix) with ESMTPSA id 785A72003BE;
        Wed,  3 Mar 2021 19:00:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1614794444;
        bh=vc3Ibk5q1/j4G/2ULBX67d+gmXvcHGHTHjagcoGL6ic=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date:From;
        b=P7MgfuIMmGb71pMrRaUcdKFMFHmRjPTC7lec5GaeScZsbzTHLQaGC3qjT11xe8k4m
         GLB/0aSkH1zSWMLu6sqtNqw8DkebOH1tgfiWqJH8/k0oPdIGrRAm0LQo/+fHVEMeP7
         AGHSCuXYPgpagR3pEes/1DOpzyKrFd3SB5mgzO9KCdeKHw6J4KwWNHY8p2hGdrwVsB
         uOU4irGjiLalJqs5WwgQ84kpqTxIxuKqVcDY/0CM9xd8TvyDq5WqlBm0YjiiT5+eWm
         F7A6fLoWPj3xAQKQMt6Ovvsnq75b6smOtRXC09aAj6p9Wa33YvWhff3oB97F+c9iVE
         g9AM6F0SqqkIw==
From:   =?iso-8859-1?Q?Ludovic_S=E9n=E9caux?= <linuxludo@free.fr>
To:     "'Florian Westphal'" <fw@strlen.de>
Cc:     "'Pablo Neira Ayuso'" <pablo@netfilter.org>,
        <kadlec@netfilter.org>, <netfilter-devel@vger.kernel.org>,
        <coreteam@netfilter.org>
References: <20210303163322.GA17445@salvia> <1709326502.137229418.1614790585426.JavaMail.root@zimbra63-e11.priv.proxad.net> <20210303171206.GE17911@breakpoint.cc>
In-Reply-To: <20210303171206.GE17911@breakpoint.cc>
Subject: RE: [PATCH] netfilter: Fix GRE over IPv6 with conntrack module
Date:   Wed, 3 Mar 2021 19:00:34 +0100
Message-ID: <00a901d71057$2171bc20$64553460$@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIYFnsF7n4In1pMbktXscglw2aElQGAxmlfAiQVixmp01mrgA==
Content-Language: fr
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thanks for your feedback.

So, in this case, can you consider this request ?
Or do I have to make a new one ?

Regards,


-----Message d'origine-----
De=A0: Florian Westphal <fw@strlen.de>=20
Envoy=E9=A0: mercredi 3 mars 2021 18:12
=C0=A0: linuxludo@free.fr
Cc=A0: Pablo Neira Ayuso <pablo@netfilter.org>; kadlec@netfilter.org;
fw@strlen.de; netfilter-devel@vger.kernel.org; coreteam@netfilter.org
Objet=A0: Re: [PATCH] netfilter: Fix GRE over IPv6 with conntrack module

linuxludo@free.fr <linuxludo@free.fr> wrote:
> When I enabled the GRE tunnel interface, I got a reject of GRE =
packets:
>=20
> Mar  1 09:09:56 router1 kernel: [  303.025798] [FW6-IN-2-D] IN=3Deth0=20
> OUT=3D MAC=3D0c:d8:6a:66:03:00:0c:d8:6a:b7:90:00:86:dd=20
> SRC=3D2001:0db8:1000:0000:0000:0000:0000:0002=20
> DST=3D2001:0db8:1000:0000:0000:0000:0000:0001 LEN=3D136 TC=3D0 =
HOPLIMIT=3D64=20
> FLOWLBL=3D825134 PROTO=3D47
>=20
> This unconditionally matched the invalid packets rule.

Yes, the return value is wrong, it should be NF_ACCEPT, not -NF_ACCEPT.

In older kernels, the gre tracker only registers for ipv4 and ipv6 gre =
falls
back to generic ipv6 tracker.

I think given there is nothing l3 protocol specific in the GRE tracker
removal of the conditional is preferable.

