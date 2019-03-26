Return-Path: <SRS0=49hf=R5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86828C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 16:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57928206DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 16:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731670AbfCZQ3T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 12:29:19 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:50899 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbfCZQ3T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 12:29:19 -0400
X-Originating-IP: 209.85.222.51
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
        (Authenticated sender: pshelar@ovn.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id BEEA1C0007;
        Tue, 26 Mar 2019 16:29:16 +0000 (UTC)
Received: by mail-ua1-f51.google.com with SMTP id c6so4525224uan.1;
        Tue, 26 Mar 2019 09:29:16 -0700 (PDT)
X-Gm-Message-State: APjAAAXnSNCD9uZ3EBjcOc2NB34Jc3vmzW6ZfP2WEeThACE8K1/55mim
        E8qRAd/z7b1prCkNc3IvZItD4Sw3AJ5jLkiXLzA=
X-Google-Smtp-Source: APXvYqwE24kuKc/TcIusrOb1KqSUSX/2bI4kN7MZQ6Q0z+PzhoVxGATC9s8/zfaVzt7qLJhDg05OFYo81smlJs8MpcM=
X-Received: by 2002:ab0:4483:: with SMTP id n3mr17294272uan.22.1553617755285;
 Tue, 26 Mar 2019 09:29:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190325185831.27284-1-fbl@sysclose.org>
In-Reply-To: <20190325185831.27284-1-fbl@sysclose.org>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Tue, 26 Mar 2019 09:29:06 -0700
X-Gmail-Original-Message-ID: <CAOrHB_D_RuDsbV8vHRrXZ1UrvPh-oMCaq1Z4LxkmLtQP7geB+w@mail.gmail.com>
Message-ID: <CAOrHB_D_RuDsbV8vHRrXZ1UrvPh-oMCaq1Z4LxkmLtQP7geB+w@mail.gmail.com>
Subject: Re: [PATCH net-next v2] openvswitch: add seqadj extension when NAT is used.
To:     Flavio Leitner <fbl@sysclose.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Joe Stringer <joe@ovn.org>, ovs dev <dev@openvswitch.org>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Mar 25, 2019 at 11:58 AM Flavio Leitner <fbl@sysclose.org> wrote:
>
> When the conntrack is initialized, there is no helper attached
> yet so the nat info initialization (nf_nat_setup_info) skips
> adding the seqadj ext.
>
> A helper is attached later when the conntrack is not confirmed
> but is going to be committed. In this case, if NAT is needed then
> adds the seqadj ext as well.
>
> Fixes: 16ec3d4fbb96 ("openvswitch: Fix cached ct with helper.")
> Signed-off-by: Flavio Leitner <fbl@sysclose.org>
> ---
>  net/openvswitch/conntrack.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> Changelog:
> v2 - removed nfct_help(ct) check as it is not necessary.
>
> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> index 51080004677e..845b83598e0d 100644
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c
> @@ -990,6 +990,12 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
>                                                             GFP_ATOMIC);
>                         if (err)
>                                 return err;
> +
> +                       /* helper installed, add seqadj if NAT is required */
> +                       if (info->nat && !nfct_seqadj(ct)) {
> +                               if (!nfct_seqadj_ext_add(ct))
> +                                       return -EINVAL;
> +                       }
>                 }
>
>                 /* Call the helper only if:

Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks,
Pravin.
