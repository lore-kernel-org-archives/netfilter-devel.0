From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/2] Fix (improve) deadlock condition on module removal
 netfilter socket option removal
Date: Wed, 05 Sep 2007 17:22:39 +0200
Message-ID: <46DEC9BF.9010807@trash.net>
References: <20070904202433.GA19083@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, adam@yggdrasil.com, jcm@jonmasters.org,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757619AbXIEPY2@vger.kernel.org>
In-Reply-To: <20070904202433.GA19083@hmsreliant.think-freely.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Neil Horman wrote:
> Hey all-
> 	So I've had a deadlock reported to me.  I've found that the sequence of
> events goes like this:
> 
> 1) process A (modprobe) runs to remove ip_tables.ko
> 
> 2) process B (iptables-restore) runs and calls setsockopt on a netfilter socket,
> increasing the ip_tables socket_ops use count
> 
> 3) process A acquires a file lock on the file ip_tables.ko, calls remove_module
> in the kernel, which in turn executes the ip_tables module cleanup routine,
> which calls nf_unregister_sockopt
> 
> 4) nf_unregister_sockopt, seeing that the use count is non-zero, puts the
> calling process into uninterruptible sleep, expecting the process using the
> socket option code to wake it up when it exits the kernel
> 
> 4) the user of the socket option code (process B) in do_ipt_get_ctl, calls
> ipt_find_table_lock, which in this case calls request_module to load
> ip_tables_nat.ko
> 
> 5) request_module forks a copy of modprobe (process C) to load the module and
> blocks until modprobe exits.
> 
> 6) Process C. forked by request_module process the dependencies of
> ip_tables_nat.ko, of which ip_tables.ko is one.
> 
> 7) Process C attempts to lock the request module and all its dependencies, it
> blocks when it attempts to lock ip_tables.ko (which was previously locked in
> step 3)
> 
> Theres not really any great permanent solution to this that I can see, but I've
> developed a two part solution that corrects the problem
> 
> Part 1) Modifies the nf_sockopt registration code so that, instead of using a
> use counter internal to the nf_sockopt_ops structure, we instead use a pointer
> to the registering modules owner to do module reference counting when nf_sockopt
> calls a modules set/get routine.  This prevents the deadlock by preventing set 4
> from happening.
> 
> Part 2) Enhances the modprobe utilty so that by default it preforms non-blocking
> remove operations (the same way rmmod does), and add an option to explicity
> request blocking operation.  So if you select blocking operation in modprobe you
> can still cause the above deadlock, but only if you explicity try (and since
> root can do any old stupid thing it would like.... :) ).
> 
> The following 2 patches have been tested out by me.


Nice catch, we've had a report of this ages ago, but I never figured
out what happend.

But I'm wondering, wouldn't module refcounting alone fix this problem?
If we make nf_sockopt() call try_module_get(ops->owner), remove_module()
on ip_tables.ko would simply fail because the refcount is above zero
(so it would fail at point 3 above). Am I missing something important?
