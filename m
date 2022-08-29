Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85FFAECAAD2
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Aug 2022 14:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiH2Os2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Aug 2022 10:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiH2Os1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Aug 2022 10:48:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA60D8E4D8
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2022 07:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661784506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iDWY21XZ+Mxzv6a2uyCuIbhj0NbbXrdLTZc43XeVG0A=;
        b=GMeX7hVckIPvUew0cJmA+bxedY0khoaDPPCDmHX5PPmBgDqS0ZoAtpj6Z5hSAeYg2TojgR
        nvSDLxJ5ZRkPwE/wgf+Xf90qdNA8kOqJ7nwwYoPlLhAgU93Brzm8+e4DMWNjGLGFjQEEZC
        Fj10/ctr2j8gWSdAR7CLfVLha0TaBkY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-494-3aqHkrDCMauYaem793o2Cw-1; Mon, 29 Aug 2022 10:48:24 -0400
X-MC-Unique: 3aqHkrDCMauYaem793o2Cw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73CE4858F11;
        Mon, 29 Aug 2022 14:48:19 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.9.178])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EEA301121314;
        Mon, 29 Aug 2022 14:48:18 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, i.maximets@ovn.org,
        pshelar@ovn.org, dev@openvswitch.org
Subject: Re: [PATCH nf] netfilter: remove nf_conntrack_helper sysctl toggle
References: <20220826070600.8404-1-pablo@netfilter.org>
Date:   Mon, 29 Aug 2022 10:48:18 -0400
In-Reply-To: <20220826070600.8404-1-pablo@netfilter.org> (Pablo Neira Ayuso's
        message of "Fri, 26 Aug 2022 09:06:00 +0200")
Message-ID: <f7t1qszjebx.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> __nf_ct_try_assign_helper() remains in place but it now requires a
> template to configure the helper.
>
> A toggle to disable automatic helper assignment was added by:
>
>   a9006892643a ("netfilter: nf_ct_helper: allow to disable automatic helper assignment")
>
> in 2012 to address the issues described in "Secure use of iptables and
> connection tracking helpers". Automatic conntrack helper assignment was
> disabled by:
>
>   3bb398d925ec ("netfilter: nf_ct_helper: disable automatic helper assignment")
>
> back in 2016.
>
> This patch removes the sysctl toggle, users now have to rely on explicit
> conntrack helper configuration via ruleset.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---

Acked-by: Aaron Conole <aconole@redhat.com>

Ilya / Pravin,

We will likely need to make a change in the ovs test-suite from:

  sysctl -w net.netfilter.nf_conntrack_helper=0

to:

  sysctl -ew net.netfilter.nf_conntrack_helper=0

I will cook up a quick patch

-Aaron

