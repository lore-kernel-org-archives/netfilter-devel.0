From: subashab@codeaurora.org
Subject: WARN due to local_bh_disable called with interrupts disabled
Date: Thu, 19 Nov 2015 02:37:54 -0000
Message-ID: <94ad7f112d565984ffdc4aaafe002803.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50114 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343AbbKSChz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Nov 2015 21:37:55 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We are seeing a WARN due to local_bh_disable called with interrupts
disabled with CONFIG_IRQSOFF_TRACER / CONFIG_PREEMPT_TRACER.

Here is the WARN trace

  1833.210427:   <6> Call trace:
  1833.212833:   <2> [<ffffffc000088530>] dump_backtrace+0x0/0x270
  1833.212838:   <2> [<ffffffc0000887b0>] show_stack+0x10/0x1c
  1833.212853:   <2> [<ffffffc000c6edac>] dump_stack+0x74/0xb8
  1833.212862:   <2> [<ffffffc0000a0fe4>] warn_slowpath_common+0x88/0xb0
  1833.212865:   <2> [<ffffffc0000a10d0>] warn_slowpath_null+0x14/0x20
  1833.212870:   <2> [<ffffffc0000a46dc>] __local_bh_disable_ip+0x4c/0xc8
  1833.212882:   <2> [<ffffffc000ae2788>] destroy_conntrack+0x90/0x184
  1833.212888:   <2> [<ffffffc000adcd50>] nf_conntrack_destroy+0x28/0x38
  1833.212896:   <2> [<ffffffc000a97550>] skb_release_head_state+0xa4/0xe0
  1833.212900:   <2> [<ffffffc000a977e0>] __kfree_skb+0x10/0xbc
  1833.212904:   <2> [<ffffffc000a976bc>] kfree_skb+0xb4/0xdc
  1833.212912:   <2> [<ffffffc000aa4660>] flush_backlog+0x88/0x120
  1833.212922:   <2> [<ffffffc00010e544>]
flush_smp_call_function_queue+0xb4/0x154
  1833.212926:   <2> [<ffffffc00010efcc>]
generic_smp_call_function_single_interrupt+0xc/0x18
  1833.212932:   <2> [<ffffffc000091050>] handle_IPI+0x120/0x338
  1833.212937:   <2> [<ffffffc000081580>] gic_handle_irq+0xb8/0xdc

Here is the callstack which leads to this WARN.

netdev_run_todo
on_each_cpu //This disables irq with local_irq_save(flags)
flush_backlog
kfree_skb
..
destroy_conntrack //This disables irq's again through local_bh_disable

I noticed that this was introduced by commit ca7433df3a ("netfilter:
conntrack: seperate expect locking from nf_conntrack_lock ").

Since interrupts are already disabled when flush_backlog is called, is it
expected to disable bottom halves in destroy_conntrack?

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux
Foundation Collaborative Project

