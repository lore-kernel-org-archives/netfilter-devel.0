Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1F123A6
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Dec 2023 03:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NC2LQScu"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-427dcdebf8fso13043131cf.3
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Dec 2023 19:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703646344; x=1704251144; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UoMsOgBSRMKiDhdInGUkFScshi+WtiSZ3pTd8KEvw5Q=;
        b=NC2LQScuLu3Bmvy8tDTiPHqY7C/4ykjwOuwrAho+5lOf3eK8tnIFqBvi9yVCnR6FVf
         e6daKEtdD/r4sCE2uqSzCJ84+FxA8uPeJEn+CtdSHbbB56mI4Rjwd4P2FgyYhlbBTV6u
         oO7qzEaBYkIig9ZjszKanAdc1pa4BxwqG2kav13swk4F1xIrI+SgiAHOdhmhm1SsxdPP
         608O5vC4hcuOreBhIdBZVZ00QfD366ZRt/6D20IemFPwgPs6QUwvTOYZND02ZqvBzeeq
         7vA8GMZyKVWhV022jO315fu1Gxhq9Z5eu0ucjaN1NpluO+XOPkqmMyiw+dOwu6Au9xuf
         EAuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703646344; x=1704251144;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UoMsOgBSRMKiDhdInGUkFScshi+WtiSZ3pTd8KEvw5Q=;
        b=J4MG+h8X7wOHoSHE/sG7K/Zzwth5O1NfCLRGo8yC5cALhQQtlV5nUT29loR0hdSYMu
         HNYCSvUlBQU7Lcwjgy77aUoBN2dPHoPunuhPMGarzD0k2j9S+O6FDC73uxDe07yL/sib
         PsjJ2HNdmIx5DeraGobhshkx7UAuh2PDBzBhpWyVNnjDY+bgxHCaUMMwkb5gYpP/3Qrw
         QFs49O22QFcbFyzGO5v0MpFkohQy6NA+FLp3c+4xDOq5E8yYM0yLNaGyX8NycGoQn8Sg
         L+mLN1k6X83y1l6ybXwiik6uYlNRFtAznSmpL7dHLdyv/fx5XCK/VsVcyNW7eCrmo3wE
         4MIA==
X-Gm-Message-State: AOJu0Ywa8HCiXj3YZgvq6hNsrX8XD2nPdydflrN5BngoQxYnhMMZYcyw
	F536eT66lM6lkwt1rY0AmcseXtzj40I=
X-Google-Smtp-Source: AGHT+IG8aamBxZk4SvyjjZYX59uwOZwwoJ2Rn68IO+GrH3sZF5jdlfA1bnt6PZYbAkPHDHcJgXRkzw==
X-Received: by 2002:a05:622a:54:b0:427:934e:694d with SMTP id y20-20020a05622a005400b00427934e694dmr12166635qtw.86.1703646343696;
        Tue, 26 Dec 2023 19:05:43 -0800 (PST)
Received: from localhost.localdomain ([2602:47:d950:3e00:484:442e:1453:8142])
        by smtp.googlemail.com with ESMTPSA id hh3-20020a05622a618300b0042542160fd0sm6629143qtb.20.2023.12.26.19.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Dec 2023 19:05:43 -0800 (PST)
From: Nicholas Vinson <nvinson234@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Nicholas Vinson <nvinson234@gmail.com>
Subject: [libnftnl] chain: Removed non-defined functions
Date: Tue, 26 Dec 2023 22:05:17 -0500
Message-ID: <f5b5ce9e42b038cb43064764385813fedd556bf1.1703646281.git.nvinson234@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The functions nftnl_chain_parse(), nftnl_chain_parse_file(),
nftnl_set_elems_foreach(), and nftnl_obj_unset() are no longer defined
and removed from the code.

The functions nftnl_chain_parse(), nftnl_chain_parse_file() were removed
with commit 80077787f8f21da1efd8dc27a4c5767ab47a1df6.

The function nftnl_set_elems_foreach() does not appear to have ever been
defined.

The function nftnl_obj_unset() does not appear to have ever been
defined, but declared within commit
5573d0146c1ae71ac5b3e4ba6a12c00585646a1a

However, libnftnl.map still lists these functions which causes libnftnl
to fail to link with ld.lld as the option --undefined-version is
disabled by default.

Fixes Gentoo bug 914710 (https://bugs.gentoo.org/914710)

Signed-off-by: Nicholas Vinson <nvinson234@gmail.com>
---
 include/libnftnl/chain.h  | 4 ----
 include/libnftnl/object.h | 1 -
 src/libnftnl.map          | 5 -----
 3 files changed, 10 deletions(-)

diff --git a/include/libnftnl/chain.h b/include/libnftnl/chain.h
index f56e581..bac1f5f 100644
--- a/include/libnftnl/chain.h
+++ b/include/libnftnl/chain.h
@@ -71,10 +71,6 @@ struct nlmsghdr;
 
 void nftnl_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_chain *t);
 
-int nftnl_chain_parse(struct nftnl_chain *c, enum nftnl_parse_type type,
-		    const char *data, struct nftnl_parse_err *err);
-int nftnl_chain_parse_file(struct nftnl_chain *c, enum nftnl_parse_type type,
-			 FILE *fp, struct nftnl_parse_err *err);
 int nftnl_chain_snprintf(char *buf, size_t size, const struct nftnl_chain *t, uint32_t type, uint32_t flags);
 int nftnl_chain_fprintf(FILE *fp, const struct nftnl_chain *c, uint32_t type, uint32_t flags);
 
diff --git a/include/libnftnl/object.h b/include/libnftnl/object.h
index 4b2d90f..94d6b94 100644
--- a/include/libnftnl/object.h
+++ b/include/libnftnl/object.h
@@ -122,7 +122,6 @@ struct nftnl_obj *nftnl_obj_alloc(void);
 void nftnl_obj_free(const struct nftnl_obj *ne);
 
 bool nftnl_obj_is_set(const struct nftnl_obj *ne, uint16_t attr);
-void nftnl_obj_unset(struct nftnl_obj *ne, uint16_t attr);
 void nftnl_obj_set_data(struct nftnl_obj *ne, uint16_t attr, const void *data,
 			uint32_t data_len);
 void nftnl_obj_set(struct nftnl_obj *ne, uint16_t attr, const void *data) __attribute__((deprecated));
diff --git a/src/libnftnl.map b/src/libnftnl.map
index ad8f2af..02d8b34 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -47,8 +47,6 @@ global:
   nftnl_chain_get_s32;
   nftnl_chain_get_u64;
   nftnl_chain_get_str;
-  nftnl_chain_parse;
-  nftnl_chain_parse_file;
   nftnl_chain_snprintf;
   nftnl_chain_fprintf;
   nftnl_chain_nlmsg_build_payload;
@@ -174,8 +172,6 @@ global:
   nftnl_set_elems_nlmsg_build_payload;
   nftnl_set_elems_nlmsg_parse;
 
-  nftnl_set_elems_foreach;
-
   nftnl_set_elems_iter_create;
   nftnl_set_elems_iter_cur;
   nftnl_set_elems_iter_next;
@@ -274,7 +270,6 @@ global:
   nftnl_obj_alloc;
   nftnl_obj_free;
   nftnl_obj_is_set;
-  nftnl_obj_unset;
   nftnl_obj_set;
   nftnl_obj_get;
   nftnl_obj_set_u8;
-- 
2.43.0

