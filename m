Return-Path: <SRS0=RRXz=6T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D77C47247
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 10:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59DC0206B9
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 10:03:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=fami-braun.de header.i=@fami-braun.de header.b="KpbVkYCX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbgEEKD2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 May 2020 06:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728531AbgEEKD1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 May 2020 06:03:27 -0400
Received: from mo6-p00-ob.smtp.rzone.de (mo6-p00-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5300::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E7CC061A0F
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 03:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1588673005;
        s=strato-dkim-0002; d=fami-braun.de;
        h=Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=HnDOEVKhevkyFYECcZvsVaIQpgEiYt39ZuQvOtJcKIg=;
        b=KpbVkYCXPE8yVEnPXfvqFsvhWKzufAJjhFJ1Hr1wPPGUgWhPyqMkK4c0zzUv5e8vH8
        HW3lS+avgOymIA61XTD95Yx+4G2BKK8jquDq5FBw9n2eHJEPsioKTZzPjGMGlMIU06cy
        fbMHFeKpbuEdzoj4ZuwuIXWTPgZiMlDfRQj7HthfSYf3RYaE4zrUDgjGp/sNJTtvrQ9t
        OcI4jiGryc6YIMqJfSV51mNBssXMzjxqx/YzGWWqA3ZHbNb4Qo5PSQIEaH4Ru4tB890G
        Vm3vnGj/lGu7XbewXDI75uLBysAN2Ig2509aB5aD1pFtuYbrWokzEHnpbSGIRLkkx7G1
        y2+w==
X-RZG-AUTH: ":P20JeEWkefDI1ODZs1HHtgV3eF0OpFsRaGIBEm4ljegySSvO7VhbcRIBGrxpcA5nVfJ6oTd1q4vmpMrAs8OZgAsWbSDyXetO/IBA+8ke6XddTw=="
X-RZG-CLASS-ID: mo00
Received: from dynamic.fami-braun.de
        by smtp.strato.de (RZmta 46.6.2 AUTH)
        with ESMTPSA id g05fffw45A3Pw1C
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 5 May 2020 12:03:25 +0200 (CEST)
Received: from dynamic.fami-braun.de (localhost [127.0.0.1])
        by dynamic.fami-braun.de (fami-braun.de) with ESMTP id 2F6A5154110;
        Tue,  5 May 2020 12:03:25 +0200 (CEST)
Received: from 9dYXDXt+meifSoZInOiid/tl47cgJPe4SzIm5Za5PrsYTbEtX3qHqw==
 (G2Bbv6HcirLc/LVivRI3SLjdVYMKJ+ND)
 by webmail.fami-braun.de
 with HTTP (HTTP/1.1 POST); Tue, 05 May 2020 12:03:14 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 05 May 2020 12:03:14 +0200
From:   michael-dev <michael-dev@fami-braun.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [RFC] concat with dynamically sized fields like vlan id
In-Reply-To: <20200504124527.GA25213@salvia>
References: <20200501205915.24682-1-michael-dev@fami-braun.de>
 <20200504124527.GA25213@salvia>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <72c3232b343ae7c1f4191007b9cbbf5e@fami-braun.de>
X-Sender: michael-dev@fami-braun.de
X-Virus-Scanned: clamav-milter 0.102.2 at gate
X-Virus-Status: Clean
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Am 04.05.2020 14:45, schrieb Pablo Neira Ayuso:
> On Fri, May 01, 2020 at 10:59:15PM +0200, Michael Braun wrote:
>> This enables commands like
>> 
>>  nft set bridge t s4 '{typeof vlan id . ip daddr; elements = { 3567 .
>> 1.2.3.4 }; }'
>> 
>> Which would previously fail with
>>   Error: can not use variable sized data types (integer) in concat
>>   expressions
> 
> Now that typeof is in place, the integer_type can be set to 32-bits
> (word size).

When just changing the datatype definition of integer_type to .size = 
32,
the resulting set elements are broken:

# ether type vlan @ll,112,16 & 4095 . ip daddr { 4095 . 1.0.0.1} accept
__set%d test-bridge 3 size 1
__set%d test-bridge 0
         element ff0f0000 01000001  : 0 [end]
bridge
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]

I also verified that such a rule really does not match
                 ether type vlan id . ip daddr { 501 . 141.24.44.2 } log 
prefix "trace "
                 vlan id 501 ip daddr 141.24.44.2 log prefix "trace2
Results in dmesg entries only for trace2.
Whereas it worked with my last version.

I cannot really find the place to fix this. Any hint?

> I would prefer to not expose the integer type definition to sets:
> 
>> +	set s4 {
>> +		type integer . ipv4_addr
>> +		elements = { 0 . 13.239.0.0 }
>> +	}
>> +
> 
> Users do not need to know that an 8-bit payload field is actually
> aligned to 32-bits. Or that osf name is actually and 32-bit id number.

That was already fixed with e10356a4 ("tests: dump generated use new nft 
tool").

Regards,
M. Braun
