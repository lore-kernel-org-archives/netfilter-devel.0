From: Iosif Peterfi <iosif.peterfi@fortesys.ro>
Subject: tproxy target and CONNMARK
Date: Thu, 20 Jul 2006 11:18:48 +0300
Message-ID: <1153383529.27719.56.camel@wks-toto>
Mime-Version: 1.0
Content-Type: text/plain
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

Hello list,

	I would like to know if tproxy target supports CONNMARK. The idea
behind the question is to mark packets in PREROUTING, then restore the
mark in POSTROUTING, using a transparent proxy.
	What I would like to achieve is shape the traffic on a transparent
squid proxy machine with 2 ISPs.
	Please correct me if i took the wrong way dealing with this problem.
        I know is possible doing ingress shaping, but i don't want this.


Thanks,
Iosif Peterfi
 
