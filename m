From: Gervasio Bernal <gervasiobernal@speedy.com.ar>
Subject: How to avoid fragmentation
Date: Mon, 24 Oct 2005 20:15:41 +0000
Message-ID: <435D40ED.1080109@speedy.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi all!!

I'm developing a new target extension and I need to add some extra data
and headers in TCP/UDP packets. But I'm having a problem: fragmentation.
In the header developed by me I add a new checksum field to verify the
integrity of that header. This works fine while there is no
fragmentation. If the packet is fragmented I can't recalculate that
checksum.

Does someone know how to correct or avoid this? Or have experience with
fragmentation?

Thanks a lot!
