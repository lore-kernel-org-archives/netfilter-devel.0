Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 428C0C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Oct 2022 13:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiJSNFe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Oct 2022 09:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiJSNFL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Oct 2022 09:05:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087B926EE
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Oct 2022 05:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666183686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q8LPpnYpysqGSiJUPWry3p0iYpcsy7FD/788/f3PsSg=;
        b=Qn0+rBGPLiyH9WHpiRTaD/2x699wQdTKEXjcYQCBqjxov9u8rlSP6+ShXtqWFCXOrb6euG
        CSREjUN+CeBkrzKOAzlJB9dbjOpl8JSP0gSN6GAGy1ztbMk6saQeh5VMS17HpGGxFU6rVF
        zM9mCHcFnjjeYpPnwpEe8uq2HT9fREk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-526-bX29pvWPPFSQf0wSFDJAnA-1; Wed, 19 Oct 2022 08:41:30 -0400
X-MC-Unique: bX29pvWPPFSQf0wSFDJAnA-1
Received: by mail-ej1-f70.google.com with SMTP id hq13-20020a1709073f0d00b0078dce6a32fcso7973558ejc.13
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Oct 2022 05:41:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q8LPpnYpysqGSiJUPWry3p0iYpcsy7FD/788/f3PsSg=;
        b=DVIXMR4SaQjrIu+yAX+ZYaH96tnP7AV+S1AfAtdLyTyBbQtld2db3SQ83VTge73yx3
         o5gQLsYJKnHcTIrdLKYLI6xc+wgqPqTR4Ngf77iCyPdOfR9na/oasBcF8oZmvB8VAg5a
         ZyT4fQdsiE7jJobRnBVjJfgCZEXHdxotaN7t54ZykQpiHlqiMRz1mgPQx/qFIK7dsjSr
         18MGV+nfbfxXCyEZTqeszZ0xVXvC4hwz+2ZDLJod9IRgqDUz8n6ycQzx89+3gx9J98W/
         4MPZocUTPXpXz0GctnfDd/DEjGACTxHA2997xduHucYB54yqoPbOHZIhkk1nzfm9kppm
         h5eg==
X-Gm-Message-State: ACrzQf0gwxev18WDvabxKu4nfmHtmZzsa3uWV934HTLFfhFf1cQ9ZZyE
        vdKzqOSqn1b74TRbaim9XIjwOcpK8AC/0GvzPbpPPXax97h6nq/Gpi0BmXLF+u2f4WfhdyRuDUa
        cw23HLGOry0JA3qT2aCEsYym3Jqgc
X-Received: by 2002:a17:906:5a4b:b0:78d:8790:d4a1 with SMTP id my11-20020a1709065a4b00b0078d8790d4a1mr6561277ejc.329.1666183287302;
        Wed, 19 Oct 2022 05:41:27 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6sWe0zylQfRJULRKTF9A5wU7VQf2KsdTVq4NOZsdUmfUsJ4OCFQfVUDSsqaTfCq+dVr7yOIg==
X-Received: by 2002:a17:906:5a4b:b0:78d:8790:d4a1 with SMTP id my11-20020a1709065a4b00b0078d8790d4a1mr6561225ejc.329.1666183286337;
        Wed, 19 Oct 2022 05:41:26 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k15-20020a17090632cf00b0078d38cda2b1sm8818709ejk.202.2022.10.19.05.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 05:41:25 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9D7306C25B2; Wed, 19 Oct 2022 14:41:24 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Florian Westphal <fw@strlen.de>, bpf@vger.kernel.org
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: netfilter+bpf road ahead
In-Reply-To: <20221018182637.GA4631@breakpoint.cc>
References: <20221018182637.GA4631@breakpoint.cc>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 19 Oct 2022 14:41:24 +0200
Message-ID: <87a65shtor.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> writes:

> - lots of details to be figured out, but if netfilter core folks
> agree to this plan it will be one of the most exciting
> projects in the linux networking. iptables will see significant
> performance boost and major feature addition.
> Blending bpf and netfilter worlds would be fantastic.

+1 on this; sounds like great news, and I look forward to seeing this
effort come to fruition. Thank you both for taking time to hash this
out! :)

-Toke

