Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE362C5517A
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Nov 2020 08:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 849AE20731
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Nov 2020 08:40:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b9o392c8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731131AbgKJIkF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Nov 2020 03:40:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56473 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729518AbgKJIjy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 03:39:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604997593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hyh7UaM+g2trOiYngrS9dlcrb+FW3phxTbIaNTk+T7A=;
        b=b9o392c8a6dLMBfCuW/vlXBKcgWWQ750CX5sv2CDbqAxeK5/Xqcru3xMRlVbF3O5sCRQ7B
        fY4qN5iUK+kl/iWedqi+V7qcZxedIB1Gb4XxUYC72dpEJJMCBmFR/kDZ26n5Rhzp/Ounmg
        GqVJHzy0MCGZekCd+E2ikGCYl1CErx4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-KeGyJCg8PqaMy4fqIlWfGg-1; Tue, 10 Nov 2020 03:39:50 -0500
X-MC-Unique: KeGyJCg8PqaMy4fqIlWfGg-1
Received: by mail-wm1-f69.google.com with SMTP id h2so960812wmm.0
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2020 00:39:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hyh7UaM+g2trOiYngrS9dlcrb+FW3phxTbIaNTk+T7A=;
        b=hwIwJRDyU+mKP343edk+R7dNCLHIBPD2EYrIOlpl6gSOADCoJbxeX/lC/YXdnLYEM+
         bb3bwZx/0jG+ltLLmpDJQXFO2smub17rp0ybmP61fbX+oOd0/T2mhGcDopAUFb0RNbJ9
         biwZap+2n5283ctVI6u+t0p0S912drdlMvGJtqrn/9/cuDN4fVCzv+HjRKbEG1aWmvoC
         pPqstcV6IAy96JnO1A/sC+5cD1HxHO4SgbW0DvYuY1HYqYkAZnyk8lUzSTdxdDXucb9T
         tRNh+yH6Y1q12ze7DCKCcyPB0vpYS6SuBhmF4iIC3jXoIaa2ZdvK/GzqzN797hyDCx6t
         K9NQ==
X-Gm-Message-State: AOAM531clakR+eo8D8WxHvDvUJSnrXFpd20MZ1LuOsld/c5v1b9ppLqW
        ga8N1OrgzLUKuOQESVSThUHDyszdN7AtIsdSY5jzCBLljZcIexerUFzG94+u8o7BpEaqF8t2mP5
        PHxmqi0bPJoNPlIm3T1SLX5PvbEyAMLKvFLOgEbgYT7HN
X-Received: by 2002:a1c:1906:: with SMTP id 6mr3356323wmz.87.1604997588698;
        Tue, 10 Nov 2020 00:39:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJygpgV8AXXuqlYLBeLe3dxUBkWwtMJMFF9d1iDZ4oUQhYNTvKRIcdpuQ/GdhgZUyOjn8cfx8iWl2yN8a32afMU=
X-Received: by 2002:a1c:1906:: with SMTP id 6mr3356300wmz.87.1604997588429;
 Tue, 10 Nov 2020 00:39:48 -0800 (PST)
MIME-Version: 1.0
References: <20201109072930.14048-1-nusiddiq@redhat.com> <20201109115458.0590541b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201109115458.0590541b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Numan Siddique <nusiddiq@redhat.com>
Date:   Tue, 10 Nov 2020 14:09:37 +0530
Message-ID: <CAH=CPzpXfLLPWLgH07iEQQJQyWNCW2uv6hh7oFCe-1uVY825SQ@mail.gmail.com>
Subject: Re: [net-next] netfiler: conntrack: Add the option to set ct tcp flag
 - BE_LIBERAL per-ct basis.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     ovs dev <dev@openvswitch.org>, netdev <netdev@vger.kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 10, 2020 at 1:25 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  9 Nov 2020 12:59:30 +0530 nusiddiq@redhat.com wrote:
> > From: Numan Siddique <nusiddiq@redhat.com>
> >
> > Before calling nf_conntrack_in(), caller can set this flag in the
> > connection template for a tcp packet and any errors in the
> > tcp_in_window() will be ignored.
> >
> > A helper function - nf_ct_set_tcp_be_liberal(nf_conn) is added which
> > sets this flag for both the directions of the nf_conn.
> >
> > openvswitch makes use of this feature so that any out of window tcp
> > packets are not marked invalid. Prior to this there was no easy way
> > to distinguish if conntracked packet is marked invalid because of
> > tcp_in_window() check error or because it doesn't belong to an
> > existing connection.
> >
> > An earlier attempt (see the link) tried to solve this problem for
> > openvswitch in a different way. Florian Westphal instead suggested
> > to be liberal in openvswitch for tcp packets.
> >
> > Link: https://patchwork.ozlabs.org/project/netdev/patch/20201006083355.121018-1-nusiddiq@redhat.com/
> >
> > Suggested-by: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Numan Siddique <nusiddiq@redhat.com>
>
> Please repost Ccing Pablo & netfilter-devel.

Thanks. I will repost.

Numan

>

