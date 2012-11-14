From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 2/2] Handle the routing changes in the MASQUERADE
 target
Date: Wed, 14 Nov 2012 08:55:22 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211140853260.4404@blackhole.kfki.hu>
References: <1352837857-22087-1-git-send-email-kadlec@blackhole.kfki.hu> <1352837857-22087-3-git-send-email-kadlec@blackhole.kfki.hu> <alpine.LNX.2.01.1211140047370.26843@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:41728 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab2KNHz0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:55:26 -0500
In-Reply-To: <alpine.LNX.2.01.1211140047370.26843@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 14 Nov 2012, Jan Engelhardt wrote:

> On Tuesday 2012-11-13 21:17, Jozsef Kadlecsik wrote:
> 
> >+static int
> >+route_cmp(struct nf_conn *i, const struct fib_info *fi)
> >+{  [...]
> >+}
> >+
> >+static int masq_route_event(struct notifier_block *this,
> >+			    unsigned long event,
> >+			    void *ptr)
> >+{
> >+	if (event == NETDEV_ROUTE_CHANGED) {
> >+		/* Routing changed, delete marked entries */
> >+		nf_ct_iterate_cleanup(net, route_cmp,
> >+				      (const struct fib_info)ptr);
> 
> It would seem you forget a '*' near fib_info)ptr.
> The cast is pointless though, since ptr is already of type void *
> which nf_ct_iterate_cleanup expects.

You are right and it was not tested at all. Just a quick code to discuss 
not only in theory but something real.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
