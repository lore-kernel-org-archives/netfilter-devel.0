From: Derrick Sawyer <derrick@ip3.com>
Subject: Re: Error compile kernel 2.6.11.7 w/ pptp_conntrack_nat
Date: Thu, 11 Aug 2005 19:00:36 -0700
Message-ID: <20050812020036.9B5D8A28028@insight.ip3.com>
Reply-To: Derrick Sawyer <derrick@ip3.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jiri Slaby <jirislaby@gmail.com>
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

Thanks Jiri for the help.

I first applied the pptp_conntrack patch.
I tried to apply the ctnetlink patch and get "ERROR (5 rejects out of 48 hunks)".  I went ahead and forced the patch and got this error when
compiling the kernel: 

CC      net/ipv4/netfilter/ip_conntrack_core.o
net/ipv4/netfilter/ip_conntrack_core.c: In function `__ip_conntrack_hash_insert':
net/ipv4/netfilter/ip_conntrack_core.c:355: error: `ip_conntrack_next_id' undeclared (first use in this function)
net/ipv4/netfilter/ip_conntrack_core.c:355: error: (Each undeclared identifier is reported only once
net/ipv4/netfilter/ip_conntrack_core.c:355: error: for each function it appears in.)
make[3]: *** [net/ipv4/netfilter/ip_conntrack_core.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2
make: *** [net] Error 2


I am just at a lost.  Any help will be great.

Thanks,

~Derrick


------ Original Message ------
From: Jiri Slaby <jirislaby@gmail.com>
Date: Thursday, August 11th, 2005 10:08 AM PDT
To: Derrick Sawyer <derrick@ip3.com>
Subject: Re: Error compile kernel 2.6.11.7 w/ pptp_conntrack_nat

Derrick Sawyer napsal(a):

> Hi all,
>
> I am getting this error when compiling kernel 2.6.11.7 with pptp 
> patch-o-matic patch:
>
> LD      .tmp_vmlinux1
> net/built-in.o(.text+0x68bce): In function `timeout_ct_or_exp':
> : undefined reference to `__ip_conntrack_expect_find'
> make: *** [.tmp_vmlinux1] Error 1

In this kernel __ip_conntrack_expect_find isn't implemented, apply 
ctnetlink patch and compile again.
Despite, there is a bug, I think there should be
select IP_NF_CONNTRACK_NETLINK
in Kconfig if it uses it.
