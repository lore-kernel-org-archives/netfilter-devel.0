Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F211C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Apr 2022 18:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbiDYSs0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Apr 2022 14:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244484AbiDYSsY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Apr 2022 14:48:24 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3319CE0
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2022 11:45:18 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id m20so10656163ejj.10
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2022 11:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=9OHieLbTN0IfTPhjCBgV2o7Gj2orriBkFhGAIyjF2E0=;
        b=SomY40dO7W75dfM6+oZqGJv2W5OBCm+ioxps4mTBu/0ezvIk3Jr+UclasEiTSxphco
         AMloe0FdAAWn0aokqaGcK9BaEzusaP9Xq0MQ2TIdriIsLIMXeIbdZEUcLQvnCzaLk40l
         Xndf+TNXhGuUkWOOQlFfFVwSQJRUuCCnyxNpo3Nzcx0h1GEVPYctwnx7/j//cEd+zKFY
         KOzUBVQ1ORBWZN4/92e+BJ5Fj4gayqxfwYviXvMc1ohySOimD41fe+ipVo1QOfhK3+aY
         kKcd5ayDgNbZxEuVQthul4TAxofVB1ibMVDw5Lg+o0d3LA05F5yS9Fafj9BZs7i3gygT
         YK6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9OHieLbTN0IfTPhjCBgV2o7Gj2orriBkFhGAIyjF2E0=;
        b=Kypjf09tMIZE2qPbdF9/gijzvg5nRA7rjYq91KD8FkPU0ARU7wdNtfJ5n2szUhBarF
         qPl+NUuCQYFWfvegLFkQZ7cURS8+YtpbnYJwk9n81yFfoUM112g421pWR9Q/xPI7VF9k
         xL1Mh27ilRrOo9+IrtNhKWtJ9VKjitO2asOoHumSLJXGcAl9h6xNTPvnIq7lTNX+ibHv
         d0e2WHJ6XWMwO0CwQpL41g1ZSRq+LV6FK9y1E5jAOvHMecKnBakCD9aHqvUv68qu6Pht
         itdYx5hsp3SZhvr4YEIVtzxKp19nCNCKU3TJeTw7qnAnWqUcr40AEg2IhG8xzS4pJL3k
         2nig==
X-Gm-Message-State: AOAM532NSeIe96M1/sFhKMlAavgezD1CZPmtLlGjTxUg89+2oOp4fU/Y
        7dnwYhR/nJ8T/fXhNqiDAvsKxIDw6LRxFA==
X-Google-Smtp-Source: ABdhPJzzEnaHtk+hPHJ3huzQ6uG0vZOBVMB/3f1z44s7oulIcfisi1clUJTPbgSigu9orVMjEeNW/A==
X-Received: by 2002:a17:906:1ecf:b0:6e7:fdc1:255b with SMTP id m15-20020a1709061ecf00b006e7fdc1255bmr17623868ejj.340.1650912316903;
        Mon, 25 Apr 2022 11:45:16 -0700 (PDT)
Received: from [192.168.1.38] (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id eq7-20020a056402298700b00419d8d46a8asm4773343edb.39.2022.04.25.11.45.15
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 11:45:16 -0700 (PDT)
Message-ID: <5a292abd-7f2e-728f-5594-86d85fbd1c00@gmail.com>
Date:   Mon, 25 Apr 2022 21:45:14 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] netfilter: nft_socket: socket expressions for GID & UID
Content-Language: en-US
To:     netfilter-devel@vger.kernel.org
References: <20220420185447.10199-1-toiwoton@gmail.com>
From:   Topi Miettinen <toiwoton@gmail.com>
In-Reply-To: <20220420185447.10199-1-toiwoton@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 20.4.2022 21.54, Topi Miettinen wrote:
> Add socket expressions for checking GID or UID of the originating
> socket. These work also on input side, unlike meta skuid/skgid.

Unfortunately, there's a reproducible kernel BUG when closing a local 
connection:

Apr 25 21:18:13 kernel: 
==================================================================
Apr 25 21:18:13 kernel: BUG: KASAN: null-ptr-deref in 
nf_sk_lookup_slow_v6+0x45b/0x590 [nf_socket_ipv6]
Apr 25 21:18:13 kernel: Read of size 4 at addr 00000000000000d8 by task 
ssh/1754
Apr 25 21:18:13 kernel:
Apr 25 21:18:13 kernel: CPU: 8 PID: 1754 Comm: ssh Tainted: G 
  E     5.17.0-rc7+ #6
Apr 25 21:18:13 kernel: Hardware name: XXX
Apr 25 21:18:13 kernel: Call Trace:
Apr 25 21:18:13 kernel:  <IRQ>
Apr 25 21:18:13 kernel:  dump_stack_lvl+0x34/0x44
Apr 25 21:18:13 kernel:  ? nf_sk_lookup_slow_v6+0x45b/0x590 [nf_socket_ipv6]
Apr 25 21:18:13 kernel:  kasan_report.cold+0x66/0xdc
Apr 25 21:18:13 kernel:  ? nf_sk_lookup_slow_v6+0x45b/0x590 [nf_socket_ipv6]
Apr 25 21:18:13 kernel:  nf_sk_lookup_slow_v6+0x45b/0x590 [nf_socket_ipv6]
Apr 25 21:18:13 kernel:  ? 0xffffffffc141c000
Apr 25 21:18:13 kernel:  ? preempt_count_sub+0xf/0xb0
Apr 25 21:18:13 kernel:  ? unwind_next_frame+0x6c6/0xbf0
Apr 25 21:18:13 kernel:  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
Apr 25 21:18:13 kernel:  ? bpf_ksym_find+0x8f/0xe0
Apr 25 21:18:13 kernel:  ? __rcu_read_unlock+0x2a/0x60
Apr 25 21:18:13 kernel:  ? is_bpf_text_address+0x1a/0x30
Apr 25 21:18:13 kernel:  ? kernel_text_address+0x57/0xb0
Apr 25 21:18:13 kernel:  ? __kernel_text_address+0x9/0x30
Apr 25 21:18:13 kernel:  ? unwind_get_return_address+0x2a/0x40
Apr 25 21:18:13 kernel:  ? create_prof_cpu_mask+0x20/0x20
Apr 25 21:18:13 kernel:  ? arch_stack_walk+0x99/0xf0
Apr 25 21:18:13 kernel:  ? __orc_find+0x63/0xc0
Apr 25 21:18:13 kernel:  ? deref_stack_reg+0x7a/0xb0
Apr 25 21:18:13 kernel:  ? get_stack_info_noinstr+0x12/0xf0
Apr 25 21:18:13 kernel:  nft_socket_eval+0xea/0x491 [nft_socket]
Apr 25 21:18:13 kernel:  nft_do_chain+0x240/0x860 [nf_tables]
Apr 25 21:18:13 kernel:  ? bpf_ksym_find+0x8f/0xe0
Apr 25 21:18:13 kernel:  ? __nft_trace_verdict.isra.0+0x20/0x20 [nf_tables]
Apr 25 21:18:13 kernel:  ? __kernel_text_address+0x9/0x30
Apr 25 21:18:13 kernel:  ? unwind_get_return_address+0x2a/0x40
Apr 25 21:18:13 kernel:  ? create_prof_cpu_mask+0x20/0x20
Apr 25 21:18:13 kernel:  ? _raw_spin_lock_irqsave+0x88/0xe0
Apr 25 21:18:13 kernel:  ? __cpuidle_text_end+0x3/0x3
Apr 25 21:18:13 kernel:  ? selinux_netlbl_skbuff_setsid+0x215/0x2a0
Apr 25 21:18:13 kernel:  ? selinux_netlbl_skbuff_setsid+0x215/0x2a0
Apr 25 21:18:13 kernel:  ? stack_trace_save+0x8c/0xc0
Apr 25 21:18:13 kernel:  ? _raw_spin_lock_bh+0x82/0xe0
Apr 25 21:18:13 kernel:  ? _raw_write_lock_irq+0xd0/0xd0
Apr 25 21:18:13 kernel:  ? __nf_ct_refresh_acct+0xa6/0xd0 [nf_conntrack]
Apr 25 21:18:13 kernel:  ? nf_ct_acct_add+0x32/0x80 [nf_conntrack]
Apr 25 21:18:13 kernel:  ? nf_conntrack_tcp_packet+0xef7/0x2c20 
[nf_conntrack]
Apr 25 21:18:13 kernel:  ? kasan_record_aux_stack_noalloc+0x5/0x10
Apr 25 21:18:13 kernel:  ? selinux_netlbl_skbuff_setsid+0x215/0x2a0
Apr 25 21:18:13 kernel:  ? selinux_ip_output+0x7b/0xa0
Apr 25 21:18:13 kernel:  ? ipv6_find_hdr+0x102/0x500
Apr 25 21:18:13 kernel:  ? ipv6_skip_exthdr+0x240/0x240
Apr 25 21:18:13 kernel:  ? ipv6_find_tlv+0xf0/0xf0
Apr 25 21:18:13 kernel:  ? tcp_new+0x420/0x420 [nf_conntrack]
Apr 25 21:18:13 kernel:  ? __nf_conntrack_find_get+0x52e/0x750 
[nf_conntrack]
Apr 25 21:18:13 kernel:  nf_route_table_hook6+0x216/0x400 [nf_tables]
Apr 25 21:18:13 kernel:  ? nf_route_table_hook4+0x280/0x280 [nf_tables]
Apr 25 21:18:13 kernel:  ? __kasan_slab_alloc+0x2c/0x80
Apr 25 21:18:13 kernel:  ? security_netlbl_sid_to_secattr+0xb6/0x130
Apr 25 21:18:13 kernel:  ? nf_conntrack_in+0x768/0xa50 [nf_conntrack]
Apr 25 21:18:13 kernel:  ? nf_route_table_hook6+0x400/0x400 [nf_tables]
Apr 25 21:18:13 kernel:  nf_route_table_inet+0xdf/0xf0 [nf_tables]
Apr 25 21:18:13 kernel:  ? nf_route_table_hook6+0x400/0x400 [nf_tables]
Apr 25 21:18:13 kernel:  nf_hook_slow+0x57/0xd0
Apr 25 21:18:13 kernel:  ip6_xmit+0x6d3/0xaa0
Apr 25 21:18:13 kernel:  ? ip6_forward_finish+0x1b0/0x1b0
Apr 25 21:18:13 kernel:  ? tcp_v6_send_response+0x19f/0xc00
Apr 25 21:18:13 kernel:  ? ip6_output+0x220/0x220
Apr 25 21:18:13 kernel:  ? ip6_dst_lookup_tail.constprop.0+0x860/0x860
Apr 25 21:18:13 kernel:  ? __build_skb_around+0x109/0x130
Apr 25 21:18:13 kernel:  ? selinux_xfrm_skb_sid_ingress+0xe1/0x110
Apr 25 21:18:13 kernel:  tcp_v6_send_response+0x7bd/0xc00
Apr 25 21:18:13 kernel:  ? tcp_v6_connect+0xbb0/0xbb0
Apr 25 21:18:13 kernel:  ? tcp_rcv_state_process+0x1d9c/0x1de0
Apr 25 21:18:13 kernel:  tcp_v6_send_reset+0x2b2/0x630
Apr 25 21:18:13 kernel:  ? tcp_parse_md5sig_option+0x16/0xa0
Apr 25 21:18:13 kernel:  ? reqsk_put+0x150/0x150
Apr 25 21:18:13 kernel:  ? tcp_v6_inbound_md5_hash+0xc4/0x260
Apr 25 21:18:13 kernel:  ? bpf_skb_vlan_pop+0xa0/0xa0
Apr 25 21:18:13 kernel:  tcp_v6_do_rcv+0x394/0x740
Apr 25 21:18:13 kernel:  tcp_v6_rcv+0x13e5/0x15d0
Apr 25 21:18:13 kernel:  ? tcp_v6_do_rcv+0x740/0x740
Apr 25 21:18:13 kernel:  ? ipv6_confirm+0x11f/0x260 [nf_conntrack]
Apr 25 21:18:13 kernel:  ? ipv4_confirm+0x130/0x130 [nf_conntrack]
Apr 25 21:18:13 kernel:  ip6_protocol_deliver_rcu+0x182/0x910
Apr 25 21:18:13 kernel:  ip6_input+0x156/0x170
Apr 25 21:18:13 kernel:  ? ip6_input_finish+0x30/0x30
Apr 25 21:18:13 kernel:  ? ip6_protocol_deliver_rcu+0x910/0x910
Apr 25 21:18:13 kernel:  ? nf_nat_ipv6_fn+0x1a0/0x1a0 [nf_nat]
Apr 25 21:18:13 kernel:  ? nf_hook_slow+0x98/0xd0
Apr 25 21:18:13 kernel:  ipv6_rcv+0x22f/0x270
Apr 25 21:18:13 kernel:  ? ip6_input+0x170/0x170
Apr 25 21:18:13 kernel:  ? __bitmap_and+0x6e/0x100
Apr 25 21:18:13 kernel:  ? _find_next_bit+0x5a/0x110
Apr 25 21:18:13 kernel:  ? ipv6_list_rcv+0x260/0x260
Apr 25 21:18:13 kernel:  ? load_balance+0x1181/0x1290
Apr 25 21:18:13 kernel:  ? ip6_input+0x170/0x170
Apr 25 21:18:13 kernel:  __netif_receive_skb_one_core+0xd4/0x130
Apr 25 21:18:13 kernel:  ? __netif_receive_skb_list_core+0x4c0/0x4c0
Apr 25 21:18:13 kernel:  ? _raw_spin_lock+0x82/0xe0
Apr 25 21:18:13 kernel:  ? _raw_spin_lock_bh+0xe0/0xe0
Apr 25 21:18:13 kernel:  process_backlog+0xec/0x270
Apr 25 21:18:13 kernel:  __napi_poll+0x57/0x1c0
Apr 25 21:18:13 kernel:  net_rx_action+0x1df/0x450
Apr 25 21:18:13 kernel:  ? napi_threaded_poll+0x1a0/0x1a0
Apr 25 21:18:13 kernel:  ? read_hpet+0x100/0x1d0
Apr 25 21:18:13 kernel:  ? native_flush_tlb_global+0xcc/0xe0
Apr 25 21:18:13 kernel:  __do_softirq+0x108/0x2b1
Apr 25 21:18:13 kernel:  ? sched_clock_cpu+0x113/0x130
Apr 25 21:18:13 kernel:  do_softirq+0xa1/0xd0
Apr 25 21:18:13 kernel:  </IRQ>
Apr 25 21:18:13 kernel:  <TASK>
Apr 25 21:18:13 kernel:  __local_bh_enable_ip+0x60/0x70
Apr 25 21:18:13 kernel:  ip6_finish_output2+0x408/0x9e0
Apr 25 21:18:13 kernel:  ? ip6_dst_lookup+0x40/0x40
Apr 25 21:18:13 kernel:  ? __rcu_read_unlock+0x2a/0x60
Apr 25 21:18:13 kernel:  ? ip6_mtu+0x7b/0xc0
Apr 25 21:18:13 kernel:  ? __ip6_finish_output+0x18d/0x420
Apr 25 21:18:13 kernel:  ip6_output+0x110/0x220
Apr 25 21:18:13 kernel:  ? ip6_finish_output+0xc0/0xc0
Apr 25 21:18:13 kernel:  ? __ip6_finish_output+0x420/0x420
Apr 25 21:18:13 kernel:  ip6_xmit+0x7ea/0xaa0
Apr 25 21:18:13 kernel:  ? ip6_forward_finish+0x1b0/0x1b0
Apr 25 21:18:13 kernel:  ? cpu_weight_nice_read_s64+0x46/0x90
Apr 25 21:18:13 kernel:  ? __rcu_read_unlock+0x43/0x60
Apr 25 21:18:13 kernel:  ? ip6_output+0x220/0x220
Apr 25 21:18:13 kernel:  ? __sk_dst_check+0x64/0xe0
Apr 25 21:18:13 kernel:  ? inet6_csk_route_socket+0x29e/0x3e0
Apr 25 21:18:13 kernel:  ? inet6_csk_addr2sockaddr+0xd0/0xd0
Apr 25 21:18:13 kernel:  ? unwind_get_return_address+0x2a/0x40
Apr 25 21:18:13 kernel:  ? create_prof_cpu_mask+0x20/0x20
Apr 25 21:18:13 kernel:  ? arch_stack_walk+0x99/0xf0
Apr 25 21:18:13 kernel:  inet6_csk_xmit+0x1b2/0x250
Apr 25 21:18:13 kernel:  ? inet6_csk_update_pmtu+0x110/0x110
Apr 25 21:18:13 kernel:  ? bpf_skops_hdr_opt_len+0x1e0/0x1e0
Apr 25 21:18:13 kernel:  ? __tcp_select_window+0x143/0x470
Apr 25 21:18:13 kernel:  ? tcp_options_write+0xc9/0x370
Apr 25 21:18:13 kernel:  __tcp_transmit_skb+0xa8a/0x14b0
Apr 25 21:18:13 kernel:  ? __tcp_select_window+0x470/0x470
Apr 25 21:18:13 kernel:  ? hpet_msi_interrupt_handler+0x30/0x30
Apr 25 21:18:13 kernel:  ? tcp_stream_alloc_skb+0x47/0x3d0
Apr 25 21:18:13 kernel:  tcp_write_xmit+0x72a/0x2510
Apr 25 21:18:13 kernel:  ? skb_page_frag_refill+0x15c/0x190
Apr 25 21:18:13 kernel:  ? __virt_addr_valid+0xb9/0x130
Apr 25 21:18:13 kernel:  __tcp_push_pending_frames+0x51/0x170
Apr 25 21:18:13 kernel:  tcp_sendmsg_locked+0x4a7/0x1460
Apr 25 21:18:13 kernel:  ? tcp_sendpage+0x80/0x80
Apr 25 21:18:13 kernel:  ? _raw_spin_lock_bh+0x82/0xe0
Apr 25 21:18:13 kernel:  ? _raw_write_lock_irq+0xd0/0xd0
Apr 25 21:18:13 kernel:  ? inet6_ioctl+0x1b0/0x1b0
Apr 25 21:18:13 kernel:  tcp_sendmsg+0x23/0x40
Apr 25 21:18:13 kernel:  sock_sendmsg+0x73/0xa0
Apr 25 21:18:13 kernel:  sock_write_iter+0x125/0x1d0
Apr 25 21:18:13 kernel:  ? sock_sendmsg+0xa0/0xa0
Apr 25 21:18:13 kernel:  ? bpf_local_storage_map_alloc_check+0x40/0xc0
Apr 25 21:18:13 kernel:  ? new_sync_read+0x33d/0x360
Apr 25 21:18:13 kernel:  ? audit_filter_rules.constprop.0+0x1326/0x1ef0
Apr 25 21:18:13 kernel:  ? audit_filter_rules.constprop.0+0x1326/0x1ef0
Apr 25 21:18:13 kernel:  new_sync_write+0x348/0x360
Apr 25 21:18:13 kernel:  ? new_sync_read+0x360/0x360
Apr 25 21:18:13 kernel:  ? bpf_local_storage_map_alloc_check+0x40/0xc0
Apr 25 21:18:13 kernel:  ? bpf_fd_pass+0xf0/0xf0
Apr 25 21:18:13 kernel:  ? selinux_file_permission+0x11c/0x1f0
Apr 25 21:18:13 kernel:  vfs_write+0x33e/0x3e0
Apr 25 21:18:13 kernel:  ksys_write+0x11b/0x150
Apr 25 21:18:13 kernel:  ? __ia32_sys_read+0x40/0x40
Apr 25 21:18:13 kernel:  ? __audit_syscall_entry+0x173/0x1f0
Apr 25 21:18:13 kernel:  ? ktime_get_coarse_real_ts64+0x45/0x60
Apr 25 21:18:13 kernel:  do_syscall_64+0x5c/0x80
Apr 25 21:18:13 kernel:  ? syscall_exit_to_user_mode+0x1d/0x40
Apr 25 21:18:13 kernel:  ? do_syscall_64+0x69/0x80
Apr 25 21:18:13 kernel:  ? do_syscall_64+0x69/0x80
Apr 25 21:18:13 kernel:  ? do_syscall_64+0x69/0x80
Apr 25 21:18:13 kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
Apr 25 21:18:13 kernel: RIP: 0033:0x75f2a694c603
Apr 25 21:18:13 kernel: Code: 8b 15 71 38 0e 00 f7 d8 64 89 02 48 c7 c0 
ff ff ff ff eb b7 0f 1f 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 01 00 
00 00 0f 05 <48> 3d 00 f0 ff ff 77 55 c3 0f 1f 40 00 48 83 ec 28 48 89 
54 24 18
Apr 25 21:18:13 kernel: RSP: 002b:00004a29af4792c8 EFLAGS: 00000246 
ORIG_RAX: 0000000000000001
Apr 25 21:18:13 kernel: RAX: ffffffffffffffda RBX: 000000000000003c RCX: 
000075f2a694c603
Apr 25 21:18:13 kernel: RDX: 000000000000003c RSI: 000065287ad9af00 RDI: 
0000000000000003
Apr 25 21:18:13 kernel: RBP: 000065287ad8f380 R08: 0000000000000000 R09: 
0000000000000000
Apr 25 21:18:13 kernel: R10: 0000000000000000 R11: 0000000000000246 R12: 
0000000000000000
Apr 25 21:18:13 kernel: R13: 00000000ffffffe8 R14: 000065287ad939c0 R15: 
0000000000000000
Apr 25 21:18:13 kernel:  </TASK>
Apr 25 21:18:13 kernel: 
==================================================================
Apr 25 21:18:13 kernel: Disabling lock debugging due to kernel taint
Apr 25 21:18:13 kernel: BUG: kernel NULL pointer dereference, address: 
00000000000000d8
Apr 25 21:18:13 kernel: #PF: supervisor read access in kernel mode
Apr 25 21:18:13 kernel: #PF: error_code(0x0000) - not-present page
