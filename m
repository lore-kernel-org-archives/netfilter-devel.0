From: pablo neira <pablo@eurodev.net>
Subject: Re: problem in compiling the hooks
Date: Wed, 14 Jan 2004 12:30:59 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40052873.5090106@eurodev.net>
References: <20040112081940.86820.qmail@web8207.mail.in.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: vamsi krishna <b_vamsi2002@yahoo.co.in>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <20040112081940.86820.qmail@web8207.mail.in.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

http://www.faqs.org/docs/kernel/x204.html

vamsi krishna wrote:

>hai,
>  
>I am a new bie. when i am trying to compile the
>following netfilter hook program i am getting errors .
>
>#define __KERNEL__
>#define MODULE
>
>#include<linux/module.h>
>#include<linux/kernel.h>
>#include<linux/netfilter.h>
>#include<linux/netfilter_ipv4.h>
>static struct nf_hook_ops nfho;
> 
>int hook_func(unsigned int hooknum,
>                      struct sk_buff **skb,
>                      const struct net_device *in,
>                      const struct net_device *out,
>                      int (*okfn)(struct sk_buff *))
>{
>return NF_DROP;
>}
>
>int init_module()
>{
>nfho.hook=hook_func;
>nfho.hooknum=NF_IP_PRI_ROUTING;
>nfho.pf=PF_INET;
>nfho.priority=NF_IP_PRI_FIRST;
>
>nf_register_hook(&nfho);
>
>return 0;
>}
>void cleanup_module()
>{
>nf_unregister_hook(&nfho);
>}
>
>i got the following errors
>
>[root@localhost vamsi]# gcc -c p1.c
>In file included from p1.c:7:
>/usr/include/linux/netfilter_ipv4.h:53: `INT_MIN'
>undeclared here (not in a function)
>/usr/include/linux/netfilter_ipv4.h:53: enumerator
>value for `NF_IP_PRI_FIRST' not integer constant
>/usr/include/linux/netfilter_ipv4.h:59: `INT_MAX'
>undeclared here (not in a function)
>/usr/include/linux/netfilter_ipv4.h:59: enumerator
>value for `NF_IP_PRI_LAST' not integer constant
>p1.c:15: warning: `struct net_device' declared inside
>parameter list
>p1.c:15: warning: its scope is only this definition or
>declaration, which is probably not what you want
>p1.c:15: warning: `struct sk_buff' declared inside
>parameter list
>p1.c: In function `init_module':
>p1.c:22: invalid use of undefined type `struct
>nf_hook_ops'
>p1.c:23: invalid use of undefined type `struct
>nf_hook_ops'
>p1.c:24: invalid use of undefined type `struct
>nf_hook_ops'
>p1.c:24: `PF_INET' undeclared (first use in this
>function)
>p1.c:24: (Each undeclared identifier is reported only
>once
>p1.c:24: for each function it appears in.)
>p1.c:25: invalid use of undefined type `struct
>nf_hook_ops'
>p1.c: At top level:
>p1.c:9: storage size of `nfho' isn't known
>
>please help me,
>
>vamsi
>
>
>
>________________________________________________________________________
>Yahoo! India Mobile: Download the latest polyphonic ringtones.
>Go to http://in.mobile.yahoo.com
>
>  
>
