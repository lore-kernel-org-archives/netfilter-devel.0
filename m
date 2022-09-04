Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A9CBECAAD3
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Sep 2022 11:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiIDLWc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 4 Sep 2022 07:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiIDLWc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Sep 2022 07:22:32 -0400
Received: from mx0.riseup.net (mx0.riseup.net [198.252.153.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E899F3F31A
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Sep 2022 04:22:30 -0700 (PDT)
Received: from fews2.riseup.net (fews2-pn.riseup.net [10.0.1.84])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx0.riseup.net (Postfix) with ESMTPS id 4ML8Py3n2bz9t88;
        Sun,  4 Sep 2022 11:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1662290550; bh=PK42AVVh1Ynq/w+Y7FKerqC3IHmPbn3bs4MDrAGdgoI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=khLSSnfaXWHHlZClbwRKi7346g37qQmpXt3wmdAe1InqAdmc+Y6Fi9Eg/aD+pZSV6
         JRe6USyM6CXSjZl3wh9VrX0z8/0SyCStNOXjtiMA+A4s/RKcowthsxWzJuhAzInkFG
         oKTInUOHIizpN59zpcaYom/QdZDQzBztOvG1sF5Y=
X-Riseup-User-ID: 34C261F69C1D6BB1C8EF47A80E198282CF98B8A1890C0FAD5A901AFF60A03101
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews2.riseup.net (Postfix) with ESMTPSA id 4ML8Px6KCVz1yPb;
        Sun,  4 Sep 2022 11:22:29 +0000 (UTC)
Message-ID: <df03a29a-ee7c-a5fb-0d65-6c477eed9e4d@riseup.net>
Date:   Sun, 4 Sep 2022 13:22:27 +0200
MIME-Version: 1.0
Subject: Re: [PATCH nft v2] json: add set statement list support
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20220901103143.87974-1-ffmancera@riseup.net>
 <YxNfXkBPgtKUx+ws@salvia>
From:   "Fernando F. Mancera" <ffmancera@riseup.net>
In-Reply-To: <YxNfXkBPgtKUx+ws@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 9/3/22 16:06, Pablo Neira Ayuso wrote:
> On Thu, Sep 01, 2022 at 12:31:43PM +0200, Fernando Fernandez Mancera wrote:
>> When listing a set with statements with JSON support, the statements were
>> ignored.
>>
>> Output example:
>>
>> {
>>    "set": {
>>      "op": "add",
>>      "elem": {
>>        "payload": {
>>          "protocol": "ip",
>>          "field": "saddr"
>>        }
>>      },
>>      "stmt": [
>>        {
>>          "limit": {
>>            "rate": 10,
>>            "burst": 5,
>>            "per": "second"
>>          }
>>        },
>>        {
>>          "counter": {
>>            "packets": 0,
>>            "bytes": 0
>>          }
>>        }
>>      ],
>>      "set": "@my_ssh_meter"
>>    }
>> }
> 
> ip/sets.t: WARNING: line 53: '{"nftables": [{"add": {"rule": {"table": "test-ip4", "chain": "input", "family": "ip", "expr": [{"set": {"set": "@set5", "elem": {"concat": [{"payload": {"field": "saddr", "protocol": "ip"}}, {"payload": {"field": "daddr", "protocol": "ip"}}]}, "op": "add"}}]}}}]}': '[{"set": {"elem": {"concat": [{"payload": {"field": "saddr", "protocol": "ip"}}, {"payload": {"field": "daddr", "protocol": "ip"}}]}, "op": "add", "set": "@set5"}}]' mismatches '[{"set": {"elem": {"concat": [{"payload": {"field": "saddr", "protocol": "ip"}}, {"payload": {"field": "daddr", "protocol": "ip"}}]}, "op": "add", "set": "@set5", "stmt": []}}]'
> 
> tests/py in nftables reports this warning.
> 
> I think it should be possible not to print "stmt" if it is empty.

Ugh, I missed it. Yes, it is possible. In addittion, I noticed when 
generating the JSON output the statements in the list should be 
stateless. I will send a patch for both problems.

Thank you,
Fernando.

> 
> Please follow up with an incremental patch to address this.
> 
> Thanks.

