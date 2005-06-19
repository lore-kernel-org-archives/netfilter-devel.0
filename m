From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.12: connection tracking broken?
Date: Sun, 19 Jun 2005 15:05:31 +0200
Message-ID: <42B56D9B.9070401@trash.net>
References: <20050618124359.39052.qmail@web52901.mail.yahoo.com>	<20050618192541.GA27439@pul.manty.net>
	<20050618221216.GB3182@pul.manty.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	ebtables-devel@lists.sourceforge.net, Chris Rankin <rankincj@yahoo.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Santiago Garcia Mantinan <netfilter-devel@manty.net>
In-Reply-To: <20050618221216.GB3182@pul.manty.net>
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

Santiago Garcia Mantinan wrote:
>>I have sent this right now to the bridge list, I'm copying it here so that
>>more info is available about this bug.
> 
> 
> I have selected patches from 2.6.12 that I thought could be related to this
> issue, and I have finaly identified this patch...
> 
> http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b31e5b1bb53b99dfd5e890aa07e943aff114ae1c
> 
> as the patch causing the problem, I have reversed it on my kernel tree and
> now the firewall is working again.
> 
> I have not really looked at what the patch does and how it does that, I have
> just identified it as the one causing the break of this connection tracking
> relating to the bridges.

The patch drops the conntrack reference when a packet leaves IP to avoid
problems with module unload because of indefinitely queued packets.
The bridge-netfilter code defers calling of some NF_IP_* hooks to the
bridge layer, when the conntrack reference is already gone, so the entry
is neither confirmed (enters the hashtable) nor available for use by
matches or targets. Reverting the patch is not a good option, I'll look
into other possiblities.

Regards
Patrick
