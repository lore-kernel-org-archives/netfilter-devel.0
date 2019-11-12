Return-Path: <SRS0=y7H9=ZE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DAE4C43331
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 12:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F6AB206BB
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 12:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfKLMIT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Nov 2019 07:08:19 -0500
Received: from mail-wr1-f47.google.com ([209.85.221.47]:37799 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbfKLMIT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Nov 2019 07:08:19 -0500
Received: by mail-wr1-f47.google.com with SMTP id t1so18251529wrv.4
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2019 04:08:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=0mcli/ld+wBlGUeBDPpdcPjq+b9VeGIaN/FAvTUm32c=;
        b=t+8E5uuTECP3YqOvGp2VfBNJi1SvHpxhTDAOzqaSFKgVsRl9z4unYgcgLIePGhWstF
         4kM9HczeoVVmneF4xspb9yVFYNCRDYJRpTYxKBiixIZe1ADbPFf5HfPM3XewCgd19Pz9
         oA+wNT1DNioASQYMYHzjyBeB7O1KFy6WbQRHR5nm0SEgr//2YVtaEWWrNC7nFmuYQ5Bz
         P/PSHggsdKFld3KXSoqfE201M/LJxuh62Wc/qDmWyr6IuVvFPUSWyeh8v+mV4mT4MHHg
         +Djd6/rJrFnZ/D2+fNRSoipDIIIFPoG+bCPq61GN63YlW4947UNncuQivQ4y8Xx+VdcT
         Gqow==
X-Gm-Message-State: APjAAAUqUzg8TavFSby39xrlH5IjUzb6bOAvA4jpnZen+YQuifcDqgQz
        JszFV8vMktXyi1K3prWH9Bpio7kIX80=
X-Google-Smtp-Source: APXvYqyKxCaxiFOAmMksEiFKRPz2K+s1X78HuuAeD91APo9xMtzZkT8t0hOsncvcCp3vocLARVSyaQ==
X-Received: by 2002:adf:fb8b:: with SMTP id a11mr10122128wrr.83.1573560496512;
        Tue, 12 Nov 2019 04:08:16 -0800 (PST)
Received: from [192.168.1.156] ([213.194.137.137])
        by smtp.gmail.com with ESMTPSA id 189sm4124896wme.28.2019.11.12.04.08.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2019 04:08:15 -0800 (PST)
Subject: Re: [nft PATCH 1/2] files: Drop shebangs from config files
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191107114516.9258-1-phil@nwl.cc>
 <99bf1a8a-96e9-3ad6-bef4-3defe0da951b@netfilter.org>
 <20191112113641.GA11663@orbyte.nwl.cc>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Openpgp: preference=signencrypt
Autocrypt: addr=arturo@netfilter.org; keydata=
 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
 EXgmBmyUKrJkh/zvupp9t9Y2ioPbcMObRIEXio4=
Message-ID: <b3bb0b8a-f018-0a12-da7f-35bc3318c041@netfilter.org>
Date:   Tue, 12 Nov 2019 13:08:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191112113641.GA11663@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 11/12/19 12:36 PM, Phil Sutter wrote:
> 
> But for me, (B) is fine as well. I just think we should be consistent.
> :)
> 

On second thought, I don't have strong opinion :-) so go ahead with whatever
approach you see fit.
