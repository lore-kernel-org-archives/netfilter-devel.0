Return-Path: <SRS0=v9tr=TU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE30BC072A4
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 08:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9484920815
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 08:35:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="VXJnk5kH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731349AbfETIfM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 May 2019 04:35:12 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44605 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730560AbfETIfM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 May 2019 04:35:12 -0400
Received: by mail-wr1-f65.google.com with SMTP id w13so2782290wru.11
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2019 01:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bG4Kqc3qMuBLltAr8C7D8iKFlz7OsYrQEvYRkM3+OEU=;
        b=VXJnk5kHKtVwNnuhdIJ2dl+OaQp4kitl22fnWKlTY/Bru6ql2gj9nWvJLJcaG/na2+
         ZGdrj1/vrsZm+GtblMvFLlx2Cj0+Q/n/7kvNL/76WSg/1sFI6d763PR4WrpNsYyy2Tug
         RPaORdmZfcZKX/2WTPh5mAcQOi9amTydUH9RpoNUskWvtUaUBB2PmGd2xZiawIgnOdPs
         CUhaY6ruaMsyo3Gbn2hZg44dq4ErbNPD7/L84fKwsr22WjORps5J1pmR/8aDNzYh110M
         jnQpE8RWdYVIQtHPABR8zi+h28M1BMlDMFsFn6NmGxtBSPyZsWPIvJLPFY3EKrEeku7T
         R8lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=bG4Kqc3qMuBLltAr8C7D8iKFlz7OsYrQEvYRkM3+OEU=;
        b=blVLp1pSYHCZxcSkpsPZY01dn8Vdeiu77d0Yo97i69LOsXbQM7u42gxZZW2VVUxnNn
         SQRmWon1aHIuJWLpZ4QTBnltlAaTJPKwSBZqaLclnRqKO+VTJRDETsPrWSRoXY4F392k
         pQjbgfVW4oHgjnWRGGr1X+vwCldomVghKukfAIV+qsf4rt0cXzFqlnqajILI37p0JcRj
         kqRJt4ePVS8it2yxU082IOes4McKOlIVXwx9XQFp7rkFTEVb074r4+PKXj70Z9XEgDd+
         /HLfvss4TsqfZaQjgVLglIrWjNz2WFeEXQZlrg7ScpBNAtmMVU5N2oP6qhb06OFcVO8w
         6zjg==
X-Gm-Message-State: APjAAAUF5vsMBdyi/wJEF0Bnd8bQnQJpId7HQDqsJgdHfmVrvVLYj96X
        oXxQyARRKLv/0NM6AhygiLsSWIL9AoM=
X-Google-Smtp-Source: APXvYqwEm78jdEIhWkkbxCxZLr6ai+5F+wLh0tlxQfs3jsbnWV6bVHMECqQvR/PmKmDyv7Elow7bUg==
X-Received: by 2002:a5d:6143:: with SMTP id y3mr43681957wrt.148.1558341310472;
        Mon, 20 May 2019 01:35:10 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:991:7682:c5ae:7f76? ([2a01:e35:8b63:dc30:991:7682:c5ae:7f76])
        by smtp.gmail.com with ESMTPSA id a15sm16146747wru.88.2019.05.20.01.35.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 01:35:09 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] netfilter: ctnetlink: Resolve conntrack L3-protocol flush
 regression
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Kristian Evensen <kristian.evensen@gmail.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
References: <20190503154007.32495-1-kristian.evensen@gmail.com>
 <20190505223229.3ujqpwmuefd3wh7b@salvia>
 <4ecbebbb-0a7f-6d45-c2c0-00dee746e573@6wind.com>
 <20190506131605.kapyns6gkyphbea2@salvia>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <6dea0101-9267-ae20-d317-649f1f550089@6wind.com>
Date:   Mon, 20 May 2019 10:35:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190506131605.kapyns6gkyphbea2@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 06/05/2019 à 15:16, Pablo Neira Ayuso a écrit :
> On Mon, May 06, 2019 at 10:49:52AM +0200, Nicolas Dichtel wrote:
[snip]
>> Is it possible to queue this for stable?
> 
> Sure, as soon as this hits Linus' tree.
> 
FYI, it's now in Linus tree:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f8e608982022


Thank you,
Nicolas
