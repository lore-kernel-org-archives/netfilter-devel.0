From: "David S. Miller" <davem@davemloft.net>
Subject: Re: Fw: [Bug 133788] New: ip_conntrack_in: Frag of proto 17
Date: Tue, 28 Sep 2004 20:54:33 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040928205433.6c0ee6e6.davem@davemloft.net>
References: <20040928130512.57479400.davem@davemloft.net>
	<20040928220532.GN29961@sunbeam.de.gnumonks.org>
	<4159F559.3040400@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4159F559.3040400@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 29 Sep 2004 01:35:53 +0200
Patrick McHardy <kaber@trash.net> wrote:

> Harald Welte wrote:
> 
> >The conntrack message basically means that at NF_IP_PRE_ROUTING we
> >suddenly see fragmented packets.  This "can never happen" since at the
> >same PRE_ROUTING hook we defragment just before
> >via ip_conntrack_defrag() -> ip_ct_gather_frags() -> ip_defrag()
> >  
> >
> 
> Here is the patch. Untracked and already tracked (loopback) packets
> are not defragmented, but the check in ip_conntrack_in for
> untracked/already tracked is after the check for fragments.
> This patch moves it up.

Applied, thanks a lot Patrick.
