From: Leen Besselink <leen@wirehub.nl>
Subject: Re: Bug (?) in ipt_reject doesn't follow policy routing (2.4.x)
Date: Mon, 14 Apr 2003 09:27:32 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.21.0304140923320.411-100000@debian.besselink>
References: <Pine.LNX.4.21.0304132204320.31984-100000@debian.besselink>
Reply-To: leen@wirehub.nl
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.21.0304132204320.31984-100000@debian.besselink>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 13 Apr 2003, Leen Besselink wrote:

> On Sun, 13 Apr 2003, Leen Besselink wrote:
> 
> > Hi netfilter-hackers,
> > 
> > So, I think the 'local ? nskb->nh.iph->saddr : 0' can actually be
> > removed, am I right ?
> > 
> 
> OK, tried that, didn't work..., strange, maybe I should just add a printk
> or something, see what happends, or see if I have a routing problem as
> well.
> 
> Works with the default-route, strange. BTW, I think the part

OK, I took a closer look, the icmp's from --reject-with don't go past the
policy-routing rules either.

Any ideas on how I can make it so, any pointers ?

tia,
	Leen.
