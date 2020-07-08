Return-Path: <SRS0=D3ak=AT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB45C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jul 2020 16:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26B1520786
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jul 2020 16:14:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TgzsOD0m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbgGHQOv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jul 2020 12:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728148AbgGHQOv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jul 2020 12:14:51 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1071AC061A0B;
        Wed,  8 Jul 2020 09:14:51 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id e15so42288863edr.2;
        Wed, 08 Jul 2020 09:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JrrGDnvTwQQpCDyz7V+eXlis568H+dx//YDRvtMgaRk=;
        b=TgzsOD0mVl94q884+wc1OCspl0e/zwgiFV3RTRQYd64GxQXyhP7vDp/fiya43JBD3R
         W0niatKqu+1Q6Akdy+eP+gPWg2zVkIOx0GTFdP96ack1aevHfsjtvKtYFuhSua/Bd5iV
         Tk/IXf77ZlPvtqWBNDBvVfVg3IGBsAofX0rtN/OgJmo0P41PpmwjFyidaV5rM+LS7klJ
         ZETAnDTxScxih4oPRk+jKMgneAJGStf9XG5W2RwR63/XyGViv9UL2iiwRsODtmU1FhAc
         lDrkJEQe37zV5U66hk7qs+an6Kqu5gNpbFjMptA121FB3Ie+EE3xL7VCd7jNZXQEGw7i
         cBmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JrrGDnvTwQQpCDyz7V+eXlis568H+dx//YDRvtMgaRk=;
        b=OUsnhiScPaFTmqmGybFMWs2TGr3+dbh1us/3tsNkVyZ+yAyWDRTeSmGliiNBfsXxZb
         ZPqf185xiyKFpvepzBIN8t+CxA2+vxPBhZh/EZ9ZnYqL6sxj7woh6LWSgnx1BJ+cd0Ya
         DmAF/E21wWhydQrSF3afZkBIfiHoR4n8ZtgXATWfyUaohBVVt0HFlxEyI+w99tZZzeOC
         hguyLoyOLjGnzVSj4ys9Vuk4CPnlnlCVvvfv3zTKYT22re4cqF/C7QKM5YH4BdjpbeX0
         XLXBPa/BIa7NMb2zCvdT+3o4EoJww5a1fvEms41TmRzZfP2PNbNaHvLx3QG0WVOB7Oh4
         oevQ==
X-Gm-Message-State: AOAM531LA2epgjvFyr7jSJ4FieVgj6Nr8QyNgYlW5TjBjsByS6h2tF2k
        G36KIQK/NFWZAVH/kp99V/s6lYehX1EGxq73QTcnCA==
X-Google-Smtp-Source: ABdhPJx4+aYBdbZ5NeKfiB8yZTlFO6ZOYTNm5Mxy01rawRtkBdKX974aCu6ZmiGqu/3/1lgXla00bWWLGwZIW4lO8so=
X-Received: by 2002:a50:cd1e:: with SMTP id z30mr65742796edi.364.1594224889753;
 Wed, 08 Jul 2020 09:14:49 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LFD.2.23.451.2007081847310.3373@ja.home.ssi.bg>
 <20200708160618.13013-1-kim.andrewsy@gmail.com> <20200708161245.GB14873@salvia>
In-Reply-To: <20200708161245.GB14873@salvia>
From:   Andrew Kim <kim.andrewsy@gmail.com>
Date:   Wed, 8 Jul 2020 12:14:38 -0400
Message-ID: <CABc050E9F2=g95eogkZPoh6NPTKZaL3SRt6mYA=8aL8iPkO6mg@mail.gmail.com>
Subject: Re: [PATCHv2 net-next] ipvs: queue delayed work to expire no
 destination connections if expire_nodest_conn=1
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Julian Anastasov <ja@ssi.bg>, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        "open list:IPVS" <lvs-devel@vger.kernel.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sorry -- I think I misunderstood what Julian said. Nothing has changed
aside from some formatting on the patch file.

Will resend this patch with the v2 in the subject removed.


On Wed, Jul 8, 2020 at 12:12 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Wed, Jul 08, 2020 at 12:06:18PM -0400, Andrew Sy Kim wrote:
> > When expire_nodest_conn=1 and a destination is deleted, IPVS does not
> > expire the existing connections until the next matching incoming packet.
> > If there are many connection entries from a single client to a single
> > destination, many packets may get dropped before all the connections are
> > expired (more likely with lots of UDP traffic). An optimization can be
> > made where upon deletion of a destination, IPVS queues up delayed work
> > to immediately expire any connections with a deleted destination. This
> > ensures any reused source ports from a client (within the IPVS timeouts)
> > are scheduled to new real servers instead of silently dropped.
>
> Is this the same patch ?
>
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20200708135854.28944-1-kim.andrewsy@gmail.com/
>
> Julian has "Signed-off-by:" previous patch and this v2 does not say
> what has been updated.
>
> Thanks.
