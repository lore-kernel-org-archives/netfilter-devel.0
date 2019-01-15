From: Florian Westphal <fw@strlen.de>
Subject: Re: [REGRESSION] 5.0-rc2: iptables -nvL consumes 100% of CPU and
 hogs memory with kernel 5.0-rc2
Date: Tue, 15 Jan 2019 11:15:19 +0100
Message-ID: <20190115101519.pf7ogpvdz22wku7g@breakpoint.cc>
References: <1608957.xtEoauR4Ya@merkaba>
 <20190115101006.GE26670@unicorn.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Steigerwald <martin@lichtvoll.de>
To: Michal Kubecek <mkubecek@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190115101006.GE26670@unicorn.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Michal Kubecek <mkubecek@suse.cz> wrote:
> > I upgraded to self-compiled 5.0-rc2 today and found the machine to be slow
> > after startup. I saw iptables consuming 100% CPU, it only responded to
> > SIGKILL. It got restarted several times, probably by some systemd service.
> > 
> > Then I started 'iptables -nvL' manually. And I got this:
> > 
> > % strace -p 5748
> > [… tons more, in what appeared an endless loop …]

This is fixed by:

http://patchwork.ozlabs.org/patch/1024772/
("netfilter: nf_tables: Fix for endless loop when dumping ruleset"). 
