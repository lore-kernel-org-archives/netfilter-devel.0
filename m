From: "Vasantha Kumar Puttappa" <vasanthakumar@iitb.ac.in>
Subject: ip_local_deliver related query
Date: Fri, 3 Feb 2006 11:43:19 +0530 (IST)
Message-ID: <60828.10.107.26.27.1138947199.squirrel@gpo.iitb.ac.in>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
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

Hi,

( I am assuming packet arrival to the local host)

  As far as I know Netfilter hook  for "INPUT" chain is called just before
the ip_local_deliver() function is called. If I am not wrong,
ip_local_deliver function will remove the IP header and gives the packet
to appropriate function in transport layer ( TCP or UDP or ICMP
Process).


 What I am want to do is to change the source IP address of the IP packet
just before calling the ip_local_deliver() using IPtables.

So I want know, will this go smoothly assuming there is a socket waiting
for this kind of packet(packet with new source IP address) or will
something go wrong ?



Please give your valuable feedback and correct me for any wrong
understanding.


-------
Vasanth
