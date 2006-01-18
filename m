From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ULOG] Use better value for 'nlbufsiz'
Date: Wed, 18 Jan 2006 17:51:06 +0100
Message-ID: <43CE71FA.1080800@trash.net>
References: <11375984923951-git-send-email-heitzenberger@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Holger Eitzenberger <heitzenberger@astaro.com>
In-Reply-To: <11375984923951-git-send-email-heitzenberger@astaro.com>
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

Holger Eitzenberger wrote:
> Performance tests showed that ULOG may fail on heavy loaded systems
> because of failed order-N allocations (N >= 1).
> 
> The default value of 4096 is not optimal in the sense that it actually
> allocates _two_ contigous physical pages.  Reasoning: ULOG uses
> alloc_skb(), which adds another ~300 bytes for skb_shared_info.
> 
> This patch sets the default value to 3700 and adds some documentation
> at the top.

I think we should just use NLMSG_GOODSIZE, which will use the maximum
amount to fit one page on any architecture.
