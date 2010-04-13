From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 5/6] netfilter: xt_TEE: have cloned packet travel through
 Xtables too
Date: Tue, 13 Apr 2010 12:51:31 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004131250220.11306@obet.zrqbmnf.qr>
References: <1270666217-27670-1-git-send-email-jengelh@medozas.de> <1270666217-27670-6-git-send-email-jengelh@medozas.de> <4BC440D0.9020500@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35936 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164Ab0DMKvc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 06:51:32 -0400
In-Reply-To: <4BC440D0.9020500@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2010-04-13 12:00, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> --- a/net/netfilter/xt_TEE.c
>> +++ b/net/netfilter/xt_TEE.c
>> @@ -33,6 +33,7 @@ static struct nf_conn tee_track;
>>  #endif
>>  
>>  static const union nf_inet_addr tee_zero_address;
>> +static bool tee_active[NR_CPUS];
>
>DEFINE_PER_CPU?

I asked about that. It seems like percpu.h puts the variable in an extra 
section and with pretty much #define magic around it (e.g. look at the 
#definition of percpu_set) all of which did not seem necessary to me.

