From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Question about tcp reopen in tcp_in_window
Date: Thu, 17 Nov 2011 10:41:49 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1111171035110.27950@blackhole.kfki.hu>
References: <4EC4AF32.5050901@cn.fujitsu.com> <alpine.DEB.2.00.1111170904040.27634@blackhole.kfki.hu> <4EC4CE41.2060003@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, xiaosuo@gmail.com
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:50880 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756149Ab1KQJlv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Nov 2011 04:41:51 -0500
In-Reply-To: <4EC4CE41.2060003@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 17 Nov 2011, Gao feng wrote:

> ? 2011?11?17? 16:07, Jozsef Kadlecsik ??:
> > No, the connection entry won't be destroyed by nf_ct_kill. Why do you 
> > think so?
> 
> nf_ct will be destroy when tcp_packet return -NF_REPEAT to nf_conntrack_in.
> nf_conntrack_in will call nf_conntrack_put to destroy nf_conn
> nf_conntrack_in:
> 
> 	ret = l4proto->packet(ct, skb, dataoff, ctinfo, pf, hooknum);
>         if (ret <= 0) {
>                 /* Invalid: inverse of the return code tells
>                  * the netfilter core what to do */
>                 pr_debug("nf_conntrack_in: Can't track with proto module\n");
>                 nf_conntrack_put(skb->nfct);
>                 skb->nfct = NULL;
>                 NF_CT_STAT_INC_ATOMIC(net, invalid);
>                 if (ret == -NF_DROP)
>                         NF_CT_STAT_INC_ATOMIC(net, drop);
>                 return -ret;
>         }
> 
> I am wrong?

No, but I still don't get what's the problem with the code segment you 
cited. You left out the comment:

        } else if (((state->state == TCP_CONNTRACK_SYN_SENT
                     && dir == IP_CT_DIR_ORIGINAL)
                   || (state->state == TCP_CONNTRACK_SYN_RECV
                     && dir == IP_CT_DIR_REPLY))
                   && after(end, sender->td_end)) {
                /*
                 * RFC 793: "if a TCP is reinitialized ... then it need
                 * not wait at all; it must only be sure to use sequence
                 * numbers larger than those recently used."
                 */

This is the reinitialization case in the SYN_SENT and SYN_RECV states.

We destroy the connection in the reopen case, and in that path the code 
segment above won't be called as you noticed.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
