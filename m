From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Patch] ip{,
	6}tables-restore -n with existing user defined chain
Date: Sat, 11 Jun 2005 18:12:49 +0200
Message-ID: <42AB0D81.2080804@trash.net>
References: <Pine.LNX.4.61.0505181157190.3744@e-smith.charlieb.ott.istop.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Charlie Brady <charlieb-netfilter-devel@budge.apana.org.au>
In-Reply-To: <Pine.LNX.4.61.0505181157190.3744@e-smith.charlieb.ott.istop.com>
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

Charlie Brady wrote:
> 
> I want to redefine an existing chain atomically. I can't do that with
> the iptables command, but can almost do it with iptables-restore -n.
> When I try, iptables barfs because the chain already exists. Duh! Yeah,
> I know it exists, but I want to redefine it.
> 
> I don't see the semantics of this case defined anywhere, and I can't
> find discussion of it in the archives. So I suggest that the semantics
> be redefined, so that iptables-restore -n can redefine an existing chain
> (iptables-restore without -n already does that). I really can't think
> why anyone would depend on the current semantics.

I have no objections, but since I'm not too familiar with that code
I would like to hear Harald's opinion before applying it.

Regards
Patrick
