Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795596265;
	b=KfQjmWs1nZxDI2UonlyH5nHtGAEIemBJytjmKTlWqLd3VF77BSzdUggnWYD70HPlUm26
	 5hVMWD86vhlyIarYNeDMocCBrermhuN1OGa0Y2D4jJPT5E/3F7cwu83QdWIgiYv/4VneX
	 IwfJTheHpA+EyTVWAY1YazxtW3LDfVRj8pG6I8dpOX08bIi67bXC5HbD+LjspF0ca3sQ4
	 i3RtNZB+DAvcQCrrAc1R/vlYhf2cSFB8FrlHH7yFkQPTEBwUUA0OI7RsBzpjoY+3gKoWU
	 BHk+5E9Ef9j5FJ1ItIHp8iXU9A1+R19Ja541s87p0RFOPw0iNJWaiIqWemhcMDlk84A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795596265;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lPFYialRWG4pRS4OT1uh519VBoCu1VzItcljyeAUzHU=;
	b=Dol9k0KauHdssUHLtwEAUXlAZkkVnTS7nXqRBqmlXeXaD/nOnuRnbCnd3DhxBPswApfo
	 Gzi3eiiQfeaquRWrlBiyH1V46ip2283/WkXS3WE1VPLo5IW9m6J7wHZ9MlrT/WqE90zWI
	 xEypLsBqqkP6VZgDxG8xnFsxOIeMhbnubbUBagG/ZPjpNyb5S1OA28JP4eIVQ6VBBZ6Pt
	 l2EqTOYZ1NqVPxVtN/uU09LlaGYschkItD9iqjKiWGaXMdXn98bENRPFVTeA0U9sDNn/q
	 KjsvNneiTtjzCkHHiuwRty0xEKKrXOZ3Pjq0BfB2IWHPDqg+wjBIoq2JDqL+0ZGARNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SvniTco1;
	arc=none smtp.remote-ip=209.85.214.181
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B04606A32C
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 08:44:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0B04606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SvniTco1
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2f0481b35c9so31770955ad.0
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 00:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795596264; x=1796201064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lPFYialRWG4pRS4OT1uh519VBoCu1VzItcljyeAUzHU=;
        b=SvniTco1NUSUtvFcoYZ0pgwBrsTVcjU87S1hUrTrJyFmUsyENhoIOScLvhwMGkbLuL
         crXEPfrkxUMG2y8MsFu3xB5AFPvmCIE9b0hx05ZepVsUWe3XH+F5bNHrwacvZuxswKux
         SPDw4FzfkycSozQxoisv3hb11k4/iqsEXBqs8xjqwbNw4x/0W9CZQCTXmCeVD+eRxCCG
         LbhpvGxuoAMlKVfZ4hIiHvjQL13hA8gGIew0cezJbNolZcFlAhOfy0qHWJhJkG285vpA
         ev4FMA+eP50cNFVfQMgJBk7OVG6NSG34uDJoQLSj3uaTLrF+KV8Djus0iMd+Go73+heL
         uVHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795596264; x=1796201064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lPFYialRWG4pRS4OT1uh519VBoCu1VzItcljyeAUzHU=;
        b=CKJPcAEaW23WYYFqTJB0l7wiYTV70OlW34ysKySrEdygUclomGWl89EZqYS6XFTTIt
         YXMjuTKMUqd28Syl0HCiKYyA5FItR0km+1oUqNayXJpDin6wse7tBu8utXouS6dnXVAa
         5dhrf+oOmrSOd/ZXm7voohvU27P5ZVDQtUZ+2vejLXybYZKxwSh6BuFv3pfUoDbJSQAE
         0l1OIt+YEux12DwAl7UDvo2Pf9HShWuPXmqLc826Mbb2RdTUJ7Me+DoUe+5Snwv2h1B8
         xqkQiClRX42v7r4s2TW/SuTWT5RYxeunoNNOPSxdKsezY9s+JnZ9edS1n61DH0uF5aAa
         HyWQ==
X-Forwarded-Encrypted: i=1; AL+hErGoIMUih8OLMYhu3gvLt+84rVXUly6rOfx5UWOVuyvoT/i+csMPu7NVlcnrm3Ppd58YUN9hPDmzCooRolxYPXg=@vger.kernel.org
X-Gm-Message-State: APuU4Z+Ua6q+a8QY6zOX0usVUJGiXkJ4M/YNVjTqZikTZ6AJDuf0bEdj
	4s029Va2HSkpX4FsY6kwGYzJUOpKYZWQqEKoD3laM+CD0iEbOpP+nKTI
X-Gm-Gg: AZFdTZfxhhjCJwGUYBkyJf99tRH0PbBPLSDMubtzC0BBOeFQMFr8KCzb4ckLXxNl3/0
	BCQ5uT+OAizW0AtotumoTBeP0L5MRyEOJc1rZz2NESDqY1nt0SianHa7tI9q0vJLdlWrQZkVMRa
	4TaqU4eHYA49RRCNPFm9ndntVnDohIWVsYt0KRqMxuNzUgefqlRfoPhaIbts1eh6evaE0srDqIr
	ko+P6FEX/sHXH1cuIrZeL43f+lniLu58FSbUcdub+q/vAW6D4zKhOq2KB+Yinaty8Bkm6NIq3Wu
	JMm6tlWiQiYP93hYoDctIwX25ZL6Tz/tzZykLRuuSmgSU7EbXZLM9IrpKIGwlXvC20ZGlyUZ/Wf
	fDj+0hsa6EYw63twT9lxD59tsJVE/W7FTSA0d9aL4tpwcod0UlT3eeg7sn4v9IKhwr//b4MHXj1
	r5/I4FTzaD4EjKaQLQmYGmyTESmE1z3NYIAE3DWVwjfmWTLkvGm3HvUy7nS7UYhLonHQsr4PRiK
	OuOaf1V0X5Qoa6aeSI6HWNO5BHjIatLtrXlJ8z8zI0dlMdoCe3dkp/BgNCHyz/myqjajKLy0oxO
	oQGePw5hZIxTCPtLNCkSsdZU72mIEzs1A2GRwByOZE/sqXDeOJTyVvn+daK4b3Zfdop0AcRDKRX
	7T8H0KZviwMCkV7ExBWFoHByTGV6S/9R7/bHHM1oB
X-Received: by 2002:a17:902:ea0c:b0:2f0:3123:899c with SMTP id d9443c01a7336-2f03f0c1f37mr159122655ad.5.1795596263959;
        Wed, 25 Nov 2026 00:44:23 -0800 (PST)
Received: from LDYT9Q2G2M.pvgl.sap.corp ([2a09:bac5:cad3:119::1c:2e7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c1a8asm81877485ad.24.2026.11.25.00.44.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 25 Nov 2026 00:44:23 -0800 (PST)
From: Zhiqi Zhang <zhiqizhangg@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc
Cc: davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	shuah@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhiqi Zhang <zhiqizhangg@gmail.com>
Subject: [PATCH v2] selftests: netfilter: fix nft_nat_zones.sh diagnostics
Date: Wed, 25 Nov 2026 16:44:16 +0800
Message-ID: <20261125084416.23282-1-zhiqizhangg@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261124071926.8818-1-zhiqizhangg@gmail.com>
References: <20261124071926.8818-1-zhiqizhangg@gmail.com>
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

nft_nat_zones.sh starts all client pings in the background and then
uses a bare wait to collect them. In bash, wait with no arguments
returns zero after all known children have been waited for, so a ping
failure does not set ret. The diagnostic after that wait is also outside
the client loop, so it would name only the final client even if it ran.

Store each ping PID and wait for it next to the matching client
namespace. This makes failed pings set ret and reports the client that
actually failed.

The veth0 ICMP counter mismatch path checks the 10.3.0.99 key but dumps
10.3.99 for debugging. Dump the same key that was checked.

OpenAI Codex helped analyze the Sashiko review and draft this respin. I
reviewed the changes.

Signed-off-by: Zhiqi Zhang <zhiqizhangg@gmail.com>
---
Changes in v2:
- Track each ping PID and wait per client instead of adding echo after a
  bare wait.
- Report the client whose ping failed instead of reusing the final loop
  value.
- Fix the veth0 ICMP debug dump key from 10.3.99 to 10.3.0.99.

 .../selftests/net/netfilter/nft_nat_zones.sh        | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_nat_zones.sh b/tools/testing/selftests/net/netfilter/nft_nat_zones.sh
index d935c967dd..9397f09d0c 100755
--- a/tools/testing/selftests/net/netfilter/nft_nat_zones.sh
+++ b/tools/testing/selftests/net/netfilter/nft_nat_zones.sh
@@ -167,11 +167,16 @@ ip netns exec "$gw" sysctl -q net.ipv6.fwmark_reflect=1 > /dev/null
 for i in $(seq 1 "$maxclients"); do
   cl=$(eval echo \$cl"$i")
   ip netns exec "$cl" ping -i 0.5 -q -c 3 10.3.0.99 > /dev/null 2>&1 &
+  ping_pids[$i]=$!
 done
 
-wait || ret=1
-
-[ "$ret" -ne 0 ] && "FAIL: Ping failure from $cl" 1>&2
+for i in $(seq 1 "$maxclients"); do
+  cl=$(eval echo \$cl"$i")
+  if ! wait "${ping_pids[$i]}"; then
+    ret=1
+    echo "FAIL: Ping failure from $cl" 1>&2
+  fi
+done
 
 for i in $(seq 1 "$maxclients"); do
    if ! ip netns exec "$gw" nft get element inet raw inicmp "{ 10.1.0.3 . \"veth$i\" . 10.3.0.99 }" | grep -q "{ 10.1.0.3 . \"veth$i\" . 10.3.0.99 counter packets 3 bytes 252 }"; then
@@ -185,7 +190,7 @@ done
 if ! ip netns exec "$gw" nft get element inet raw inicmp "{ 10.3.0.99 . \"veth0\" . 10.3.0.1 }" | grep -q "{ 10.3.0.99 . \"veth0\" . 10.3.0.1 counter packets $((3 * maxclients)) bytes $((252 * maxclients)) }"; then
     ret=1
     echo "FAIL: counter icmp mismatch for veth0: { 10.3.0.99 . \"veth0\" . 10.3.0.1 counter packets $((3 * maxclients)) bytes $((252 * maxclients)) }"
-    ip netns exec "$gw" nft get element inet raw inicmp "{ 10.3.99 . \"veth0\" . 10.3.0.1 }" 1>&2
+    ip netns exec "$gw" nft get element inet raw inicmp "{ 10.3.0.99 . \"veth0\" . 10.3.0.1 }" 1>&2
 fi
 
 if [ $ret -eq 0 ]; then
-- 
2.54.0 (Apple Git-157)

