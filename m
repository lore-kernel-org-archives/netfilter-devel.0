Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6046734CF5
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 11:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751629209; cv=none; b=GXoHKIroQZ5DdadHn6tSft3hfkpK0KbdQTfDhMMYmgoV7JsxKB3Gc2GTXBrELY3pJkZoMr5tJ/44czYVGHwDtYDw5Q1EzJAC9KIKwwFue3AtWIQ35AxpdLP4XmU+qbD1yTPoaPx/U1PhFh58KBocwp6zlIWFL4yrpWWI9NCXXng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751629209; c=relaxed/simple;
	bh=aqVoU9d4J3G7eP4gdo3Q4W9TdPPas3QwjOZ6g97ItM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGlMuGmkd8UE0r4n78gz7OOYb5oa99+7lljUITbJ2HjO7D6e+ONu1HQ9/91GtpZ3RGQ/2COd1enhJ5/nXGCcXJhhOsVG3C7U+O8WR5jrON8aFwsMnpqVMLzvzj2MflIr2yjRF/dd5eBapnqJKHKtNSESK7IciRIYazA2WCVrW1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PjjJhMzh; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PjjJhMzh"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2349f096605so12519615ad.3
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Jul 2025 04:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751629207; x=1752234007; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eEJtn5CR0QJe9/1YtXXQYKyRHDLdjOwLz/6+gVQ5z6U=;
        b=PjjJhMzhdHAtbC3maCCzY5IPIJOGxeFJEwJQ9y3tMIyXmCYBfHFjcc/jWx5HIAn2TD
         GpYUq3B6KA5mRoEtrurixRNfZsGk20cFkrJt2l9oAFAS8yolmHZDY2AU/oR+B0dntSWg
         MvNXwJiPuOwZrkUKvmMof1PTjMHuP4uOJZnhY5WWqdZhCS+HJojvytf/AJVQ2F8QtG5U
         w+M4uhDlc6n0J9M8PFZMo6fERdmcCI9t71W3lFdJvrtoonhvE/80HtYwNvn314gXx4UW
         WOgfYRhT+HTvxzUL256vj9D29GlwXOsez1XwCIOJp4XidDGePk00Pa3XUOqDweCbbCpb
         gMcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751629207; x=1752234007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eEJtn5CR0QJe9/1YtXXQYKyRHDLdjOwLz/6+gVQ5z6U=;
        b=aC8UEzMRyJpQFfMVoTS6Fp1NlER1hKUQ+YXRm7erq6okkXRJe2ym9OuD7L1G6CdzJW
         9xiIxfh9rx4t4tnB0XhrJliNqDvIRMlaBa6FLy6+SDP78xpHwGob7GJftyY3MBb3Ggrd
         zRpyrMdpNKGLqalwZsTV/57De2LSAjY+JNMcjqWu3BBBufUesFw1/3RXI0cFZkcYMYJA
         Fq5W16G+8BB/SBIC3R6sbgqzM57qf8YxAEdxkGoXs+5orZIcKFcyMnl/NA79NaZ1JUwX
         rx91w8iXo3BR/gyHDc1aPey5DK18rLI6LZXQdm+k3b7mo/NXVyJQ6UHbefm0JqOjRjGP
         rnqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQhjOp25WRlBoDgX0dYtVF7VAs82CHfyRzuhYRdWM8FPvF4M3NGFMajP5qXjR3lYln05HboB4hqqxGMB2F85c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwelqwP7A8RMDrUMJtnBRB8V4jjmezms9LXVBIxuaH/uVCRzap6
	t2Wwz/jojguNcEciNrmWP57QO4w9sbMOUnkgQ+k+1CciVOOf95+NmD9UfjxKDA==
X-Gm-Gg: ASbGncutfnhW2MDOWC4EX78fhFU1pcwFOf/bR41BG0oxJZUAT+8KLKQAKuiUa3fHpWX
	Nz+aYw7WSMtSk7VNcDaAOVjLg7qY5qgvooiswySxhCLCcvdQ4k7H8a82RGFthEW+VBdJuBIEgY9
	fT8i37LJ1eU0O6SiDEq58ZEwfxF4NHaF5BhBhiSghj/PAtSltXxeb4eHksHFMeaCgBfbqeA2Tlq
	Jw/ylPh73e8V6pWPAJX32HYYdYzVonrCzoSzqN5ure8Y0PZ+yRxfvq/x7WG1E5y2umeVBczY6RZ
	aJgPIjXgaDfZjhIgfzAjlWoWdN0XcIwbkBlwageF8TtZIpDjupCmUpOCaYwTU4AzTA==
X-Google-Smtp-Source: AGHT+IHzXDSU7YBCQboTcZ0QipGW2/fbRpog/QHHwRDHCfWAGlpyYjZbq8Ol0WBd3GxKrxq4O+DBlQ==
X-Received: by 2002:a17:902:cf0a:b0:236:6f7b:bf61 with SMTP id d9443c01a7336-23c8755d84amr25522715ad.26.1751629207491;
        Fri, 04 Jul 2025 04:40:07 -0700 (PDT)
Received: from localhost.localdomain ([103.114.158.1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c8455e74fsm19585365ad.99.2025.07.04.04.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 04:40:07 -0700 (PDT)
From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
To: coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Simon Horman <horms@kernel.org>,
	Fernando Fernandez Mancera <ffmancera@riseup.net>,
	Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Subject: [PATCH nft 2/3] src: do not print unnecessary space for the synproxy object
Date: Fri,  4 Jul 2025 11:39:46 +0000
Message-ID: <20250704113947.676-3-dzq.aishenghu0@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250704113947.676-1-dzq.aishenghu0@gmail.com>
References: <20250704113947.676-1-dzq.aishenghu0@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If timestamp is not enabled in the synproxy object, an additional space
will be print before the sack-perm flag.

Before this patch:

table inet t {
	synproxy s {
		mss 1460
		wscale 8
		 sack-perm
	}
}

After this patch:

table inet t {
	synproxy s {
		mss 1460
		wscale 8
		sack-perm
	}
}

Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
---
 src/rule.c                             | 4 +++-
 tests/shell/testcases/json/single_flag | 4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index c0f7570e233c..af3dd39c69d0 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1951,7 +1951,9 @@ static void obj_print_data(const struct obj *obj,
 		}
 		if (flags & (NF_SYNPROXY_OPT_TIMESTAMP | NF_SYNPROXY_OPT_SACK_PERM)) {
 			nft_print(octx, "%s%s%s", opts->nl, opts->tab, opts->tab);
-			nft_print(octx, "%s %s", ts_str, sack_str);
+			nft_print(octx, "%s%s%s", ts_str,
+				  flags & NF_SYNPROXY_OPT_TIMESTAMP ? " " : "",
+				  sack_str);
 		}
 		nft_print(octx, "%s", opts->stmt_separator);
 		}
diff --git a/tests/shell/testcases/json/single_flag b/tests/shell/testcases/json/single_flag
index f0a608ad8412..b8fd96170a33 100755
--- a/tests/shell/testcases/json/single_flag
+++ b/tests/shell/testcases/json/single_flag
@@ -157,13 +157,13 @@ STD_SYNPROXY_OBJ_1="table ip t {
 	synproxy s {
 		mss 1280
 		wscale 64
-		 sack-perm
+		sack-perm
 	}
 }"
 JSON_SYNPROXY_OBJ_1='{"nftables": [{"table": {"family": "ip", "name": "t", "handle": 0}}, {"synproxy": {"family": "ip", "name": "s", "table": "t", "handle": 0, "mss": 1280, "wscale": 64, "flags": "sack-perm"}}]}'
 JSON_SYNPROXY_OBJ_1_EQUIV=$(sed 's/\("flags":\) \([^}]*\)/\1 [\2]/' <<< "$JSON_SYNPROXY_OBJ_1")
 
-STD_SYNPROXY_OBJ_2=$(sed 's/ \(sack-perm\)/timestamp \1/' <<< "$STD_SYNPROXY_OBJ_1")
+STD_SYNPROXY_OBJ_2=$(sed 's/\(sack-perm\)/timestamp \1/' <<< "$STD_SYNPROXY_OBJ_1")
 JSON_SYNPROXY_OBJ_2=$(sed 's/\("flags":\) \("sack-perm"\)/\1 ["timestamp", \2]/' <<< "$JSON_SYNPROXY_OBJ_1")
 
 back_n_forth "$STD_SYNPROXY_OBJ_1" "$JSON_SYNPROXY_OBJ_1"
-- 
2.43.0

