Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F9FC55ABD
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Nov 2020 14:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A495D22252
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Nov 2020 14:00:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=waldekranz-com.20150623.gappssmtp.com header.i=@waldekranz-com.20150623.gappssmtp.com header.b="INDtGaCk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgKNOAI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 Nov 2020 09:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgKNOAI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Nov 2020 09:00:08 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3126AC0613D1
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2020 06:00:06 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id z21so18291839lfe.12
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2020 06:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=AGcVlRZ9vE1VQQJQyinrCZx9zIfIuSlLjtVaKeF4RGs=;
        b=INDtGaCkS0hpL4OxFtq0WAE0ZY3XPvpkhMefnsCYizWNOYEN8WNoQv2mjz8b96aKfp
         mC29/Av9RGTOXYjmhvz46Se1u7R9sEGsjs8x2TmtkDv61B8Rxx4d3vY7PxvifqlrgYNn
         xamKk3aIlJzYSMmFcy4kA8vfjLUHo9iiF7FXxtTc0mGdWkK6jdlVem0s9szVcajlf23k
         fTc4QzyStsX9rqLO65GS4eUd/pBDc3J+cz/r0GFOTAjRBXwszbckd9FJQKhMVu7Fzth0
         K5Z6lGD7kcBvseBztFhLcbWozJjYNmH6fKv6j1rJWKQlQOi/rGFTvGkau6yL8CwzE6HR
         xSPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=AGcVlRZ9vE1VQQJQyinrCZx9zIfIuSlLjtVaKeF4RGs=;
        b=Ot2f+kbDmL5F5W9TITDXiDwczyLkL6s3W+3I8iX2EGTQmue8hqHXai7mGUnMYpLsF6
         7eCqE1kgEjR2vlWX/7TWvMT0OJjgnaBougXVbrhxPRbig5Z4q4swbYK3D/XcSC/jcwL1
         suDgQXJLSTNySG1D2u30RBS4ywZwtrNAQWp9YZCNmBySRvxuA3PmxDZ8HJHIdh5prgh/
         WMqpUKYzz6HKY58PobSV69IOz3hnin4DadCrMGoPuKqXuczVBbkbKTDLxEdC9pyD/ViR
         MNq9h2SI/ewTTV8QbNVwiiv1ZEUZlIPtpYK3kf1/hE9/h9Ddn/vRlYtk5UhTAxau0/B7
         wjwQ==
X-Gm-Message-State: AOAM5336iGl88D2E06LbRUmX52CjjJo3cjpRgoU53nVhhTWd2Swzs+vt
        Dsm5kGRV/hpe1+oSbsZBNRt8hLI4jdwA6atO
X-Google-Smtp-Source: ABdhPJzDqsUurfGe5s9cJYc0mLhuivmbdq3AH9gHgXmlZYcOYCyKDA61wtFCYSVXczhPArdCGiXbRg==
X-Received: by 2002:a19:587:: with SMTP id 129mr2609236lff.189.1605362404613;
        Sat, 14 Nov 2020 06:00:04 -0800 (PST)
Received: from wkz-x280 (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id p137sm1639415lfa.146.2020.11.14.06.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 06:00:04 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, razor@blackwall.org, jeremy@azazel.net
Subject: Re: [PATCH net-next,v3 0/9] netfilter: flowtable bridge and vlan enhancements
In-Reply-To: <20201114115906.GA21025@salvia>
References: <20201111193737.1793-1-pablo@netfilter.org> <20201113175556.25e57856@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20201114115906.GA21025@salvia>
Date:   Sat, 14 Nov 2020 15:00:03 +0100
Message-ID: <87sg9cjaxo.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Nov 14, 2020 at 12:59, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> If any of the flowtable device goes down / removed, the entries are
> removed from the flowtable. This means packets of existing flows are
> pushed up back to classic bridge / forwarding path to re-evaluate the
> fast path.
>
> For each new flow, the fast path that is selected freshly, so they use
> the up-to-date FDB to select a new bridge port.
>
> Existing flows still follow the old path. The same happens with FIB
> currently.
>
> It should be possible to explore purging entries in the flowtable that
> are stale due to changes in the topology (either in FDB or FIB).
>
> What scenario do you have specifically in mind? Something like VM
> migrates from one bridge port to another?

This should work in the case when the bridge ports are normal NICs or
switchdev ports, right?

In that case, relying on link state is brittle as you can easily have a
switch or a media converter between the bridge and the end-station:

        br0                  br0
        / \                  / \
    eth0   eth1          eth0   eth1
     /      \      =>     /      \
  [sw0]     [sw1]      [sw0]     [sw1]
   /          \         /          \
  A                                 A

In a scenario like this, A has clearly moved. But neither eth0 nor eth1
has seen any changes in link state.

This particular example is a bit contrived. But this is essentially what
happens in redundant topologies when reconfigurations occur (e.g. STP).

These protocols will typically signal reconfigurations to all bridges
though, so as long as the affected flows are flushed at the same time as
the FDB it should work.

Interesting stuff!
