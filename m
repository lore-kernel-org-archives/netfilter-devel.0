Return-Path: <SRS0=iBHO=7Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E9CC433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Jun 2020 08:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40D28207D8
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Jun 2020 08:34:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G9Jd9LJI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgFLIe1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Jun 2020 04:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbgFLIe0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Jun 2020 04:34:26 -0400
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82217C03E96F
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Jun 2020 01:34:25 -0700 (PDT)
Received: by mail-vk1-xa41.google.com with SMTP id m23so2073197vko.2
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Jun 2020 01:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Vl05A32PDpnhPAwttEshq1LnZ1r8XwFCL+316jHSGk=;
        b=G9Jd9LJIcj2uPY1VIvtc+slQDFxW6SHsradI/Ol98dOTgPhA+Gn6U9Be5XeeVQ0jNh
         81R9P9ydEceXrjQYR+ww4ZeyQvr4x3ggPDr9KzhzGmwTR1UiybKwcG34/CGjT8dDcC4c
         JrGC/k07IFRjlHNJBNO+dNS5xv4VNqWOa9MIUPEyVWxqOo/+ZiVh6yzHkyNNvuppsAdc
         KtAg1a+1mq3SJxWbLFu9Xi04KcpbEG8cJLpVci6AM6NaAYzRjyeadHHAI7gtnJNIdw7Y
         JH2PJ1zXWoXWEgsCAzMSHdu3haDco/z3ZtqzMJVrvw87hXxGJqJZCZ7UsHsmSXTl810n
         58Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Vl05A32PDpnhPAwttEshq1LnZ1r8XwFCL+316jHSGk=;
        b=SCUZJ507bijiivdjSqw0AGzAhiFX81jlIhpTdjIahJ/KlTuBwRvXApsuEzVkfWDn7s
         k2uXl6llMa+K0vZGBw7Pphf5tm7ADtF5qY0ThwFWrKpxYM+sHD+6T7MnJtCLMd7mw5m5
         9koNb1GVQpQ9GlUKbkuJU1LNIgbXcLU9WB8otXnC0gRFLf/qeAamEaEAUwKSyXXERE09
         s9yIOo4JxiUpPACbXyd0/8vlItlJMLvebetJZhr046BFbVN03Z4RmUfqNMsDz4i2Hruo
         hYZ2RtOy87o/Ss1RvCObonBnTD3XA5oOn0caEXZj+q5445uK7+22362evOdCqmghPVT5
         udHA==
X-Gm-Message-State: AOAM532NtgpA/NB/eN3o5wY6Kg+ywmE0XzBwbKheQySGYZ5EHoGpMyKn
        4fM1ctSbXVZLNquB2/JU2nNWEsT8bGBp6aiCEFA=
X-Google-Smtp-Source: ABdhPJyqooe3W6TPaBD7Ba+gHArmGusbXFlGZyYCSjlLlI1B9ZcYrHCxKUc1HuPsp4qr82K6llkgKQT8zhaFcNGUzPc=
X-Received: by 2002:a05:6122:33a:: with SMTP id d26mr9276274vko.30.1591950864381;
 Fri, 12 Jun 2020 01:34:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200608190103.GA23207@nevthink> <20200609153541.GA25538@salvia>
In-Reply-To: <20200609153541.GA25538@salvia>
From:   =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>
Date:   Fri, 12 Jun 2020 10:34:12 +0200
Message-ID: <CAF90-Wib46a=cmVYa=shEeWDWOfxJ3HrdcGHpwQWeFwsCFw47Q@mail.gmail.com>
Subject: Re: [PATCH nf-next 2/2] netfilter: nft: add support of reject verdict
 from ingress
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, devel@zevenet.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Jun 9, 2020 at 5:35 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Hi Laura,
>
> On Mon, Jun 08, 2020 at 09:01:03PM +0200, Laura Garcia Liebana wrote:
> > diff --git a/net/netfilter/nft_reject_netdev.c b/net/netfilter/nft_reject_netdev.c
> > new file mode 100644
> > index 000000000000..64123d80210d
> > --- /dev/null
> > +++ b/net/netfilter/nft_reject_netdev.c
> [...]
> > +static void nft_reject_netdev_eval(const struct nft_expr *expr,
> > +                                struct nft_regs *regs,
> > +                                const struct nft_pktinfo *pkt)
> > +{
> > +     switch (ntohs(pkt->skb->protocol)) {
> > +     case ETH_P_IP:
> > +             nft_reject_ipv4_eval(expr, regs, pkt);
> > +             break;
> > +     case ETH_P_IPV6:
> > +             nft_reject_ipv6_eval(expr, regs, pkt);
> > +             break;
> > +     }
>
> We should reuse nft_reject_br_send_v4_tcp_reset() and
> nft_reject_br_send_v4_unreach() and call dev_queue_xmit() to send the
> reject packet.
>
> No need to inject this from LOCAL_OUT, given this packet is being
> rejects from the ingress path.
>
> The reject action for netdev is more similar to the one that bridge
> supports than what we have for inet actually.
>
> You can probably move the bridge functions to
> net/netfilter/nf_reject.c so this code can be shared between bridge
> reject and netdev.
>

Thank you for your review, I'll apply the changes.

> I like your code refactoring in patch 1 though.
