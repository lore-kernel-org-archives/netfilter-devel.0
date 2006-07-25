From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter newbie asking about writing matches
Date: Tue, 25 Jul 2006 03:36:33 +0200
Message-ID: <44C575A1.3070205@trash.net>
References: <008b01c6af89$024fc380$0100a8c0@newlife>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ming-Ching Tiew <mingching.tiew@redtone.com>
In-Reply-To: <008b01c6af89$024fc380$0100a8c0@newlife>
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

Ming-Ching Tiew wrote:
> Well I have asked about the user space counter part of
> xt_statistic match in iptables but get no response in
> netfilter@lists.netfilter.org.
> 
> Now I am getting into the iptables/extensions/libipt_random.c
> itself. It is still using the wrong structure for passing into 
> the kernel.
> 
> I have modified the C program to use struct xt_statistic_info
> in everywhere of the C code. The iptables compiles now.
> But my question is, now the iptables library is libipt_random.so,
> whereis the kernel module is xt_statistic.ko, which part of
> the iptables code which instruct the kernel to use xt_statistic.ko
> for the matching ?
> 
> Don't fire me, I just just a newbie trying hard to get my work
> accomplished.

I have a complete patch for userspace, just wanted to think
about splitting the current single match in two to provide
command line compatibility .. but not sure if this is even
possible. I'll add it soon.
