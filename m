From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/22]: Netfilter update for 2.6.22
Date: Wed, 14 Mar 2007 16:52:40 -0700 (PDT)
Message-ID: <20070314.165240.74747790.davem@davemloft.net>
References: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
	<20070314.160559.74747185.davem@davemloft.net>
	<45F881D1.3010701@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F881D1.3010701@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 15 Mar 2007 00:14:25 +0100

> David Miller wrote:
> > I have two major merges to do today, one large set from Arnaldo with
> > more skb data access refinements, and this netfilter set.
> > 
> > What I'm going to do is merge Arnaldo's first, then your's.
> > 
> > The logic is that it's easier for me to fix conflicts in your
> > patch set (since it largely just removes code) than the other
> > way around.
> 
> Thanks. I had a quick look at Arnaldo's patches and think there
> shouldn't be any conflicts, but if there are, just let me know
> and I'll go over it afterwards.

Happily, it all went in cleanly.  I push it all back out to
kernel.org, let me know if I screw up anything :-)

Thanks!
