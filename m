From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [2.4 patch] netfilter Configure.help cleanup
Date: Mon, 30 Jun 2003 14:38:12 +1000
Sender: linux-net-owner@vger.kernel.org
Message-ID: <20030630051516.AAEC12C220@lists.samba.org>
References: <20030627233357.GN24661@fs.tum.de>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	linux-net@vger.kernel.org
Return-path: <linux-net-owner@vger.kernel.org>
To: Adrian Bunk <bunk@fs.tum.de>
In-reply-to: Your message of "Sat, 28 Jun 2003 01:33:58 +0200."
             <20030627233357.GN24661@fs.tum.de>
List-Id: netfilter-devel.vger.kernel.org

In message <20030627233357.GN24661@fs.tum.de> you write:
> - remove useless short descriptions above CONFIG_*

> -Connection tracking (required for masq/NAT)
>  CONFIG_IP_NF_CONNTRACK

Can you really do this?  A quick skim didn't find anyone else skipping
this line...

Thanks,
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
