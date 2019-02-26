Return-Path: <SRS0=SqQQ=RB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61AE2C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 09:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39C6A213A2
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 09:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfBZJKx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Feb 2019 04:10:53 -0500
Received: from nimbus.fidion.de ([62.146.2.206]:51478 "EHLO nimbus.fidion.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbfBZJKw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Feb 2019 04:10:52 -0500
Received: (qmail 30004 invoked from network); 26 Feb 2019 09:10:48 -0000
Received: from nimbus.fidion.de (HELO ?192.168.42.88?) (flo@62.146.2.206)
  by nimbus.intra.fidion.de with ESMTPA; 26 Feb 2019 09:10:48 -0000
Subject: Re: [PATCH] netfilter: nf_conntrack_amanda: add support for STATE
 streams
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <a01c1d2d-d55d-c55b-c39d-2b35c070bcae@fidion.de>
 <20190215143902.ga5e2pljilncvqcu@salvia>
 <ecf05928-0258-f835-6ea2-f6bb73a83481@fidion.de>
 <20190218095336.2u54jnsn3mmxoq5q@salvia>
 <767a3554-3a6f-651d-44d7-7b309a29688f@fidion.de>
 <20190218124245.s3b5zoysnu7gtloy@salvia>
From:   Florian Tham <tham@fidion.de>
Openpgp: preference=signencrypt
Message-ID: <5ed5cbb2-d083-ef70-7ca6-6c0ca7cb8062@fidion.de>
Date:   Tue, 26 Feb 2019 10:10:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190218124245.s3b5zoysnu7gtloy@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Pablo,

On 2/18/19 1:42 PM, Pablo Neira Ayuso wrote:
>> After I set max_expected to 4, the backup completes successfully.
> 
> Then, the new protocol version needs to set up more than 3
> expectations in parallel. Please, document this in your patch
> description.

I did so in my reply to this message on Feb. 18. Does this work for you,
or is there anything else I can do?

Best regards,

Florian
