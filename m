Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173558;
	b=14arLkfHnZmdp+gAfmqJY1pfOZdC2N3u+FPp36qAbmf3VFgIsV+O4tJQihztX7m+Owas
	 5KMvFuKLraWqWc9nwloUl+ZLYH4mMvrrXv4ZH92JqsCgcxJZGBuRmLDfb/uET8/wVL/lo
	 sQQACYUYclbwpLIYii9HU+2l58RRK39pMeh/AKqqJmpN6ndfDSmkDXk+KibUs5w7I6s55
	 +EAfda2Zs6hi4BnpXCdRL0It4njLZfScjmCk+agk3V3XjzbBirlUnA21taQX+K0H2Zxhu
	 MWCVfBDdI1e8419EL4fEYDnh+8gEu4w4GJEECtdUMPAKXSuwXnimba1O/bGUIZkZLIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173558;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cO7QiRpUot9Vz25lkQZDD0fNa3WCQpmTa73WBgTVjk8=;
	b=dtb5QthjFLgkqazEH07N6JoteUAFgQxYSTmMrFrwHN3/kbeByibUPtOhifs3W5Op60ZE
	 4uiMTEEQRHMtzQU1UCjXnOZBmZH24zbjbZTCuRlB/WZH1K7fQSEckERO+32AwMcGIKdRE
	 fivNwCeFtNODvsMn5bXR/TZibOKFKBF42vrf4OwM/jjm2it7oVRGBzfI/nEfkI7sS/IJO
	 5AGCQCG8smglboCiU2ilakankyVzLbum3KyM6LC4rJAaYkMbSZCtgto0s9JAH6b9hTdus
	 ReAiEZDD1mAB/MlQK3nVIYNM9eo7z+Ec3z9D28o0VrFTBluqXtJ6pKuzHj/WWV5EhFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uvqD4Pve;
	arc=none smtp.remote-ip=209.85.210.174
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0303D606A326
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 11:19:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0303D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uvqD4Pve
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8a06e79e152so416110b3a.0
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 03:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795173557; x=1795778357; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cO7QiRpUot9Vz25lkQZDD0fNa3WCQpmTa73WBgTVjk8=;
        b=uvqD4PvefDfCYawdcK8xfOke5kh4ebqkVLbhfhlyznmi+YdFEJnYB7CLXX+DqFiLBi
         +AUAn7T0N9wKeWlPwzfk/TfhssK5JetXq4D6Ut6A+OsxsT0aZwOsLDtP039n3y60/6Jg
         7w39bpMSKj3XVfubN7DviLW+G0hW6VpYKSf1hYdEno2jT5ky/UV/+c8VjkvSgYyTY9yZ
         2Asz1rjgQuM7Ex9rMxoDFJuFtHA40XPSM2/WXlXfi4EaYEWzfUgRqRPL1RmMoUZrkVxR
         t+oZ6HleMIMRUAM6sHW89GT7YSyrDxDLav6AnF4UwNQcRxV8Ybw21iS5IrCB9P39yNEr
         FVJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795173557; x=1795778357;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cO7QiRpUot9Vz25lkQZDD0fNa3WCQpmTa73WBgTVjk8=;
        b=ZIg7Y0BdgRdMsbFLmiEdJ03Tkp06RWlbihDikZKBXDyuw0xvwyV0sxykn1/9DAG/GA
         o1JCbFjnUZkq2C5NrdUMEFxMZUP8D1a35c1OdmDg734EnRufY2IHp3hcYcis6H6RoCOD
         ceFf+Oep5gYJsU6FTnQ0QPDt/6Fj9MsiBhKs9SqJ4zpRh30qwEQR6tNlxCTAcSpzLnqp
         dlC+jLWK3DKmSietvEOuVGqaYVqmdyxcpe3n4E/NOUrO3YsVK4r0oyCd8KgDXtuJAI/U
         fvluBLmHr+49X0bBgMTg+Bt8VcjTzqFKYHedbxxtaXxV4XiaDEEgzyamLnpchI2Mz1rR
         ImvA==
X-Forwarded-Encrypted: i=1; AL+hErFwghDBCopUlO/yYLsCbN/oyheI5HzcFILxoVExweQV4Pa0LLb+Lpo4BX5X8qk8rEUgHoyC4fPGwoJCbENh4dM=@vger.kernel.org
X-Gm-Message-State: APuU4Z91s6nUVz8fR6W3dmZ/ziyVEaiqRKhO88Ddq4FOkJVE17vfekZc
	ZAWlf8RFvuwpoqUGHWKVj9pvgtz4iZzfE2lvSy3F6QJL2CWmQ4C7APYR
X-Gm-Gg: AYBFou0XMcZUVIgJkbveEL5Qp5I2RH5uvlAxb8LXk3buik5yd17lIzZaGoOdLpbTAC/
	N1kIWC0sHVS+IsvkZGjZnTTpeGvSLxonLpOSaxT2nY2hkgLxj4YlkPFI6/4HIitACbctAKNVBSk
	8kohZqr+tNFZxNKc1L89CBzracg48g/HBKWmoBXbyp23I4lrkEar+TY+xbpGYaq+M1Cm2OQWSxR
	dJ632UhT8z1CRv8dt4TfHN5gcKbywyM04JQ9tV4UckkguVatKv9ltZrTN+oR8ydhGBpURzkgb/p
	RVfsP9sFElS/7UUscqMqgPOiX++9W8g6PBspAL0jX7JgYbZhNOZlSwqYibYsPks47SmUqjMJTlg
	LdKYMmXEDFhU/HZxBrHMFGJnAZJECOES2knfr4OMNFW1QnwpiA+WGuTPnluyjbH2OSrolKH/xOF
	n18eZA6U9dyw4rFoyxw1cJ3lvTvwSjulTT2VeH62u5+v0YZhXhub8cJxUcNXb2UPget8QzVpv6C
	kc08c/MwpLbRxjb1CWBpWizJlz/ifk7sRpnE5bLYug/q2VAThojPYcV0Xbplc9DCI9L3OmztzZj
	54xSUMH+savcZ3xuwmncLkm87AZtmXODz4IbbZWcSo62D+VJmaqsz81dFLKbrLtb3v5IdI5I2YM
	ijNPqD6SfdlpG
X-Received: by 2002:a05:6a21:4d8e:b0:3fb:a69:8480 with SMTP id adf61e73a8af0-4014e35c584mr2272208637.87.1795173556776;
        Fri, 20 Nov 2026 03:19:16 -0800 (PST)
Received: from JUNVYYANG-MC1.tencent.com ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87285c14fsm1367050b3a.15.2026.11.20.03.19.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 03:19:16 -0800 (PST)
From: Jun Yang <juny24602@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	kadlec@netfilter.org,
	aconole@redhat.com,
	yifanwucs@gmail.com,
	manizada@pm.me,
	david.lee@trailofbits.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	junvyyang@tencent.com,
	corvus@tencent.com,
	stable@kernel.org
Subject: [PATCH nf] netfilter: ipset: do not destroy shared extensions on hash resize
Date: Fri, 20 Nov 2026 19:18:57 +0800
Message-ID: <20261120111910.67379-1-juny24602@gmail.com>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jun Yang <junvyyang@tencent.com>

mtype_resize() copies the elements into the replacement table with a
plain memcpy(), so the comment extension is shared between an element
and its copy until the resize completes.

Commit cffcf57bf03cb ("netfilter: ipset: exclude gc when resize is in
progress") stopped gc from freeing it behind the copy, but the packet
path still does: mtype_add() reusing a timed out element and
mtype_del() destroy the extension on the old table before queueing the
operation for replay.  The replay finds the copy in the replacement
table and frees the same ip_set_comment_rcu again:

  BUG: KASAN: double-free in rcu_free_sheaf+0x1b/0xe0
  Free of addr ffff8881056b9480 by task poc/798
   kfree+0x12f/0x4e0
   hash_ip4_resize+0x1268/0x18e0 [ip_set_hash_ip]
   call_ad+0x367/0x8e0 [ip_set]
  Allocated by task 798:
   ip_set_init_comment+0xbe/0x220 [ip_set]
   hash_ip4_add+0x19c7/0x22f0 [ip_set_hash_ip]

A replayed add can instead leave the copy holding the stale pointer,
because ip_set_init_comment() is skipped for kernel side adds since
commit a442c8a89fb9 ("netfilter: ipset: do not update comments from
kernel-side adds"), and the second free then happens at set destroy.

Destroy the extension on the old table only when the operation is not
queued for replay: the replacement table owns the element from the
replay on, and the old table is freed with ext_destroy == false.  An
element deleted before the copy loop reaches it is not copied, so its
comment is leaked instead of freed twice.

Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
Cc: stable@kernel.org
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Signed-off-by: Jun Yang <junvyyang@tencent.com>
---
A KASAN reproducer for this issue is available if requested.

 net/netfilter/ipset/ip_set_hash_gen.h | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 80ca523f304b..e84341ae9ab6 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1068,7 +1068,11 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		data = ahash_data(n, j, set->dsize);
 		if (!deleted) {
 			mtype_del_cidr_all(set, h, data);
-			ip_set_ext_destroy(set, data);
+			/* The resize copy shares this extension:
+			 * the replayed add destroys it.
+			 */
+			if (!(t->resizing && ext && ext->target))
+				ip_set_ext_destroy(set, data);
 			t->hregion[r].elements--;
 		}
 		goto copy_data;
@@ -1223,11 +1227,10 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			smp_store_release(&n->pos, --pos);
 		t->hregion[r].elements--;
 		mtype_del_cidr_all(set, h, d);
-		ip_set_ext_destroy(set, data);
-
 		if (t->resizing && ext && ext->target) {
-			/* Resize is in process and kernel side del,
-			 * save values
+			/* Resize is in process and kernel side del, save
+			 * values.  The resize copy shares the extension:
+			 * the replayed del destroys it.
 			 */
 			x = kzalloc_obj(struct mtype_resize_ad, GFP_ATOMIC);
 			if (x) {
@@ -1236,6 +1239,8 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 				       sizeof(struct mtype_elem));
 				x->flags = flags;
 			}
+		} else {
+			ip_set_ext_destroy(set, data);
 		}
 		for (; i < pos; i++) {
 			if (!test_bit(i, n->used))

base-commit: 4d67cf2fd2352f130c42494a933ba9158b925c65
-- 
2.56.1
