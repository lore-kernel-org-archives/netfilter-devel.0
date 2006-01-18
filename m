From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] [ULOG] Use better value for 'nlbufsiz'
Date: Wed, 18 Jan 2006 18:33:24 +0100
Message-ID: <43CE7BE4.7090805@trash.net>
References: <11376052233425-git-send-email-heitzenberger@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Holger Eitzenberger <heitzenberger@astaro.com>
In-Reply-To: <11376052233425-git-send-email-heitzenberger@astaro.com>
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
> This patch sets the default value to NLMSG_GOODSIZE and adds some
> documentation at the top.

Applied, thanks Holger.
