From: Florian Westphal <fw@strlen.de>
Subject: Re: Possible bug in __nfnl_handle_msg
Date: Fri, 27 Jun 2014 00:14:29 +0200
Message-ID: <20140626221429.GA23488@breakpoint.cc>
References: <20140626205023.GA32347@joerntop.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Joern Heissler <nfdevel@joern.heissler.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:32866 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233AbaFZWOa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Jun 2014 18:14:30 -0400
Content-Disposition: inline
In-Reply-To: <20140626205023.GA32347@joerntop.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Joern Heissler <nfdevel@joern.heissler.de> wrote:
> Hi,
> 
> I'm trying to use libnetfilter_log and I think I might have found a bug :)

Looks like nfnl_handle_packet doesn't handle control messages (like NLMSG_DONE).

I don't understand libnfnetlink here, specifically why
nfnl_handle_packet exists in first place, seems like it was superseded
by nfnl_process(), so I *thought* a quick fix is

--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -322,7 +322,7 @@ int nflog_callback_register(struct nflog_g_handle *gh, nflog_callback *cb,
 
 int nflog_handle_packet(struct nflog_handle *h, char *buf, int len)
 {
-       return nfnl_handle_packet(h->nfnlh, buf, len);
+       return nfnl_process(h->nfnlh, (unsigned char *) buf, len);
 }

But that breaks probably every user of the library since
nfnl_process() expects cb to return NFNL_CB_CONTINUE (== 1)
and not 0 (which makes _process top iterating).

But 0 is what the examples use :-(

'someone' has to touch libnfnetlink it seems...
