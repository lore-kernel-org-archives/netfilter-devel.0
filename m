From: Michael Kunze <mkunze@ambora.de>
Subject: conntrack read locking problem still exists
Date: Sat, 28 Sep 2002 18:45:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3D95DCBE.3080407@ambora.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

i read similar messages on the list from time to time, but the issue 
seems not to have been resolved so far.

ASSERT ip_conntrack_core.c:94 &ip_conntrack_lock_R0c1132e0 readlocked
ASSERT ip_conntrack_core.c:1063 &ip_conntrack_lock not readlocked
ASSERT: ip_nat_core.c:841 &ip_conntrack_lock not readlocked

My kernel is linux-2.4.20-pre8 with recent cvs netfilter applied on 
i386, but the same effect applies for vanilla 2.4.19

BTW, the ip_conntrack_protocol_destroy.patch breaks when running ./runme 
pending claiming it can't patch the source tree.

Cheers
Michael
