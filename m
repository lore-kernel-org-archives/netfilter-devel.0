From: "David S. Miller" <davem@davemloft.net>
Subject: Re: Questions about your dual Opteron packetfiltering tests
Date: Fri, 10 Sep 2004 14:29:25 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040910142925.64978b95.davem@davemloft.net>
References: <20040716015152.GA29337@soohrt.org>
	<20040716131829.GC2214@obroa-skai.de.gnumonks.org>
	<20040906205653.GA4626@soohrt.org>
	<20040907084151.GG16651@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: kdesler@soohrt.org, netfilter-devel@lists.netfilter.org,
	laforge@gnumonks.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040907084151.GG16651@obroa-skai.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 7 Sep 2004 10:41:51 +0200
Harald Welte <laforge@netfilter.org> wrote:

> > net/ipv4/conf/all/rp_filter=1
> 
> never ever enable rp_filter, that makes a huge difference.  rp_filter is
> not even recommended as default, and probably Debian is the only
> distribution doing that mistake (read netdev archives on this).

Absolutely correct.  This setting causes routing lookups to be
2 to 3 times more expensive.
