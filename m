From: Pablo Neira <pablo@eurodev.net>
Subject: Re: How to avoid fragmentation
Date: Tue, 25 Oct 2005 01:37:00 +0200
Message-ID: <435D701C.1080501@eurodev.net>
References: <435D40ED.1080109@speedy.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gervasio Bernal <gervasiobernal@speedy.com.ar>
In-Reply-To: <435D40ED.1080109@speedy.com.ar>
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

Gervasio Bernal wrote:
> I'm developing a new target extension and I need to add some extra data
> and headers in TCP/UDP packets. But I'm having a problem: fragmentation.
> In the header developed by me I add a new checksum field to verify the
> integrity of that header. This works fine while there is no
> fragmentation. If the packet is fragmented I can't recalculate that
> checksum.
> 
> Does someone know how to correct or avoid this? Or have experience with
> fragmentation?

Hm, still missing some information. You mean that you can't recalculate 
the checksum because the checksum part is missing, don't you? Use 
skb_header_pointer(...) to work with the headers, it's fragment-aware.

--
Pablo
