From: Jarek <hugle@vkt.lt>
Subject: flush current NAT  mappings.
Date: Mon, 26 Dec 2005 10:47:26 +0200
Message-ID: <1512650062.20051226104726@vkt.lt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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

Hello all.

I was playing with iptables and came to idea, that sometimes I need
to flush current NAT mappings (not iptables rules).
I think  I should clear somewhere from conntrack tables, but where?

I was doing it easily under FreeBSD.
I think iptables/Linux should hangle this possibility too?


Thanks,
Jarek
