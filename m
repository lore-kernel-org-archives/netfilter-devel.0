Return-Path: <SRS0=Eqja=WM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D267C3A59C
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 15:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2598E2133F
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 15:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfHPPKA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Aug 2019 11:10:00 -0400
Received: from rp02.intra2net.com ([62.75.181.28]:59862 "EHLO
        rp02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfHPPKA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Aug 2019 11:10:00 -0400
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by rp02.intra2net.com (Postfix) with ESMTPS id 808781000BE;
        Fri, 16 Aug 2019 17:09:58 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id 548714F5;
        Fri, 16 Aug 2019 17:09:58 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.54.70,VDF=8.16.21.30)
Received: from rocinante.m.i2n (rocinante.m.i2n [172.16.1.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: smtp-auth-user)
        by mail.m.i2n (Postfix) with ESMTPSA id AC65335A;
        Fri, 16 Aug 2019 17:09:56 +0200 (CEST)
Subject: Re: [PATCH v2] netfilter: nfacct: Fix alignment mismatch in
 xt_nfacct_match_info
From:   Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
To:     fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
References: <7899070.tJGA48rBTd@rocinante.m.i2n>
Message-ID: <3db64b99-9787-4e9d-7499-55cb32591856@intra2net.com>
Date:   Fri, 16 Aug 2019 17:09:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <7899070.tJGA48rBTd@rocinante.m.i2n>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian.

I hope this patch reflects your suggestion to add a 'v1' match revision
to nfacct. To be sincere, I'm not sure if should have also written
nfacct_mt_v1() and etc, since these would be pretty much duplicate code.


Please let me know if this patch needs more work.

Best regards,
Juliana.

On 8/16/19 5:02 PM, Juliana Rodrigueiro wrote:
> When running a 64-bit kernel with a 32-bit iptables binary, the size of
> the xt_nfacct_match_info struct diverges.
> 
>      kernel: sizeof(struct xt_nfacct_match_info) : 40
>      iptables: sizeof(struct xt_nfacct_match_info)) : 36
> 
> Trying to append nfacct related rules results in an unhelpful message.
> Although it is suggested to look for more information in dmesg, nothing
> can be found there.
> 
>      # iptables -A <chain> -m nfacct --nfacct-name <acct-object>
>      iptables: Invalid argument. Run `dmesg' for more information.
> 
> This patch fixes the memory misalignment by enforcing 8-byte alignment
> within the struct's first revision. This solution is often used in many
> other uapi netfilter headers.
> 
> Signed-off-by: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
> ---
> Changes in v2:
>      - Keep ABI by creating a v1 of the match struct.
> 
>   include/uapi/linux/netfilter/xt_nfacct.h |  5 ++++
>   net/netfilter/xt_nfacct.c                | 36 ++++++++++++++++--------
>   2 files changed, 30 insertions(+), 11 deletions(-)
> 
