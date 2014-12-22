From: Patrick McHardy <kaber@trash.net>
Subject: Re: bug : nft_redirect port byteorder issue
Date: Mon, 22 Dec 2014 13:44:12 +0100
Message-ID: <9FE9AEC5-F57E-4EB8-8F06-3EDFCD5A5A3D@trash.net>
References: <54885B08.1010700@c-s.fr> <20141210182244.GA5622@salvia> <548AC07D.6080703@c-s.fr> <20141222115448.GA4908@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: arturo.borrero.glez@gmail.com, GUITTON Alex <alex.guitton@c-s.fr>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	leroy christophe <christophe.leroy@c-s.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49357 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbaLVMoe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Dec 2014 07:44:34 -0500
In-Reply-To: <20141222115448.GA4908@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 22. Dezember 2014 12:54:48 MEZ, schrieb Pablo Neira Ayuso <pablo@netfilter.org>:
>On Fri, Dec 12, 2014 at 11:16:29AM +0100, leroy christophe wrote:
>> Hi,
>> 
>> table ip nat {
>>         chain prerouting {
>>                  type nat hook prerouting priority 0;
>>                  tcp dport 222 redirect :22
>>         }
>>         chain postrouting {
>>                  type nat hook postrouting priority 0;
>>         }
>> }
>> 
>> With the above rules, data[priv->sreg_proto_min].data[0] has value
>> 0x160000 instead of 0x16 on powerpc (Big Endian byte order)
>> 
>> Due to this, mr.range[0].min.all gets assigned value 0 instead of 22.
>> 
>> Below patch fixes it, but it is maybe not the proper way to fix it,
>> so I let it up to you.
>> 
>> Christophe
>> 
>> diff --git a/net/ipv4/netfilter/nft_redir_ipv4.c
>> b/net/ipv4/netfilter/nft_redir_ipv4.c
>> index 643c596..554bb32 100644
>> --- a/net/ipv4/netfilter/nft_redir_ipv4.c
>> +++ b/net/ipv4/netfilter/nft_redir_ipv4.c
>> @@ -28,9 +28,9 @@ static void nft_redir_ipv4_eval(const struct
>> nft_expr *expr,
>>  	memset(&mr, 0, sizeof(mr));
>>  	if (priv->sreg_proto_min) {
>>  		mr.range[0].min.all = (__force __be16)
>> -					data[priv->sreg_proto_min].data[0];
>> +					*(__be16*)&data[priv->sreg_proto_min].data[0];
>>  		mr.range[0].max.all = (__force __be16)
>> -					data[priv->sreg_proto_max].data[0];
>> +					*(__be16*)&data[priv->sreg_proto_max].data[0];
>>  		mr.range[0].flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
>>  	}
>
>It seems userspace was generating the wrong bytecode, so your
>workaround was reversing the again the port values.
>
>Please, test the userspace fix I sent you and get back to us.

I actually think this is exactly what needs to be done since it also matches what we're doing for runtime gathered data.

>
>Thanks for diagnosing!


