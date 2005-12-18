From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [RFC][PATCH] ctnetlink port to nf_conntrack take #3
Date: Sun, 18 Dec 2005 20:33:33 +0900 (JST)
Message-ID: <200512181133.jBIBXYPo012043@toshiba.co.jp>
References: <200512150224.jBF2O4Qf011205@toshiba.co.jp>
	<43A0D5C2.40000@trash.net> <43A1C126.9020606@eurodev.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
In-Reply-To: <43A1C126.9020606@eurodev.net>
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

From: Pablo Neira Ayuso <pablo@eurodev.net>
Date: Thu, 15 Dec 2005 20:16:55 +0100

> Patrick McHardy wrote:
> > Yasuyuki KOZAKAI wrote:
> > 
> >> Well, I've found a issue. Current dumping code returns the
> >> informations about
> >> IPv6 connections regardless of the address family in nfctnetlink header
> >> (nfgenmsg). As a result, conntrack program prints "0.0.0.0 ....."
> >>
> >> A something like filtering with address family might be necessary while
> >> dumping. Yes, that would be inefficient. One long term solution would be
> >> conntrack hash per layer 3 protocol.
> > 
> > 
> > The filtering sounds fine for now. Dumping already has a large overhead
> > because the repeated iterations over the entire hash to find out where
> > to continue after an skb was full, this is not going to make it much
> > worse. I'm going to fix it up when adding the patch.
> 
> What about the patch attached? It applies on top of my previous global
> ctnetlink port to nf_conntrack take#4 patch.

looks fine to me. And that's good idea to dump informations of all connections
if AF_UNSPEC is set in nfgenmsg. But I don't know that such way to handle
AF_UNSPEC can be generic policy of nfnetlink.

-- Yasuyuki Kozakai
