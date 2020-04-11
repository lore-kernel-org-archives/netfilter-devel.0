Return-Path: <SRS0=44Uw=53=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B805AC2BA2B
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Apr 2020 13:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5759D20753
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Apr 2020 13:35:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=thorsten-knabe.de header.i=@thorsten-knabe.de header.b="BQSFFA3k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgDKNfm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Apr 2020 09:35:42 -0400
Received: from mail.thorsten-knabe.de ([212.60.139.226]:42302 "EHLO
        mail.thorsten-knabe.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgDKNfm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Apr 2020 09:35:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=thorsten-knabe.de; s=dkim1; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LUnm7T2aKDusNEbafyv67eqERnXgL0QPtLK2k2dTdbY=; b=BQSFFA3kro0O9KzfFPq5/kiFcI
        MMYts1ktG6FiW7AjJpFE1Mt5EUD154SZgGNBxHrorde10P0bZl37qD0gz5mamfx6NIUw9P4RTo3vE
        /3JWhiXqjkqpa44s5wqbXAyXT9oPwzdkx8nKWQBZ8adRBhsVUVWjdDu9I171FRFFgoJ+8zFpdkSg3
        mCDLldV1PXqZ62b+E9Cpgn+RUGNvwug+tsgLT1oKTTuK99QtCAdz6BuamRwi/Mw9jlbSUpkvsL+Gj
        XGwKh3PHL0Lyd12rE7lLACYsCwklL9Sx6l6V8eualOURtBr54k8wq1iKLtr77FwOXmJBspK8H47pU
        NX8hHyUg==;
Received: from tek01.intern.thorsten-knabe.de ([2a01:170:101e:1::a00:101])
        by mail.thorsten-knabe.de with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <linux@thorsten-knabe.de>)
        id 1jNGIJ-0002D9-A1; Sat, 11 Apr 2020 15:35:37 +0200
Subject: Re: BUG: Anonymous maps with adjacent intervals broken since Linux
 5.6
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
References: <6d036215-e701-db81-d429-2c76856463ee@thorsten-knabe.de>
 <20200411092456.72e2ddd4@elisabeth>
From:   Thorsten Knabe <linux@thorsten-knabe.de>
Message-ID: <4f8bf97a-9fe2-1615-9095-c656a246849e@thorsten-knabe.de>
Date:   Sat, 11 Apr 2020 15:35:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200411092456.72e2ddd4@elisabeth>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Stefano.

On 4/11/20 9:24 AM, Stefano Brivio wrote:
> Hi Thorsten,
> 
> On Fri, 10 Apr 2020 19:25:49 +0200
> Thorsten Knabe <linux@thorsten-knabe.de> wrote:
> 
>> Hello.
>>
>> BUG: Anonymous maps with adjacent intervals are broken starting with
>> Linux 5.6. Linux 5.5.16 is not affected.
>>
>> Environment:
>> - Linux 5.6.3 (AMD64)
>> - nftables 0.9.4
>>
>> Trying to apply the ruleset:
>>
>> flush ruleset
>>
>> table ip filter {
>>   chain test {
>>     ip daddr vmap {
>>         10.255.1.0-10.255.1.255: accept,
>>         10.255.2.0-10.255.2.255: drop
>>     }
>>   }
>> }
>>
>> using nft results in an error on Linux 5.6.3:
>>
>> # nft -f simple.nft
>> simple.nft:7:19-5: Error: Could not process rule: File exists
>>     ip daddr vmap {
> 
> Thanks for reporting this issue. I can't test it right now, but:
> 
> commit 72239f2795fab9a58633bd0399698ff7581534a3
> Author: Stefano Brivio <sbrivio@redhat.com>
> Date:   Wed Apr 1 17:14:38 2020 +0200
> 
>     netfilter: nft_set_rbtree: Drop spurious condition for overlap detection on insertion
> 
> should be the fix for this. Can you try with that?

I tried your patch 72239f2795fab9a58633bd0399698ff7581534a3 and it
indeed fixes the problem. Thank you.

Kind regards
Thorsten


-- 
___
 |        | /                 E-Mail: linux@thorsten-knabe.de
 |horsten |/\nabe                WWW: http://linux.thorsten-knabe.de
