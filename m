From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnl netfilter log
Date: Sat, 08 Dec 2007 19:24:35 +0100
Message-ID: <475AE163.9040005@netfilter.org>
References: <475A2987.8030505@trash.net> <475ADF79.1030204@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Philip Craig <philipc@snapgear.com>, Thomas Graf <tgraf@suug.ch>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44884 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750833AbXLHSYo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Dec 2007 13:24:44 -0500
In-Reply-To: <475ADF79.1030204@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> I've added support for netfilter queueing to libnl based on the
>> logging support and would like to suggest a few changes.
>>
>> One of the problems with the netfilter libraries has been adding
>> support for new features, since that often required changing
>> function signatures, for example:
>>
>> extern int nfq_set_verdict(struct nfq_q_handle *qh,
>>                              u_int32_t id,
>>                              u_int32_t verdict,
>>                              u_int32_t data_len,
>>                              unsigned char *buf);
>>
>> extern int nfq_set_verdict_mark(struct nfq_q_handle *qh,
>>                                   u_int32_t id,
>>                                   u_int32_t verdict,
>>                                   u_int32_t mark,
>>                                   u_int32_t datalen,
>>                                   unsigned char *buf);
>>
>> libnl always took an object-centric approach, so this would
>> look something like this:
>>
>> nfnl_queue_msg_set_verdict(pkt, verdict);
>> nfnl_queue_msg_set_mark(pkt, mark);
>> nfnl_queue_msg_send_verdict(pkt);
>>
>> which avoids this problem. The libnl logging support deviates
>> from this scheme, for example with this function:
>>
>> int nfnl_log_set_mode(struct nl_handle *nlh, uint16_t queuenum,
>>                       uint8_t copy_mode, uint32_t copy_range)
>>
>> What I would like to change is make struct nfnl_log the logging
>> instance, so you would have:
>>
>> nfnl_log_set_mode(log, mode);
>> nfnl_log_set_copy_range(log, range);
>> nfnl_log_send_config(log);
>>
>> and add a new struct nfnl_log_message, which represents the
>> actual messages. Similar for queueing, we would have a
>> struct nfnl_queue and nfnl_queue_message.
>>
>> Any objections or suggestions to this API change?
> 
> Looks fine to me. Actually, much better than the current API :)

Hm, wait. Did libnl adopt an API similar to libnetfilter_log? Uh bad :)
Then, instead of changing the API that is something that could break any
existing application, I think that you can introduce the new API that
you propose and put the old one with the __attribute__((deprecated)) thing.

BTW, is libnl website broken? Any CVS or something I can get a working
copy to have a look at current netfilter support?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
