Return-Path: <SRS0=suf1=VM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D5BCC7618F
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 11:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E29C120665
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 11:59:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="J+UUAbEa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbfGOL7h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jul 2019 07:59:37 -0400
Received: from mx1.riseup.net ([198.252.153.129]:40594 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729827AbfGOL7h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jul 2019 07:59:37 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 617341A32A7;
        Mon, 15 Jul 2019 04:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563191976; bh=ESwqwZN6MGv0t2OBxX2O/xiAyiO2xKkkOI7FTx6M5r8=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=J+UUAbEaYtL3yXoYf9otVMQi3I4acN4+4fAtvMr9RuqNEUCY4DeubjuxHxnznX0KS
         ySSiVTkp04J+R2pZIiTJxH5AtmR769ssHFDhCPCPllK0oZo4CVcau4YcRRt59ga8Iu
         JZ8vDP/0NPQL7zGxN+bUmrGp1LxNC5ZgQyKUWKck=
X-Riseup-User-ID: CCB0D0143894916E6B586861C791E8B317782B94F6F8115D2B7CEEC1524F45D5
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 79E7C120559;
        Mon, 15 Jul 2019 04:59:35 -0700 (PDT)
Subject: Re: [PATCH nf v2] netfilter: synproxy: fix rst sequence number
 mismatch
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
References: <20190712104513.11683-1-ffmancera@riseup.net>
 <20190713222624.heea2xjqeh52dohu@breakpoint.cc>
 <D18A40D8-9569-4975-8CC2-3ED9DE7FFFB7@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <e452baf5-0ac8-473f-0568-389de62eb375@riseup.net>
Date:   Mon, 15 Jul 2019 13:59:47 +0200
MIME-Version: 1.0
In-Reply-To: <D18A40D8-9569-4975-8CC2-3ED9DE7FFFB7@riseup.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On 7/14/19 1:25 AM, Fernando Fernandez Mancera wrote:
> El 14 de julio de 2019 0:26:24 CEST, Florian Westphal <fw@strlen.de> escribió:
>> Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:
>>> 14:51:00.024418 IP 192.168.122.1.41462 > netfilter.90: Flags [S], seq
>>> 4023580551, win 64240, options [mss 1460,sackOK,TS val 2149563785 ecr
>>> 0,nop,wscale 7], length 0
>>
>> Could you please trim this down to the relevant parts
>> and add a more human-readable description as to where the problem is,
>> under which circumstances this happens and why the
>> !SEEN_REPLY_BIT test is bogus?
>>
>> Keep in mind that you know more about synproxy than I do, so its
>> harder for me to follow what you're doing when the commit message
>> consists
>> of tcpdump output.
>>
>>> 14:51:00.024454 IP netfilter.90 > 192.168.122.1.41462: Flags [S.],
>> seq
>>> 727560212, ack 4023580552, win 0, options [mss 1460,sackOK,TS val
>> 355031 ecr
>>> 2149563785,nop,wscale 7], length 0
>>> 14:51:00.024524 IP 192.168.122.1.41462 > netfilter.90: Flags [.], ack
>> 1, win
>>> 502, options [nop,nop,TS val 2149563785 ecr 355031], length 0
>>> 14:51:00.024550 IP netfilter.90 > 192.168.122.1.41462: Flags [R.],
>> seq
>>> 3567407084, ack 1, win 0, length 0
>>
>> ... its not obvious to me why a reset is generated here in first place,
>> and why changing code in TCP_CLOSE case helps?
>> (I could guess the hook was called in postrouting and close transition
>> came from rst that was sent, but that still doesn't explain why it
>> was sent to begin with).
>>
>> I assume the hostname "netfilter" is the synproxy machine, and
>> 192.168.122.1 is a client we're proxying for, right?
> 
> Sure, I will prepare a detailed description of the problem. Sorry about that and thanks!
> 

When there is no service listening in the specified port in the backend,
we get a reset packet from the backend that is sent to the client but
the sequence number mismatches the tcp stream one so there is a loop in
which the client is requesting it until the timeout.

To solve this we need to adjust the sequence number, we cannot use the
!SEEN_REPLY_BIT test because it is always false at this point and then
we never get into the if statement. Instead of check the !SEEN_REPLY_BIT
we need to check if the CT IP address is different to the original CT IP.

I hope that answers your questions, here is the tcpdump output with only
the important information. Please note that "netfilter" is the synproxy
machine and 192.168.122.1 is the client. If that is fine to you, I will
include this description into the commit message and send a v3 patch.
Thanks Florian! :-)

TCPDUMP output:

14:51:00.024418 IP 192.168.122.1.41462 > netfilter.90: Flags [S], seq
4023580551,
14:51:00.024454 IP netfilter.90 > 192.168.122.1.41462: Flags [S.], seq
727560212, ack 4023580552,
14:51:00.024524 IP 192.168.122.1.41462 > netfilter.90: Flags [.], ack 1,
14:51:00.024550 IP netfilter.90 > 192.168.122.1.41462: Flags [R.], seq
3567407084,
14:51:00.231196 IP 192.168.122.1.41462 > netfilter.90: Flags [.], ack 1,
14:51:00.647911 IP 192.168.122.1.41462 > netfilter.90: Flags [.], ack 1,
14:51:01.474395 IP 192.168.122.1.41462 > netfilter.90: Flags [.], ack 1,
