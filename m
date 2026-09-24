Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D06D3B8930
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Sep 2026 06:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790231906; cv=none; b=KFN+FeBmMCw8mmatAQDRVudUksjTuDDvZtbTW2BQDNbG5NQylowSlyuxvT42y+5BksIldmnWfrKO7TbLcrHcBXr+0oaKsftaJQRdAY52dDSi1tz6g/t9tSKwCqOFNsKu6J0efN8O8+AiU+DPJvvI/eX0nGG1jPWKox/1+A9zwWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790231906; c=relaxed/simple;
	bh=TOrEwZjx9rc/LajuSNVm5T+0fRyMCyX2DHD+dAYOwiw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MxJJH8JbvtVUAcxfjLLoNaxQ2OaRQZlLIO6tFNMeHomAGWeG43D7jWqpjI0gn7/0bMVuKu8pLKq6NfUa1jQ5X6MdO3UkCodlq0EXsMo52mZpcUImOmqPxtK6ihFP3PyTtwltLkLH/MR6fcUIBMB2Z/w3CFaFTzFhsXGpQC53qt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jd+lQgxl; arc=none smtp.client-ip=74.125.227.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jd+lQgxl"
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-39e4a0daf4eso303773a91.2
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 23:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790231905; x=1790836705; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ODq8hdeYCaD0vpXsbi1Uc+7UGgX4p/bnDCOFSGmNn6o=;
        b=jd+lQgxlA9U2azAhiX1o1DNPxH8XZH1uwWW0NGClzvDPsrnY0FAoUB9L/T2ODU74/a
         u2P+SBx3RYFIITd1MsJE5hJABu8G5weGdBVucfqRk1ALADuykn3UB8ZwS6fyjdE7ZX6p
         DBx1YRcPFsczY1bk+H30hcn+ugMxVhP/UAUUvJL6COY3PRJZymWdSqY/GVwFoftXtGOU
         G1sw0xHPdo0sNeRD2br/gm+H0TJDiq0X5QinfsVbbfPiHkmbL+TAKncgDg7v7+3toD3Z
         Ky/ES5HswWY0rip3lZJEIE0mDxzUY6sNruR9oRjNtUntnIrNQYv8NfgPRKiO6uymwega
         F60w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790231905; x=1790836705;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ODq8hdeYCaD0vpXsbi1Uc+7UGgX4p/bnDCOFSGmNn6o=;
        b=psoxMv1lqRS6ze4xROFs9755n3/X/cfhqdWWNZAFNRkAOgUpDPfo4bZU+tPpPGRuzQ
         ezTvR2IAsmWheLpXtY75mhoHL5+dIFdEwvo6+g1Sgq7xITIyVv+ABm1N5b77UUyuMB4v
         j1vO8z8H9IjtLr+4iEWwWTDo6UtD10cNtYB8wo4OoAX7rNzvh1If3bk6MrMhEZi4moQ5
         xjIX27B2Ayfx9rpShGsvVqFgCGcGjgb+xumPtOFcNZrOQzlFhLwtSbujPq9kiM2Yel5d
         KtxQjTeZlTLWGAud3+mn9bypfB3iDpk15aPxF75Jfp8QsAViPlxu81X9Xcl0sweGDHgy
         UU2g==
X-Gm-Message-State: AFuF++nEj+893EsyXXEff7KSsdsb5NZjMu4uxh3xiiZwsXrnaKB/V5Ql
	kU05eSLAeWlVBq+MFa76QhQ9OOb++MkAcXbo6L0SjBtzdvuKCtJra75IiOeG1sic
X-Gm-Gg: AYBFou1XMFG4zyS9x0xiUDgzbOsw7gjR7NYeZGJh1ndZPNlMyGoFI/eQaVfrX1FzRx0
	SrU/vXkyH872vsfnPyNnj3VRgseAxqdWmT4jXiQxgOuIJVIroMZN4/9193o/cppQFPcuecy4PYY
	UBqjMXQvgzC00CSn177oorX8dzC2AzwyjdQId/7aHIEYP7HvD86uSYPk8PWd2Ne+r4PyhBlll5Y
	Bi+p4S6ST82EaYRbejRKDA+GSAb+pV9eEbQqJm/MAXnxtUwOPiQpoKDUEvJ76V4iJ9eORKg9ZV7
	Fx7Q/VGrnqDTI7sJYpGB1tGZWvkx2OQP3d1j6ku9n0VDqLgLjvBlEUqAfIcH1h3fiRNtccDjv5t
	bHm0+yeYfAFHAcGTnDpRUxL0V+qeLnBHb3iimAXiUiWlpFSCFbBdmVLKGKdYCJWlmPmioeZJ0kv
	kyQi9XwPaMzW8mdoFl46L/Lut52BaUwKa/a4tlrpt9Npr8HRsFpDCSR//RGNknI2I1JP+x/euSz
	0cuUYIdpgc=
X-Received: by 2002:a17:90b:2f90:b0:39e:b778:2b3a with SMTP id 98e67ed59e1d1-3a0992c4574mr1837276a91.6.1790231904603;
        Wed, 23 Sep 2026 23:38:24 -0700 (PDT)
Received: from localhost.localdomain ([175.159.181.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a097344841sm3025685a91.10.2026.09.23.23.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 23:38:24 -0700 (PDT)
From: Yu Junzhe <junzheyu1@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [BUG] netfilter: nf_tables_netdev_event UAF of JUMP binding chain
Date: Thu, 24 Sep 2026 06:38:21 +0000
Message-ID: <20260924063821.573-1-junzheyu1@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

I am reporting a slab use-after-free in nf_tables_netdev_event(): deleting
a netdev hooked by an nftables ingress base chain can free a binding-chain
successor while the notifier is still walking table->chains. Triggering it
requires CAP_NET_ADMIN (including in a network namespace). I do not claim
privilege escalation; the result we see is local DoS (KASAN slab UAF read).

Summary
=======

nf_tables_netdev_event() walks table->chains with list_for_each_entry_safe.
On NETDEV_UNREGISTER it releases the netdev ingress base chain. A JUMP to an
NFT_CHAIN_BINDING successor is deactivated (nft_chain_del + bound = false)
and then nft_immediate_destroy() kfree's that successor. The walker's saved
nr still points at the freed nft_chain, so the loop increment reads
chain->list.next.

The deactivate/destroy path:

  __nft_release_basechain_now()
    -> nft_rule_expr_deactivate(..., NFT_TRANS_RELEASE)
    -> nft_immediate_deactivate(): nft_chain_del(chain); chain->bound = false;
    -> nft_immediate_destroy(): nf_tables_chain_destroy() when !chain->bound

list_for_each_entry_safe only protects deleting the current entry, not a
sibling freed inside the loop body.

Affected
========

- Confirmed on Linux 6.6.144, KASAN guest.
- Files: net/netfilter/nft_chain_filter.c, net/netfilter/nft_immediate.c,
  net/netfilter/nf_tables_api.c
- Config: CONFIG_NF_TABLES=y, CONFIG_NF_TABLES_NETDEV=y, CONFIG_BRIDGE=y
  (KASAN used for the report)
- Source review of torvalds/linux master as of 2026-09-18:
  nft_immediate_deactivate() still unlinks binding chains on NFT_TRANS_RELEASE
  and nft_immediate_destroy() still destroys them when !chain->bound.
  __nft_release_basechain() is gone from nf_tables_api.c and the notifier
  only unregisters hooks on tip, so this PoC's live RTM_DELLINK trigger was
  not re-run on tip.

Ruleset that triggers it
========================

  table netdev t {
          chain in {
                  type filter hook ingress device "br0" priority 0;
                  jump j
          }
          chain j {
                  flags binding;
          }
  }

Create br0 in a network namespace, load the ruleset, then RTM_DELLINK br0
while the namespace is still alive (NETDEV_UNREGISTER). Netns teardown alone
is too late: nft pernet exit wins that race.

Crash excerpt (minimized PoC, Linux 6.6.144 KASAN)
==================================================

BUG: KASAN: slab-use-after-free in nf_tables_netdev_event+0x699/0x7d0
Read of size 8 at addr ff11000009aefd20 by task repro/220
CPU: 0 PID: 220 Comm: repro Not tainted 6.6.144 #1
Call Trace:
  kasan_report
  nf_tables_netdev_event+0x699/0x7d0
  notifier_call_chain
  unregister_netdevice_many_notify
  rtnl_dellink
  rtnetlink_rcv_msg
Allocated by task 220:
  nf_tables_addchain
  nf_tables_newchain
Freed by task 220:
  nf_tables_chain_destroy
  nft_immediate_destroy
  __nft_release_basechain_now
  __nft_release_basechain
  nf_tables_netdev_event+0x63a/0x7d0

The KASAN read is 8 bytes at offset 32 of a kmalloc-128 object (nft_chain.list).

Reproducer
==========

A self-contained C PoC (raw NETLINK_NETFILTER batch plus RTM_NEWLINK/
RTM_DELLINK, no nft binary) and a Docker/QEMU package are available on
request. VM-only: the program triggers a guest KASAN UAF. Please do not run
it on a host kernel.

I am happy to test patches or send the reproducer.

Thanks,
Yu Junzhe
FuzzAnything <fuzzanything@gmail.com>
