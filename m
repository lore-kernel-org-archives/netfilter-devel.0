From: Adrian Bunk <bunk@fs.tum.de>
Subject: Re: [2.4 patch] netfilter Configure.help cleanup
Date: Thu, 17 Jul 2003 22:11:27 +0200
Sender: linux-net-owner@vger.kernel.org
Message-ID: <20030717201127.GK1407@fs.tum.de>
References: <20030627233357.GN24661@fs.tum.de> <20030630051516.AAEC12C220@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	linux-net@vger.kernel.org
Return-path: <linux-net-owner@vger.kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <20030630051516.AAEC12C220@lists.samba.org>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jun 30, 2003 at 02:38:12PM +1000, Rusty Russell wrote:
> In message <20030627233357.GN24661@fs.tum.de> you write:
> > - remove useless short descriptions above CONFIG_*
> 
> > -Connection tracking (required for masq/NAT)
> >  CONFIG_IP_NF_CONNTRACK
> 
> Can you really do this?  A quick skim didn't find anyone else skipping
> this line...

These lines are only (sometimes outdated) copies of the lines in the
Config.in files that are not used by any tool I am aware of. 

> Thanks,
> Rusty.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

