From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [00/14]: Netfilter fixes for 2.6.16
Date: Sat, 04 Feb 2006 02:21:50 -0800 (PST)
Message-ID: <20060204.022150.115231220.davem@davemloft.net>
References: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
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
Date: Fri,  3 Feb 2006 14:43:58 +0100 (MET)

> following are my pending netfilter bugfixes for 2.6.16, unfortunately
> its quite a lot, but mostly trivial patches. There are still two open
> bugs from the netfilter IPsec patches, the "ip_finish_output2: No header
> cache and no neighbour!" bug reported by Andi Kleen and a crash in
> xfrm4_output_finish. I'll probably have the fixes ready sometime this
> weekend.

All merged, thanks a lot.

Patrick, I must say you do an excellent job submitting patches.  They
are always logically split up, have reasonable change log entries (not
too long, not too terse), and there is never any tab or newline
mangling.

Thanks again.
