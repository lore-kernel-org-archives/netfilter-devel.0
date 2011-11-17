From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Question about tcp reopen in tcp_in_window
Date: Thu, 17 Nov 2011 09:07:27 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1111170904040.27634@blackhole.kfki.hu>
References: <4EC4AF32.5050901@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, xiaosuo@gmail.com
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:55845 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755677Ab1KQIHa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Nov 2011 03:07:30 -0500
In-Reply-To: <4EC4AF32.5050901@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 17 Nov 2011, Gao feng wrote:

> I has a question about the tcp reopen request in func tcp_in_window.
> The code is below,what confuse me is that the var end is never after sender->td_end.
> 
> static int tcp_in_window(struct ip_ct_tcp *state,
> 		...
> 	if (sender->td_end == 0) {
> 		...
> 	} else if (((state->state == TCP_CONNTRACK_SYN_SENT
>                      && dir == IP_CT_DIR_ORIGINAL)
>                    || (state->state == TCP_CONNTRACK_SYN_RECV
>                      && dir == IP_CT_DIR_REPLY))
>                    && after(end, sender->td_end)) {
> 
> 		...
> 	}
> 		...
> }
> 
> 
> When nf_conn rcv a syn request in TIME_WAIT state,the new_state is SYN_SNET.
> in func tcp_packet, this nf_conn will be kill by nf_ct_kill and the syn packet will repeat.

No, the connection entry won't be destroyed by nf_ct_kill. Why do you 
think so?

> So we will have a new nf_conn,whose sender->td_end is reset in func tcp_new.
> 
> finally,when this syn packet arrive tcp_in_window,the var end is equal to sender->td_end.
> 
> Maybe there is the other situation Or what I understand is totally wrong?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
