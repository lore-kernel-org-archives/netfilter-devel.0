From: "zhengchuanbo" <zhengcb@netpower.com.cn>
Subject: to solve the performance problem of netfilter
Date: Wed, 17 Dec 2003 10:29:9 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200312171018140.SM00864@zhengcb>
Mime-Version: 1.0
Content-Type: text/plain;
      charset="GB2312"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I noticed that the netfilter module has a big influnce to the performance. 
I tested the throughput of our linux firewall. the result is as follows,
	linux(no netfilter)					580kpps
	with netfilter(no ip_conntrack)	    450kpps
	with ip_conntrack					295kpps
So the throughput dropped about 40% when with ip_conntrack.

I tried NOTRACK module, but the performance is not very good.
	
On our linux firewall, most of the traffic are from a trusted host on the 
DMZ server, which need not to be filtered. So I wish there could be a solution
to open a fast path to the certain server, with no conntrack nor filter.   	
Somebody suggested to install a netfilter-module that gets the packets before 
conntrack and steal the packets, and bypass the rest of iptables as well. Is there
any ideas on that?
	
thanks.
	
regards,
Jack Zheng
zhengcb@netpower.com.cn
