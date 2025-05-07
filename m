Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B01521D3DF;
	Wed,  7 May 2025 22:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746656411; cv=none; b=HKB8kLKopkrYeH6d4cn3voPYnJXPYnL+y7e97pITHUsw+t3M1tuHtqEPlYMPLHZaVWprWK1ratdV4NJ4DcNcsmk6vtUhR5Itm4LV2mMbKRXQaX70jr4CKSPrHT5XlRy3XEqSaAuXOcY6dJmhsSspTy6doZRnihM7fpH3MBtrrsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746656411; c=relaxed/simple;
	bh=cwuCnw7YghsVOajxCRJES3ubzE5EKbh1HOU/FXrjF1Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M2jZP54Zsa2MdE7mujiTM1KBBtG4c4yqnSS74srVZPmz5bFnXQ+vcxdiv2cHcUgzArH4W38JzfvHeWw9TO6DTosIX52yAn4JoVSDRb/KzHFubRCIZZ4i0myDLw3p4c3P3DMfvwhHyelP+0D4WJqFLKQpk6gRojE5fwpNUfEpK2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=A7Ipv4c/; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ttLd9M3/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="A7Ipv4c/";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ttLd9M3/"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 42A65602D1; Thu,  8 May 2025 00:20:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746656401;
	bh=eZczpkk2vaIsJ8tQ6aBRYFvw1ArY//REQAgdcNTEEMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A7Ipv4c/UprJLhEwl/rsna6vfzSVEOHf7p8A09SBX4/Oni301qLl+9FORvXPX05Ye
	 TcnQzW2rlIJ07js4dg/gclA33lKN44VJ7tER8Oo2if0mQlAfz+EtU/jHL6XvPWV+q5
	 0YVZABAHdICBIfcwTZKEwIWk8REdmCAsyps52a3rrm8HnTuFCQENifxV5PTa5d9chz
	 H5mOaVcJJK46cyFcVHoHoA0NiM5vdmhPwMayEulOchnTFls57g8Tt3Wz3ooKrnRLGt
	 wx5OersTulEW4ptj3IEiJuguSYr89em4Jx4/xUWDHvlb1i2LusoyTYvXpBbobgwzwX
	 2UYwOAuc98QlA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 330E8602C6;
	Thu,  8 May 2025 00:19:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746656398;
	bh=eZczpkk2vaIsJ8tQ6aBRYFvw1ArY//REQAgdcNTEEMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ttLd9M3/TVAvPDC0MXJXyvMyxTK6JwQyXzyQwah5vXNOJ8khrBDRqmIIRTTtUZsN2
	 knbY6Ax2d/ZTpy5sA2ziDMEzaWs0ftVJpW23UsWBEvm4I4dmaVGQIO/vQbtN2w9q5o
	 2CRPNCLbXUr0F/8XhQ+rBoyUJ4EZKsU2uylA6YCAgG2e61y33BLIrpZI9ZQxHjsHLx
	 9VJcX9OajRn43awnBjfWo0vTWdZIgIKkTxHcnwknVgTmZlExXyI7m8GaobqM9LaL6g
	 YLp2kmM80x6QzmhRlUAz6DQFssZ34WE5D9SXoSCTrQrgD1u+qyB/18u/nir1dXotRd
	 DrdkKunkThtMA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 1/2] ipvs: fix uninit-value for saddr in do_output_route4
Date: Thu,  8 May 2025 00:19:51 +0200
Message-Id: <20250507221952.86505-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250507221952.86505-1-pablo@netfilter.org>
References: <20250507221952.86505-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

syzbot reports for uninit-value for the saddr argument [1].
commit 4754957f04f5 ("ipvs: do not use random local source address for
tunnels") already implies that the input value of saddr
should be ignored but the code is still reading it which can prevent
to connect the route. Fix it by changing the argument to ret_saddr.

[1]
BUG: KMSAN: uninit-value in do_output_route4+0x42c/0x4d0 net/netfilter/ipvs/ip_vs_xmit.c:147
 do_output_route4+0x42c/0x4d0 net/netfilter/ipvs/ip_vs_xmit.c:147
 __ip_vs_get_out_rt+0x403/0x21d0 net/netfilter/ipvs/ip_vs_xmit.c:330
 ip_vs_tunnel_xmit+0x205/0x2380 net/netfilter/ipvs/ip_vs_xmit.c:1136
 ip_vs_in_hook+0x1aa5/0x35b0 net/netfilter/ipvs/ip_vs_core.c:2063
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xf7/0x400 net/netfilter/core.c:626
 nf_hook include/linux/netfilter.h:269 [inline]
 __ip_local_out+0x758/0x7e0 net/ipv4/ip_output.c:118
 ip_local_out net/ipv4/ip_output.c:127 [inline]
 ip_send_skb+0x6a/0x3c0 net/ipv4/ip_output.c:1501
 udp_send_skb+0xfda/0x1b70 net/ipv4/udp.c:1195
 udp_sendmsg+0x2fe3/0x33c0 net/ipv4/udp.c:1483
 inet_sendmsg+0x1fc/0x280 net/ipv4/af_inet.c:851
 sock_sendmsg_nosec net/socket.c:712 [inline]
 __sock_sendmsg+0x267/0x380 net/socket.c:727
 ____sys_sendmsg+0x91b/0xda0 net/socket.c:2566
 ___sys_sendmsg+0x28d/0x3c0 net/socket.c:2620
 __sys_sendmmsg+0x41d/0x880 net/socket.c:2702
 __compat_sys_sendmmsg net/compat.c:360 [inline]
 __do_compat_sys_sendmmsg net/compat.c:367 [inline]
 __se_compat_sys_sendmmsg net/compat.c:364 [inline]
 __ia32_compat_sys_sendmmsg+0xc8/0x140 net/compat.c:364
 ia32_sys_call+0x3ffa/0x41f0 arch/x86/include/generated/asm/syscalls_32.h:346
 do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
 __do_fast_syscall_32+0xb0/0x110 arch/x86/entry/syscall_32.c:306
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/syscall_32.c:331
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/syscall_32.c:369
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:4167 [inline]
 slab_alloc_node mm/slub.c:4210 [inline]
 __kmalloc_cache_noprof+0x8fa/0xe00 mm/slub.c:4367
 kmalloc_noprof include/linux/slab.h:905 [inline]
 ip_vs_dest_dst_alloc net/netfilter/ipvs/ip_vs_xmit.c:61 [inline]
 __ip_vs_get_out_rt+0x35d/0x21d0 net/netfilter/ipvs/ip_vs_xmit.c:323
 ip_vs_tunnel_xmit+0x205/0x2380 net/netfilter/ipvs/ip_vs_xmit.c:1136
 ip_vs_in_hook+0x1aa5/0x35b0 net/netfilter/ipvs/ip_vs_core.c:2063
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xf7/0x400 net/netfilter/core.c:626
 nf_hook include/linux/netfilter.h:269 [inline]
 __ip_local_out+0x758/0x7e0 net/ipv4/ip_output.c:118
 ip_local_out net/ipv4/ip_output.c:127 [inline]
 ip_send_skb+0x6a/0x3c0 net/ipv4/ip_output.c:1501
 udp_send_skb+0xfda/0x1b70 net/ipv4/udp.c:1195
 udp_sendmsg+0x2fe3/0x33c0 net/ipv4/udp.c:1483
 inet_sendmsg+0x1fc/0x280 net/ipv4/af_inet.c:851
 sock_sendmsg_nosec net/socket.c:712 [inline]
 __sock_sendmsg+0x267/0x380 net/socket.c:727
 ____sys_sendmsg+0x91b/0xda0 net/socket.c:2566
 ___sys_sendmsg+0x28d/0x3c0 net/socket.c:2620
 __sys_sendmmsg+0x41d/0x880 net/socket.c:2702
 __compat_sys_sendmmsg net/compat.c:360 [inline]
 __do_compat_sys_sendmmsg net/compat.c:367 [inline]
 __se_compat_sys_sendmmsg net/compat.c:364 [inline]
 __ia32_compat_sys_sendmmsg+0xc8/0x140 net/compat.c:364
 ia32_sys_call+0x3ffa/0x41f0 arch/x86/include/generated/asm/syscalls_32.h:346
 do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
 __do_fast_syscall_32+0xb0/0x110 arch/x86/entry/syscall_32.c:306
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/syscall_32.c:331
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/syscall_32.c:369
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

CPU: 0 UID: 0 PID: 22408 Comm: syz.4.5165 Not tainted 6.15.0-rc3-syzkaller-00019-gbc3372351d0c #0 PREEMPT(undef)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025

Reported-by: syzbot+04b9a82855c8aed20860@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/68138dfa.050a0220.14dd7d.0017.GAE@google.com/
Fixes: 4754957f04f5 ("ipvs: do not use random local source address for tunnels")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_xmit.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 3313bceb6cc9..014f07740369 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -119,13 +119,12 @@ __mtu_check_toobig_v6(const struct sk_buff *skb, u32 mtu)
 	return false;
 }
 
-/* Get route to daddr, update *saddr, optionally bind route to saddr */
+/* Get route to daddr, optionally bind route to saddr */
 static struct rtable *do_output_route4(struct net *net, __be32 daddr,
-				       int rt_mode, __be32 *saddr)
+				       int rt_mode, __be32 *ret_saddr)
 {
 	struct flowi4 fl4;
 	struct rtable *rt;
-	bool loop = false;
 
 	memset(&fl4, 0, sizeof(fl4));
 	fl4.daddr = daddr;
@@ -135,23 +134,17 @@ static struct rtable *do_output_route4(struct net *net, __be32 daddr,
 retry:
 	rt = ip_route_output_key(net, &fl4);
 	if (IS_ERR(rt)) {
-		/* Invalid saddr ? */
-		if (PTR_ERR(rt) == -EINVAL && *saddr &&
-		    rt_mode & IP_VS_RT_MODE_CONNECT && !loop) {
-			*saddr = 0;
-			flowi4_update_output(&fl4, 0, daddr, 0);
-			goto retry;
-		}
 		IP_VS_DBG_RL("ip_route_output error, dest: %pI4\n", &daddr);
 		return NULL;
-	} else if (!*saddr && rt_mode & IP_VS_RT_MODE_CONNECT && fl4.saddr) {
+	}
+	if (rt_mode & IP_VS_RT_MODE_CONNECT && fl4.saddr) {
 		ip_rt_put(rt);
-		*saddr = fl4.saddr;
 		flowi4_update_output(&fl4, 0, daddr, fl4.saddr);
-		loop = true;
+		rt_mode = 0;
 		goto retry;
 	}
-	*saddr = fl4.saddr;
+	if (ret_saddr)
+		*ret_saddr = fl4.saddr;
 	return rt;
 }
 
@@ -344,19 +337,15 @@ __ip_vs_get_out_rt(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 		if (ret_saddr)
 			*ret_saddr = dest_dst->dst_saddr.ip;
 	} else {
-		__be32 saddr = htonl(INADDR_ANY);
-
 		noref = 0;
 
 		/* For such unconfigured boxes avoid many route lookups
 		 * for performance reasons because we do not remember saddr
 		 */
 		rt_mode &= ~IP_VS_RT_MODE_CONNECT;
-		rt = do_output_route4(net, daddr, rt_mode, &saddr);
+		rt = do_output_route4(net, daddr, rt_mode, ret_saddr);
 		if (!rt)
 			goto err_unreach;
-		if (ret_saddr)
-			*ret_saddr = saddr;
 	}
 
 	local = (rt->rt_flags & RTCF_LOCAL) ? 1 : 0;
-- 
2.30.2

