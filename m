From: Fang Han <fanghan@opencjk.org>
Subject: [BUG] ipt_SAME rule can't be deleted
Date: Sat, 4 Dec 2004 23:02:23 +0800
Message-ID: <20041204150223.GA10247@dfbbb.opencjk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Kernel 2.6.9 ac2

Using the next test command:

/sbin/iptables  -t nat -I POSTROUTING -s 192.168.100.23 -o eth0 -j SAME --to 192.168.1.60
/sbin/iptables  -t nat -D POSTROUTING -s 192.168.100.23 -o eth0 -j SAME --to 192.168.1.60

generate error:
iptables: Bad rule (does a matching rule exist in that chain?)

But I can use iptables -t nat -D POSTROUTING 1 to delete this rules
