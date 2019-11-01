Return-Path: <SRS0=Gx1r=YZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A00CA9ECF
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 15:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 428DE21734
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 15:11:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=tootai.net header.i=@tootai.net header.b="ngXl0Xwi";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=tootai.net header.i=@tootai.net header.b="oqmcWnlK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbfKAPLw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Nov 2019 11:11:52 -0400
Received: from mail1.tootai.net ([213.239.227.108]:51650 "EHLO
        mail1.tootai.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbfKAPLw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Nov 2019 11:11:52 -0400
Received: from mail1.tootai.net (localhost [127.0.0.1])
        by mail1.tootai.net (Postfix) with ESMTP id E96316027B01
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Nov 2019 16:11:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=tootai.net; s=mail;
        t=1572621111; bh=YpXMDOz2zKeN1kuxSiNxO5oSMP8/ko7vDhyFD3AUqPg=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=ngXl0XwiH2Zyrj7msXJZ0n0/kj47sQ4CeQwYOWegl+NreIUahuSBK47r2y4jcpX0X
         EBb0MWO0Inw0SbAXGDHZKumDJyZ3P1oqo+INlGfejBKFKsqO+UbRq/B0+qDDd0/6kX
         bfNAM9ZQcHZMpCCrEQ1F/QwnhLKHmHnGK8cXgYDY=
Received: from [192.168.10.4] (unknown [192.168.10.4])
        by mail1.tootai.net (Postfix) with ESMTPSA id A44746008767
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Nov 2019 16:11:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=tootai.net; s=mail;
        t=1572621110; bh=YpXMDOz2zKeN1kuxSiNxO5oSMP8/ko7vDhyFD3AUqPg=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=oqmcWnlKV/lF4wAxg3h6Wtsk9d+84GSMMX6WwOk1Qc1Rkyv5xXowi+WFE2ectubMb
         PVjIqCjbffTUaJX03edl9DM5/hPNqOGl3Gj36cHuFxwdAaa2MKXGqh3+T+6yu/8ywC
         ndE5g/9ZUF8PowvLlUo1iRsn+2wkajQhdFCAIbJc=
Subject: Re: Nat redirect using map
To:     Netfilter list <netfilter-devel@vger.kernel.org>
References: <6ea6ecb5-99c5-5519-b689-8e1291df69cc@tootai.net>
 <20191031191219.GL876@breakpoint.cc>
From:   Daniel Huhardeaux <tech@tootai.net>
Message-ID: <f7e300bd-2112-7e98-884b-1eb049c035f3@tootai.net>
Date:   Fri, 1 Nov 2019 16:11:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191031191219.GL876@breakpoint.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 31/10/2019 à 20:12, Florian Westphal a écrit :
> Daniel Huhardeaux <tech@tootai.net> wrote:
>> Hi,
>>
>> I have a map like this
>>
>> map redirect_tcp {
>>                  type inet_service : inet_service
>>                  flags interval
>>                  elements = { 12345 : 12345, 36025 : smtp }
>>          }
>>
>> and want to use nat redirect but it fail with unexpecting to, expecting EOF
>> or semicolon. Here is the rule
>>
>> nft add rule ip nat prerouting iif eth0 tcp dport map @redirect_tcp redirect
>> to @redirect_tcp
> 
> This should work:
> nft add rule ip nat prerouting iif eth0 ip protocol tcp redirect to : tcp dport map @redirect_tcp

Yes !

> 
>> Other: when using dnat for forwarding, should I take care of forward rules ?
>>
>> Example for this kind of rule from wiki:
>>
>> nft add rule nat prerouting iif eth0 tcp dport { 80, 443 } dnat
>> 192.168.1.120
> 
> You mean auto-accept dnatted connections? Try "ct status dnat accept"

Exactly what I was looking for, many thanks.

Daniel
-- 
TOOTAi Networks
