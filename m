From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [RFC] updated ctnetlink patches
Date: 01 Jun 2003 01:01:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1054422066.24777.1.camel@tux.rsn.bth.se>
References: <3ED4BD16.8030606@trash.net>
	 <20030531205210.GE29312@sunbeam.de.gnumonks.org>
	 <3ED9306B.6000607@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3ED9306B.6000607@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 2003-06-01 at 00:44, Patrick McHardy wrote:

> >>ip_ct_refresh is changed to only update the timer if timer.expires !=
> >>jiffies+extra_jiffies. This reduces timeout change messages to at most
> >>HZ/s instead of 1/packet. 
> >>    
> >>
> >>I'm unclear if this change introduces a race condition of some kind.
> >>    
> >>
> >
> >I don't think so.
> >  
> >
> 
> then this change would probably also make sense for mainline kernel. i was
> even thinking about going a bit further and only doing changes if they are
> bigger than say 1s, it doesn't seem to matter. if not that, maybe reduce
> only event messages to 1/s for timer changes.

Look at the last part of optimizations/ip_ct_refresh_optimization.patch
I've been running with that patch for a long time and it works fine.

-- 
/Martin
