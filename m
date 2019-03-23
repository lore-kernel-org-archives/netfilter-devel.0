Return-Path: <SRS0=amc/=R2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E19EDC10F05
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Mar 2019 19:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEA9C21874
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Mar 2019 19:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfCWTcv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Mar 2019 15:32:51 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:53881 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727680AbfCWTcv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Mar 2019 15:32:51 -0400
X-Originating-IP: 209.85.217.44
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
        (Authenticated sender: pshelar@ovn.org)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 3DA45FF804;
        Sat, 23 Mar 2019 19:32:48 +0000 (UTC)
Received: by mail-vs1-f44.google.com with SMTP id g127so3250531vsd.6;
        Sat, 23 Mar 2019 12:32:47 -0700 (PDT)
X-Gm-Message-State: APjAAAUtFMEvyMJMnEQ0BNwlMNjjqOnM9/m0mx1W1YtkeUNcJgQY0NWc
        JbbVvfe+B77PeO7AY+KpUDmCUpAjTr9tEC659/M=
X-Google-Smtp-Source: APXvYqyINkro0FvoY/wCs3nPF5kPQVhKjnqfayd6NSLOYkSWdANdFR0o6bK3lrfC9EPlfPyp1ndTlTB2T5AUyACs5So=
X-Received: by 2002:a67:c490:: with SMTP id d16mr9973636vsk.93.1553369566743;
 Sat, 23 Mar 2019 12:32:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190321165224.24118-1-fbl@sysclose.org>
In-Reply-To: <20190321165224.24118-1-fbl@sysclose.org>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 23 Mar 2019 12:32:37 -0700
X-Gmail-Original-Message-ID: <CAOrHB_CActmZPWipq6chM0SXAkTsODuHFyVMTdL8idCjB-Vecw@mail.gmail.com>
Message-ID: <CAOrHB_CActmZPWipq6chM0SXAkTsODuHFyVMTdL8idCjB-Vecw@mail.gmail.com>
Subject: Re: [PATCH net-next] openvswitch: add seqadj extension when NAT is used.
To:     Flavio Leitner <fbl@sysclose.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Joe Stringer <joe@ovn.org>, ovs dev <dev@openvswitch.org>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 21, 2019 at 9:52 AM Flavio Leitner <fbl@sysclose.org> wrote:
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
>  net/openvswitch/conntrack.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
I am not able to apply this patch.

> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> index 1b6896896fff..a7664515c943 100644
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c
> @@ -990,6 +990,11 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
>                                                             GFP_ATOMIC);
>                         if (err)
>                                 return err;
> +
> +                       if (info->nat && nfct_help(ct) && !nfct_seqadj(ct)) {
Given helper is just assigned, is nfct_help() check required here?

> +                               if (!nfct_seqadj_ext_add(ct))
> +                                       return -EINVAL;
> +                       }
>                 }
>
>                 /* Call the helper only if:
> --
> 2.20.1
>
>
>
