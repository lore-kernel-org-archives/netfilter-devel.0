From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: src: remove dependency on libiptc headers
Date: Wed, 30 Jul 2008 09:51:59 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0807300951200.30006@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0807300839010.6568@fbirervta.pbzchgretzou.qr> <48907080.8020207@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36697 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761432AbYG3NwB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 09:52:01 -0400
In-Reply-To: <48907080.8020207@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-07-30 09:45, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> commit 8219a9d65fe583de06c2ff4e84d1ea299955184b
>> Author: Jan Engelhardt <jengelh@medozas.de>
>> Date:   Wed Jul 30 08:36:33 2008 -0400
>> 
>> src: remove dependency on libiptc headers
>> 
>> struct xt_rateest_match_info {
>> -	char			name1[IFNAMSIZ];
>> -	char			name2[IFNAMSIZ];
>> +	char			name1[16];
>> +	char			name2[16];
>
> Seems unrelated and I don't want to apply this change.
> Please remove the IFNAMSIZ changes.

Then I would have to add linux/if.h everywhere.

>>  struct xtables_match
>>  {
>>   struct xtables_match *next;
>> 
>> -	xt_chainlabel name;
>> +	char name[32];
>>  
>
> Why 32?
>
That is what xt_chainlabel was typedefed to. No clue who had that
idea, char *name would work just as well.
