Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BDD7CA0EC3
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Sep 2023 04:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjILEl2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Sep 2023 00:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjILEl1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Sep 2023 00:41:27 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DF8B8
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Sep 2023 21:41:22 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2b962535808so88395261fa.0
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Sep 2023 21:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694493681; x=1695098481; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IesEn5tdA1SJXmeb07LLZemkYsmGxrPA/FkLyLh/bhE=;
        b=hJ3tLccMZnSkx99S3dVaeJLF8Fzks3YaWfnhP9GhoKaXPxFfvMcHPFMf2LboPKbgG4
         3NR5SiVuaAYZV03Mzad3zmwOFUZqSMFTsJIK2NGeRaVzVypyMmdbqkjCxWNbPbOXXIz+
         orOYIDg5+aalmkAS6pRMXS3+ni6DPE8/H0WB+lW27miWMB1rs7VZG0N5ykb2YSGuxOx9
         HPAWxk5W7G+7JW+v37ROg9rvJMcDtOq2mWvZsxDuH0KvVC/+OqCpyzthx62zGVzr34Nu
         b69pH3Oti+XSKZzNXFc3sJ6FYXxaaVWeWLK7kfpkQCDJHBOEcj4BVhRA91WWNdcwWisV
         jKTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694493681; x=1695098481;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IesEn5tdA1SJXmeb07LLZemkYsmGxrPA/FkLyLh/bhE=;
        b=hoikOwlngfXQ/9O0cIK2IzTzsYbIiLO2rrxrpmg4yHbB6Ksrq+ATwzYoT2Ikef4Rmo
         Mq5jRXzLby3VRpIXwWLSLAfXrzx4ojg5pofGoH2MR25WZ7/q1zkkldl+QXlbp7UiZuhN
         26MjHcgoRhGiXACGnhXF4nh2+tt9aGeGN/qoayFVnVATesnk4d96xlXQZ/mq3Zve8oY5
         Zo9Ja81ITcCcr3ZdXHifvJCMndZk+cCTyy6xnlnX0nMnjdlqOE6MVD/Z19PkHJlvq/0G
         Eg9eNUcG1TCnjExA45GGtnHlsYgfDvJiLlGaegjzmHs8kKD+DBSfeKSq8Mok0w1WoXXI
         TgnQ==
X-Gm-Message-State: AOJu0Yxd6NgtKRsJefiLTQo2JV3mzhivlAJ7Ph4EXDa35fFMRbmkq/UI
        cy8LjsHkYZzfCugmsSfKIEa99XbB9DVFYIcwsgY=
X-Google-Smtp-Source: AGHT+IFoMlTctxjiIVKmr4kIHAKZkxsIsXRgN6w/syRWcUrl8pLjyGqZVKqeJ6YJRbw6KqbRGyJ4YqPlWAX5q74IKu8=
X-Received: by 2002:a2e:7213:0:b0:2bc:e51e:b007 with SMTP id
 n19-20020a2e7213000000b002bce51eb007mr9985490ljc.41.1694493680707; Mon, 11
 Sep 2023 21:41:20 -0700 (PDT)
MIME-Version: 1.0
References: <ZPZqetxOmH+w/myc@westworld> <6e4a44b1-fa78-bcb3-5c2e-fcfd6489dac4@netfilter.org>
In-Reply-To: <6e4a44b1-fa78-bcb3-5c2e-fcfd6489dac4@netfilter.org>
From:   Kyle Zeng <zengyhkyle@gmail.com>
Date:   Mon, 11 Sep 2023 21:40:44 -0700
Message-ID: <CADW8OBsTm=2y9vYmusLvhVEhxwS_C3PFogzx8r+oW7zhSjOMGA@mail.gmail.com>
Subject: Re: Race between IPSET_CMD_CREATE and IPSET_CMD_SWAP
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        pablo@netfilter.org, edumazet@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jozsef,

On Mon, Sep 4, 2023 at 11:45=E2=80=AFPM Jozsef Kadlecsik <kadlec@netfilter.=
org> wrote:
>
> Hi Kyle,
>
> On Mon, 4 Sep 2023, Kyle Zeng wrote:
>
> > There is a race between IPSET_CMD_ADD and IPSET_CMD_SWAP in
> > netfilter/ip_set, which can lead to the invocation of `__ip_set_put` on
> > a wrong `set`, triggering the `BUG_ON(set->ref =3D=3D 0);` check in it.
> > ......
> > A proof-of-concept code that can trigger the bug is attached.
> >
> > The bug is confirmed on v5.10, v6.1, v6.5.rc7 and upstream.
>
> Thanks for the thorough report. I think the proper fix is to change the
> reference counter at rescheduling from "ref" to "ref_netlink", which
> protects long taking procedures (originally just dumping). Could you
> verify that the patch below fixes the issue?
>
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
> index e564b5174261..8a9cea8ed5ed 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -682,6 +682,15 @@ __ip_set_put(struct ip_set *set)
>  /* set->ref can be swapped out by ip_set_swap, netlink events (like dump=
) need
>   * a separate reference counter
>   */
> +static void
> +__ip_set_get_netlink(struct ip_set *set)
> +{
> +       write_lock_bh(&ip_set_ref_lock);
> +       set->ref_netlink++;
> +       write_unlock_bh(&ip_set_ref_lock);
> +}
> +
> +
>  static void
>  __ip_set_put_netlink(struct ip_set *set)
>  {
> @@ -1693,11 +1702,11 @@ call_ad(struct net *net, struct sock *ctnl, struc=
t sk_buff *skb,
>
>         do {
>                 if (retried) {
> -                       __ip_set_get(set);
> +                       __ip_set_get_netlink(set);
>                         nfnl_unlock(NFNL_SUBSYS_IPSET);
>                         cond_resched();
>                         nfnl_lock(NFNL_SUBSYS_IPSET);
> -                       __ip_set_put(set);
> +                       __ip_set_put_netlink(set);
>                 }
>
>                 ip_set_lock(set);
>

Sorry for the late reply, somehow the response was moved to spam folder and=
 I
didn't notice it.

> Thanks for the thorough report. I think the proper fix is to change the
> reference counter at rescheduling from "ref" to "ref_netlink", which
> protects long taking procedures (originally just dumping). Could you
> verify that the patch below fixes the issue?

I applied the patch to the upstream kernel and tested it. The proof-of-conc=
ept
crash program can no longer trigger the crash.

Best,
Kyle Zeng
