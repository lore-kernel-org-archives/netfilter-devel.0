From: Patrick McHardy <kaber@trash.net>
Subject: [00/14]: Netfilter fixes for 2.6.16
Date: Fri,  3 Feb 2006 14:43:58 +0100 (MET)
Message-ID: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
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

Hi Dave,

following are my pending netfilter bugfixes for 2.6.16, unfortunately
its quite a lot, but mostly trivial patches. There are still two open
bugs from the netfilter IPsec patches, the "ip_finish_output2: No header
cache and no neighbour!" bug reported by Andi Kleen and a crash in
xfrm4_output_finish. I'll probably have the fixes ready sometime this
weekend.
