Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB378C77B75
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Apr 2023 12:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbjDRMHe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Apr 2023 08:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjDRMGx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Apr 2023 08:06:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45850CC16
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2023 04:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681819133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ic+G8JxkY030ztDDxrSVr0gIWS+MILOdZNy5BfZjtHQ=;
        b=GRokVicCAK5z3JYvEz1SaiJmczut8JZ4kCvrVdQz46bWtN3LyCV0MvTo/UL8QPWaWl2/mS
        olStiqtLIENXN96jgEO0eOILmEWJ7y5O1LyhGKxyDiWvl0NW1aQheQYjMl1SWksJeewSpc
        0u87/uSfQlvOJaTwTjhwtbH11RodILM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-1bgyZeYLONWigJUuAVHtxw-1; Tue, 18 Apr 2023 07:58:52 -0400
X-MC-Unique: 1bgyZeYLONWigJUuAVHtxw-1
Received: by mail-wm1-f69.google.com with SMTP id h8-20020a05600c314800b003f170ffbe44so3245293wmo.3
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2023 04:58:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681819131; x=1684411131;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ic+G8JxkY030ztDDxrSVr0gIWS+MILOdZNy5BfZjtHQ=;
        b=JgMdhW9xRHDDK2GuHAaWIIKiGGd4lSCR5tCb/m3mv0muuqDNJI27w57yfwFRYR4TDX
         oTnehnCRAbvZWF5p+rf44cC5XrPmXVnuQrZrS1GT4yyoOyqRo7NO4mjUN9S2iI8h/ULB
         7uf39m8TKUCrOnh2reQM2tCGtjQK21pxu8eWjo4ZvhIhzJ2/OZdcYfILi6BSeJ2pfh4d
         ugoeDqsNrJoLe5Bz31tXTS/XVC+l2RU1/BH16OFDQLgKVLg3mgM4GtP3WEO5gJvgDlY/
         OWdR2MG9lwhrADam5wZz2JtdI7rY+mnGVgOm8zrSzEy4G+X6n2qi+8vM7xE7cV3lSTpZ
         /I9A==
X-Gm-Message-State: AAQBX9cLyNnQfZatNEYN4b3GzDjUAOQhL+cHaHxdUl0VXSNlR6VuRfma
        NqBRv7Ah9HzDfZIudjDzy3LU9iWWgFLo1YTnU9/IZweC9/7G1YRarfdn9LJfGcY6w5i3MZno9Gt
        s3jDVfoRDxnELmBkNKg7xT8aLkMYp
X-Received: by 2002:a7b:cb07:0:b0:3f0:5519:9049 with SMTP id u7-20020a7bcb07000000b003f055199049mr13710165wmj.8.1681819131389;
        Tue, 18 Apr 2023 04:58:51 -0700 (PDT)
X-Google-Smtp-Source: AKy350YYPfT3gB+38KJa3OuGZh4qKj+97YG3AusxGQ1ufp+BlxDKePtvpPOBSG270xYpIPQ/XjAu0Q==
X-Received: by 2002:a7b:cb07:0:b0:3f0:5519:9049 with SMTP id u7-20020a7bcb07000000b003f055199049mr13710144wmj.8.1681819131056;
        Tue, 18 Apr 2023 04:58:51 -0700 (PDT)
Received: from localhost ([37.160.130.245])
        by smtp.gmail.com with ESMTPSA id m4-20020a05600c4f4400b003f0ae957fcesm12903095wmq.42.2023.04.18.04.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 04:58:50 -0700 (PDT)
Date:   Tue, 18 Apr 2023 13:58:46 +0200
From:   Andrea Claudi <aclaudi@redhat.com>
To:     Abhijeet Rastogi <abhijeet.1989@gmail.com>
Cc:     Julian Anastasov <ja@ssi.bg>, Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: change ip_vs_conn_tab_bits range to [8,31]
Message-ID: <ZD6F9l2yE0i42YE5@renaissance-vector>
References: <20230412-increase_ipvs_conn_tab_bits-v1-1-60a4f9f4c8f2@gmail.com>
 <d2519ce3-e49b-a544-b79d-42905f4a2a9a@ssi.bg>
 <CACXxYfxLU0jWmq0W7YxX=44XFCGvgMX2HwTFUUHCUMjO28g5BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXxYfxLU0jWmq0W7YxX=44XFCGvgMX2HwTFUUHCUMjO28g5BA@mail.gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 13, 2023 at 06:58:06PM -0700, Abhijeet Rastogi wrote:
> Hi Simon, Andrea and Julian,
> 
> I really appreciate you taking the time to respond to my patch. Some follow up
> questions that I'll appreciate a response for.
> 
> @Simon Horman
> >In any case, I think this patch is an improvement on the current situation.
> 
> +1 to this. I wanted to add that, we're not changing the defaults
> here, the default still stays at 2^12. If a kernel user changes the
> default, they probably already know what the limitations are, so I
> personally don't think it is a big concern.
> 
> @Andrea Claudi
> >for the record, RHEL ships with CONFIG_IP_VS_TAB_BITS set to 12 as
> default.
> 
> Sorry, I should have been clearer. RHEL ships with the same default,
> yes, but it doesn't have the range check, at least, on the version I'm
> using right now (3.10.0-1160.62.1.el7.x86_64).
> 
> On this version, I'm able to load with bit size 30, 31 gives me error
> regarding allocating memory (64GB host) and anything beyond 31 is
> mysteriously switched to a lower number. The following dmesg on my
> host confirms that the bitsize 30 worked, which is not possible
> without a patch on the current kernel version.
> 
> "[Fri Apr 14 01:14:51 2023] IPVS: Connection hash table configured (size=1073741
> 824, memory=16777216Kbytes)"

I see. This makes sense to me as RHEL 7 does not include the range
check, while RHEL 8 and RHEL 9 both includes it.

The reason why any number beyond 31 results in a lower number is to be
searched in gcc implementation. IIRC shifting an int by more than 31 or
less than 0 results in an undefined behaviour, according to the C
standard.

> 
> @Julian Anastasov,
> >This is not a limit of number of connections. I prefer
> not to allow value above 24 without adding checks for the
> available memory,
> 
> Interesting that you brought up that number 24, that is exactly what
> we use in production today. One IPVS node is able to handle spikes of
> 10M active connections without issues. This patch idea originated as
> my company is migrating from the ancient RHEL version to a somewhat
> newer CentOS (5.* kernel) and noticed that we were unable to load the
> ip_vs kernel module with anything greater than 20 bits. Another
> motivation for kernel upgrade is utilizing maglev to reduce table size
> but that's out of context in this discussion.
> 
> My request is, can we increase the range from 20 to something larger?
> If 31 seems a bit excessive, maybe, we can settle for something like
> [8,30] or even lower. With conn_tab_bits=30, it allocates 16GB at
> initialization time, it is not entirely absurd by today's standards.
> 
> I can revise my patch to a lower range as you guys see fit.
> 
> --
> Cheers,
> Abhijeet (https://abhi.host)
> 

