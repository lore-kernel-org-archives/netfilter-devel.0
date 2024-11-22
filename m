Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF7B176AAE
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Nov 2024 22:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732313103; cv=none; b=Ars781TOlW8Es3WsCYcT4BpcRVvqFPm4QKj3aoGJStbI/Myaj7C1RIMKXkFLzZUUJCSHOsNSMfzSP0Aabzdr2aqhlDQ000Z3u+LjuLw1AgkYCrClFluam/E8GTiHiet4V47dELcYqQS4K7zArrCLTM1hmtXIwQiMzckj4/yiO5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732313103; c=relaxed/simple;
	bh=fcw6YODCoECXzfeWxXSl6j04gE6jDRvUIKhLCJhPe8g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eIu6+sjI7/WDB9Vs5cQFrz9VEMQTh5+fSKsQFhgRBdKV/cVhDlnEEOwbTBTxfYZh0b3itF8bcQyA1v5fXkU6nJYlaPqENnP9S7uUJVzaVEy5S+tT2nXUrjIbyUN5nsqs4v4gpozjqRhAAXDYG5DhWo/S7HnHL8esEACjAn/7/aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kkPjFWm7; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kkPjFWm7"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6d41eeca2d6so17593406d6.1
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Nov 2024 14:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732313100; x=1732917900; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nrFdnCjgOzIlIVVDoe2qGrJrB+2UzDVpUvYZfE1THVI=;
        b=kkPjFWm7yCjO3giUfW7CCHpKcbi7OvP44Q1k+nBO5FDQQeR7tH6bynDxv+C6GvGF0Q
         6VlzTgOSS4TWYr3MbQuQ+woZC5xcKkxR4rDSu7oQhF8lwv65f1Wsr22G/7ugZttsE7om
         6/C4MjbZew3N/T5aTKletvG6CYNSSGPlE99+zIrYALngL1zw+nN8NM0evCF8JToAMGYD
         9umzkCeK28H3rSror3SB0ip/XFfJS4hXqTW+FQ9O9XB1dNBT4lE6bIhsHOzb0vonilbc
         LDuPfSpG4x2u0DiUZRiN8MrBJobNhZDEuiue/7jXX2o3CeRdH3Y2aC6LQOa8liP/hjgb
         5yog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732313100; x=1732917900;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nrFdnCjgOzIlIVVDoe2qGrJrB+2UzDVpUvYZfE1THVI=;
        b=i25T3BhM2hPXhtY0jabd/P1aZ+/PtxlTJGEPbd8knFE2TRhiwzD6mNNcQcKLmVmaa+
         S2Izk/9XEfgt3e1feuKp8dsZ0d9akxsXPwZwYPvIfvNiIpa5FeDmMSEopQwsPtQUW+d0
         kPPueNmKUHK8ZAerSNwGgZ1z/elp5+V0V8JVkP/fBgXb7qkONorzVsRl9bK5yGKchUtm
         H81uNKWG6R+3A6cc2QUF7nCDHIZVlN+XmwThUrvnquls1WBr3HLMZqjO7QfBN/NIXrbf
         vBLejyFyQxPoGVcn898xfbrx2txGRJX517pfocsl4IdrrHSIf34L9PE+aYJNp173W7Om
         1cYA==
X-Gm-Message-State: AOJu0YzRbqgwygWPldDlNu5xSEhoDrsuDtPSlqHAEaVdwyOG+yq+HQ3A
	N9s8jRjE5Sb4Qr/c2LslozmBtnQoHwXn5U1oEZ5QWQ+uk94lH0NtnslQjQ==
X-Gm-Gg: ASbGncswHeYs1V7JVfDPHasudy0saMnS8lGDiHkf+JkfnvAfZgmhvN66C/Yn1jqs1Nw
	tbcNsVWZvC/cFHT/YSwl9+qQxt3rhWJcXOwsVkpIQ6JciFk5v4Ki058ciVpvoYHi8PgP7Ba+4pj
	1KGQ2CrUPBLMDpjbLgIBD/vXYiSPL5N2xTNSk8ua+MtOJ39N2ELkWG/owPR7G4Ix1AR415U+8pT
	xPXC2AXnQF+ESesXh+AOCEcj/KlF+8SlD4=
X-Google-Smtp-Source: AGHT+IGGey4s9f0cJXwAaHQLjbwYyitNVrO2BQJCqWmOtDJwNxrYapT9cVet3feFqNnoNFEnAIZk4Q==
X-Received: by 2002:a05:6214:490:b0:6cd:ed0b:3392 with SMTP id 6a1803df08f44-6d45134039emr69237386d6.39.1732313100583;
        Fri, 22 Nov 2024 14:05:00 -0800 (PST)
Received: from fedora.. ([2607:fea8:79d7:c400::b8f9])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d451b244e6sm14871006d6.91.2024.11.22.14.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 14:05:00 -0800 (PST)
From: Donald Yandt <donald.yandt@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Donald Yandt <donald.yandt@gmail.com>
Subject: [PATCH nft] mnl: fix basehook comparison
Date: Fri, 22 Nov 2024 17:04:49 -0500
Message-ID: <20241122220449.63682-1-donald.yandt@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When comparing two hooks, if both device names are null,
the comparison should return true, as they are considered equal.

Signed-off-by: Donald Yandt <donald.yandt@gmail.com>
---
 src/mnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index 828006c4..88fac5bd 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -2204,7 +2204,7 @@ static bool basehook_eq(const struct basehook *prev, const struct basehook *hook
 	if (prev->devname != NULL && hook->devname != NULL)
 		return strcmp(prev->devname, hook->devname) == 0;
 
-	if (prev->devname == NULL && prev->devname == NULL)
+	if (prev->devname == NULL && hook->devname == NULL)
 		return true;
 
 	return false;
-- 
2.47.0

