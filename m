Return-Path: <SRS0=iy/8=SN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06141C10F13
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 19:46:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2B322070D
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 19:46:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="gzYVKVcR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfDKTqU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 15:46:20 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54968 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726577AbfDKTqU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 15:46:20 -0400
Received: by mail-wm1-f68.google.com with SMTP id c1so8215140wml.4
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Apr 2019 12:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Kw7Bj/IDGgX8T5/sQ7iiAjq559FI+Z3akbIQXjeqjhs=;
        b=gzYVKVcR8YvNH/cviohnRUvubmz83Yza2z6BiSpdDM/nPpnk/Aue0NPKupon4sEA1k
         yBHcERBaNY/Fzxa5ePIxlC5NJsjdUzEVb5UE0+1XztO9FmSkyNdRR0cV8RSLwZ0VWXqW
         4IBaQoXjJFH/KbuDm/ZQrMsL3uemyuB2aPvzc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kw7Bj/IDGgX8T5/sQ7iiAjq559FI+Z3akbIQXjeqjhs=;
        b=AMwY694N9bZSBgwYuhq9D9r15Jb4JLPTz7CEXWHffWloOlHNrh/dzn48WScb2DbmYi
         X8jIUSM6ozyqAeGrFcM2G9wpuAJORo/4xVjN0CZhyFoj+JiZiS8rO4ySBBCcIwsHKV0h
         tYA5tG57YRL6+eG8AWDCUJGQpjc3AvqErzi8F6zUNu8WjgljKiUdt5KsZmEkSrP6s28z
         nNl2bKEwKYAtILZKXDX5K4KLAQEdggBpiwMz7qhZDoKK94VOfh8mG9SjT4xxOdUsuncf
         QJlnzjaLSOWRS5blWEKdqFME4DizFepnwRY3cUg7sIdex6Pa/HNVZ7gYp6v94CNXM/z0
         Zl1A==
X-Gm-Message-State: APjAAAVsXy6MBk5dsFlA8p0OH3Quuqk5peEOaAc0EzvU2xHdm6iacdDc
        qMfAKBgAefK6LCXQgMHhwSqJXA==
X-Google-Smtp-Source: APXvYqyj1e1qOS/bwgJ+koBjkwqfZtwOWyyTznJPALoZ8qLulrWd5cNMT0VPjYTJgJ0VNQSG0266Tw==
X-Received: by 2002:a1c:21c1:: with SMTP id h184mr7552842wmh.128.1555011978403;
        Thu, 11 Apr 2019 12:46:18 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id z20sm4248666wmf.34.2019.04.11.12.46.17
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Apr 2019 12:46:17 -0700 (PDT)
Subject: Re: [PATCH nf-next 0/4] netfilter: bridge: remove broute hook
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, netdev@vger.kernel.org
References: <20190411143642.1087-1-fw@strlen.de>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <c3d1e77b-b3e2-cc27-d569-ddcea9460273@cumulusnetworks.com>
Date:   Thu, 11 Apr 2019 22:46:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190411143642.1087-1-fw@strlen.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 11/04/2019 17:36, Florian Westphal wrote:
> This series removes the 'broute' hook by promoting ebtables' broute table
> to a normal ebtables table (invoked via normal PREROUTING netfilter hook).
> 
> The downside is that nf_hook_slow() needs to be duplicated in br_input.c
> (see patch 3).
> 
> However, I think its worth the price as this allows to remove the
> br_should_route_hook.
> 
> There are quite some changes in bridge specific code, if you prefer
> I can re-submit this for net-next instead of nf-next.
> 
> Main motivation is to provide 'ebtables -t broute' functionality via
> nftables later on, this can then be done without touching the bridge
> or netfilter core infrastructure again.
> 
> Florian Westphal (4):
>       selftests: netfilter: add ebtables broute test case
>       bridge: reduce size of input cb to 16 bytes
>       bridge: netfilter: unroll NF_HOOK helper in bridge input path
>       bridge: broute: make broute a real ebtables table
> 
>  include/linux/if_bridge.h                           |    3 
>  include/net/netfilter/nf_queue.h                    |    3 
>  net/bridge/br_arp_nd_proxy.c                        |   18 +-
>  net/bridge/br_input.c                               |   72 +++++++--
>  net/bridge/br_private.h                             |   15 +-
>  net/bridge/netfilter/ebtable_broute.c               |   63 ++++++--
>  net/bridge/netfilter/ebtables.c                     |    7 
>  net/netfilter/core.c                                |    1 
>  net/netfilter/nf_internals.h                        |    3 
>  net/netfilter/nf_queue.c                            |    1 
>  tools/testing/selftests/netfilter/Makefile          |    2 
>  tools/testing/selftests/netfilter/bridge_brouter.sh |  146 ++++++++++++++++++++
>  12 files changed, 268 insertions(+), 66 deletions(-)
> 

The set looks good to me, the only little thing is the new memset() in br_handle_frame(),
before we would lazily zero the fields when needed but that would save us from future
bugs where one could forget to initialize the field.
Now we can remove most of the explicit cb field zeroing and rely on the memset.

Nice work! For the set:

Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

