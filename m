From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: PROBLEM: 2.4.23-rc4 -> rc1 hang with change to ip_nat_core.c
 made in pre4
Date: Thu, 13 Nov 2003 09:07:05 -0200 (BRST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311130850030.3878-100000@logos.cnet>
References: <20031112212025.5eb29f52.davem@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Beau E. Cox" <beau@beaucox.com>, <linux-kernel@vger.kernel.org>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
In-Reply-To: <20031112212025.5eb29f52.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



On Wed, 12 Nov 2003, David S. Miller wrote:

> On Wed, 12 Nov 2003 19:24:38 -1000
> "Beau E. Cox" <beau@beaucox.com> wrote:
> 
> > On Wednesday 12 November 2003 05:59 pm, David S. Miller wrote:
> > > Marcelo has reverted the change in question, so his current
> > > 2.4.x tree should be fine.
> > 
> > Thank you so much.
> > 
> > I guess this makes me an honary Linux kernel contribitor, er...
> > uncontributor... :)
> 
> I take what I said back temporarily, Marcelo didn't revert the
> change yet but I have just reminded him to do so.
> 
> It should be fixed by the time 2.4.23 final rolls out.

The mentioned change is already in bkbits.net.
