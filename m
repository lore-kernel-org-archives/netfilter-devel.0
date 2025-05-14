Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F201DDC28;
	Wed, 14 May 2025 05:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747201081; cv=none; b=BrzFJSpLWgNXOZoFoCcT85cmNzvNP/9lWboW34GImSu/wPIbPST+zOIz7UGzLy9y86Pk+aZzjvD2swAUyjbj+pNxS9FrQGw29NGnJRc2ISfvwNS0VRZv2Aj+/h++94KchAj8ja3F11YN/bOnbTVhrTSomw7ePWgcVURzoubUn34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747201081; c=relaxed/simple;
	bh=/ZAskp40rYSNhz66uBQbuHwURjSXVxSPsnAOOjVdcv0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aA0PceyXABFE/hkSmr+rLFl+Ju3W7y+VsQtpqFEiMiDYSr1Z3bmSU14VrEywea2FDy1WX01jS+56zeZhQUc5rYsPFGhpdPYq7fyeaXnt2czWaSDNEIyDoWSGQ9p2+4FkHV/W/luG/mfz7YWScpbkIVCPY9lU5i6bv9PjCMLF510=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UkB1dvAW; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UkB1dvAW"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-74264d1832eso3718044b3a.0;
        Tue, 13 May 2025 22:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747201080; x=1747805880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=z1FrVevl9xk1mZlS2y4IA8EHsiTRZOhyhjcDocMnWEw=;
        b=UkB1dvAWPJrThANpUYuD3RvI+nLawMMyjL4wIluJTT/b097l2lZAZvAhvbnhkFd48k
         WookxgPFEO+ogtK2dLW701wiK629xrdrMsTLZucOaOYNl6juFzvJz5j57sQK33VT2fRW
         FSmp/eukDXJfU8PwXxvGr0NhI0RPWGgia9Ed/ULCZoah3WKq32SiTB4m6rjmjOFXRMLD
         iv61xSBtHsG8Ld+paPxE1DkMi33Y0QLFGHOHJe7TZtsxrD4ULKy5BGakmfwVyc7Deoxl
         mjIkc6SRcg4mqM8lui1bH4O9bfAoBuS+bUl2CMoOjtr/rNrEwngJPIOF5qGtNZT/thlJ
         D8HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747201080; x=1747805880;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z1FrVevl9xk1mZlS2y4IA8EHsiTRZOhyhjcDocMnWEw=;
        b=P/tEhOKHlCdjRWW/zxABuNYqLyUfIRYjDwCX5Ao4LITd7x4K52WdbqFZ1h8elBNwW/
         1iYoOctt1GdaCXfHyrZY7B+Xj8daGb69gnAul9WiMMmKZB4kay1AEGwDmaJh79xNOTBS
         Sf9LY4ixJVmeLp0uRJ7tldr9jqCcPysEl+O4rACbcAJN3gof74UikVNcLCiveaaIbEoJ
         JDyLr7ctu/axw15ZluLEiPqVP+B2MQXT7laKFHx00G85eQwDKInkAMDbJ9QbuuG0f7Kr
         9g11Q/pX6apxuCHj8dmBvFllXC+MQtS/xaGLKXGYwalUGf0YVm+ymT51etPAb2r1cmTv
         pJUA==
X-Forwarded-Encrypted: i=1; AJvYcCWWcNVm6pfZMuXTG2zAQ2xh+1T0LiO1pgZhb+lpwPc81CzUAx5Dv6R6C+0nQ3wvEHW8tclcUeJDOv7lTTc=@vger.kernel.org, AJvYcCWaEEvr/Kxyc8KoN8x26sLOmrp45uK4OqcaNAX3dboAYpsGkDgsJxI/jk5k2yHOxZEkb507SYWM2FSnmQYJs+6P@vger.kernel.org
X-Gm-Message-State: AOJu0YwPoUKo4w2i4fLJsncNzKKZkv/TYNitTKwFQjDsmmrWs90uuMC9
	F5RsIjkafLGjpaZolAVIdGXdTxAaw49ppefdrI43h5jOg1sDNUh5
X-Gm-Gg: ASbGnctJZ0Ssq4CEKhXKEsNKEtn3gCyFUVvsOrGAxV5EvFen5e08UW46AGZWyKRlS6L
	sVfzYfxT+xKNJAEyolJvxcKLNKcgYsFVei2SOGIkMZY10gA5FATqbOGa1+F4ogSTOveTklOeyJZ
	i49olIGtRgzlKuFPwC8eJB5lkDAODAQdWTKJjxHyj0VldtDIp7/ilVGSsWk/6FZHq/xg6NQ9wt+
	OzduK1vPV6csbILh2Kxlo3yskT1Vw8L6SvkE3AIL1+8mqVQk+26aqZNt0ZBaWfdvkL8Ol/NUt2s
	f0EsxxBJ0FbaB4wpWAw3/nFWbX0L7BLD/p4W11XCd5YzkE92aN0gQfStg/9C
X-Google-Smtp-Source: AGHT+IFw4qAk9jrbGR1Hwgey0fD8K/CvhR07siSBPrK3CH8gb/JyYgc/5ALTVVOH8bNxg1xqJiBM9A==
X-Received: by 2002:a05:6a20:258e:b0:1f5:8d91:293a with SMTP id adf61e73a8af0-215ff1c00ddmr3015791637.41.1747201079675;
        Tue, 13 May 2025 22:37:59 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([124.156.216.125])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2349dd1fcdsm7003609a12.18.2025.05.13.22.37.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 May 2025 22:37:59 -0700 (PDT)
From: Lance Yang <ioworker0@gmail.com>
X-Google-Original-From: Lance Yang <lance.yang@linux.dev>
To: pablo@netfilter.org,
	kadlec@netfilter.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Zi Li <zi.li@linux.dev>,
	Lance Yang <lance.yang@linux.dev>
Subject: [RESEND PATCH 1/1] netfilter: load nf_log_syslog on enabling nf_conntrack_log_invalid
Date: Wed, 14 May 2025 13:37:51 +0800
Message-ID: <20250514053751.2271-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lance Yang <lance.yang@linux.dev>

When nf_log_syslog is not loaded, nf_conntrack_log_invalid fails to log
invalid packets, leaving users unaware of actual invalid traffic. Improve
this by loading nf_log_syslog, similar to how 'iptables -I FORWARD 1 -m
conntrack --ctstate INVALID -j LOG' triggers it.

Signed-off-by: Zi Li <zi.li@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 net/netfilter/nf_conntrack_standalone.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 2f666751c7e7..b4acff01088f 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -543,6 +543,24 @@ nf_conntrack_hash_sysctl(const struct ctl_table *table, int write,
 	return ret;
 }
 
+static int
+nf_conntrack_log_invalid_sysctl(const struct ctl_table *table, int write,
+				void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
+	if (ret < 0 || !write)
+		return ret;
+
+	if (*(u8 *)table->data == 0)
+		return ret;
+
+	request_module("%s", "nf_log_syslog");
+
+	return ret;
+}
+
 static struct ctl_table_header *nf_ct_netfilter_header;
 
 enum nf_ct_sysctl_index {
@@ -649,7 +667,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.data		= &init_net.ct.sysctl_log_invalid,
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dou8vec_minmax,
+		.proc_handler	= nf_conntrack_log_invalid_sysctl,
 	},
 	[NF_SYSCTL_CT_EXPECT_MAX] = {
 		.procname	= "nf_conntrack_expect_max",
-- 
2.49.0

