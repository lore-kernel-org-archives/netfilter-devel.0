From: Philip Ho <cbho@ie.cuhk.edu.hk>
Subject: DSCP match
Date: Fri, 04 Apr 2003 14:01:04 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E8D1FA0.A8FB58@ie.cuhk.edu.hk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dear all

I am using Redhat 8.0 and then upgraded iptables to version 1.2.7a.

Even after upgrade, I cannot use DSCP match. Is it a must that I need to
install also patch-o-matic? 20030107 ?

[root@mediaw11 ip2test]# /usr/local/sbin/iptables -v -A PREROUTING -t
mangle -m dscp --dscp 0x2e -j DROP
DROP  all opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  DSCP match 0x2e
iptables: No chain/target/match by that name
[root@mediaw11 ip2test]#

Thanks all.

Regards,
philip
