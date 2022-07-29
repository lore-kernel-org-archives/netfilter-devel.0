Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D12C00144
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jul 2022 13:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbiG2NIm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Jul 2022 09:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236522AbiG2NI1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Jul 2022 09:08:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D01F2655
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jul 2022 06:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659100027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hw/T0KuutWmutKorDwSCcw84YbRCYDzWVqoD6oCagEc=;
        b=QZK3xHinxJCoBGvLmSIDfmHNjiPJ9G5/HhqdTSsvmkITuV5bXFyN2V46wa3CYNgTmMTmG8
        DVVY1ivOdEcO7NawmVY943qK3k6BHA8SkkNx0ryo8x+Pm2g1tJGXCerjBlF78EDwYrtqAD
        Wt5UniX6u2fdYphb5T3EWHbznQdRK+E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-0gR6w3JUPnylcH6Knnvr1w-1; Fri, 29 Jul 2022 09:07:05 -0400
X-MC-Unique: 0gR6w3JUPnylcH6Knnvr1w-1
Received: by mail-wm1-f69.google.com with SMTP id p36-20020a05600c1da400b003a33a8c14f2so2172512wms.7
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jul 2022 06:07:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc;
        bh=Hw/T0KuutWmutKorDwSCcw84YbRCYDzWVqoD6oCagEc=;
        b=C0d76dMhyc67fKHJbgkuLN2QrgaKFDAPgCsdUE+I92jcY2JyLwNPu99GhrP7Yai3eK
         M+qibprO9mB/elBFm2qQisG9I9P0n5YY+kadZYzUB2z2vfgsiul8ckslALvzeFeUzVB8
         FpDbDp+vYtF/6Ty66FgolzGrV9rcTdC72bdxRYyb2KjxVfNJWvWDDoFJlJJ8vf+TXkMY
         lemX5p7Hee1RIoYL9PefFz2/nG8ia1qR3HFKESV3l0AeJCqYbtDDkRFu8Bji+2ZgYbx8
         JsSHKcSjXV0xg2ITA8Oma8bTcurdGK87XtDcOqFxDrMLoCP14X6K5uNkaWCQ8a+JpjAK
         +Qmw==
X-Gm-Message-State: AJIora87TFVKLcninI3uTkQecymyOW3KsJnI9JKZAYPmS2MT01ncxKC5
        LASUAZUpOVuVSgBObYwIwRL5rmS+RsWfmVXr3FpDGu9e7fVH3hnPbUvAXJjmE4c9m4c4nBRluu8
        GvLeaatQ23xQtkxVX7LoNY6sFrTtR
X-Received: by 2002:a05:600c:2194:b0:3a3:bea:1017 with SMTP id e20-20020a05600c219400b003a30bea1017mr2471647wme.44.1659100024040;
        Fri, 29 Jul 2022 06:07:04 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t0zeZ8KjApceSA4fdtwakYqmTwf9SQr1yGnTwqJ+OW3Yi4kYN4fhYK02MY5245rOl6IQXe+w==
X-Received: by 2002:a05:600c:2194:b0:3a3:bea:1017 with SMTP id e20-20020a05600c219400b003a30bea1017mr2471626wme.44.1659100023556;
        Fri, 29 Jul 2022 06:07:03 -0700 (PDT)
Received: from nautilus.home.lan (cst2-15-35.cust.vodafone.cz. [31.30.15.35])
        by smtp.gmail.com with ESMTPSA id z14-20020a05600c0a0e00b003a31ca9dfb6sm5145067wmp.32.2022.07.29.06.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 06:07:03 -0700 (PDT)
Date:   Fri, 29 Jul 2022 15:07:01 +0200
From:   Erik Skultety <eskultet@redhat.com>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/3] tests: shell: Fix testcases for changed
 ip6tables opts output
Message-ID: <YuPbdXD9rjfrA7zX@nautilus.home.lan>
References: <20220728113136.24376-1-phil@nwl.cc>
 <20220728132634.GC4816@breakpoint.cc>
 <YuOubmfEJ3wZ750N@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YuOubmfEJ3wZ750N@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 29, 2022 at 11:54:54AM +0200, Phil Sutter wrote:
> On Thu, Jul 28, 2022 at 03:26:34PM +0200, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > Adjust captured output, ip6tables prints '--' instead of spaces since
> > > the commit in Fixes: tag.
> > 
> > Thanks, all 3 patches look good to me.
> 
> Series applied, thanks for your review.
> 
> Cheers, Phil
> 

Thank you for taking care of the fixes Phil, much appreciated.

Regards,
Erik

