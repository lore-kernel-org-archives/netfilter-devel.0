From: Patrick McHardy <kaber@trash.net>
Subject: libnl netfilter log
Date: Sat, 08 Dec 2007 06:20:07 +0100
Message-ID: <475A2987.8030505@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Philip Craig <philipc@snapgear.com>, Thomas Graf <tgraf@suug.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49473 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbXLHFUT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Dec 2007 00:20:19 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I've added support for netfilter queueing to libnl based on the
logging support and would like to suggest a few changes.

One of the problems with the netfilter libraries has been adding
support for new features, since that often required changing
function signatures, for example:

extern int nfq_set_verdict(struct nfq_q_handle *qh,
                              u_int32_t id,
                              u_int32_t verdict,
                              u_int32_t data_len,
                              unsigned char *buf);

extern int nfq_set_verdict_mark(struct nfq_q_handle *qh,
                                   u_int32_t id,
                                   u_int32_t verdict, 

                                   u_int32_t mark,
                                   u_int32_t datalen,
                                   unsigned char *buf);

libnl always took an object-centric approach, so this would
look something like this:

nfnl_queue_msg_set_verdict(pkt, verdict);
nfnl_queue_msg_set_mark(pkt, mark);
nfnl_queue_msg_send_verdict(pkt);

which avoids this problem. The libnl logging support deviates
from this scheme, for example with this function:

int nfnl_log_set_mode(struct nl_handle *nlh, uint16_t queuenum,
                       uint8_t copy_mode, uint32_t copy_range)

What I would like to change is make struct nfnl_log the logging
instance, so you would have:

nfnl_log_set_mode(log, mode);
nfnl_log_set_copy_range(log, range);
nfnl_log_send_config(log);

and add a new struct nfnl_log_message, which represents the
actual messages. Similar for queueing, we would have a
struct nfnl_queue and nfnl_queue_message.

Any objections or suggestions to this API change?

Somewhat related, there currently is a problem with message
reception since libnl uses a page-sized buffer for recvmsg(),
but netfilter can send messages up to 64k. I recall there
was some recvmsg buffer size probing some time ago, but it
seems to be gone. Should I reintroduce it, increase the size
to 64k or make it configurable?

