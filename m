From: wanghtb@legend.com.cn
Subject: Re: about install iptables_1.2.9
Date: Thu, 4 Mar 2004 17:25:12 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <OFEB99B4B8.6DE50FED-ON48256E4D.00334740@legend.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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

HI,
I met this problem before. The error is due to different kernel version, 
which your kernel is 
a little older compared with iptables. And the solution is quite simple:
just check the file ip_conntrack.h and ip_conntrack_tuple.h inKERNEL_SRC/include/linux/netfilter_ipv4/ipt_conntrack.h,
make the definition IPS_EXPECTED visible for user appliciation by
moving them out of the '#ifdef __KERNEL__'  precompile directors
