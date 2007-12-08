From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnl netfilter log
Date: Sat, 08 Dec 2007 19:16:25 +0100
Message-ID: <475ADF79.1030204@netfilter.org>
References: <475A2987.8030505@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Philip Craig <philipc@snapgear.com>, Thomas Graf <tgraf@suug.ch>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56567 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750864AbXLHSQl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Dec 2007 13:16:41 -0500
In-Reply-To: <475A2987.8030505@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> I've added support for netfilter queueing to libnl based on the
> logging support and would like to suggest a few changes.
> 
> One of the problems with the netfilter libraries has been adding
> support for new features, since that often required changing
> function signatures, for example:
> 
> extern int nfq_set_verdict(struct nfq_q_handle *qh,
>                              u_int32_t id,
>                              u_int32_t verdict,
>                              u_int32_t data_len,
>                              unsigned char *buf);
> 
> extern int nfq_set_verdict_mark(struct nfq_q_handle *qh,
>                                   u_int32_t id,
>                                   u_int32_t verdict,
>                                   u_int32_t mark,
>                                   u_int32_t datalen,
>                                   unsigned char *buf);
> 
> libnl always took an object-centric approach, so this would
> look something like this:
> 
> nfnl_queue_msg_set_verdict(pkt, verdict);
> nfnl_queue_msg_set_mark(pkt, mark);
> nfnl_queue_msg_send_verdict(pkt);
> 
> which avoids this problem. The libnl logging support deviates
> from this scheme, for example with this function:
> 
> int nfnl_log_set_mode(struct nl_handle *nlh, uint16_t queuenum,
>                       uint8_t copy_mode, uint32_t copy_range)
> 
> What I would like to change is make struct nfnl_log the logging
> instance, so you would have:
> 
> nfnl_log_set_mode(log, mode);
> nfnl_log_set_copy_range(log, range);
> nfnl_log_send_config(log);
> 
> and add a new struct nfnl_log_message, which represents the
> actual messages. Similar for queueing, we would have a
> struct nfnl_queue and nfnl_queue_message.
> 
> Any objections or suggestions to this API change?

Looks fine to me. Actually, much better than the current API :)

> Somewhat related, there currently is a problem with message
> reception since libnl uses a page-sized buffer for recvmsg(),
> but netfilter can send messages up to 64k. I recall there
> was some recvmsg buffer size probing some time ago, but it
> seems to be gone. Should I reintroduce it, increase the size
> to 64k or make it configurable?

If you reintroduce the probing I think that something similar to the
libnfnetlink behaviour would be fine. But, indeed, I prefer to make it
configurable.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
