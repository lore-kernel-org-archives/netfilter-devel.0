From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Do nfnl_query and nfnl_catch are blocking fuctions ?
Date: Sun, 16 Mar 2008 13:03:50 +0100
Message-ID: <47DD0CA6.8040002@netfilter.org>
References: <000e01c88502$8f4212c0$adc63840$@com> <47D957FC.3000900@netfilter.org> <002901c8859b$11fa98c0$35efca40$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Nishit Shah <nishit@elitecore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34171 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751587AbYCPMEC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Mar 2008 08:04:02 -0400
In-Reply-To: <002901c8859b$11fa98c0$35efca40$@com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nishit Shah wrote:
> Yes,
> 	I am using libnetfilter_conntrack for adding expected connection
> through Application Proxies. Now, sometimes my proxy hangs and when I do gdb
> on the core generated, recvmsg call is in waiting mode.

Does this happen under heavy load? Probably the ack message from netlink
is getting lost. You can change the socket behaviour accessing the
descriptor with nfct_fd(...)

> 	I have changed libnetfilter_conntrack slightly to make it single
> socket for my Proxy. I do nfct_open at time of proxy start, do
> nfct_create_expectation every time request comes and nfct_close when proxy
> ends.

BTW, not directly related but I suggest you to if you move to the new
API, the old one is deprecated and broken in some specific aspects.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
