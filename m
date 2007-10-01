From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 06/13] Port redirection support for TCP
Date: Mon, 01 Oct 2007 16:09:21 +0200
Message-ID: <4700FF91.6080600@trash.net>
References: <20070930205141.10969.27205.stgit@nessa.odu> <20070930205243.10969.90629.stgit@nessa.odu> <47002299.9040400@trash.net> <200710010049.50756@nessa>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33611 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbXJAOJq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Oct 2007 10:09:46 -0400
In-Reply-To: <200710010049.50756@nessa>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

KOVACS Krisztian wrote:
>>>ipv4/tcp_output.c
>>>index 666d8a5..69dd230 100644
>>>--- a/net/ipv4/tcp_output.c
>>>+++ b/net/ipv4/tcp_output.c
>>>@@ -2153,7 +2153,11 @@ struct sk_buff * tcp_make_synack(struct sock
>>>*sk, struct dst_entry *dst, th->syn = 1;
>>> 	th->ack = 1;
>>> 	TCP_ECN_make_synack(req, th);
>>>+#if defined(CONFIG_IP_NF_TPROXY) ||
>>>defined(CONFIG_IP_NF_TPROXY_MODULE) +	th->source = ireq->loc_port;
>>>+#else
>>> 	th->source = inet_sk(sk)->sport;
>>>+#endif
>>
>>I think this should simply use loc_port unconditionally.
> 
> 
> Unfortunately ireq->loc_port does not exist unless tproxy is enabled in 
> the config. (We could remove all these #ifdefs but that would mean 
> extending inet_request_sock with 2 bytes even if tproxy is not enabled.)


There's a 2 byte hole with IPv6 where you could put this in.
I think even without IPv6 the small waste is not worth the
increased testing complexity.
