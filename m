From: Peter Stamfest <peter@stamfest.at>
Subject: Re: [PATCH] Efficient matching of many IP blocks
Date: Tue, 8 Jun 2004 20:27:44 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406082024010.5747-100000@peter.stamf.pr.at>
References: <Pine.LNX.4.44.0406051017530.16559-100000@peter.stamf.pr.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Peter Stamfest <peter@stamfest.at>
In-Reply-To: <Pine.LNX.4.44.0406051017530.16559-100000@peter.stamf.pr.at>
ReSent-Message-ID: <Pine.LNX.4.44.0406082028440.5747@peter.stamf.pr.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Sorry to follow-up on my own post...

On Sat, 5 Jun 2004, I wrote:

> Date: Sat, 5 Jun 2004 11:35:47 +0200 (CEST)
> From: Peter Stamfest <peter@stamfest.at>
> To: netfilter-devel@lists.netfilter.org
> Subject: [PATCH] Efficient matching of many IP blocks
> 
> 
> Hello List, 
> 

[ snip ] 

> [...] I decided to implement a module to efficiently match many nets...
> 
> The idea is to keep a "balanced" [1] tree of ip-ranges and to walk the 
> tree in order to decide if a given IP matches or not. That way, matching 
> N nets is now O(ln(N)) instead of O(N). I tested the module using all the 
> network assignments done by RIPE, APNIC and ARIN combined, and the speed 
> is really incredible.
> 

[snip]

> I have written a README for the module which can be found here:
> 
>    http://oss.stamfest.net/ipt-match-table/README
> 
> And the code can be found here (a patch for the 2.4.25 kernel, some chunks 
> may be off by a couple of lines, but it _should_ apply cleanly to vanilla 
> 2.4.25)
> 
>    http://oss.stamfest.net/ipt-match-table/ipt-table-match-2.4.25.diff
> 
> The iptables user-space support can be found here (sorry, no patch, just 
> the source).
> 
>    http://oss.stamfest.net/ipt-match-table/libipt_table_match.c
> 

[ snip ]

I know that some of you d/l'ed the README and the tgz, so what do people 
think about

* the concept?
* the interface?
* the implementation?
* the likelihood to add this to netfilter proper?
* the porting to 2.6 and creating the equivalent ipv6 module?

So many questions....

peter
