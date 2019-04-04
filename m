Return-Path: <SRS0=UjrQ=SG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A96C4360F
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Apr 2019 12:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82BCB2082E
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Apr 2019 12:08:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="NXXtHD1w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbfDDMIh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Apr 2019 08:08:37 -0400
Received: from mx1.riseup.net ([198.252.153.129]:46538 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbfDDMIg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Apr 2019 08:08:36 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 49E671B92A9;
        Thu,  4 Apr 2019 05:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1554379716; bh=qbrSV9wR+oSwDI3BFkBN79kZphhQdTyKc9MCsU1SxQI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=NXXtHD1wZU6keB1qZ33Epgi0ZbBDsKLo/hMJTWrxFra22pOdl44gkj2iCQL5zAf9H
         BeFPeOe8daUMHzTHe4zj7jukr1DcyNI4mtUgTFVCdYDX9M6M+msUYqCeLkVhyB9JrF
         dIG2cOEVRmti3L7RwHpm99OZ/Bdyy/ww/tyfIRn4=
X-Riseup-User-ID: 23D3D554F7736F05611CBBC6C82E926D0E0FA967A2BAB72D746B407AC3C87021
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 6AF7B223430;
        Thu,  4 Apr 2019 05:08:35 -0700 (PDT)
Subject: Re: [PATCH nft] doc: update nft list plural form parameters
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, duncan_roe@optusnet.com.au
References: <20190404114158.5758-1-ffmancera@riseup.net>
 <20190404120123.5d3mpuf2unlmmg6n@salvia>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <32e5f702-bda5-a4ed-d0e3-e2f338556c4d@riseup.net>
Date:   Thu, 4 Apr 2019 14:08:42 +0200
MIME-Version: 1.0
In-Reply-To: <20190404120123.5d3mpuf2unlmmg6n@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On 4/4/19 2:01 PM, Pablo Neira Ayuso wrote:
> Cc'ing Duncan, he's been helping with reviewing documentation.
> 
> On Thu, Apr 04, 2019 at 01:41:58PM +0200, Fernando Fernandez Mancera wrote:
>> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
>> ---
>>  doc/nft.txt | 13 +++++++++----
>>  1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/doc/nft.txt b/doc/nft.txt
>> index d162dad..36a92fe 100644
>> --- a/doc/nft.txt
>> +++ b/doc/nft.txt
>> @@ -256,6 +256,7 @@ TABLES
>>  [verse]
>>  {add | create} *table* ['family'] 'table' [ {flags 'flags'} ]
>>  {delete | list | flush} *table* ['family'] 'table'
>> +list *tables*
>>  delete *table* ['family'] handle 'handle'
>>  
>>  Tables are containers for chains, sets and stateful objects. They are identified
>> @@ -266,7 +267,8 @@ nfproto* keyword can be used to test which family (ipv4 or ipv6) context the
>>  packet is being processed in. When no address family is specified, *ip* is used
>>  by default. The only difference between add and create is that the former will
>>  not return an error if the specified table already exists while *create* will
>> -return an error.
>> +return an error. The plural form of list can be used to list all the existing
>> +tables.
> 
> Not sure we need this sentence, I mean, not sure if reader will
> correlate this with 'list tables'.
> 
> Probably just adding:
> 
> list *tables*
> 
> and so on, for other objects in the [verse] area is just enough.
> 

But do you think we need to keep the stateful objects one? If not, how
should we state that a plural form can be used with stateful objects?
Thanks!

>> @@ -609,7 +613,8 @@  delete type ['family'] 'table' handle 'handle'
>>  
>>  Stateful objects are attached to tables and are identified by an unique name.
>>  They group stateful information from rules, to reference them in rules the
>> -keywords "type name" are used e.g. "counter name".
>> +keywords "type name" are used e.g. "counter name". The plural form can be used
>> +to list all exisiting stateful objects e.g "list counters".
>>  
>>  [horizontal]
>>  *add*:: Add a new stateful object in the specified table.
> Thanks!
> 
