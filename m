From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: fix ordering of jumpstack allocation and
 table update
Date: Fri, 18 Oct 2013 10:18:13 -0700
Message-ID: <1382116693.3284.21.camel@edumazet-glaptop.roam.corp.google.com>
References: <1382016273-21993-1-git-send-email-will.deacon@arm.com>
	 <20131018111536.GA11132@localhost>
	 <20131018165749.GI3296@mudshark.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Will Deacon <will.deacon@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131018165749.GI3296@mudshark.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2013-10-18 at 17:57 +0100, Will Deacon wrote:
> Hi Pablo,
> 

> > We also need fixes for net/ipv6/netfilter/ip6_tables.c and
> > net/ipv4/netfilter/arp_tables.c as well. Could you extend this patch
> > and resend?
> 
> Sure, I can try, but that's going to require a bit of time to sit down and
> look at the shared data, access order, dependencies etc. I'm currently
> preparing for Edinburgh, so it might be a while before I get a chance to
> extend this.

That's basically same code copy/pasted, so it should be relatively easy.
