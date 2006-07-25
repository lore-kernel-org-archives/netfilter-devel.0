From: "Ming-Ching Tiew" <mingching.tiew@redtone.com>
Subject: netfilter newbie asking about writing matches
Date: Tue, 25 Jul 2006 09:24:00 +0800
Message-ID: <008b01c6af89$024fc380$0100a8c0@newlife>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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


Well I have asked about the user space counter part of
xt_statistic match in iptables but get no response in
netfilter@lists.netfilter.org.

Now I am getting into the iptables/extensions/libipt_random.c
itself. It is still using the wrong structure for passing into 
the kernel.

I have modified the C program to use struct xt_statistic_info
in everywhere of the C code. The iptables compiles now.
But my question is, now the iptables library is libipt_random.so,
whereis the kernel module is xt_statistic.ko, which part of
the iptables code which instruct the kernel to use xt_statistic.ko
for the matching ?

Don't fire me, I just just a newbie trying hard to get my work
accomplished.

Regards. 
