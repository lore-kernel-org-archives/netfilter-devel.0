Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA4E248F57
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2026 13:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785503930; cv=pass; b=dwLwI/E4EJFKdyfgkCrcXEwtCCpye0lcqZWkTJ1OzN1vhozGLZKLRy1OS48LsEkxT+qJKpQDwo9AjGVAkTnrXOjefbMcFN0s6Juf5yV+f4EauZezo4nM/s8Xl8q5HaJYmMZiR49ut2m7VA/2MuhBB79+7v5nXEH+Zu/ssp8+wMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785503930; c=relaxed/simple;
	bh=No1LZO0/xWGQaiEAYrYAljUhDkAED+OYsMfKkFdGXmA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=LbuSQnfy3nMiHwnK3evd6bR43IwYpY8Crvsc+nwYLXVzRhCJUm7BRl36a7EWT+y1ia6/VcIP2PJmxlv24wd0Gv8IOAy4BXo5idOpVaQYNcUZioYTbpCBB01rmYVC7wTzymBG+b/tVkiHZ+13rsZlPMLf0iS80AVkQBOgTP8Tne0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T4PeFN3U; arc=pass smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T4PeFN3U"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7e9eaf04bfaso378214a34.1
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2026 06:18:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785503928; cv=none;
        d=google.com; s=arc-20260327;
        b=cYtlHILbG8zU9RR3e98ngFXY9Gra/luvKrpkV/uqLK26K2yVgStqoxuqAavLqI6x+w
         w6mXHsj7d7kZ0yoppGbDRnyPA7eaVa0uzOwwJdS7tM1VoEKLRJsanAgoCjENXeei3S4L
         JDmVEXi/QOoRWhJ5VkJPq7M83w2feYSnK8SyB5xutmf6pHjoo1htMx96W0juyaoGxZea
         fiuFKRs5soHzx9VHr2CqgHIUfKIUgewUPpIhpt5es5uACnymMM+5cOYerrncs7m/cXBu
         ahu4DxWl6SYgRU23oYCCZD3B6lo+al2+Q5446ptwk01sy1uSW3b9apnRKpML3+Qbgr56
         lwhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=No1LZO0/xWGQaiEAYrYAljUhDkAED+OYsMfKkFdGXmA=;
        fh=bcjZt7oAdwbxaqicHOtYljCvmn7XxWpgLdGbtiZxLK8=;
        b=MTKEz9Ji0M5CpMHTyTgLr/4UUKu3WDsQW4uRwyXe+S+1MHvxu0PLT7WOrTdho4GYQs
         52HkTEGx1BlzdZmfpWc0R6+Ky1JWbuw72qOWagphtn8yKOFKUmEmvCiSgtr+1oUL7My3
         aEBWKqEBHP/+ts7jeU83/x+eZuivTNJQr8bp1ia/RQGg2cxbAWT5s5oAzoD5mbpaL3gp
         bS6B5A56tpNfUjS+Y93SPMsIbgitzeSRkNVgvwPs282tVu0KD+vvUFvZck4/AmWGSMLa
         7A3eMyGSi300IN48g2F3M3ni3+1zlTKzdJG8eGpdubjIYxmJ2Vk8MayF8c3UudoNrfhH
         Aa3w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785503928; x=1786108728; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=No1LZO0/xWGQaiEAYrYAljUhDkAED+OYsMfKkFdGXmA=;
        b=T4PeFN3U8XGk+G6x6+kAwMDU699o2JTjbnCvFXlcaY9Fn95z40SiCJvRvpJlouSg1T
         WfOUkEplNnhaNUNeufRXwA21DyoNOm/mhmV/co3YGK72OJ7AxAb7G4zSTx9dSC27msT/
         ZUKiqq1G2ZVGv8SwE6klMYvhCweCM1TiXJvjqntsiz2GAPetB/So0PBYn8QADp2fMi1w
         jh6XTHLJoqs/wTm1OoQhCGzDZ27mWAl3xZngFAWZixovpEpWTVX59lpmKfKU7KCex/lb
         utAm3j7fxRJYI2OY43mqfQmf+wCQjL3n79oEnkViJpVw395pMyGpTVT2h04LQiq5J5yW
         RYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785503928; x=1786108728;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=No1LZO0/xWGQaiEAYrYAljUhDkAED+OYsMfKkFdGXmA=;
        b=CVrOHb30pk5CEGYAtHgi4ry0TPYG6DrNKSs1NQ8SbqPQMz/Dya05orpAO3i6CmRUv3
         CLiZdT/PObpGwZBOg6As4cuXAba79gJ/uEAIj6RYshuolIULTFqnQSxwCE0JxqjL08Bc
         sekYND3r7oP7fNLMtyKZ4tVr+5RFALsuALBZt12feoaKI0HzkUpgcDGzG9kZA0axQpI7
         SJN2SCpKL41E0ixkMpUaOkZpoiWWVsqTub5yfBbmD6Ig1smMGQftTjfHYlc+M+K7qSdC
         0AEmf8F5ofbRkxol9ziCl9pDO4cK/LE6vwk95pucYZB8rvhHJ1WEwi0Gn+rZ9OA0AR8w
         Yj0A==
X-Forwarded-Encrypted: i=1; AHgh+RrSgZwFVXm8P5Q2WvvTWWzh48aerchUfm5Zc83TG4zIuf8YHY4OJ4dv4yHuEJWH6tuSLqWhFU0ddFNnbqx3WSY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyX1KvuzYOMWrpj17qgPDK8c/YJFcRThFioZIO6JmL93yxktsrV
	xdJNjRhtD1PPiVcGkF3rXRB9GO2LL2NpBPBJHQpOasf6ESIxfrE82Zsy07+nmhJfA9fLiJ3O9mL
	M9Y10m7RSPFrt3up06XmiNxDqds/x6UE=
X-Gm-Gg: AR+sD11LLe5srrHbDHFg9M3DIZlAJr9OiJf0RtFwtvhnuCH+X3/SXJNx/8X+zPWxpoS
	A2UfyuEn6hJ5v4t5EV2pIIPTkrcGOMfZLYjSp53z2e4wtkqB53rq/HzKjmv/+GlVYqQ7rDgrmfL
	+BEMb0jm55Qse56YXs4LCP5iirWOOzb4FSxxWZeZ03pYt34E//wEtjDUZk+pIkrhKcLwabyXZ63
	ek7+usz9bGBBLva9SwiszFBflzL4dBP907zsNAb+/u2AXQIs2tqhcFG7GZre3j7HtGltFJZUvzn
	HTir3IYC1DLzaQ00DNI5Jucm0yg0w0wsSW3AFVNVfbJFx16eSPdAf8DADh3KMKTkdboSuvs4oxE
	5pyfcsUmw1anZtdQWl0m6KQYqtZ3vahPIHgkrrOSYuAfzm56pW3SSWUh6yHOSS5BbVltVRd4=
X-Received: by 2002:a05:6808:178b:b0:496:fd2:94e8 with SMTP id
 5614622812f47-4ae4c51dc85mr2301495b6e.12.1785503928007; Fri, 31 Jul 2026
 06:18:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Smit Patel <smit5292@gmail.com>
Date: Fri, 31 Jul 2026 09:18:37 -0400
X-Gm-Features: AUfX_mwbt9cTvAsQbxrtWkq9sJY0s-Cbx0ff8_-RCd2WxaW8Zp4iRgH_w3ybUrc
Message-ID: <CAM5kW9DyDSJz+W70HhzQL4TeY28GTcOxDvkPHnFBh7TotqiEVg@mail.gmail.com>
Subject: [stable request] Backport b2870fc21601 to 6.1.y, 6.6.y, 6.12.y, 6.18.y
To: stable@vger.kernel.org
Cc: lorenzo@kernel.org, idosch@nvidia.com, pablo@netfilter.org, fw@strlen.de, 
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

Please consider picking up the following mainline commit for the stable
trees listed below:

commit b2870fc21601db9133bc70c48c603b487614fa3b
"netfilter: br_netfilter: Reallocate headroom if necessary in neigh_hh_bridge()"
Author: Lorenzo Bianconi <lorenzo@kernel.org>, 2026-05-14
Fixes: e179e6322ac33 ("netfilter: bridge-netfilter: Fix MAC header
handling with IP DNAT")

Requested trees: 6.1.y, 6.6.y, 6.12.y, 6.18.y

neigh_hh_bridge() copies the aligned L2 header to
skb->data - HH_DATA_ALIGN(ETH_HLEN), i.e. skb->data - 16, without
checking that the skb has that much headroom. build_skb()-based receive
paths leave skb->data only ETH_HLEN above skb->head, so the 8-byte copy
starts two bytes below skb->head on every bridged packet that reaches
the DNAT neighbour fast path - an oops or silent corruption of the
adjacent page, depending on where the buffer falls.

The commit carries a Fixes: tag but no Cc: stable, so it was never
queued. It is in mainline from v7.1 onwards. I have verified it is
present in 7.1.y and absent from 6.18.y, 6.12.y, 6.6.y and 6.1.y, so
backporting to the trees above does not leave a gap for users moving to
a newer series.

This is not a theoretical concern. In addition to the report in the
commit message (Airoha AN7581, 6.12.57), I hit it independently on
unrelated hardware: a FriendlyElec NanoPi R76S (Rockchip RK3576, arm64)
running 6.1.141 with Realtek's out-of-tree r8125 driver, which as of
9.016.01 uses a page-reuse build_skb() receive path. With br_netfilter
loaded, bridge-nf-call-iptables=1 and NAT reflection rules able to match
bridged traffic, the machine took 7 unclean reboots in 2.5 hours, with
uptimes of 59, 3, 89, 22, 2, 27 and 4 minutes.

Excerpt from the ramoops dump; the full dump is available on request:

Unable to handle kernel write to read-only memory at virtual address
ffff0000c213fffe
ESR = 0x000000009600004f
FSC = 0x0f: level 3 permission fault
Internal error: Oops: 000000009600004f [#1] SMP
CPU: 2 PID: 0 Comm: swapper/2 Tainted: G O 6.1.141 #1
Hardware name: FriendlyElec NanoPi R76S (DT)
pc : br_nf_pre_routing_finish_bridge+0xd0/0x270 [br_netfilter]
x2 : ffff0000c214000e x1 : 0000000000000000 x0 : ffff0000cf600000
Call trace:
br_nf_pre_routing_finish_bridge+0xd0/0x270 [br_netfilter]
br_nf_hook_thresh+0x124/0x140 [br_netfilter]
br_nf_pre_routing_finish+0x180/0x490 [br_netfilter]
br_nf_pre_routing+0x1d0/0x484 [br_netfilter]
br_handle_frame+0x270/0x42c [bridge]
__netif_receive_skb_core.constprop.0+0x274/0xed4
__netif_receive_skb_one_core+0x40/0x84
__netif_receive_skb+0x1c/0x6c
process_backlog+0xcc/0x190
__napi_poll+0x3c/0x1e0
net_rx_action+0x350/0x3e0
handle_softirqs+0x110/0x2f0

x2 is skb->data, 14 bytes above the page at ffff0000c2140000, and the
faulting address ffff0000c213fffe is exactly x2 - 0x10: 14 bytes of
headroom where 16 are required. Keeping br_netfilter unloaded has kept
the machine stable since - 15 hours and counting, against a pre-fix
maximum of 89 minutes.

These branches are where the affected configuration lives: OpenWrt 24.10
builds 6.6, current OpenWrt carries 6.12 and 6.18, and vendor BSPs are
commonly on 6.1.

The patch applies cleanly to all four requested trees (verified with
both git apply and patch -F0). It does not apply to 5.15.y, which would
need an adjusted patch; I am not requesting that here.

Happy to test the resulting queue on the R76S.

Disclosure per Documentation/process/generated-content.rst: the upstream
branch survey and the apply-testing above were carried out with AI
assistance. The hardware, the crash, the ramoops dumps and the
workaround testing are my own.

Assisted-by: Claude Code:claude-opus-5

Thanks,
Smit
