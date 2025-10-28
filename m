Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C57B27510E
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 16:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761670577; cv=none; b=BzJmX1+VHQMsF8r+FPhSQjxSoV3BaK/xtyiJeRJFcMpdO1yke6iE3m1QvTliUSlx6opOQUHe3V87wDKr09prVdcRZMdn0qYVyQOttEea6xZzS5mWElrL9E1qzdktX4/2M+VzgsHPJycTyTkQZHkRsvrlv2qYyk//bvn2kkzIiz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761670577; c=relaxed/simple;
	bh=ebxJ4Uq7hCQ7+ffV3X6AZpZUgPmt6G1l5DPc78yJCWE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WODInPsqtxRk+KvfpAyG/rjJkc9d3zEE/0nOxL54QdbN+LT+xRYrPSerMno+XtivdppTYWn4HbBqKdnoQWqtw+J+89PmpEoBQuIkuiapJFcpoFUsyo5nyNqYL7BKWjOu0vsh8lBiLqnGX+rdgkr4GlSYTlbpqX/jWzjevA+MD/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io; spf=pass smtp.mailfrom=vyos.io; dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b=PkN3Fls6; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vyos.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b="PkN3Fls6"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b6d6c11f39aso135144366b.2
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 09:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vyos.io; s=google; t=1761670573; x=1762275373; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZHL0j4k6KYEeT5CO33gDzN0Ka4Dw7UDn9JDP71GdOJo=;
        b=PkN3Fls6AudRQvCgI8wDxJKrTpl4zoq4f7O9TlCZfbauzVqnoHSmd8eK4M+Wbei89W
         MTxjaQHkrj6Wn+F9qxCQHHjJHeMh5ofg2g45OJSa9GeGBDXOmQeyshVKxhsROoK7S5dA
         kl8n8e8PHnJsjxa7EboZGZmpvIxZIpYv3TNTQfgkaYu3puR1hI3dYrXthtOUhdooh1Bb
         0Wi/hhyKoW8DfmU9Qo0Jka0j/P6Xl9GnVQAiLMGzG9yQF2DYj/WGhDuOR9mSwuZtIFF0
         o26+YVlXtKd8xAAdiz0Uc2jniaY8RgVe+Z45Lnr0jpJ2h097YomH9bWoGoPFhx/+F7G+
         QShA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761670573; x=1762275373;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZHL0j4k6KYEeT5CO33gDzN0Ka4Dw7UDn9JDP71GdOJo=;
        b=AwQRXIJCFdeNr3SyeTdCN+VHgvzoK0oFnHdhd/6WeoKK96QygfXvnOPlsu2jSRSUAt
         aCRct8PSHuxVCX/UPiUCEazuAmwyIZBeKdcD8A9t8KU/krQkAzIl2+LWNiDnCYq9zcCq
         RIZc/Iw5nHi7YLeY82gYosMupQ6BNkleaXJ73tKOti3xGn/fyXZeqfNjZDovunFWYgrr
         9lK0KR5cemo+R01WhjCzI0dtK3B0fNWBPN2R8G5eBcgYFsblpIdt986dzDBVUsu0WmWL
         qIPppsBMvhGn4cU4MfvbXLvj+iNlrrSoxg+G5DoEU4r3FMBjdMrVVnMFC7lfUsDVVMxD
         JxYA==
X-Gm-Message-State: AOJu0YxDaY4+uGWUhrzS6vAl6U7l93WR+ZkJykAVhAHeA+uGupzHFFRE
	VAZkrRmM4he1HXY51TFqXQjQWR8nCPnllNQT6Z816ErtKeLG8NTQBzDPNlOXY3HPu5pQZRuDPDr
	CS6iG
X-Gm-Gg: ASbGncuglMfCG2meAKDtJp35gJ4LJLcD0S325gY5OpHcWwo2DDkwcnqIgB9oZp4JRGo
	zVege/0AJwg8gssggfBLfE1BRg1rSjjh8L/ci90QFUr+Qw7Libfl/gkzmFNLYmlS78TScCY+vF9
	1bG9R1zqN3f2RliZlMN6rNo0Me2UFBNIRMYqdggssimNakORdgYPJJQDJJTnTVcbWOXECYuV5yL
	39Mi86fWylmmvrkq1JG2Q7HKKnF8hbV9u16/azAQpMqOSkm10ROBkUN8e5DtmepJmoAawWJDniG
	WEESybexuK1FDFqHIPEcFDIbPinIvet/QouLWPMcmiUOykg4r8QS/Kx1413aEvJmRriblmZ5v8e
	S6MyDbzwqbeKaOQzF1kRRiGBn5hu2NiUII7gKXqTcSTEN+5EbXsz3o/jAja7NLNQ2IjSaDed8KF
	qGnKyb/ZdfLOkjEA/JN44tt/Sg
X-Google-Smtp-Source: AGHT+IEd1+FxQooQu/TXnLO7mD1M1Cc1CYYInsQWYEREuvP/tvORApMI1yam2lHnDm2PyQM4iIyGlQ==
X-Received: by 2002:a17:907:3c8b:b0:b57:d379:7f5e with SMTP id a640c23a62f3a-b6dba4631dfmr462989766b.2.1761670573354;
        Tue, 28 Oct 2025 09:56:13 -0700 (PDT)
Received: from VyOS.. (213-225-2-6.nat.highway.a1.net. [213.225.2.6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d8541fb5bsm1138462566b.56.2025.10.28.09.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 09:56:12 -0700 (PDT)
From: Andrii Melnychenko <a.melnychenko@vyos.io>
To: netfilter-devel@vger.kernel.org,
	fw@strlen.de
Subject: [PATCH v2 2/2] tests: shell: Added SNAT/DNAT only cases for nat_ftp
Date: Tue, 28 Oct 2025 17:56:07 +0100
Message-ID: <20251028165607.1074310-3-a.melnychenko@vyos.io>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251028165607.1074310-1-a.melnychenko@vyos.io>
References: <20251028165607.1074310-1-a.melnychenko@vyos.io>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Added cases for SNAT or DNAT only for active and passive modes.

Signed-off-by: Andrii Melnychenko <a.melnychenko@vyos.io>
---
 tests/shell/testcases/packetpath/nat_ftp | 32 ++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/tests/shell/testcases/packetpath/nat_ftp b/tests/shell/testcases/packetpath/nat_ftp
index bc116f6e..97161025 100755
--- a/tests/shell/testcases/packetpath/nat_ftp
+++ b/tests/shell/testcases/packetpath/nat_ftp
@@ -144,6 +144,18 @@ reload_ruleset()
 	load_snat
 }
 
+reload_ruleset_dnat_only()
+{
+	reload_ruleset_base
+	load_dnat
+}
+
+reload_ruleset_snat_only()
+{
+	reload_ruleset_base
+	load_snat
+}
+
 dd if=/dev/urandom of="$INFILE" bs=4096 count=1 2>/dev/null
 chmod 755 $INFILE
 assert_pass "Prepare the file for FTP transmission"
@@ -190,9 +202,29 @@ reload_ruleset
 test_case "Passive mode" [${ip_rc}]:2121 ${ip_rs}
 
 
+# test passive mode DNAT only
+reload_ruleset_dnat_only
+test_case "Passive mode DNAT only" [${ip_rc}]:2121 ${ip_cr}
+
+
+# test passive mode SNAT only
+reload_ruleset_snat_only
+test_case "Passive mode SNAT only" [${ip_sr}]:21 ${ip_rs}
+
+
 # test active mode
 reload_ruleset
 test_case "Active mode" [${ip_rc}]:2121 ${ip_rs} "-P -"
 
+
+# test active mode DNAT only
+reload_ruleset_dnat_only
+test_case "Active mode DNAT only" [${ip_rc}]:2121 ${ip_cr} "-P -"
+
+
+# test active mode SNAT only
+reload_ruleset_snat_only
+test_case "Active mode SNAT only" [${ip_sr}]:21 ${ip_rs} "-P -"
+
 # trap calls cleanup
 exit 0
-- 
2.43.0

