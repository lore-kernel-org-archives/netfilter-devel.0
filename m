From: "David S. Miller" <davem@davemloft.net>
Subject: Re: Questions about your dual Opteron packetfiltering tests
Date: Sat, 11 Sep 2004 18:23:09 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040911182309.26bb9d2d.davem@davemloft.net>
References: <20040716015152.GA29337@soohrt.org>
	<20040716131829.GC2214@obroa-skai.de.gnumonks.org>
	<20040906205653.GA4626@soohrt.org>
	<20040907084151.GG16651@obroa-skai.de.gnumonks.org>
	<20040910140617.GA4314@soohrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
   laforge@gnumonks.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Karsten Desler <kdesler@soohrt.org>
In-Reply-To: <20040910140617.GA4314@soohrt.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 10 Sep 2004 16:06:17 +0200
Karsten Desler <kdesler@soohrt.org> wrote:

> > never ever enable rp_filter, that makes a huge difference.  rp_filter is
> > not even recommended as default, and probably Debian is the only
> > distribution doing that mistake (read netdev archives on this).
> 
> Ok, I've disabled rp_filter and added rp_filter-like iptables
> rules, doesn't make much (any?) difference though.

Please only disable rp_filter, then test.

You're making it difficult to determine the source of the
bad performance if you add a new set of overhead.  So please
don't add the new rp_filter-like iptables rules, and test
like that.
