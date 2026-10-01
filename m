Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AC837F320
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Oct 2026 18:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790877766; cv=none; b=nD067V8hy1lhdEF81muZf4RcHIoGt6pgpwJ1LveIhLgxnqF2QM9zVTDHrHDWoq1F8ocoWFK3d6UYulqWK4L0aYD1aPkSuEBmVkzESGZCGCxrxICgs8BY+c9qapd7cGM8cHANraxO1RZTlZlhFaFQBhJeU/Auyse58RoEavlDzD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790877766; c=relaxed/simple;
	bh=wMs6vW86I8zfsm+tLyJQj3t0n3d+3Hy54v7gPa84fk8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EBMnOuZHV1D1JGloZXLAlBJCNYjdGxQ58OGw09Dqcr5Vh/m7cUO/VIdTh8+N68HBcp6aZbCI1RdYq9eMKIOhnLxHNCinX34TbYE5UQjTb1pzL/3e7RkBuIZyAlGjaxEBPegLBPZsNmq4Kqjv2eYyn5QvO7ou1vzFORmuzm0UcwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lV7CXU3T; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lV7CXU3T"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-39b2ad83dc6so4597258a91.0
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Oct 2026 11:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790877757; x=1791482557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JwsI/5Y1lBQd0B/lyvICZESjhXRO4PckWvccwc02nPU=;
        b=lV7CXU3TDWWfJ1mmQ4WBfwQKi5cwo1gPGYvamB3udVKXvSg+d38klHVEsaujma/JZP
         RwLpQGl+BdIFPWjMHn32LuMKQ3ClDcb9zdI+sNepizNjjrh40zV64p0HasbLb3qnhQpp
         RUCA6yoDNuMVNjMUW3RwF4h6AzQmx2+Wq4YD52Ij3I+7UZSWPWE44E2LL2CtCDWbtxA3
         e/D5+TE1mIXIv+KjtWTWzvPa4MI8K1PSkKOsZ1MPrkGHvnsjQ/ETr+ZxjXRRCfn48gZI
         FTR2rUQW72dQpkfl5w7KDpojhPASmH3bZ+8GFsQmc1j0nMlq+AfYE6+BkZquoIf1+1Sp
         vqqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790877757; x=1791482557;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JwsI/5Y1lBQd0B/lyvICZESjhXRO4PckWvccwc02nPU=;
        b=PVVIuT95CgdYqy9D1OoyxvKCIH5YQNnUm3en0ONTB53qepPwbZmaahTB4SrGQuNof8
         IvsGt1rKi9ePhXzvMIvlil5885Px8IWTNhxfJgHDhlkSoTUIT7EDWFfyiTu/nthUgCzT
         pQX7oUf69zpXHv0f8osR+GaJzkdwtEP5X0pzypKnhH/kFJnjSpuLNN5K5EoQFcGnF3PK
         HYWdzqQ6qb0N9o/RdhZqNdkSotb+GDR/tkfMXp2U0mxa1UVGcC2AfGLW5CT4pWySME5d
         DAyDLJhmuGzllOve0dA/ShRQclXJ9vx247PpBGbb0lJNJBT9/LbQRNXGKgcRsKEKdVki
         7nKg==
X-Forwarded-Encrypted: i=1; AKwUvBzxnSFJeqxX9PpiZNCRaOGzLVly5MD+pzL3LFhb1W1tDfPmu1jSr/1ZlS+kXwdXdwBfjukcLzKD4EGjdAjXsRA=@vger.kernel.org
X-Gm-Message-State: AFq9FYKXfowZJBKtk2L+sXlbk6KSPHfNashqOLWcVjdJOJI5TLvYr578
	DL4vdTgiMcG39zTwso0lIJTAfrp8KlpaH1YHSbONiae8behMevmGAvNy
X-Gm-Gg: AYBFou2l0hKi3jw24MbE/k/F2BvhgcfIQStx+OAaykahAqi/96wkgWmSPECRS/3qS5x
	LnIkcwyGUMRur9tMzmUj5vjlJC9A8SnxZG1hmIeXFN4T/gSAn4T5oKWs9lu9KQFvP+wmBPJu7l0
	GnkXn5RjulT1xLJJfWIlpeI7icQT6nz0dZ06OG/UWnQXk7nQgLcHeoiOxX+kMULITuyLEAfug+G
	DQyiDAX3KW2srcWlAPsEhlFzDSghBUDFIeSN49tfWKssuuKpKCE8tTBhHjOgoEHtG0+EAp0QknY
	ZLFxKovU6bnlq21EmvBn5uyuwZBUM/UDr/SU98drBchke+WuXi/PVzSWRH1jwLBHbcZzCrwYDoP
	uNmVtBSdAY5gNf0yw0oNlcjnw9eXan2HG8DYwIkj26I+FJyvKTh3ZcJhRqDW8UadomDIcQv+ir2
	6CedLv2GGIPh3t0rqtjZEeDmkdSeZEvbp3+ae8wUOXxeErzDzfi8SJLMD46b6LHNryqEEdorF94
	g/5cpobyqQ=
X-Received: by 2002:a17:90a:dfc5:b0:3a0:e476:576b with SMTP id 98e67ed59e1d1-3a6ce7c072emr312864a91.37.1790877757241;
        Thu, 01 Oct 2026 11:02:37 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4f439f9f9sm5502805a91.1.2026.10.01.11.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 11:02:36 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Daehyeon Ko <4ncienth@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net] netfilter: conntrack: avoid recursive master destruction
Date: Fri,  2 Oct 2026 03:02:24 +0900
Message-ID: <20261001180224.1018290-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Conntrack entries created through ctnetlink can reference another
confirmed entry as their master.  There is no limit on the resulting
chain depth.

When the last external reference to such a chain is dropped,
nf_ct_destroy() puts the master reference.  If that is the master's last
reference, nf_ct_put() invokes nf_ct_destroy() recursively.  A sufficiently
long chain therefore exhausts the task stack.

Release the master reference directly.  When it was the final reference,
continue destroying it in the current invocation.  This keeps the existing
refcount and lifetime rules while bounding stack use.

Fixes: 5faa1f4cb5a1 ("[NETFILTER]: nf_conntrack_netlink: add support to related connections")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
---
Tested on net e23a64eb244356ee47c0620f0722d51bd88db522 and exact
v6.12.105. A source reproducer and userns launcher are available privately
on request and are intentionally omitted from this public posting.

The trigger needs CONFIG_USER_NS, CONFIG_NET_NS, CONFIG_NF_CONNTRACK and
CONFIG_NF_CT_NETLINK. Host UID 65534 used only namespace-local
CAP_NET_ADMIN. The essential vulnerable trace is:

  BUG: TASK stack guard page was hit at ffffc90001197ff8
  CPU: 1 UID: 65534 PID: 178 Comm: conntrack-maste
  nf_ct_destroy+0x1ac/0x5f0 (repeated)

Fixed current and LTS 6,000-entry runs ended with nf_conntrack_count=0 and
no crash marker. The netdev allyesconfig and allmodconfig W=1 full builds
were not run.

 net/netfilter/nf_conntrack_core.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d0d9e5ea84a09..0ce6141b3dfd7 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -592,6 +592,10 @@ static void warn_on_keymap_list_leak(const struct net *net)
 void nf_ct_destroy(struct nf_conntrack *nfct)
 {
 	struct nf_conn *ct = (struct nf_conn *)nfct;
+	struct nf_conn *master;
+	bool destroy_master;
+
+again:
 
 	WARN_ON(refcount_read(&nfct->use) != 0);
 
@@ -610,10 +614,17 @@ void nf_ct_destroy(struct nf_conntrack *nfct)
 	 */
 	nf_ct_remove_expectations(ct);
 
-	if (ct->master)
-		nf_ct_put(ct->master);
+	master = ct->master;
+	destroy_master = master &&
+		refcount_dec_and_test(&master->ct_general.use);
 
 	nf_conntrack_free(ct);
+
+	if (destroy_master) {
+		ct = master;
+		nfct = &ct->ct_general;
+		goto again;
+	}
 }
 EXPORT_SYMBOL(nf_ct_destroy);
 
-- 
2.55.0
