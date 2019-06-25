Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D665C4646B
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 03:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4884D205C9
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 03:02:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kaechele.ca header.i=@kaechele.ca header.b="mlKgfqo4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730662AbfFYDCp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 23:02:45 -0400
Received: from mail.fetzig.org ([54.39.219.108]:43826 "EHLO mail.fetzig.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730654AbfFYDCo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 23:02:44 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: felix@fetzig.org)
        by mail.fetzig.org (Postfix) with ESMTPSA id 4ACEE8107C;
        Mon, 24 Jun 2019 23:02:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kaechele.ca;
        s=kaechele.ca-201608; t=1561431762;
        bh=K8Mmb0/02NQkOFBzxgJAfaACjjI1q3xuRj529hQALzo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=mlKgfqo4jzuZ3o1ir/tYjD4XUGJC/OtLvOajJ4KYfpTh8kTuOPP7/7E64OKmShGhd
         xPC1Ki3Pcs+Z6YjCBty1LHOtjNuWhsx4Crat7oUmQVowjfxs57wdHEMpHo/wnlwiDV
         WJDt/Ha2aeWBEVgxMI0SQWEglEEvxHSJODCHm7gcItnCpxifdkSW+lTTX4mXj1lsJb
         ffpcaAalePpYO9wANPhHM9Wgtyl0XFONFCbVHuKdJBhhRNLb/+MJ709GHUgikTW/kF
         PZpJxztqqEdS6K48dWwTWbgGbYeSqo49nyVwaFs4LpjTBMGMRApVM9Brv4ib29u+44
         rPg0wFXNz6iNA==
Subject: Re: [PATCH 08/13] netfilter: ctnetlink: Resolve conntrack L3-protocol
 flush regression
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20190513095630.32443-1-pablo@netfilter.org>
 <20190513095630.32443-9-pablo@netfilter.org>
 <0a4e3cd2-82f7-8ad6-2403-9852e34c8ac3@kaechele.ca>
 <20190624235816.vw6ahepdgvxhvdej@salvia>
From:   Felix Kaechele <felix@kaechele.ca>
Message-ID: <4367f30f-4602-a4b6-a96e-35d879cc7758@kaechele.ca>
Date:   Mon, 24 Jun 2019 23:02:40 -0400
MIME-Version: 1.0
In-Reply-To: <20190624235816.vw6ahepdgvxhvdej@salvia>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.101.2 at pandora.fk.cx
X-Virus-Status: Clean
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2019-06-24 7:58 p.m., Pablo Neira Ayuso wrote:
> Could you give a try to this patch?

Hi there,

unfortunately the patch didn't work for me.

I did some deeper digging and it seems that nf_conntrack_find_get within 
ctnetlink_del_conntrack will not find the entry if the address family 
for the delete query is AF_UNSPEC (due to nfmsg->version being 0) but 
the conntrack entry was initially created with AF_INET as the address 
family. I believe the tuples will have different hashes in this case and 
my guess is that this is not accounted for in the code, i.e. that 
AF_UNSPEC should match both AF_INET and AF_INET6. At the moment it seems 
to match none instead.

I could be wrong though, I'm not that familiar with the netfilter code.

Regards,
   Felix
