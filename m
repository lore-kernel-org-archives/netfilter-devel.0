From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/1] netfilter: nf_ct_tcp: pack nf_ct_tcp_flags to match
 user space
Date: Mon, 15 Mar 2010 19:04:21 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003151903510.13447@obet.zrqbmnf.qr>
References: <1268157924-4879-1-git-send-email-ljaenicke@innominate.com> <1268157924-4879-2-git-send-email-ljaenicke@innominate.com> <4B9E66FC.10303@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lutz Jaenicke <ljaenicke@innominate.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50967 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936581Ab0COSEX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Mar 2010 14:04:23 -0400
In-Reply-To: <4B9E66FC.10303@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-03-15 17:57, Patrick McHardy wrote:
>Lutz Jaenicke wrote:
>> ---
>>  include/linux/netfilter/nf_conntrack_tcp.h |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/include/linux/netfilter/nf_conntrack_tcp.h b/include/linux/netfilter/nf_conntrack_tcp.h
>> index 6e135f9..9d4cf26 100644
>> --- a/include/linux/netfilter/nf_conntrack_tcp.h
>> +++ b/include/linux/netfilter/nf_conntrack_tcp.h
>> @@ -42,7 +42,7 @@ enum tcp_conntrack {
>>  struct nf_ct_tcp_flags {
>>  	__u8 flags;
>>  	__u8 mask;
>> -};
>> +} __attribute__ ((packed));
>
>I would prefer to fix userspace to use sizeof(...) instead of
>using packed structs in the kernel. AFAICT, that should also
>work on all architectures.

Yeah that's what I would have preferred too.
