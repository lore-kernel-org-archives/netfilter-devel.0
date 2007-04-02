From: "johnpeng" <johnpeng@unitytek.com.tw>
Subject: Multiple calls of check functions
Date: Mon, 2 Apr 2007 17:22:47 +0800
Message-ID: <29392.0101634741$1175512084@news.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Dear all:
    When I issue the command with debug version of the SAME target (I am
using kernel 2.6.17.7 and iptables 1.3.5)
"iptables -t nat -A PREROUTING -d 10.10.10.1 -j SAME -to
172.31.0.1-172.31.0.3"
I find that the check function of SAME target would be called multiple
times, any following SNAT,DNAT rules would call the check function of the
SAME
Target ,  however, I didn't see the same situation in kernel 2.4 , is that
due to some framework change in kernel 2.6 ?

And 
When we issue the removal "iptables -t nat -D PREROUTING -d 10.10.10.1 -j
SAME -to 172.31.0.1-172.31.0.3", 
Iptables get reply of "iptables: No chain/target/match by that name",
 it seems the memory comparison is not equal with user level and kernel
level passed target info data structure, 
Any solution?

Thanks for your help!!

JohnPeng
