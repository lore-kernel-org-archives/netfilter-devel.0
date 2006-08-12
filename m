From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Trivial replace of ip_queue by nfnetlink_queue
 in	nfnetlink_queue code
Date: Sat, 12 Aug 2006 17:12:50 +0200
Message-ID: <44DDEFF2.9010403@trash.net>
References: <1155394240.10172.29.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1155394240.10172.29.camel@localhost>
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

Eric Leblond wrote:
> This patch replace "ip_queue" by "nfnetlink_queue" in nfnetlink_queue.c.

I already changed it to nf_queue now. If you want to change it to
nfnetlink_queue, it should be done in all places. But I think it
would make more sense to throw most of these printks out.
