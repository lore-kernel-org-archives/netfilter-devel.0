From: Andrew Morton <akpm@digeo.com>
Subject: Re: Sleeping function called from illegal context at slab.c:1378
Date: Mon, 23 Sep 2002 11:30:10 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3D8F5DB2.A3E36E16@digeo.com>
References: <1032804558.28404.13.camel@spc9.esa.lanl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: lkml <linux-kernel@vger.kernel.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Steven Cole <scole@lanl.gov>
List-Id: netfilter-devel.vger.kernel.org

That's a bug in ip_fw_ctl().  It's calling convert_ipfw()
inside FWC_WRITE_LOCK_IRQ(&ip_fw_lock, flags);

But convert_ipfw() does kmalloc(GFP_KERNEL).


Steven Cole wrote:
> 
> Hi Andrew,
> 
> Are these traced warnings of any use to you?
> 
> If so, here is one.  This one was from
> 
> "Sleeping function called from illegal context at slab.c:1378"
> 
> on bootup of 2.5.38-mm2:
> 
> Trace; c0119986 <__might_sleep+56/5d>
> Trace; c0135166 <kmalloc+66/1f0>
> Trace; c0271e03 <convert_ipfw+63/130>
> Trace; c02721c0 <ip_fw_ctl+2f0/4d0>
> Trace; c026a023 <sock_fn+63/80>
> Trace; c012ff2e <find_get_page+2e/60>
> Trace; c0130db5 <filemap_nopage+115/310>
> Trace; c012d8ef <do_no_page+2ef/390>
> Trace; c012b5ba <pte_alloc_map+ea/150>
> Trace; c023471a <nf_sockopt+fa/150>
> Trace; c0234790 <nf_setsockopt+20/30>
> Trace; c0242fda <ip_setsockopt+74a/910>
> Trace; c02255de <sock_map_fd+be/120>
> Trace; c022562a <sock_map_fd+10a/120>
> Trace; c0263995 <inet_setsockopt+25/30>
> Trace; c02269d6 <sys_setsockopt+56/70>
> Trace; c0227026 <sys_socketcall+1a6/200>
> Trace; c0114ea0 <do_page_fault+0/436>
> Trace; c01099b1 <error_code+2d/38>
> Trace; c0108f6f <syscall_call+7/b>
> 
> Steven
