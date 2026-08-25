Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADA13BE174
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2026 19:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787685068; cv=none; b=cSW5D9ENa35B7jv2oaISnhURN/QKIdUhAOkR/7Rb9i2BNy6ujTTa0aYLJTQK0Y6SjW7dTqCgqc+m4YOxB8C1kg136U72HIvTsn/BS158SYr2nzc36CjGTjEQwJtMzvuiHGCb/oNkUz+ok0Dsy5XmwUDdHySU2/xkc7X598TUsjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787685068; c=relaxed/simple;
	bh=8TUilZ/8wXOmP46L4hggUWblCI+w+fMdPbby7AJioX0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cmj5HiTA59Be8NwD12JsFxQyPbyPzMf4WFuEaKsKk/StUcUrfjnaDB1ApqQ8BLGCh94Dq9O1zgyqLFU3i2l6V6o5qpNNK38DvjU2I2ptQdDk4x8Cmiig9jmTO+z959HYD3rne9BF7A0NlROFJthoRaHAepNDY3hDBokVRRw83zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=changeover.za.net; spf=pass smtp.mailfrom=changeover.za.net; dkim=pass (2048-bit key) header.d=changeover.za.net header.i=@changeover.za.net header.b=Xz+7u5nC; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=changeover.za.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=changeover.za.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=changeover.za.net header.i=@changeover.za.net header.b="Xz+7u5nC"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c207cb16cf5so5741766b.1
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2026 12:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=changeover.za.net; s=google; t=1787685054; x=1788289854; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zj5NV56xFIM61faWP39aLuivn6GD8cnzc7hvj7HICkI=;
        b=Xz+7u5nCVod0zDuQ740MclDmaYJ79BWr5R2f7wmLcUGO8R4nIB6s/SyrNdeH7qCP/R
         ch7NB7Ix5syUZrlPlbGL1j8ZhDmJVxmSUYTa8WlI0NchrQhb+bmY2dB/Zwn2UlXfBbYS
         Z/vDDV35O2iA5arvrZpyTDKKOpNK2pfmTbdKKn2qJtIqLT3c+Aj7hVGCATp7fnQh2VFE
         63AkQQS+OttlrJti3umiLG48YpK5PoCXILqZi+pQzYMwEpuGwDLESX7CyJlosx0vHHvF
         Ie1NMh6WdRswH6Ajhy6DrkF2MKyI0wOZdmYEOoJNd7ZjBTtCVYGeWhMxFWx2bayLI5Ai
         V9Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787685054; x=1788289854;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zj5NV56xFIM61faWP39aLuivn6GD8cnzc7hvj7HICkI=;
        b=Ym5VB1j0zEuCZpapWw6fcHdUCkcSHMf4sDVicFHNtFhPDQNH2mcmzvQX8JY34/frZ4
         mWVYVAku4NX27AHEyjZDIJcZNZDeHrqRbTVEYBfdCMpDejz2Yy0lDBK/jCWmNHP5iYYy
         rfzGOvwsy/1wvBdFJBAiYuJU3EF6rJ52euYR3SVcMci6QCU4T2TJ4ykwOM3QNd89X7jq
         EmjkD7T3o5hhCWZxSFl9+X2Saxe+YoS4kCzFr2F80DYLeSa2prBpgTg16Hz7xefmaG2h
         rcoi1qTwOFm0FS2h2EV9DMoEoDd4pgsH27qaEdTQo+IhU6xZhAsFkvcdb/G4nSJzGNBK
         cYIg==
X-Gm-Message-State: AFuF++kA/r8Zajp9XHDw/FesaENjrqzfq24DdPv8auElcTYKBFkcUhVr
	m4IHbNUTeThO2MRTO+qwlKNb8XDKUUiAvNaPszJpVXvwz3ilsFGwcj6VdjA5mt30R4H8skJLMQd
	7ZlNVFQ==
X-Gm-Gg: AR+sD10+ig3aNk6FzY1qLT7KS12I50IAkrmEEd8JaawfLY4RP/Wg0F4A4fee4mNfVQc
	vLnWyH8tGjIK06NpqGQqws2rei+57BPs7rCftx517m7j/SAZjGL6DfYAgVOcBTYWHEZxJnNTXcQ
	yH1DCekcRYPWpmYoTH5FPYmFUXrrFrW3T7Z9XoQn8RXFT7stxO50UIK7X6iKpKmdOg9W7t42k3v
	6XOeEtlWCWYgaEQtsFk7RZhrKlaChD37+awsP0oWnefqoIXlTf3T4Ax1mp3dgUxBmPV7mzT2lP2
	bC08WiLc7Xwn6CQpyiD64zQKKzXJYMQ+wAlb2MLJds7HHm+eIN6jCgIEYZFTcgnhdaWhBUfGaZi
	Y7W35WP0R19hhl6gnN5TuzN6CWppFFLwod7HtfxLwwhghksv7Yxo8XtFsP4LANLTStk2ZAlNqP1
	ZsDLXmROhvIGW7JuodRLafjK9b64a/pu4isQVOLMVNZ3nhQjxb6KVtHUBEMZtbBEij62i+LTyqw
	UxDtBmTK5h/IcLDVX1hjS5v4LfoN4G+nv9JR3o8ppxW/+Fo1L8Dnc0UktDv0lZSuKWPqxE=
X-Received: by 2002:a05:6938:a082:10b0:c25:659:89ba with SMTP id a640c23a62f3a-c250bb7ca3emr89034366b.9.1787685054471;
        Tue, 25 Aug 2026 12:10:54 -0700 (PDT)
Received: from localhost.localdomain ([2c0f:ef18:2413:1:98ef:3ae1:52fd:a05f])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a6fd676sm105041266b.17.2026.08.25.12.10.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 12:10:53 -0700 (PDT)
From: Adrian Moisey <adrian@changeover.za.net>
To: netfilter-devel@vger.kernel.org
Cc: Adrian Moisey <adrian@changeover.za.net>
Subject: [PATCH nft] payload: restore is_raw flag for th expressions parsed from udata
Date: Tue, 25 Aug 2026 21:10:48 +0200
Message-ID: <20260825191048.95426-1-adrian@changeover.za.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

payload_expr_parse_udata() restores the pseudo transport header (th)
proto desc from set userdata, but not payload.is_raw. The bison and
json parsers both set is_raw for raw th expressions, which makes
evaluation skip the transport protocol conflict check. Without it,
re-evaluating a map declared with 'typeof ... th dport ...' from a
later transaction fails with a bogus

  conflicting transport layer protocols specified: tcp vs. th

Set is_raw when the restored desc is proto_th, just like the parsers
do.

Signed-off-by: Adrian Moisey <adrian@changeover.za.net>
---
 src/payload.c                                 |  3 ++
 .../testcases/maps/typeof_maps_restore_0      | 28 +++++++++++++++++++
 2 files changed, 31 insertions(+)
 create mode 100755 tests/shell/testcases/maps/typeof_maps_restore_0

diff --git a/src/payload.c b/src/payload.c
index 162367eb..4f1834a0 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -239,6 +239,9 @@ static struct expr *payload_expr_parse_udata(const struct nftnl_udata *attr)
 
 	expr = payload_expr_alloc(&internal_location, desc, type);
 
+	if (desc == &proto_th)
+		expr->payload.is_raw = true;
+
 	if (len)
 		expr->len = len;
 
diff --git a/tests/shell/testcases/maps/typeof_maps_restore_0 b/tests/shell/testcases/maps/typeof_maps_restore_0
new file mode 100755
index 00000000..417e1c3c
--- /dev/null
+++ b/tests/shell/testcases/maps/typeof_maps_restore_0
@@ -0,0 +1,28 @@
+#!/bin/bash
+
+# 'th dport' in a typeof map is restored from set userdata. A later
+# transaction re-evaluating it must not fail with a bogus
+# "conflicting transport layer protocols specified: tcp vs. th".
+
+set -e
+
+$NFT -f - <<EOF
+table ip t {
+	map m {
+		typeof ip saddr : ip daddr . th dport
+		elements = { 10.1.1.1 : 10.2.3.4 . 4242 }
+	}
+
+	chain c {
+		type nat hook prerouting priority dstnat; policy accept;
+		meta l4proto tcp dnat ip to ip saddr map @m
+	}
+
+	chain d {
+		type nat hook prerouting priority dstnat; policy accept;
+	}
+}
+EOF
+
+# separate transaction
+$NFT add rule 'ip t d meta l4proto tcp dnat ip addr . port to ip saddr map @m'
-- 
2.55.0

