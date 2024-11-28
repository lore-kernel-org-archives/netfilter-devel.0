Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF32195385;
	Thu, 28 Nov 2024 12:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732797532; cv=none; b=DaVNqCi6ewURVlSMgTc2O/vdC66shTteMdD/RDhmw2YylY5d/sqKYN/omB7Epew1MEcryRRX8AXEdddthrP3Qd14NSMTpmis2MTf3yZsYpt71ZBTBa0mP/Bdy+Wrp7W6yjiZfCCVWFiqXkLpuMT0MDyfn6ZQuLq6bIVJPZg9phw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732797532; c=relaxed/simple;
	bh=rl6K2qrpxyJybEOdvULFU5pYulet5pDFonGnFQj0GuE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V+/U0ytvHpEbjjQUtPMb2bremEjZyuFTedtUdmzIN0ck1er1mRRka7d/OCcUYQ0xd8WayQfNNXJKJo4Rg1U+hflyUtl5uqOu7sG9bij0MrGtZaDQCRPMQJsifBLlbF/XMDPj6AEQPDOJSZWCrijrDXL8OPAxqfMW9Du6lEjXkjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 1/4] ipvs: fix UB due to uninitialized stack access in ip_vs_protocol_init()
Date: Thu, 28 Nov 2024 13:38:37 +0100
Message-Id: <20241128123840.49034-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241128123840.49034-1-pablo@netfilter.org>
References: <20241128123840.49034-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jinghao Jia <jinghao7@illinois.edu>

Under certain kernel configurations when building with Clang/LLVM, the
compiler does not generate a return or jump as the terminator
instruction for ip_vs_protocol_init(), triggering the following objtool
warning during build time:

  vmlinux.o: warning: objtool: ip_vs_protocol_init() falls through to next function __initstub__kmod_ip_vs_rr__935_123_ip_vs_rr_init6()

At runtime, this either causes an oops when trying to load the ipvs
module or a boot-time panic if ipvs is built-in. This same issue has
been reported by the Intel kernel test robot previously.

Digging deeper into both LLVM and the kernel code reveals this to be a
undefined behavior problem. ip_vs_protocol_init() uses a on-stack buffer
of 64 chars to store the registered protocol names and leaves it
uninitialized after definition. The function calls strnlen() when
concatenating protocol names into the buffer. With CONFIG_FORTIFY_SOURCE
strnlen() performs an extra step to check whether the last byte of the
input char buffer is a null character (commit 3009f891bb9f ("fortify:
Allow strlen() and strnlen() to pass compile-time known lengths")).
This, together with possibly other configurations, cause the following
IR to be generated:

  define hidden i32 @ip_vs_protocol_init() local_unnamed_addr #5 section ".init.text" align 16 !kcfi_type !29 {
    %1 = alloca [64 x i8], align 16
    ...

  14:                                               ; preds = %11
    %15 = getelementptr inbounds i8, ptr %1, i64 63
    %16 = load i8, ptr %15, align 1
    %17 = tail call i1 @llvm.is.constant.i8(i8 %16)
    %18 = icmp eq i8 %16, 0
    %19 = select i1 %17, i1 %18, i1 false
    br i1 %19, label %20, label %23

  20:                                               ; preds = %14
    %21 = call i64 @strlen(ptr noundef nonnull dereferenceable(1) %1) #23
    ...

  23:                                               ; preds = %14, %11, %20
    %24 = call i64 @strnlen(ptr noundef nonnull dereferenceable(1) %1, i64 noundef 64) #24
    ...
  }

The above code calculates the address of the last char in the buffer
(value %15) and then loads from it (value %16). Because the buffer is
never initialized, the LLVM GVN pass marks value %16 as undefined:

  %13 = getelementptr inbounds i8, ptr %1, i64 63
  br i1 undef, label %14, label %17

This gives later passes (SCCP, in particular) more DCE opportunities by
propagating the undef value further, and eventually removes everything
after the load on the uninitialized stack location:

  define hidden i32 @ip_vs_protocol_init() local_unnamed_addr #0 section ".init.text" align 16 !kcfi_type !11 {
    %1 = alloca [64 x i8], align 16
    ...

  12:                                               ; preds = %11
    %13 = getelementptr inbounds i8, ptr %1, i64 63
    unreachable
  }

In this way, the generated native code will just fall through to the
next function, as LLVM does not generate any code for the unreachable IR
instruction and leaves the function without a terminator.

Zero the on-stack buffer to avoid this possible UB.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202402100205.PWXIz1ZK-lkp@intel.com/
Co-developed-by: Ruowen Qin <ruqin@redhat.com>
Signed-off-by: Ruowen Qin <ruqin@redhat.com>
Signed-off-by: Jinghao Jia <jinghao7@illinois.edu>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_proto.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_proto.c b/net/netfilter/ipvs/ip_vs_proto.c
index f100da4ba3bc..a9fd1d3fc2cb 100644
--- a/net/netfilter/ipvs/ip_vs_proto.c
+++ b/net/netfilter/ipvs/ip_vs_proto.c
@@ -340,7 +340,7 @@ void __net_exit ip_vs_protocol_net_cleanup(struct netns_ipvs *ipvs)
 
 int __init ip_vs_protocol_init(void)
 {
-	char protocols[64];
+	char protocols[64] = { 0 };
 #define REGISTER_PROTOCOL(p)			\
 	do {					\
 		register_ip_vs_protocol(p);	\
@@ -348,8 +348,6 @@ int __init ip_vs_protocol_init(void)
 		strcat(protocols, (p)->name);	\
 	} while (0)
 
-	protocols[0] = '\0';
-	protocols[2] = '\0';
 #ifdef CONFIG_IP_VS_PROTO_TCP
 	REGISTER_PROTOCOL(&ip_vs_protocol_tcp);
 #endif
-- 
2.30.2

