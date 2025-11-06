Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA3C1DA55
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Nov 2025 09:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762420584; cv=none; b=txCMtER+d9L7ozTR7fr451+WIv4WgVUtzRkCAd1qv6jexEKvAV4k3Jvnst5d2u1ldEr1w0MnHTDJT10J36RglmXu/kvUBvG61q0Zm+rXL3+BXboWvXXRbTjsFom4V1oIFhjx4oPfaAISvPxcpJyWoS7ttmTD0qKx8b0EMfe4uF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762420584; c=relaxed/simple;
	bh=WbJGUIA5aZMIVrr95eLS5hzMiTycKTAX0wSyvw6cSVc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SvMV5MaqfBBTfrbQSvbI5t0ofTFoI8U+gYEhts5W0OeOXDg7sBX63+/J0fsNC+O6Lvq5lNC5n5dAmaWnNa+b2V9PXH/Xu5XtnGePkHl3yj5d0UtB83MCyk4mRZTBghEnHNnEgMaABdvOwsZenYdT3T66GMujiqPjIvLXe9qtM5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CcdQVu5o; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CcdQVu5o"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3ece1102998so396913f8f.2
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Nov 2025 01:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762420581; x=1763025381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3mJGM5LR17pJDWn55uOgJD4bSkGEi+VF3Beehx1FeZk=;
        b=CcdQVu5oESuF01FXaI2YstV7LB8pXjfgF9YoTfgOk3xRUaW/IwdEcOvIVAMoCXMcYa
         PswefuT7YXM1c5ExThHpFdOVjWlynQK5PLj6fBURrqg3xUaYUyvihk4A4KYOY7AP8Enb
         MqI8B81Aj+UPVYTQeO2/nEbjUNgfjZXc+l18MiBrspkGYeWoNvUna2kHqsqrqNxIiuaZ
         uq1vUKyMPvTqkmS1MlRQyUjN7KSN+2QRkRRpDj4NG8i7EMTOEzKWPugGrvVTMPP4nJ9c
         zaQlpRia0PAMXAXJAqP4aj1dLR8Ru+b5AelLEga7vyrjhPGK4wFcILDeNSwDT0FAs9Ai
         a+mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762420581; x=1763025381;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3mJGM5LR17pJDWn55uOgJD4bSkGEi+VF3Beehx1FeZk=;
        b=fbxD2i0nKRthdmEno7moQSC3XcJ22MmRdvXOl23yIoCFbH+GM5UGFTb8WqDbMcdcRY
         zK4wP5irJC7lzCsVgPBRRenkbqC6mlbpzxhEsWLSFFR0h130tkuHwE3q43Z6e4lJ+h6E
         EQY9jOivv0t4IuHLzhN2T/FUCgxx8VgwFEKrPA9x2Z0BTxh7n0rYdkLKKSatsg/DZYcM
         JTaq4Z6ET/dbv+ze07L9SM5XcitKphLtMdUjSJi18/r3137uqVtS+r4JbPMSF2H3RFIC
         K24mEPVl/FtKR3MY3GiFJwoqQrtI5mFB3+27RHsw8fiiT7egTW44pwxK+35EmxnsT3bS
         5MUA==
X-Gm-Message-State: AOJu0YxuhuuKF54TRkUAUk2IYP+LsWIiy4RnUhZLQXVfsaJxYFr5zrtB
	C5Nvv91Qz8y0FnMvqUOXwJCrHV2v3NZ/JeFWpuHYOK1N54sgGM6Sy8NSpuiPaQ==
X-Gm-Gg: ASbGnctMzZBcwMUWuAji/geF8QOAQwbaOw2W+JEysy31692lkp5SKYQp77qAB/fSiRm
	g5PuNUTISY1AZj8q75hEQvPSNVLPeR5qtDlV+GDeCrBd3nn/5IhncLrNdcNrq9somAo9Znj6S1G
	78DmAb/SKhjnd+2Ve8S/Fkh4IhP+pSESYpD1QT6cwhGfCmIMeR+lyeqyXARyd9I39SsrjUD5yph
	s0gj8WFwWMi7jVikO/0dYqmSaV+gKxI68GijFLg5XIUBM7Y64woCFNTMAGOMjHbz0DVkx5LFBWS
	alBPdhOLGLfMt4I04rLnGcMy42JS6vf9vRF2FCJH1PFLZi1vEgX+6hMalc/pturAsaIqvbCgeiZ
	RcRWRiOUMt0+muMA34Yvf9D6WsVM8ITPS21bXOlJcYYSa0RR/grNLVxMzERnSUHE+83DtKjEXRR
	qp7bDOGsycYYf+canKt8ig9VlWhH9k8NYq/TPu81EpiMAdjLGwZTGuNiDvtA==
X-Google-Smtp-Source: AGHT+IHEI6OqhTRmDX0tvc7eu/qnOOOF51OOOd53Bqx6U4KMYE1wLQ2a1fCmTE8zZaJdGddQJGKM4w==
X-Received: by 2002:a05:6000:400f:b0:428:3cd7:a340 with SMTP id ffacd0b85a97d-429e33063c0mr5338874f8f.35.1762420580497;
        Thu, 06 Nov 2025 01:16:20 -0800 (PST)
Received: from pc-111.home ([2a01:cb1c:8441:2b00:c694:3c2c:878b:f4c0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429eb410f5csm3683270f8f.13.2025.11.06.01.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 01:16:19 -0800 (PST)
From: Alexandre Knecht <knecht.alexandre@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	phil@nwl.cc,
	Alexandre Knecht <knecht.alexandre@gmail.com>
Subject: [PATCH nf v3 2/2] doc: clarify JSON rule positioning with handle field
Date: Thu,  6 Nov 2025 10:16:09 +0100
Message-ID: <20251106091609.220296-1-knecht.alexandre@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The existing documentation briefly mentioned that the handle field can be
used for positioning, but the behavior was ambiguous. This commit clarifies:

- ADD with handle: inserts rule AFTER the specified handle
- INSERT with handle: inserts rule BEFORE the specified handle
- Multiple rules added at the same handle are positioned relative to the
  original rule, not to previously inserted rules
- Explicit commands (with command wrapper) use handle for positioning
- Implicit commands (without command wrapper, used in export/import)
  ignore handle for portability

This clarification helps users understand the correct behavior and avoid
confusion when using the JSON API for rule management.

Signed-off-by: Alexandre Knecht <knecht.alexandre@gmail.com>
---
 doc/libnftables-json.adoc | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index 643884d5..4391cdb0 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -122,7 +122,9 @@ ____
 		'CT_TIMEOUT' | 'CT_EXPECTATION'
 ____
 
-Add a new ruleset element to the kernel.
+Add a new ruleset element to the kernel. For rules, this appends the rule to the
+end of the chain by default. If the rule contains a *handle* or *index* property,
+it is inserted *after* the rule identified by those properties.
 
 === REPLACE
 [verse]
@@ -143,9 +145,14 @@ Identical to *add* command, but returns an error if the object already exists.
 
 This command is identical to *add* for rules, but instead of appending the rule
 to the chain by default, it inserts at first position. If a *handle* or *index*
-property is given, the rule is inserted before the rule identified by those
+property is given, the rule is inserted *before* the rule identified by those
 properties.
 
+NOTE: In explicit commands (*add*, *insert*, *create* with command wrapper), the
+*handle* field is used for positioning. In implicit commands (bare *rule* objects
+without command wrapper, as used in export/import), the *handle* field is ignored
+to ensure portability across systems.
+
 === DELETE
 [verse]
 *{ "delete":* 'ADD_OBJECT' *}*
@@ -299,8 +306,13 @@ Each rule consists of at least one.
 	*add*/*insert*/*replace* commands only.
 *handle*::
 	The rule's handle. In *delete*/*replace* commands, it serves as an identifier
-	of the rule to delete/replace. In *add*/*insert* commands, it serves as
-	an identifier of an existing rule to append/prepend the rule to.
+	of the rule to delete/replace. In *add*/*insert*/*create* commands, when
+	present, it specifies positioning relative to an existing rule: *add* inserts
+	the new rule *after* the specified handle, *insert* inserts *before* it. When
+	multiple rules are added at the same handle position, they are positioned
+	relative to the original rule, not to previously inserted rules. In implicit
+	rule objects (without command wrapper, as used in *nft -j list* output), the
+	handle field is present but ignored on input to ensure export/import portability.
 *index*::
 	The rule's position for *add*/*insert* commands. It is used as an alternative to
 	*handle* then.
-- 
2.51.0

