From: Peter Lee <mclee@sfu.ca>
Subject: ip6_queue
Date: Thu, 05 Dec 2002 1:35:39 PST
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200212050935.gB59ZdMj023281@rm-rstar.sfu.ca>
Reply-To: Peter Lee <mclee@sfu.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: binary
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
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

Hi,

I am stuck with ip6_queue module. I am using RedHat 7.3 and I did try to
recompile my kernel to build the ip6_queue module. But, I am not sure why
this module didn't get build. What I did is, I manually copy this file to
another directory and create a new make file to build the module. Is there
another way out?

I do the following to install the module:

install -m 644 ip6_queue.o /lib/modules/$(KERNEL)/ip6_queue.o
/sbin/depmod -ae

and I got the following error message:
depmod: *** Unresolved symbols in /lib/modules/2.4.18-3/aodv/ip6_queue.o
depmod: 	sock_wfree
depmod: 	__kfree_skb
depmod: 	nf_register_queue_handler
depmod: 	alloc_skb
depmod: 	kmalloc
depmod: 	unregister_netdevice_notifier
depmod: 	netlink_kernel_create
depmod: 	create_proc_entry
depmod: 	rtnl_sem
depmod: 	nf_unregister_queue_handler
depmod: 	netlink_ack
depmod: 	proc_dointvec
depmod: 	unregister_sysctl_table
depmod: 	net_ratelimit
depmod: 	kfree
depmod: 	___pskb_trim
depmod: 	nf_reinject
depmod: 	remove_proc_entry
depmod: 	skb_over_panic
depmod: 	netlink_unicast
depmod: 	proc_net
depmod: 	sock_release
depmod: 	do_BUG
depmod: 	sprintf
depmod: 	register_netdevice_notifier
depmod: 	printk
depmod: 	irq_stat
depmod: 	register_sysctl_table
depmod: 	do_softirq
depmod: 	skb_copy_expand

But I can use modprobe to load the module and it seem to work fine. But I
would like to get rid of the error message, help please :-<


Thanks.
Peter Lee
M.Eng. Student
Simon Fraser University
