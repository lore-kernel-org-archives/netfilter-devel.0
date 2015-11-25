From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH nft 1/2] src: add dscp support
Date: Thu, 26 Nov 2015 00:17:13 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1511252341470.6198@nerf40.vanv.qr>
References: <1448480362-12411-1-git-send-email-pablo@netfilter.org> <20151125200124.GH30712@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:54816 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbbKYXRP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 18:17:15 -0500
In-Reply-To: <20151125200124.GH30712@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2015-11-25 21:01, Patrick McHardy wrote:
>On 25.11, Pablo Neira Ayuso wrote:
>>  #define TYPE_MAX		(__TYPE_MAX - 1)
>> diff --git a/include/proto.h b/include/proto.h
>> index a43bf98..41af0c1 100644
>> --- a/include/proto.h
>> +++ b/include/proto.h
>> @@ -176,7 +176,7 @@ enum ip_hdr_fields {
>>  	IPHDR_INVALID,
>>  	IPHDR_VERSION,
>>  	IPHDR_HDRLENGTH,
>> -	IPHDR_TOS,
>> +	IPHDR_DSCP,
>
>Shouldn't we keep both?

>From what I read from RFC 2474, DSCP is the 6-bit portion.
The 8-bit field is known as
  (a) TOS per IPv4 RFC
  (b) TC (Traffic Class) per IPv6 RFC 2460
  (c) DS per RFC 2472

I would therefore recommend against IPHDR_DSCP, and instead go
with either of IPHDR_TOS, IPHDR_DS, IPHDR_DIFFSERV, or even
some mnemonic involving traffic class.
