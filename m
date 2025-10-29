Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF352C21E2
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 00:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761697871; cv=none; b=bHh0xflq1KWVnVprAykHDk1t6/uZwR9RBWAtDqDH0smD3ZgU3su+9TrBFX/uPYlMTX7phbYU923GgYAVB7Bnxt1f6FLVRRe3CoxPxZDEHyP15VzTZFTcGA00c1lMVYb3iB/po/9dTybwzDjVu9lcd0u0hSXk1dCgNBE98UEwjlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761697871; c=relaxed/simple;
	bh=FjeBJ7qTOOuFy5XC/P8ENdKUZAwjK0jGghsUJJ5YXyg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LgDzpUcR5Yhrj1QK7IuBUgyha4I9Li3Abk0f81HiMyHdd31E182aWPg1jxokrCpVSpq1teB4rAMrD6cO6H8Xyqddo5DzYkr1v6QjTbA0A3o9B4FVr/HpGzpw3/Mo0LN3/uJgdOVoM2XAV6TCrcvjaMpLrdz10sCb/OwrV4pK1v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YVh1R5a8; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YVh1R5a8"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-475dc6029b6so38537785e9.0
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 17:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761697865; x=1762302665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IStlHAPGFAuv66IOHetCckKbHriTUSVQfUzkY0LaiRc=;
        b=YVh1R5a8B5i8aDuTG/qN0FVmeDmHXXYeod0BseSHT4zFYeQda//hITsekgXvI2U/BI
         fd0m2Xjl21P5t77PTb4spioD9/q1R021KQIqA1b+wmKNJKSoa6P5m29pyjzYDtxteNwd
         uziNoBq3c9lMrwG6HmPDv14ezHaXroXSQ74totBtz3KXks724MmnfoN1UG0NjibpRfDO
         UM197wYfj3qMl8Evyy67HEzGQuCn/ZL8HbhC7kI9ZUGazMAYDolr40qyCfUOULWwSPz2
         nxhAjbpuvsFBHITj4QV09kTdPdJsbf+0nOWePvlgI8ZcmurhOS+oxNemEXvS3eRD3Qhp
         KLvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761697865; x=1762302665;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IStlHAPGFAuv66IOHetCckKbHriTUSVQfUzkY0LaiRc=;
        b=ASlMM29G0n7lhAC4Mpq/B+8mXEbyuNeoj0KF/QvbRaoj0JvfnuYK4/mYPDUb2VZWb5
         GKYFTsZucdOPuGVtnkJUgTZ4+4r6LA23FkpUn9c7K37pi+CBzz6z6Is5pv0WJxBWUmut
         ez5QOaTobzDMNLKA/wxjE98+tnZI8dhh+ltJpDwlLalV4h6NkmMyJsLI1cyNgV3Fjt4T
         3k2cr0ejncazxV3mzc+C1zGdAKgN6XKkWTXWzfw8xez0g8LDjPBohAEvkycCx5Nq+R0o
         cYRfvuW2uNfz9XDfnclqUBpdABPEZyUDKCJnuehnOHatcOjM4FzRvddI31Bq+nCKBeBU
         KgiA==
X-Gm-Message-State: AOJu0YygLxOUZx4n3RZRghPVm2w+8kml9IcVCPa+QryMFKRa46oFITv/
	16Rhpqm/0a9StvU4/7daBQHBqSHFJTnlZATS8r3VtzSzxi4EEoJAwW+4mBPAqQ==
X-Gm-Gg: ASbGncunV07wXkVf5uUQyAtBjrlBXP2ld7EJO5Jc7oD/Gfu/tb7dX6LQDTtLU/uwFEy
	v1yqxSSRLO6bhHykmwMZXrWh/fEUT8PqYXMH9XuUFgeSvYMI7MudIb40pplW4EL6LQkMk54GKsz
	n/1JhmPbywkiETOmQBm+tCmwxBwp5FMugvO6qIT3/gDCuHZXeza2sfE/16/nBrSSnz1s12fiQOk
	/FHeDJoy3H8J3gGbGe9H3gIJN0Crla6VTjlOucvUdIuaATHUMczuFhhHI9BMADt3cCTrwJxjt/7
	Ui6YJC/ZOBycWIbkvXZcy4evKIlSMfIzZY9EZPpuY+WIpUiTrG2sb3ZP7D3n5BiOHjGxdxZdsdJ
	3mY5Sr+Rpl4RnLMtOVJFjqzg8eLaCUyRFhj7NPCKHCS/RjossyBd58TLchOwH8Udh1DTvdUMtF3
	uyx4UJKAXLPpTfV0yzqmH+CiMC6aQqenRfi2aflUAk/7jEGMQ=
X-Google-Smtp-Source: AGHT+IFum1ku0bKJnOQHD47btEXv8+XIvP+eW+NcROPPuevWJf0k1sEHg81PxlwJr267W0jtKp7ujQ==
X-Received: by 2002:a05:600c:608b:b0:475:de12:d3b2 with SMTP id 5b1f17b1804b1-4771e1f1dc2mr10346065e9.36.1761697864866;
        Tue, 28 Oct 2025 17:31:04 -0700 (PDT)
Received: from pc-111.home ([2a01:cb1c:8441:2b00:c694:3c2c:878b:f4c0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952cb7dcsm23838309f8f.11.2025.10.28.17.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 17:31:03 -0700 (PDT)
From: Alexandre Knecht <knecht.alexandre@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Alexandre Knecht <knecht.alexandre@gmail.com>
Subject: [nft PATCH] parser_json: support handle for rule positioning in JSON add rule
Date: Wed, 29 Oct 2025 01:30:44 +0100
Message-ID: <20251029003044.548224-1-knecht.alexandre@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch fixes JSON-based rule positioning when using "add rule" with
a handle parameter. Previously, the handle was deleted before being used
for positioning, causing rules to always be appended at the end of the
chain instead of being placed after the specified rule handle.

The fix follows the same pattern used in json_parse_cmd_replace():
- Parse the handle field from JSON
- Convert handle to position for CMD_ADD operations
- Remove the code that was deleting the handle field

With NLM_F_APPEND set (as it always is for add operations), the kernel
interprets position as "add after this handle", which matches the CLI
behavior of "add rule position X".

Before this fix:
  nft -j add rule ... handle 2  --> rule added at end

After this fix:
  nft -j add rule ... handle 2  --> rule added after handle 2

The CLI version (nft add rule ... position X) was already working
correctly.

Tested with:
  # nft add table inet test
  # nft add chain inet test c
  # nft add rule inet test c tcp dport 80 accept
  # nft add rule inet test c tcp dport 443 accept
  # echo '{"nftables":[{"add":{"rule":{"family":"inet","table":"test","chain":"c","handle":2,"expr":[{"match":{"left":{"payload":{"protocol":"tcp","field":"dport"}},"op":"==","right":8080}},{"accept":null}]}}}]}' | nft -j -f -
  # nft -a list table inet test

Result: Rule with port 8080 correctly placed after handle 2 (port 80).

Signed-off-by: Alexandre Knecht <knecht.alexandre@gmail.com>
---
 src/parser_json.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 7b4f3384..c974a9e2 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3197,10 +3197,18 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 		return NULL;
 	}
 
+	/* Parse handle and index (similar to json_parse_cmd_replace) */
+	json_unpack(root, "{s:I}", "handle", &h.handle.id);
 	if (!json_unpack(root, "{s:I}", "index", &h.index.id)) {
 		h.index.id++;
 	}
 
+	/* For CMD_ADD, convert handle to position for rule positioning */
+	if ((op == CMD_ADD || op == CMD_CREATE) && h.handle.id) {
+		h.position.id = h.handle.id;
+		h.handle.id = 0;
+	}
+
 	rule = rule_alloc(int_loc, NULL);
 
 	json_unpack(root, "{s:s}", "comment", &comment);
@@ -3226,9 +3234,6 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 		rule_stmt_append(rule, stmt);
 	}
 
-	if (op == CMD_ADD)
-		json_object_del(root, "handle");
-
 	return cmd_alloc(op, obj, &h, int_loc, rule);
 
 err_free_rule:
-- 
2.51.0

