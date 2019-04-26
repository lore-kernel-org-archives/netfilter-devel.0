Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 773CDC43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4769B2077B
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:06:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fLuchEcH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfDZQGS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:06:18 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46020 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbfDZQGS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 12:06:18 -0400
Received: by mail-pf1-f194.google.com with SMTP id e24so1929135pfi.12;
        Fri, 26 Apr 2019 09:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QbrThhIz4x0+qP/ijd3OLE/M53TudApirYQPrtFpEoM=;
        b=fLuchEcH12MRqD2ufdG4bOk18J72ajkZauI9fkGXpNWHhfv2fHklPPdWtQ0aT3AXFA
         GYw7hEdkeYAf18rMoOcDCFoZVTxV/wE8Qsnbchj0evHevNWjKJXGZjW8OFs87/s0W3WJ
         S8QOuguSnfteZ9gnShXkmKdFxb/a9CfnHG/EtmC10RspnwGhSjp8DLZ0QNUuxfYATCE1
         klMzsr47hxwzCbJ7DWkAArV95lBKOPM6jT8cb9v6ci4GhDrH2KU1z2UHtoD/bZvCJjf/
         hAPMpl9N6Q8i/6/88YJNZjTMscJ7/KN+MAEm0MAax70wcvlOXD6nvTVSlPwKUUVREaqf
         SMgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QbrThhIz4x0+qP/ijd3OLE/M53TudApirYQPrtFpEoM=;
        b=Zsk8kOtuOH/b7HkRKFkEAIBHXJ2DiPkUTmHQVsr7dH6gIPn0wztRmLzGBd7xpK1kql
         eU/J3lPqs2S7Nn5cmA+SHZW1tqKJK9UtmCJOmORpaOfjMPO3OqeQHNl+eNA1mCKfUn5V
         U59//61Y7fI4qj9+QvSddzbK6kEc7kPcp5z4Co3VV2MwoQgWgcczkJfnKoqaeC2R0aEO
         Mo7tEsDYj1ZkkN8WBUUoKrMBZ6l3n+Bvxt4+Gv/M9Kn2dtXtl/EFMrljKTYy15vLnA4n
         A5bwRmeXxVkyt1zhrZBxLcyyUti4SyJtll1CVCdvqYbFg9X+gDLVO1QKU6czvTW0drt1
         KrLA==
X-Gm-Message-State: APjAAAX9IWJcIZfkAQ0KHE/N50MRil2sBMd1utkiSWhnksw+3n4OIpN8
        Hk+l85SaYv6I5kYiWaOMveQ=
X-Google-Smtp-Source: APXvYqyctW0wlvPe0l/ufxHeXCRqPYfifUeE33JV7ynYp0aYdLB1QZ4ro8Kzb/pW3GojFIR1jwFPqg==
X-Received: by 2002:a63:5715:: with SMTP id l21mr16687377pgb.279.1556294777557;
        Fri, 26 Apr 2019 09:06:17 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:c824:60cf:2bea:8fbc? ([2601:282:800:fd80:c824:60cf:2bea:8fbc])
        by smtp.googlemail.com with ESMTPSA id h4sm35238269pfo.119.2019.04.26.09.06.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Apr 2019 09:06:16 -0700 (PDT)
Subject: Re: [PATCH v3] net: netfilter: Fix rpfilter dropping vrf packets by
 mistake
To:     linmiaohe <linmiaohe@huawei.com>, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Mingfangsen <mingfangsen@huawei.com>
References: <212e4feb-39de-2627-9948-bbb117ff4d4e@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cd63abd0-e979-4b54-8707-af2f7241e64b@gmail.com>
Date:   Fri, 26 Apr 2019 10:06:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <212e4feb-39de-2627-9948-bbb117ff4d4e@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 4/25/19 7:43 AM, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> When firewalld is enabled with ipv4/ipv6 rpfilter, vrf
> ipv4/ipv6 packets will be dropped because in device is
> vrf but out device is an enslaved device. So failed with
> the check of the rpfilter.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  net/ipv4/netfilter/ipt_rpfilter.c  |  1 +
>  net/ipv6/netfilter/ip6t_rpfilter.c | 10 +++++++++-
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 


Reviewed-by: David Ahern <dsahern@gmail.com>
