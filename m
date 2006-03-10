From: "GuanYao Huang" <gyhuang@mail.ustc.edu.cn>
Subject: ip6tables: Unknown error 4294967295
Date: Fri, 10 Mar 2006 09:41:44 +0800
Message-ID: <341954904.20764@ustc.edu.cn>
Reply-To: GuanYao Huang <gyhuang@mail.ustc.edu.cn>
Content-Type: text/plain
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

Hi:
I am doing research into iptables-1.3.5, in which I am trying to use ROUTE target
which is an extension to the current iptables. 
I added libip6t_ROUTE.h which makes libip6t_ROUTE.c complied.
When using the following command:
[root@localhost iptables]# /root/CNGI/iptables-1.3.5/ip6tables -A POSTROUTING -t
mangle -o eth0 -p tcp --dport 22 -j ROUTE --oif iptun
ip6tables: Unknown error 4294967295

I don't know why. Can you help me? Thanks.
