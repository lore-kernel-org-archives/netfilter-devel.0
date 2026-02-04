Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8554441B357
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Feb 2026 15:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219536; cv=none; b=HGcGk8Cj6crtz9zHyOjNNUIJShISHYepwXyuym0yQDY9gELF0nv8QAx7TR3xax+Dh/fdnKtLtopt+pLBc2qkgr7JoQ0OfkyMqiaLlOGBiF1q1SQ8vaqXsBx+copx3G+lZ4D31UPwEnUpfUcuTORnUdNLOY/63SCm2kZhjEO0EAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219536; c=relaxed/simple;
	bh=b7WkUfdl7cNyd3rvs28XPRl7naD0eLIJrTKWlrRDrgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9mSiEUyvfq5fSXBaan+KztuW6X/qyK4BkZctYmwXgq5i4KVahGWbq/tJaBvXQq1SvzuHUExAPgPjTvfoTZCWBhWPX5PwAS/eYo6MO4L9+rcO45y1lQ9GUmk8ONqUqMNR/l/CGvdE/yoeI3UImLnqx1UpxDB+Pb8jYFf6ywxxhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CENDczjO; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CENDczjO"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-79088484065so65240257b3.1
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Feb 2026 07:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770219536; x=1770824336; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h/5SD8AXq32EOZXgCdiUpBHAXtYnBkcl9u7VsKej7wE=;
        b=CENDczjOxUCq6yKjcR54oD4sHPsYVf7ssLMzx0Ud8wS2jfHnrRD2VRg5kluR8ICSAO
         xDBtxx8Dr1dwYTqH0wfMBC08rjCrJ3aC5GQ4MAz98OpmTHxSD9FLsy21t0tIHgX2C8nI
         Ufs5ozDAvG1Y5jpdUpDlBRLCkeT3jMZd80PifPxwNAIMznPVecK6Trgbfj/k9DrQvnEn
         sjrcKUfVGm2Bt4QChEGs9UbHkTJwKqw9CfVA5P7u+utES7wy1BQw2YPQFcWLmakBCgYq
         VTJOxqQsKQgYYqLI3ryCVPcvpB3mzujmOEt5JNuHN2HZGDScUBs1eaIJ7mvC75Pvc9Ou
         cuuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770219536; x=1770824336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h/5SD8AXq32EOZXgCdiUpBHAXtYnBkcl9u7VsKej7wE=;
        b=qmOsF76LUPMwX4TrLaD82fXHQR/4SfxhpTQ+l4I0/b2vF481KCRSipSHXWo7e52D7h
         cR2nLXjLH76oh5lPzZteyoLueQTVkNhuguLnnw1GNrUIBCxmDAutm/yHlF3jqtlIHPIQ
         40wKrPvsGy4vcKj9yCEo2zzysBjteMRk+W8C5EmOtdJPE6cs1Xd3yr78C8mr65RWq2fo
         7oOmQvDpzJgs6kWsmsb6TD4fyynfDCL1XsQ8USvkY98DPVg37bJjSno/GCFXEpeDnjR1
         LeABpzhMsupASsTqda1QZXYCDkJYl8PpH9hnOQIyZdrORlvorTKbLJOmUtK2u381TzBe
         1yTg==
X-Forwarded-Encrypted: i=1; AJvYcCU3klMa7uZ0sIuHv/SjMIh5gX6sDiJ5hsHnpmWMvJOgWE06RsSxiyA64sU1daRrf3A75UuYpoyU/hvBbXH/z+o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxt0gVo55D9n4sU6cwEasEnmgyt6SS/toC0R7GXzUtlNT2cgtxA
	Hx7XI8EtSOMzCX/RppX6kvQgWrNhssqXtDj7c/rh+jt3kERG9Ijo//wj
X-Gm-Gg: AZuq6aK6KxIo0WOCRJ4HXVZKVN1OeF2z0CTFHEmN+eAd/jPYC8+7olQJdzf/Qz13DZV
	EOYf7N5i8KHkz2dtjIrFRIAW2gyAXO3xSDxyjxr2NQkj8lUQ9mV9lkDiaU7xzawbKcnupd0npSY
	O+n5Bf5euzfyRAWNhga8ElKcE4nGtcI82n85enaCQtJWJL3rHUCU4f2APktGK5eLHRNDErjNrJ4
	FfICEl8D+HcH+IUsBc0yFWM6M6K5kr+v78G6QB/2BMoczkABjWVVMoMCL32L6XW0ZVOkLpI+Io8
	ZrwoXNq/HTGYlG6PBAoeZjvNKeSt3mQ3xPPICjpFR0ZsGKhCCEs5OBKHQlEMfqnEbJxn4kP/4dF
	i/ADWJqWm5fWAduJZjf1VoeZca3T9GAUS4d8GeErUfFA/5NoknxQ9YOXhKTaNmf/X89z6/19Yin
	ShpxLEtvs1/pXf0is4JyMn8X91/Zb4E1EytPEFtE41Kq1zsK5lKV7lfeHt7cww75tmtq2Oe9i6l
	eABMlPZr3uZMuqth3ol
X-Received: by 2002:a05:690c:39b:b0:794:ef94:1222 with SMTP id 00721157ae682-794fe7a13f5mr68835017b3.55.1770219535570;
        Wed, 04 Feb 2026 07:38:55 -0800 (PST)
Received: from localhost.localdomain (108-214-96-168.lightspeed.sntcca.sbcglobal.net. [108.214.96.168])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-794fefedd4bsm23609397b3.48.2026.02.04.07.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 07:38:55 -0800 (PST)
From: Sun Jian <sun.jian.kdev@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sun Jian <sun.jian.kdev@gmail.com>
Subject: [PATCH v4 5/5] netfilter: tftp: annotate nf_nat_tftp_hook with __rcu
Date: Wed,  4 Feb 2026 23:38:12 +0800
Message-ID: <20260204153812.739799-6-sun.jian.kdev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260204153812.739799-1-sun.jian.kdev@gmail.com>
References: <aYM6Wr7D4-7VvbX6@strlen.de>
 <20260204153812.739799-1-sun.jian.kdev@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The nf_nat_tftp_hook is an RCU-protected pointer but lacks the
proper __rcu annotation. Add the annotation to ensure the declaration
correctly reflects its usage via rcu_dereference().

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
---
 include/linux/netfilter/nf_conntrack_tftp.h | 2 +-
 net/netfilter/nf_conntrack_tftp.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_tftp.h b/include/linux/netfilter/nf_conntrack_tftp.h
index dc4c1b9beac0..1490b68dd7d1 100644
--- a/include/linux/netfilter/nf_conntrack_tftp.h
+++ b/include/linux/netfilter/nf_conntrack_tftp.h
@@ -19,7 +19,7 @@ struct tftphdr {
 #define TFTP_OPCODE_ACK		4
 #define TFTP_OPCODE_ERROR	5
 
-extern unsigned int (*nf_nat_tftp_hook)(struct sk_buff *skb,
+extern unsigned int (__rcu *nf_nat_tftp_hook)(struct sk_buff *skb,
 				        enum ip_conntrack_info ctinfo,
 				        struct nf_conntrack_expect *exp);
 
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index 80ee53f29f68..c6d8c2e80661 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -32,7 +32,7 @@ static unsigned int ports_c;
 module_param_array(ports, ushort, &ports_c, 0400);
 MODULE_PARM_DESC(ports, "Port numbers of TFTP servers");
 
-unsigned int (*nf_nat_tftp_hook)(struct sk_buff *skb,
+unsigned int (__rcu *nf_nat_tftp_hook)(struct sk_buff *skb,
 				 enum ip_conntrack_info ctinfo,
 				 struct nf_conntrack_expect *exp) __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_tftp_hook);
-- 
2.43.0

