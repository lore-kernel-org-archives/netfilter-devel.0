From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Error compile kernel 2.6.11.7 w/ pptp_conntrack_nat
Date: Thu, 11 Aug 2005 17:52:41 +0200
Message-ID: <42FB7449.2090007@gmail.com>
References: <42FA9451.90206@ip3.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Derrick Sawyer <derrick@ip3.com>
In-Reply-To: <42FA9451.90206@ip3.com>
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
