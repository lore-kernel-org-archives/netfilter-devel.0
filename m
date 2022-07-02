Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 269A3C43334
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Jul 2022 05:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiGBFFR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Jul 2022 01:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiGBFFQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Jul 2022 01:05:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3377128735
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2022 22:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656738314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OgmelVIHlZJe+PkFDrrtSLh/L/gMttzAWSBeAVB7Xk8=;
        b=GTJeXwlAJOjHb3LFC7nHGnu18YFucXiybqiaRMw6l0WVhC4LL95LiWYUngyU6mUau9EgLq
        PfkKR/0QmY4h/90NAnTLNvfHEZOR8i4dBtIIh6Z6ZYaE8BY79mhODYJWWaCZBGYtJmyte5
        VXQzwB8WQdekyE4LS6rB7kjQOg02x6o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-AGUzszLpOvad2wlZyVAp9A-1; Sat, 02 Jul 2022 01:05:13 -0400
X-MC-Unique: AGUzszLpOvad2wlZyVAp9A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB8D41C05ECF;
        Sat,  2 Jul 2022 05:05:12 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9305840D282E;
        Sat,  2 Jul 2022 05:05:12 +0000 (UTC)
Date:   Sat, 2 Jul 2022 07:05:09 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_set_pipapo: release elements in clone
 from abort path
Message-ID: <20220702070509.25802501@elisabeth>
In-Reply-To: <Yr+rQ3pKsQBjJAep@salvia>
References: <20220628164527.101413-1-pablo@netfilter.org>
        <20220702003928.1ae75aaa@elisabeth>
        <Yr+rQ3pKsQBjJAep@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, 2 Jul 2022 04:19:47 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Sat, Jul 02, 2022 at 12:39:28AM +0200, Stefano Brivio wrote:
> [...]
> > Other than that, it looks good to me.
> > 
> > I would also specify in the commit message that we additionally look
> > for elements pointers in the cloned matching data if priv->dirty is
> > set, because that means that cloned data might point to additional
> > elements we didn't commit to the working copy yet (such as the abort
> > path case, but perhaps not limited to it).  
> 
> This v2, I forgot to tag it properly:
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220702021631.796822-2-pablo@netfilter.org/
> 
> it is updating documentation and it also adds a paragraph to the
> commit description as you suggested.

Thanks!

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

