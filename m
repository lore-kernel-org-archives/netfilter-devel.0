From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [2.4 patch] netfilter Configure.help cleanup
Date: Fri, 18 Jul 2003 11:06:49 +1000
Sender: linux-net-owner@vger.kernel.org
Message-ID: <20030718012910.0D5BB2C5A9@lists.samba.org>
References: <20030717201304.GL1407@fs.tum.de>
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	linux-net@vger.kernel.org
Return-path: <linux-net-owner@vger.kernel.org>
To: Adrian Bunk <bunk@fs.tum.de>
To: Marcelo Tosatti <marcelo@conectiva.com.br>,
	"David S. Miller" <davem@redhat.com>
In-reply-to: Your message of "Thu, 17 Jul 2003 22:13:05 +0200."
             <20030717201304.GL1407@fs.tum.de>
List-Id: netfilter-devel.vger.kernel.org

In message <20030717201304.GL1407@fs.tum.de> you write:
> On Wed, Jul 02, 2003 at 04:25:05PM -0300, Marcelo Tosatti wrote:
> > 
> > Make that go through davem, please.
> 
> Hi Dave,
> 
> the patch below does the following changes to the netfilter entries in
> Configure.help in 2.4.22-pre2:
> - order similar to net/ipv4/netfilter/Config.in
> - remove useless short descriptions above CONFIG_*
> - added CONFIG_IP_NF_MATCH_RECENT entry (stolen from 2.5)

Sorry Adrian, I think this is overzealous.

Please just add the CONFIG_IP_NF_MATCH_RECENT entry.  Remember,
"stable" means "boring". 8)

Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
