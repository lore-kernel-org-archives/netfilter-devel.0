From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/5] Add support for secmark
Date: Sun, 09 Dec 2007 20:19:55 +0100
Message-ID: <475C3FDB.5080807@trash.net>
References: <475C3044.5020300@netfilter.org> <475C32C7.5010708@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	James Morris <jmorris@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60206 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbXLITUN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Dec 2007 14:20:13 -0500
In-Reply-To: <475C32C7.5010708@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Pablo Neira Ayuso wrote:
>   
>> Index: net-2.6.git/include/linux/netfilter/nf_conntrack_common.h
>> ===================================================================
>> --- net-2.6.git.orig/include/linux/netfilter/nf_conntrack_common.h	2007-12-08 19:56:12.000000000 +0100
>> +++ net-2.6.git/include/linux/netfilter/nf_conntrack_common.h	2007-12-08 20:04:37.000000000 +0100
>> @@ -133,6 +133,10 @@ enum ip_conntrack_events
>>  	/* NAT sequence adjustment */
>>  	IPCT_NATSEQADJ_BIT = 13,
>>  	IPCT_NATSEQADJ = (1 << IPCT_NATSEQADJ_BIT),
>> +
>> +	/* Secmark is set */
>> +	IPCT_SECMARK_BIT = 12,
>>     
>                            ^^^
> Also bad patch, this should be 14. New patch attached. Sorry

Patch 3 and 5 don't apply without the nat sequence patch, so I'm
holding off on these until I know what the NATSEQADJ bit is meant
for.


