From: Anton VG <anton.vazir@gmail.com>
Subject: Re: (nfnl_talk: recvmsg over-run) and (nf_queue: full at 1024
	entries, dropping packets(s). Dropped: 582) - bug or just some defaults
	increase required?
Date: Wed, 11 Feb 2009 17:26:45 +0500
Message-ID: <c4b050a10902110426s5e997220r21d615ebf0683bb8@mail.gmail.com>
References: <c4b050a10902061014w3df3b2c3xe9e6465be79b4e07@mail.gmail.com>
	 <498E3693.6030702@netfilter.org>
	 <200902091556.25407.anton.vazir@gmail.com>
	 <49901176.6020502@netfilter.org> <49928B62.1090600@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f20.google.com ([209.85.220.20]:53477 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZBKM0t (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:26:49 -0500
Received: by fxm13 with SMTP id 13so431540fxm.13
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2009 04:26:46 -0800 (PST)
In-Reply-To: <49928B62.1090600@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo,

On 64bit system, after applying the patch, nfq_create_queue() started
to oftenly return NULL, and calling
strerror(errno) - I've got a error "Invalid or incomplete multibyte or
wide character".

On 32bit it works. This have been tested with only 2x simultaneous queues
Any thoughts?

2009/2/11 Pablo Neira Ayuso <pablo@netfilter.org>:
> Updates on this?
>
> Pablo Neira Ayuso wrote:
>> Anton wrote:
>>> Pablo,
>>>
>>> Just a little more thought, this happened when my
>>> application attempted to create a NEW queue, while in
>>> kernel packet queue overrun situation. And after calling
>>> the nfq_create_queue there was no return from it, and only
>>> error message generation in the loop inside the
>>> libnetfilter_queue library. Looks like not a very proper
>>> behaviour. Am I missing something?
>>
>> Oh I see, I did not get the point initially. Does this patch fix the
>> problem?
>>
>>
>>
>> ------------------------------------------------------------------------
>>
>> diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
>> index 9e4903b..ec17595 100644
>> --- a/src/libnetfilter_queue.c
>> +++ b/src/libnetfilter_queue.c
>> @@ -141,7 +141,7 @@ __build_send_cfg_msg(struct nfq_handle *h, u_int8_t command,
>>       cmd.pf = htons(pf);
>>       nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_CMD, &cmd, sizeof(cmd));
>>
>> -     return nfnl_talk(h->nfnlh, &u.nmh, 0, 0, NULL, NULL, NULL);
>> +     return nfnl_query(h->nfnlh, &u.nmh);
>>  }
>>
>>  static int __nfq_rcv_pkt(struct nlmsghdr *nlh, struct nfattr *nfa[],
>> @@ -553,7 +553,7 @@ int nfq_set_mode(struct nfq_q_handle *qh,
>>       nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_PARAMS, &params,
>>                       sizeof(params));
>>
>> -     return nfnl_talk(qh->h->nfnlh, &u.nmh, 0, 0, NULL, NULL, NULL);
>> +     return nfnl_query(qh->h->nfnlh, &u.nmh);
>>  }
>>
>>  /**
>> @@ -581,7 +581,7 @@ int nfq_set_queue_maxlen(struct nfq_q_handle *qh,
>>       nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_QUEUE_MAXLEN, &queue_maxlen,
>>                       sizeof(queue_maxlen));
>>
>> -     return nfnl_talk(qh->h->nfnlh, &u.nmh, 0, 0, NULL, NULL, NULL);
>> +     return nfnl_query(qh->h->nfnlh, &u.nmh);
>>  }
>>
>>  /**
>
>
> --
> "Los honestos son inadaptados sociales" -- Les Luthiers
>
