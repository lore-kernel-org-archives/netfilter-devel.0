Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CFD1947E
	for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2024 16:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709395691; cv=none; b=J71MjEA8eaHQNvfG2nvehA8D+Ec9z6RC4zXzc7WuOoxwo8oUBHZ1954TYeUH3a510LNXgxlUDyhgOID0SL8NxCsZjjJo63HKr8BKrp7e8xxKK0Oypt0xewrb09FW0UkK3Hbo5ttFlVDxmAye76HVlALLOIylSGcPvQoip8RuTMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709395691; c=relaxed/simple;
	bh=+s9x+3J/y670g4nj+D61f/mx8OaLWwtMIg7kk7fYNAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPLroFg+sjjXF8+OTqUrNPZ8Z+ATLWGJS0u3wOIqzoZMn7nwaWcJZ/4RkntAxvJrMXCR4o8QBsMkEsBdJ9wVN1bYiLfjOp3KJYPVYUybjWx90De7EcRsHfvFnEWx98NdhnyVtSExxczvCAbBfE46bEGtTfi2t/CL7g63fPGYB/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H6agzJgG; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H6agzJgG"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-788201c344aso8765285a.0
        for <netfilter-devel@vger.kernel.org>; Sat, 02 Mar 2024 08:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709395688; x=1710000488; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+4Dp1aflshjG5qXMoiU/r/Blnmp7WCLl5SGk96BBnJw=;
        b=H6agzJgGKKdZJL29vNhPjZuaNUtIqIwpgU0BbyGGZl5eD/kqEgcuH81r7dQ4JY6B+Q
         ohXH8UfeEhiy1vomC76Um/4RZneau6L7wOVIkZhOtALhkbj55HpynxY2/xZi+JRqc7jv
         TDFcoBKDc3qQcsNCQFAkNu2B5+uhpB0/aq5WY0AyLsjkWTNQr5hwhAVpFOHh1xbn4XpY
         M1m++Z2rmtv5SdyxsjEXC88aXQ+jhkkrA8kb2P1Bg2d/wAXNs1YQiu/zNe1rl1g6AoIh
         SYpW/0h4MeZk8eArdWWTPtGP4vNpKJfDh3OgdEpT5QFX0auseutXUps/9Ih9AUaOa57N
         drnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709395688; x=1710000488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+4Dp1aflshjG5qXMoiU/r/Blnmp7WCLl5SGk96BBnJw=;
        b=rj4N7oPYXZ4uL7LjtPYbhK2Bkv3ozO2VsUbs63XdIw6XSFKdOLMSb+K9WHfsv5hUh4
         6XtYXRbqFfaJxTHPYcDbu3SNPYuWkJx6aY0Dzh34tErjj78wntPPAeDhGeuJEi6lnf1u
         7k/OSeGU07nTkgYwvmbnc70KAR+oiFW5/OcVuYE7H6QFbcGd26jdof3DVWX3buUSsgCF
         Pr9qI+4eTScuFKCSaQmNu/5UQI3Jz7Ue5Qxdib4IHRuLbH670qKrMJLouQUupsY9XTJn
         ANdeG9axtATe7JBrhQyenpDDgERqa2T48CVQzCdM5kOBCkspaJBNwmv+Cnj6woVMeq/2
         HuFA==
X-Gm-Message-State: AOJu0YzUsx6MmkwZLYKdWa4TiGrqGmUTVbOjS5b7zv4quKEzrEw0ymxH
	1xuOPA8HN95Yg1qj7ef59lpldRWRjenhSeKT+XAsEzTqtxyOPfcsehhaqdv3
X-Google-Smtp-Source: AGHT+IETTvR8bPGquFWvdPWgUKBD/fFN4EI7yuxJHUI92VoqeKmZwI76Q/vzkYdU8ts0F35x9mHxvA==
X-Received: by 2002:a05:620a:ec2:b0:787:f16b:e4a with SMTP id x2-20020a05620a0ec200b00787f16b0e4amr4791053qkm.42.1709395688222;
        Sat, 02 Mar 2024 08:08:08 -0800 (PST)
Received: from fedora.phub.net.cable.rogers.com ([2607:fea8:79d7:c400::557b])
        by smtp.gmail.com with ESMTPSA id k1-20020a05620a0b8100b00787c7c0a078sm2666118qkh.121.2024.03.02.08.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Mar 2024 08:08:07 -0800 (PST)
From: Donald Yandt <donald.yandt@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Donald Yandt <donald.yandt@gmail.com>
Subject: [PATCH conntrack-tools v2 3/3] conntrackd: exit with failure status
Date: Sat,  2 Mar 2024 11:08:02 -0500
Message-ID: <20240302160802.7309-4-donald.yandt@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240302160802.7309-1-donald.yandt@gmail.com>
References: <20240302160802.7309-1-donald.yandt@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Donald Yandt <donald.yandt@gmail.com>
---
 src/main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/src/main.c b/src/main.c
index de4773d..c6b2600 100644
--- a/src/main.c
+++ b/src/main.c
@@ -175,7 +175,7 @@ int main(int argc, char *argv[])
 			}
 			show_usage(argv[0]);
 			dlog(LOG_ERR, "Missing config filename");
-			break;
+			exit(EXIT_FAILURE);
 		case 'F':
 			set_operation_mode(&type, REQUEST, argv);
 			i = set_action_by_table(i, argc, argv,
@@ -309,8 +309,7 @@ int main(int argc, char *argv[])
 		default:
 			show_usage(argv[0]);
 			dlog(LOG_ERR, "Unknown option: %s", argv[i]);
-			return 0;
-			break;
+			exit(EXIT_FAILURE);
 		}
 	}
 
-- 
2.44.0

