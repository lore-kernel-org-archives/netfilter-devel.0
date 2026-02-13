Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FD92C11E5
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Feb 2026 22:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771023214; cv=none; b=YisbQY7ij55uWZHPELZO1+h6b8DVjtYmr57D36sHhwLct2picclZKHLpEILRQ5YTh7E8zMpDRDbzzz2BzVZscPKRUT4jx+i8OQ6ZGDwXkDMEeOehZ0BpPDfh8q2YLLWJMrMPF1esUa5oXeEk7WgFrM0nf0fTVWpCttwvooFT5I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771023214; c=relaxed/simple;
	bh=5JMs9aIZ1bi3HLTDRgakvPbUT2rcR1gk4/WgD0hIJgI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kj8pgwtUuT40HCEQVcU2y7+4opue+EBZF6+lMOJLaHRjDqjrNwfN+nj0S89deiDX/wefnxW3CybhHsjItvS7FD3MYxXKuBCdfLyj+SFjNcJqVW6OUdNG3FsP2A/+2yn9RIJlG2+FrG3MN4YGJFWOz0hLVy5uxoXy6JH5CQzwe6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sleuthco.ai; spf=fail smtp.mailfrom=sleuthco.ai; dkim=pass (2048-bit key) header.d=sleuthco.ai header.i=@sleuthco.ai header.b=c6peDAMQ; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sleuthco.ai
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=sleuthco.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sleuthco.ai header.i=@sleuthco.ai header.b="c6peDAMQ"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8cb48234b08so83106585a.1
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Feb 2026 14:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sleuthco.ai; s=google; t=1771023211; x=1771628011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kfqcDFPBwJDnv2FWvajh1p7LsMhJKi95glIjMj+Kkeg=;
        b=c6peDAMQPAa5dy/+X0y3QsYM1lCUbykRPH6FkCc911hYsG+n9kc91DwlXGOivn43y8
         ahL58RUR9MzKYf4R3N+bIN+xF1u2r2WCvaZvaLh8/5+yhgsgXYrdcmqwfvO4+ner4IIi
         MKO7shkCogFI2v5OoRlpADna7oKr/jPCfm81fp71+CXDw7Ex/s+j6NuKQl9sOFkIX8EM
         7JV4Z2Kv3UTAqyGZsl0plEyF8zjd+QK76rdf9QpgUuojoz/da2rfyy8VOf4UdONi+i7f
         thbRxpg+Ib9nsywR6PkJ1XNc/KWU/Ni9UvUQYu1VP44aakXzXTTrDt8TsuqDwfoBk+VV
         mNSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771023211; x=1771628011;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kfqcDFPBwJDnv2FWvajh1p7LsMhJKi95glIjMj+Kkeg=;
        b=q9yhyZb0IetI/zlCxOjcxAvC+1um+EQoApdVaO7YCbfQW6fIf88MV9oGwou7g6xMg5
         EQRSr6LkBOjq+Ex06KiOpLwl6Wh/T/OApfRUB+UltcWVVWeiAHwO4H8yzSfAUtkPrsak
         HR+2JqrOWl6nAqQ3GcxulgdR4BXOElr+uPfYecnLkxC9LS/2OX+sXuwisVoU6agQ9wxL
         B+1s5uDEBv/MgGPQsf+a/uz3zmoMFaa1PkvHGafnJJcbN8AeY67YKJWrEdqYs/Fi3Jqp
         Sk8M7NXR3FScWC4dkAT2/6PO13Xf3VJYCV4layMWkvzs+aZGzi/eIf2oN/KLnR93vb1D
         YISg==
X-Gm-Message-State: AOJu0YyCJ3P5/GGPK8e4gpDoWk+OvyJqEz/ArxCMDPVMTCspVFoDjlOR
	/z5NIgZj+OsHovHFXT/ETmMbpF2j1afC8f0MVSIR+kijFGAF77huy06E1ygEUgzwydKkSgh8QAm
	1k72Ws2+r
X-Gm-Gg: AZuq6aJf24b+w9CKUGqoRs3xcjCpgmwS+drKpj307OIzfMlcdDUX283wl0VebjxykLG
	UYNOV303RgIrGrPLSr0mj1qc9kqbfLCMJS5/ZxrgkOtVu0ktnAsRc4zAT+OagLHDr8VPrD92hHR
	/Vb4mGBxgXkotrNMnGC945hDx1wiNiiPYfb2tz1hplRfX4NGNfvMZDerlTgxQBaW/QASsFC1Mqt
	uUmpswR3G2FHjQK9ciofFF2yMgmCUo+1eAX5Pd5r1nrL9ewND4H6y23B1pjtpM693tXYNLdBpx1
	h6ePDU/Dc0E1IbhSuafbaCfovWKUAMILKx1jF+m5/5oEz/k8d4jLN046X80jsulUXUmzRXE57P5
	edWtNh6xv0DbLZa6vxkVewop6kVclulEhM4XBJC7q2uHC3lKnDynPTHsnExXKnWXRvCVA3mcbwm
	h40kZ/CIOWgskuARciarkB6gAk0DSbXtrXMR1Psnk=
X-Received: by 2002:a05:620a:1917:b0:85e:b7b6:81e2 with SMTP id af79cd13be357-8cb4c00c942mr138175685a.50.1771023211087;
        Fri, 13 Feb 2026 14:53:31 -0800 (PST)
Received: from localhost.localdomain ([2601:195:c200:c890:bc72:9727:601e:995e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb4120f939sm277612585a.44.2026.02.13.14.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Feb 2026 14:53:30 -0800 (PST)
From: Alan Ross <alan@sleuthco.ai>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	Alan Ross <alan@sleuthco.ai>
Subject: [PATCH] main: refuse to run under file capabilities
Date: Fri, 13 Feb 2026 17:53:23 -0500
Message-ID: <20260213225323.5749-1-alan@sleuthco.ai>
X-Mailer: git-send-email 2.52.0.windows.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Extend the existing setuid guard in main() to also detect
file capabilities via getauxval(AT_SECURE).

Some container runtimes and minimal distributions grant cap_net_admin
via file capabilities (setcap cap_net_admin+ep /usr/sbin/nft)
rather than running through sudo.  In that configuration the kernel
sets AT_SECURE and the dynamic linker strips LD_PRELOAD, but
getuid() == geteuid() so the existing setuid check passes.

CAP_NET_ADMIN is quite powerful; even without dlopen(), we should not
sanction setcap-installations — a control flow bug could still be
exploited as the capability-elevated user.

getauxval(AT_SECURE) is nonzero whenever the kernel has set AT_SECURE
in the auxiliary vector — this covers both classic setuid/setgid and
file capabilities.  Exit with status 111, matching the existing
setuid behavior.

Signed-off-by: Alan Ross <alan@sleuthco.ai>
---
 src/main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/main.c b/src/main.c
index 29b0533..af49bec 100644
--- a/src/main.c
+++ b/src/main.c
@@ -17,6 +17,7 @@
 #include <getopt.h>
 #include <fcntl.h>
 #include <sys/types.h>
+#include <sys/auxv.h>
 
 #include <nftables/libnftables.h>
 #include <utils.h>
@@ -371,8 +372,8 @@ int main(int argc, char * const *argv)
 	char *filename = NULL;
 	unsigned int len;
 
-	/* nftables cannot be used with setuid in a safe way. */
-	if (getuid() != geteuid())
+	/* nftables cannot be used with setuid/setcap in a safe way. */
+	if (getuid() != geteuid() || getauxval(AT_SECURE))
 		_exit(111);
 
 	if (!nft_options_check(argc, argv))
-- 
2.43.0

