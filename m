From: Philip Craig <philipc@snapgear.com>
Subject: Re: libnl netfilter log
Date: Mon, 10 Dec 2007 10:53:57 +1000
Message-ID: <475C8E25.6050802@snapgear.com>
References: <475A2987.8030505@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Thomas Graf <tgraf@suug.ch>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:44826 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751696AbXLJAv3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Dec 2007 19:51:29 -0500
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
>                               u_int32_t id,
>                               u_int32_t verdict,
>                               u_int32_t data_len,
>                               unsigned char *buf);
> 
> extern int nfq_set_verdict_mark(struct nfq_q_handle *qh,
>                                    u_int32_t id,
>                                    u_int32_t verdict, 
> 
>                                    u_int32_t mark,
>                                    u_int32_t datalen,
>                                    unsigned char *buf);
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
>                        uint8_t copy_mode, uint32_t copy_range)
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

That makes a lot of sense to me. And don't worry about breaking the
API for this or other netfilter stuff.  I doubt anyone besides me has
used it. There's no publicly available programs besides the test ones
in libnl.
