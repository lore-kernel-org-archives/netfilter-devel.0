From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 2/2] Handle the routing changes in the MASQUERADE
 target
Date: Wed, 14 Nov 2012 00:49:20 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1211140047370.26843@nerf07.vanv.qr>
References: <1352837857-22087-1-git-send-email-kadlec@blackhole.kfki.hu> <1352837857-22087-3-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:60708 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab2KMXtX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:49:23 -0500
In-Reply-To: <1352837857-22087-3-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2012-11-13 21:17, Jozsef Kadlecsik wrote:

>+static int
>+route_cmp(struct nf_conn *i, const struct fib_info *fi)
>+{  [...]
>+}
>+
>+static int masq_route_event(struct notifier_block *this,
>+			    unsigned long event,
>+			    void *ptr)
>+{
>+	if (event == NETDEV_ROUTE_CHANGED) {
>+		/* Routing changed, delete marked entries */
>+		nf_ct_iterate_cleanup(net, route_cmp,
>+				      (const struct fib_info)ptr);

It would seem you forget a '*' near fib_info)ptr.
The cast is pointless though, since ptr is already of type void *
which nf_ct_iterate_cleanup expects.
