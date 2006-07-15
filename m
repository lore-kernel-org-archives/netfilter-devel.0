From: "Paul C. Diem" <PCDiem@FoxValley.net>
Subject: Chain Sorting
Date: Sat, 15 Jul 2006 15:19:04 -0500
Message-ID: <FFEPKIHJDEDDAAFOFDGFKELOCBAA.PCDiem@FoxValley.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

In my quest to speed up the TC_INIT, I found that the libiptc.c searches the
chain list for the alphabetically correct place to insert chains as it
converts from the blob to the chain list. However, when adding a new chain
in TC_CREATE_CHAIN, it simply adds the new chain to the end of the list.

This leaves the chains unsorted when written back to the kernel and uses
lots of cycles when loading. I patched libiptc.c to simply add chains to the
end of the list when loading and use iptc_insert_chain in TC_CREATE_CHAIN to
insert newly created chains into the proper order. My
TC_INIT time with 4106 chains went from about 1.09 real seconds to about
0.05 real seconds.

Paul C. Diem
PCDiem@FoxValley.net
