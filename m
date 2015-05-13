From: Praveen Kumar <praveenkr.cs@gmail.com>
Subject: Kernel panic with skb_alloc during post_routing
Date: Tue, 12 May 2015 20:21:44 -0400
Message-ID: <CAJxoMGYDv2nrHr3=aa_A6+Mr2qy4coO+MB=mNWkf8=_SELhVbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:32813 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbbEMAWH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 May 2015 20:22:07 -0400
Received: by qgdy78 with SMTP id y78so13625216qgd.0
        for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2015 17:22:06 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am writing a netfilter module to process outgoing packets
(NF_INET_POST_ROUTING) and modify them according to certain rules. In
the current version, I am just trying to push the same VLAN tag on
every outgoing pkt.
However, after running for a few seconds at ~1Gbps, it crashes with
kernel panic. Also, I see similar crash, when I don't modify the pkt,
i.e. I create a copy and send it. Am I missing something when using
skb_alloc()? What can I do next to debug this issue?

------------------------------------------
Log:
------------------------------------------

      KERNEL: /usr/lib/debug/boot/vmlinux-3.13.0-32-generic
    DUMPFILE: dump.201505121934  [PARTIAL DUMP]
        CPUS: 4
        DATE: Tue May 12 19:34:18 2015
      UPTIME: 00:22:08
LOAD AVERAGE: 1.95, 1.34, 0.64
       TASKS: 752
     RELEASE: 3.13.0-32-generic
     VERSION: #57-Ubuntu SMP Tue Jul 15 03:51:08 UTC 2014
     MACHINE: x86_64  (2699 Mhz)
      MEMORY: 4 GB
       PANIC: ""
         PID: 6186
     COMMAND: "client"
        TASK: ffff88009e5017f0  [THREAD_INFO: ffff88009b20e000]
         CPU: 1
       STATE: TASK_RUNNING (PANIC)

crash> bt
PID: 6186   TASK: ffff88009e5017f0  CPU: 1   COMMAND: "client"
 #0 [ffff88013fc83610] machine_kexec at ffffffff8104a742
 #1 [ffff88013fc83660] crash_kexec at ffffffff810e6cf3
 #2 [ffff88013fc83728] oops_end at ffffffff817251a8
 #3 [ffff88013fc83750] die at ffffffff810171db
 #4 [ffff88013fc83780] do_general_protection at ffffffff81724ace
 #5 [ffff88013fc837b0] general_protection at ffffffff817243e8
    [exception RIP: __kmalloc_node_track_caller+371]
    RIP: ffffffff811a4383  RSP: ffff88013fc83860  RFLAGS: 00010246
    RAX: 0000000000000000  RBX: ffff88009f62b500  RCX: 00000000013656da
    RDX: 00000000013656d9  RSI: 0000000000000000  RDI: 00000000000172c0
    RBP: ffff88013fc838a8   R8: ffff88013fc972c0   R9: ffff88013b001400
    R10: ffff88013b001400  R11: 0000000000000000  R12: 0000000000010220
    R13: 0000000000000740  R14: 5452d00923005452  R15: 00000000ffffffff
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #6 [ffff88013fc83860] sch_direct_xmit at ffffffff81640cdf
 #7 [ffff88013fc838b0] __kmalloc_reserve at ffffffff816104f1
 #8 [ffff88013fc838f0] __alloc_skb at ffffffff81610e7e
 #9 [ffff88013fc83938] process_pkt_post_routing at ffffffffa0295a74 [modmerlin]
#10 [ffff88013fc839b8] nf_iterate at ffffffff8164faba
#11 [ffff88013fc83a00] nf_hook_slow at ffffffff8164fb44
#12 [ffff88013fc83a68] ip_output at ffffffff8165bf02
#13 [ffff88013fc83a88] ip_local_out at ffffffff8165b635
#14 [ffff88013fc83aa0] ip_queue_xmit at ffffffff8165b98d
#15 [ffff88013fc83ad8] tcp_transmit_skb at ffffffff81672749
#16 [ffff88013fc83b40] tcp_write_xmit at ffffffff81672cf0
#17 [ffff88013fc83ba8] __tcp_push_pending_frames at ffffffff8167391e
#18 [ffff88013fc83bc0] tcp_rcv_established at ffffffff8166f2bf
#19 [ffff88013fc83c08] tcp_v4_do_rcv at ffffffff81679185
#20 [ffff88013fc83c78] tcp_v4_rcv at ffffffff8167b590
#21 [ffff88013fc83cf0] ip_local_deliver_finish at ffffffff81656328
#22 [ffff88013fc83d18] ip_local_deliver at ffffffff81656628
#23 [ffff88013fc83d38] ip_rcv_finish at ffffffff81655fad
#24 [ffff88013fc83d60] ip_rcv at ffffffff816568f8
#25 [ffff88013fc83d90] __netif_receive_skb_core at ffffffff81620366
#26 [ffff88013fc83de8] __netif_receive_skb at ffffffff81620558
#27 [ffff88013fc83e08] netif_receive_skb at ffffffff816205c3
#28 [ffff88013fc83e30] virtnet_poll at ffffffff81526384
#29 [ffff88013fc83eb0] net_rx_action at ffffffff81620942
#30 [ffff88013fc83f08] __do_softirq at ffffffff8106cafc
#31 [ffff88013fc83f68] irq_exit at ffffffff8106d045
#32 [ffff88013fc83f80] do_IRQ at ffffffff8172e996
--- <IRQ stack> ---
#33 [ffff88009b20fbb8] ret_from_intr at ffffffff8172412d
    [exception RIP: __copy_user_nocache+96]
    RIP: ffffffff8136d320  RSP: ffff88009b20fc60  RFLAGS: 00000206
    RAX: 0000000000000000  RBX: ffff8800a16c3800  RCX: 000000000000000c
    RDX: 0000000000000014  RSI: 0000000001444890  RDI: ffff8800a00663b0
    RBP: ffff88009b20fd18   R8: 74737271706f6e6d   R9: 31307a7978777675
    R10: 3938373635343332  R11: 6c6b6a6968676665  R12: 00000000ffffffff
    R13: 00000000000000d0  R14: ffff8800a16c3800  R15: ffff88013b001600
    ORIG_RAX: ffffffffffffff7c  CS: 0010  SS: 0018
#34 [ffff88009b20fc60] tcp_sendmsg at ffffffff81665296
#35 [ffff88009b20fd20] inet_sendmsg at ffffffff8168e8f4
#36 [ffff88009b20fd50] sock_sendmsg at ffffffff816079eb
#37 [ffff88009b20fe58] SYSC_sendto at ffffffff81607b91
#38 [ffff88009b20ff70] sys_sendto at ffffffff816086ae
#39 [ffff88009b20ff80] tracesys at ffffffff8172c87f (via system_call)
    RIP: 00007ff3166a403d  RSP: 00007fff6b95f828  RFLAGS: 00000246
    RAX: ffffffffffffffda  RBX: ffffffff8172c87f  RCX: ffffffffffffffff
    RDX: 0000000000000e10  RSI: 0000000001444010  RDI: 0000000000000003
    RBP: 00007fff6b95fa90   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffff816086ae
    R13: ffff88009b20ff78  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: 000000000000002c  CS: 0033  SS: 002b


------------------------------------------
Code:
------------------------------------------

static unsigned int post_routing_process(const struct nf_hook_ops *ops,
        struct sk_buff *skb,
        const struct net_device *in,
        const struct net_device *out
        /*, int (*okfn)(struct sk_buff *)) */
)
{
    struct ethhdr *eth_hdr;
    __be16 proto;
    struct iphdr *ip_hdr;
    struct iphdr *ip_hdr2;
    char* ip_pkt;
    char* ip_pkt2;
    int ip_pkt_len;
    int ip_pkt_len2;
    struct sk_buff *skb2 = NULL;
    struct flow_keys flow_key;
    int eth_hdr_len, full_pkt_len, ip_hdr_len;
    void *saddr;
    void *daddr;

    struct stack stk;

    u_int16_t tag11[] = {11};

    __wsum skb2_csum = 0;
    unsigned char dst[] = {0xFF,0xFF,0xFF,0xFF,0xFF,0xFF};

    pr_debug("Packet in ++++++++\n");

    if(skb_is_nonlinear(skb)){
        pr_debug("Proces_pkt: Still non-linear skb.\n");
        goto cleanup;
    }

    proto = ntohs(skb->protocol);
    switch (proto) {
        case ETH_P_IP:
            eth_hdr = (struct ethhdr *)skb_mac_header(skb); // need to set
            // proto is set; h_proto isn't
            pr_debug("Proto: %04x %04x\n", ntohs(eth_hdr->h_proto), proto);

            ip_hdr = (struct iphdr *)skb_network_header(skb);
            ip_hdr_len = ip_hdrlen(skb);
            ip_pkt = (char*)ip_hdr;
            ip_pkt_len = ntohs(ip_hdr->tot_len);
            skb_flow_dissect(skb, &flow_key);

            /* struct stk {int num_tags; u_int16_t tags[]; }; */
            stk.num_tags = 1;
            stk.tags = tag11;
            eth_hdr_len = ETH_HLEN + stk.num_tags * sizeof(vlan_label);
            full_pkt_len = eth_hdr_len + ip_pkt_len;
            pr_debug("Full length: %d", full_pkt_len);

            skb2 = alloc_skb(full_pkt_len, GFP_ATOMIC);

            if (skb2 == NULL) {
                goto cleanup;
            }
            if(skb->sk != NULL) {
                skb_set_owner_w(skb2, skb->sk);
            }
            else{
                goto cleanup;
            }

            pr_debug("mod_vlan: skb2 - Reserving header\n");
            skb_reserve(skb2, eth_hdr_len);

            // Copy IP packet
            pr_debug("mod_vlan: copying IP pkt.\n");
            if (!(ip_pkt2 = skb_put(skb2, ip_pkt_len))) {
                pr_debug("skb_put failed!\n");
                goto cleanup;
            }
            skb_reset_network_header(skb2);
            memcpy(ip_pkt2, ip_pkt, ip_pkt_len);
            ip_hdr2 = (struct iphdr *)(ip_pkt2);
            ip_pkt_len2 = ntohs(ip_hdr2->tot_len);

            skb2_csum = fix_csum(ip_hdr2);

            // Set VLAN stack
            if(set_vlan_stack(skb2, &stk)){
                proto = ETH_P_8021Q;
            }

            // Get outgoing interface
            skb2->dev = dev_get_by_name(&init_net,out->name);
            if (!skb2->dev) {
                pr_debug("mod_vlan dev_get_by_name (%s) FAILED.", out->name);
                goto cleanup;
            }

            saddr = skb2->dev->dev_addr;
            daddr = dst;

            // ARP Lookup
            if(0 == get_dst_haddr(daddr, flow_key.dst, skb2->dev)){
                pr_debug("ARP lookup - success!\n");
            }

            pr_debug("calling dev_hard_header\n");
            if (dev_hard_header(skb2, skb2->dev, proto,
                        daddr, saddr, skb2->dev->addr_len) < 0) {
                pr_debug("mod_vlan dev_hard_header FAILED.\n");
                goto cleanup;
            }
            pr_debug("Resetting mac header\n");
            skb_reset_mac_header(skb2);
            pr_debug("mod_vlan dev_hard_header SUCCESS.\n");

            // Set skb checksum
            skb2->csum = skb2_csum;

            // Send out packet
            pr_debug("mod_vlan: sending skb2....\n");
            if (dev_queue_xmit(skb2) != NET_XMIT_SUCCESS) {
                pr_debug("mod_vlan dev_queue_xmit failed.");
                goto cleanup;
            }
            kfree_skb(skb);
            return NF_STOLEN;
            break;
        default:
            pr_debug("Proto: Non-IP pkt\n");
            break;
    }
cleanup:
    if(skb2)   kfree_skb(skb2);
    if(skb) kfree_skb(skb);
    return NF_STOLEN;
}



Thanks,
Praveen
