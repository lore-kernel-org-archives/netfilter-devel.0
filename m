Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793787280;
	b=4jcMKKDw6cczcUa3CS18XQalDJTDsxFczEPULm+ndUVECPagwXHg+nmfC2meRiL3iW8c
	 YsrWRxYxlkMtGYUazGtyzsmLo37yeVL1fExGLkKoQCePAwYz7XWtrGlckbcNGRRAAWh+x
	 2jezpy2wIwXnRhQxGyVwxIN4bCYmtK144ppAum5Yrm4PweH4Ew6BBa9gyh/PiAjBJzc21
	 F8ZjyaT0kwR5jKhBEUen1zUqfp7R6OpoQxiPljYQapbu4sqy71lWLayaZcbFwFdgPEahZ
	 pcoHkx7ROvJcKc7lDzfTne67lNrQgxIpw5fT8uL7V/uiraSoQuI5CzezRxuTsvkWPaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793787280;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=JFuvjpFgpIgnI/buX16Ja3+yga1xnT/9led9URms74U=;
	b=owMQkPMjyuQbKcH45EToZ2+o1GYquWcudiKLFbZO238KY34Eo9X4rmULWism4d4SCzeE
	 KiMlx4kdIVuYImUepsReF3ta5vxXUFOe/5l3gIFQHWzjgkigWqixGrxrPG1+zW5zpVEXK
	 5Rr/7ntqaI6hV3L4mc0BA5RwCUk0FbaaOkzAK1NmF/X2QEO2dC/4WdapVguI9Blr42v0u
	 CYYQBvhSWfk9kwS2o0zDi1bmD2AUmcdWJC1WMLfWAMXAByh5TeG4S6Ezc0UqjGY14FAVY
	 wYX/n193nCTs7DNdmXfypOHBJ8w3Di2/M/BN/hpwKzWRZKI7KdrhqvIfsMHyiwzUK4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=anby1nHA;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 4B997606A31B;
	Wed,  4 Nov 2026 10:14:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B997606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=anby1nHA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793787276;
	bh=JFuvjpFgpIgnI/buX16Ja3+yga1xnT/9led9URms74U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=anby1nHAVv6SWDDgHRf1GgPFV3ukJ5S8ugvVTkHAkjIpeilqB+6ou0smubfTGkqTq
	 vzBD+GhIyvIb1MDGInLXxr33WUZ85ZnnQ3djVQeibS3VPpRL3QLzhanpMLLEKvYZmq
	 nxBaYmmrTuN7bv1TU06pt5U4jC7CxQNG7OzA5xhyZqoJHU5BdzOD4rqyb46/322IEm
	 HNKor1ceHvPoyQ27iB06ye96JoSBjdPtZIYIZh5HtSI9cLTmy9Z8IbZOTKZBgueaL5
	 7yeAg391vFXwLR3FNwVmlCGzG6Tzu/4jGHb5qfYnf64liEPOzDZ/RtNlNeyprNG0oC
	 xk2MG2U3W3QoA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 63B3B6005D;
	Wed,  4 Nov 2026 11:14:36 +0100 (CET)
Date: Wed, 4 Nov 2026 11:14:34 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Muhammad Zuhayr al-Tayyar <mzuhayr@earthlink.iq>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [BUG] netfilter: nf_tables: hw-offloaded flowtable entries leak
 when the flowtable is deleted (UNBIND at commit, DESTROY at release)
Message-ID: <ausFiqLdZGbCZRDX@chamomile>
References: <AM0PR02MB4307BD45EE715C8B94EE3E6AC6682@AM0PR02MB4307.eurprd02.prod.outlook.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AM0PR02MB4307BD45EE715C8B94EE3E6AC6682@AM0PR02MB4307.eurprd02.prod.outlook.com>

Hi,

On Wed, Nov 04, 2026 at 10:07:51AM +0000, Muhammad Zuhayr al-Tayyar wrote:
> Hi,
>  
> When a flowtable with "flags offload" is deleted (nft flush ruleset,
> deleting the table/flowtable, or loading a ruleset that starts with
> "flush ruleset"), the hardware entries of connections that are offloaded
> at that moment are never removed from the NIC. The NIC keeps forwarding
> those connections with no ruleset loaded. For a firewall this means that
> replacing or removing the ruleset does not stop already offloaded
> connections.

Thanks, this bugs has been already reported 3 times in the last two
weeks.

I posted an alternative patch which is not yet covering all cases.

This is on my radar.

> Environment
> -----------
> - NIC:     NVIDIA ConnectX-6 Dx, in-tree mlx5_core, firmware 22.36.1010
>            (DEL0000000027), eswitch switchdev, flow_steering_mode smfs
> - Kernel:  AlmaLinux 10.2, 6.12.0-211.69.1.el10_2.x86_64 (distribution
>            kernel with backports; behaves like current mainline here)
> - nft:     flowtable "flags offload" on two VLAN subinterfaces of the
>            uplink (indirect block, mlx5e_rep_indr_setup_ft_cb); traffic
>            routed between the two VLANs
> - Note:    on mlx5 a separate driver bug keeps flowtable rules from being
>            hit until a chain-0 tc rule with prio >= 2 exists (reported
>            separately to netdev). For this test I added and removed such a
>            rule first:
>              tc qdisc add dev <uplink> ingress
>              tc filter add dev <uplink> ingress protocol ip prio 2 flower \
>                  skip_sw dst_ip 192.0.2.254 action drop
>              tc qdisc del dev <uplink> ingress
> 
> Symptom
> -------
> With a TCP transfer offloaded ([HW_OFFLOAD], uplink rx_packets ~20 pps vs
> rx_packets_phy ~19k pps), I ran "nft flush ruleset". Afterwards:
> - the transfer continues and is still hardware-forwarded (rx_packets
>   ~20 pps, rx_packets_phy ~19k pps), with NO ruleset loaded;
> - the conntrack entry shows [ASSURED] (no longer offloaded), its counters
>   are frozen and its timeout only counts down, because no packet of the
>   connection reaches the kernel;
> - "devlink dev eswitch set pci/<BDF> mode legacy" fails with
>   "Can't change mode, E-Switch is busy" (mlx5 still counts the leaked
>   rules in esw->user_count);
> - the entries stay until reboot. After "devlink dev reload ... action
>   driver_reinit" the rules are gone from the NIC, but the eswitch still
>   refuses mode changes ("busy") until a reboot;
> - the mlx5 SW steering dump (/sys/kernel/debug/mlx5/<BDF>/steering/fdb/)
>   still shows the two flow rules of the connection after the flush.
> 
>   Dump taken after "nft flush ruleset" (nft list ruleset is empty),
>   decoded with a small local script:
>     192.168.1.10:22 -> 192.168.2.10:41234 tcp  pop-vlan, set-dmac,
>         set-smac, counter, -> FW table 0xf (VLAN push + out)
>     192.168.2.10:41234 -> 192.168.1.10:22 tcp  pop-vlan, set-dmac,
>         set-smac, counter, -> FW table 0x10 (VLAN push + out)
>   Raw rule entries (match on 192.168.1.10/192.168.2.10, ports 22/41234,
>   tcp):
>     3303,0xf000004c,0x6ac5e1e0,...c0a8010ac0a8020a0016a11200000006
>     3303,0xf000004f,0x6ac5e660,...c0a8020ac0a8010aa112001600000006
> 
> Trace
> -----
> From an earlier run of the same setup: function_graph on
> nf_tables_flowtable_destroy, nf_flow_table_free,
> nf_flow_table_offload_setup and flow_offload_work_handler
> (funcgraph-retval, funcgraph-abstime), plus the mlx5:mlx5e_delete_flower
> event.
> 
> At load, BIND succeeds for both devices, and FLOW_CLS_REPLACE reaches the
> driver callbacks:
>   841.635738 | 15)  nf_flow_table_offload_setup [nf_flow_table]() {
>   841.635751 | 15)    } /* flow_indr_dev_setup_offload = 0x1 */
>   841.636970 |  3)      nf_flow_offload_tuple [nf_flow_table]() {
>   841.636972 |  3)        mlx5e_rep_indr_setup_ft_cb [mlx5_core]() {
>   841.637029 |  3)        } /* mlx5e_rep_indr_setup_ft_cb = -95 */  (other device)
>   841.637030 |  3)        mlx5e_rep_indr_setup_ft_cb [mlx5_core]() {
>   841.637729 |  3)        } /* mlx5e_rep_indr_setup_ft_cb = 0x0 */
>   841.637730 |  3)      } /* nf_flow_offload_tuple [nf_flow_table] = 0x1 */
> 
> At "nft flush ruleset", the release path runs and the DESTROY work finds
> no callbacks:
>   847.435723 | 23)  nf_tables_flowtable_destroy [nf_tables]() {
>   847.435724 | 23)    nf_flow_table_free [nf_flow_table]() {
>   847.435852 | 16)  flow_offload_work_handler [nf_flow_table]() {
>   847.435853 | 16)    nf_flow_offload_tuple [nf_flow_table]() {
>   847.435855 | 16)    } /* nf_flow_offload_tuple = 0x0 */  <- no driver callback
>   847.435855 | 16)    nf_flow_offload_tuple [nf_flow_table]() {
>   847.435857 | 16)    } /* nf_flow_offload_tuple = 0x0 */
>   847.435859 | 16)  } /* flow_offload_work_handler [nf_flow_table] = 0x0 */
>   847.435926 | 23)    } /* nf_flow_table_free [nf_flow_table] = ... */
>   847.435938 | 23)  } /* nf_tables_flowtable_destroy [nf_tables] = 0x0 */
> - No nf_flow_table_offload_setup(UNBIND) call inside
>   nf_tables_flowtable_destroy(); the unbind had already happened at commit.
> - mlx5e_delete_flower events: 0.
> 
> Control experiment: with the flowtable left in place, "conntrack -D" on the
> offloaded connection makes mlx5e_delete_flower fire twice (original +
> reply), and the hardware entries are removed correctly.
> 
> Analysis (mainline)
> -------------------
> - When NFT_MSG_DELFLOWTABLE is committed, the kernel calls
>   nft_unregister_flowtable_net_hooks() -> nft_unregister_flowtable_ops(),
>   which does nf_unregister_net_hook() and then
>   data.type->setup(..., FLOW_BLOCK_UNBIND).
> - FLOW_BLOCK_UNBIND only frees the flow_block_cb entries
>   (nf_flow_table_block_setup()). It does not remove offloaded flows.
> - Later the release path calls nf_tables_flowtable_destroy() ->
>   data.type->free() = nf_flow_table_free(). That tears the flows down and
>   queues FLOW_CLS_DESTROY through nf_flow_offload_tuple() over
>   flowtable->flow_block.cb_list, which is empty by then. The hardware
>   entries leak.
> 
> Before 13210fc63f35 ("netfilter: nf_tables: imbalance in flowtable
> binding", v6.13), nf_tables_flowtable_destroy() called free() first and
> only then FLOW_BLOCK_UNBIND for each hook, so the DESTROYs were delivered
> while the callbacks were still registered. That commit moved the UNBIND
> into __nft_unregister_flowtable_net_hooks() to fix BIND/UNBIND imbalances,
> but the hardware flows are now deleted only after the callbacks are gone.
> 
> The commit was backported to the stable branches. In the stable trees,
> 6.12.10+ (6.12.9 is the last without it), 6.6.y, 6.1.y, 5.15.y and 5.10.y
> all have the UNBIND in the commit path and none in
> nf_tables_flowtable_destroy(). So every maintained kernel appears to be
> affected, including the distribution kernel I tested. The code is
> unchanged as of v7.3 and v7.4-rc1.
> 
> The same leak has been reported independently on a different driver:
> Qualcomm IPQ9570 PPE, kernel 6.18.55 (ImmortalWrt/OpenWrt,
> https://github.com/perceival/openwrt-flint3/issues/115, 2026-10-22). The
> reporter's PPE flow table filled up after a few firewall reloads and gave
> the same root cause (hooks unbound at commit before nf_flow_table_free()
> sends the DESTROYs). Their fix is local to that driver.
> 
> Proposed tag:
>   Fixes: 13210fc63f35 ("netfilter: nf_tables: imbalance in flowtable binding")
> The fix should keep that commit's balancing and only make sure the
> hardware entries are deleted before FLOW_BLOCK_UNBIND.
> 
> Possible directions:
>  (a) tear down and flush the flowtable's hardware entries before
>      FLOW_BLOCK_UNBIND in the commit path, or
>  (b) for a full flowtable deletion, keep the UNBIND in
>      nf_tables_flowtable_destroy() after free(), as in v6.12.
> 
> One way to do (a) that covers every UNBIND caller (flowtable deletion,
> removing a device from a flowtable, the NETDEV_UNREGISTER event): in
> nf_flow_table_offload_setup(), before unbinding, tear down the flows that
> use the device and wait for their DESTROY work. This is UNTESTED:
> 
> 	if (!nf_flowtable_hw_offload(flowtable))
> 		return nf_flow_offload_xdp_setup(flowtable, dev, cmd);
> 
> +	/* Remove this device's hardware entries while the driver
> +	 * callbacks are still registered.
> +	 */
> +	if (cmd == FLOW_BLOCK_UNBIND)
> +		nf_flow_table_gc_cleanup(flowtable, dev);
> +
> 	if (dev->netdev_ops->ndo_setup_tc)
> 
> nf_flow_table_gc_cleanup() already does teardown -> flush_delayed_work(gc)
> -> nf_flow_table_offload_flush(), the order established by 91bfaa15a379
> ("netfilter: flowtable: Fix hardware flush order on nf_flow_table_cleanup")
> for the netdev-down case. This only works if no caller unbinds after
> nf_flow_table_free() has destroyed the hashtable, which is true for the
> current mainline destroy path. Removing one device from an existing
> flowtable needs the same care; I have not tested that case.
> 
> Reproduction (control vs. bug, same setup, only the teardown order differs)
> --------------------------------------------------------------------------
> Minimal ruleset:
> 
>   table inet leak {
>       flowtable ft {
>           hook ingress priority 0
>           devices = { "<uplink>.2", "<uplink>.3" }
>           flags offload
>           counter
>       }
>       chain forward {
>           type filter hook forward priority 0; policy accept;
>           meta l4proto tcp ct state established flow add @ft
>       }
>   }
> 
> Control: "nft flush chain inet leak forward" (stop new offloads),
> "conntrack -D" for the offloaded connection, wait 4 s, then
> "nft flush ruleset": mlx5e_delete_flower = 2, the kernel forwards again
> (rx_packets == rx_packets_phy), eswitch mode change works.
> 
> Bug: "nft flush ruleset" directly: mlx5e_delete_flower = 0, the NIC keeps
> forwarding, eswitch busy.
> 
> Steps for the bug case:
> 1. Load the ruleset above; start a TCP transfer between the two VLANs and
>    wait until it is [HW_OFFLOAD] with rx_packets << rx_packets_phy.
> 2. nft flush ruleset
> 3. The transfer keeps running with rx_packets << rx_packets_phy. The
>    conntrack entry is [ASSURED] with frozen counters. The flow rules are
>    still in the mlx5 steering dump. devlink eswitch mode change -> EBUSY.
> 
> 
> Thanks,
> Mohammed Zuhair, Earthlink Telecommunications
