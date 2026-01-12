Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66ADB3587B3
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2026 12:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768222496; cv=none; b=axUz0SmdOdOvUxcEsWz5v9jLgwNKUT3XE+w/a4xGclPw0k7QD9dFtm0lzycTDXCuT6M5VXBMU16IXuUb3I5cCsknfxuCmnf88+VplDc7plo2rNbeBl1wW0sOfRE5gH14dW6+e6OM3vOID5JVJT5MkwjZKGryqP43WQDDTk4Jyhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768222496; c=relaxed/simple;
	bh=XU1R8eEmf+8OcV6QhVEoFS8ffVTmlKxgnjEPke2eHaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjCkyWeF86yO7IctC4aZwoYWAhHY6rzM8h+lMLnD9uyRtrRxvu57txsjSFeg+ZX8rfzvingT1qr/NWRVqZ+3yqPVCjgM6sPMaer4jVMLPa15SUpmhYPojQs078lfzElk5MBWPISS8rkMtNbMyzdSZoQmlSJnn1o7fSTMjiduXCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CEzeXbIi; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LqSqNFh5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CEzeXbIi";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LqSqNFh5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768222491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2pTWpsZNjWgj8wv5f92UAOMouEbb8hc3HuMURULyk40=;
	b=CEzeXbIiwM/J4K3PnlT5Y3fP2V/l+GqD1X1TpGhvRUcgecMqzY61DaOBGS/83uEk/6qI+l
	2RGNRa9fADcXZxu0PZ9LbUr6Gk25DOiSP5jC7S7ZmYFLwicAno5Evci2oAytNOp0bYXeAl
	0AhHlSq5+D1Cqo0sSyAAR4lBzMRhRbg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-SUjJVkWmONq0FBU6LozMDA-1; Mon, 12 Jan 2026 07:54:50 -0500
X-MC-Unique: SUjJVkWmONq0FBU6LozMDA-1
X-Mimecast-MFC-AGG-ID: SUjJVkWmONq0FBU6LozMDA_1768222489
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b8012456296so596390966b.0
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2026 04:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768222489; x=1768827289; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2pTWpsZNjWgj8wv5f92UAOMouEbb8hc3HuMURULyk40=;
        b=LqSqNFh52oCCy4tw8QgSvS8ufBhTEEWVhgKds6lYaSxVk1WvSTIIEACeYiUzsVQpPM
         IjyuipVH2D8+7BOhL8h1P3wvZIhCCwu9POsdpoifZ8r/o9RkJtG1QEMlz5Ww3LHc7NsT
         PCAZ01DDVwLMNqGuRjD3sLZGnaTQYfyNtoG/H8iQJpXYp+vlU107WBn52H86etbyw6pb
         92l4B4JQnuhwAFrO2eAtIgK58nj3X2GbICLw2L9XNuEjR1BvBQzCw9BQyEc232Fy3izr
         lXEkITsELO+NXFrfTHcuhW/wH1PKXtDUivtDxdxPfcMG+Tk2WPWRmcHAwQ37rht0prEQ
         lfKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768222489; x=1768827289;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2pTWpsZNjWgj8wv5f92UAOMouEbb8hc3HuMURULyk40=;
        b=n7T9av1EXvAxhIbQAJISmT2CWiedS3bLLETc3ayzFcvbt0pXQhn8pK9sIKVlqTRQhM
         /wdMdQw1G2+vw7Q5FdMnbaD+D9cYMhSINXlEw7bdiZlae5Nd/kf50WjIJYxWOBGeG979
         uyAiGnMD8U1H0cVGHZnw5g/jT+EpFGOQaJMl/LplwEbpYfeMq8MF8awEqkJZqSdgtPIM
         jG+tKvn1jRaXN/3+9NW6UKhDr5GBm9BHctMOCSsP8LKKSdZm94AX9oWUJmgMA/RLH8BT
         22YMSn8zzkV9r6oPEj3NCBvkX8k6zpDicEt5P+AFw3WIcqCX81G8MYEJvSJl3H8ybGWQ
         fgHg==
X-Forwarded-Encrypted: i=1; AJvYcCXY23m4T7Rd72YWngK9ev9MKpqNggmcSO+Om/bH47RUFpcBSMnXVZPSrNA7JVVllw+gaO2QeEd7txYD4iizOu8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUk9g/9JpUQdK6JVySCroE99yePQKhrd7EwiFHmxDBOIfdmp9k
	1g1G5DN1w4mrf5luUtkrt27/0VxVaoDCy5WKwuIbYlxaISWIGoFUFLADb/6vHo0Jsn8u5bBLE3n
	0+vbjoO90N0ahTVg6WzV2+t3je8hT3DwsH9MZGOKYPeL3iRH1GrI1gatmUz5MwEyMeSAUzA==
X-Gm-Gg: AY/fxX70wAVmba43COttXCYknSRJi1gOmlo55vVp4s9sT5Quk2FILjI/+pBW8J/3PFx
	FtOqVXA8CEHdPAOLJ5Q8NiigFgjfbfQ47q4luCsv3H0JPQ4vnUoF5mpZra7hzG76yyaLoqv1stR
	W1ycePYYN/EoPCy8Tp0zg+1Dkvn+ae9d6AbKkdXtJiJLGd7dKx9PCCwp7BIWXQmkWwwb8fXB9CQ
	ZJqo/CChYKqS97s/b4IlHl7UbS8fXcG97KLXOGQUR8qZLwVpIomEZNZEccjUPGCuC/9y/dq+IMX
	I9CZx8cOuVaqdpYQFqr5jo421Q/QWb5TfKgSfSAemnkxLWVreoJLoekK8VdQj1v5KrebwbbAfYB
	Np5EOIWxafcXj693kBFH17cJka/qJlD3h3W+caVqq4U27FG6uRsp3XRq1+ms=
X-Received: by 2002:a17:907:a0e:b0:b80:34e8:5eb with SMTP id a640c23a62f3a-b844542221cmr1612466966b.55.1768222489046;
        Mon, 12 Jan 2026 04:54:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE7t8/HlV/5AlKScEccxcE3fk05AaGQ3PxxJdFkixgC3oQPqTZ4vVB050U3KXnraou/3iD9lw==
X-Received: by 2002:a17:907:a0e:b0:b80:34e8:5eb with SMTP id a640c23a62f3a-b844542221cmr1612464966b.55.1768222488577;
        Mon, 12 Jan 2026 04:54:48 -0800 (PST)
Received: from lbulwahn-thinkpadx1carbongen12.rmtde.csb ([2a02:810d:7e01:ef00:ff56:9b88:c93b:ed43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8706c2604bsm497062466b.16.2026.01.12.04.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 04:54:48 -0800 (PST)
From: Lukas Bulwahn <lbulwahn@redhat.com>
X-Google-Original-From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	David Ahern <dsahern@kernel.org>,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	linux-riscv@lists.infradead.org,
	linux-m68k@lists.linux-m68k.org,
	linux-s390@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: [RFC PATCH 2/5] selftests: net: replace deprecated NF_LOG configs by NF_LOG_SYSLOG
Date: Mon, 12 Jan 2026 13:54:28 +0100
Message-ID: <20260112125432.61218-3-lukas.bulwahn@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260112125432.61218-1-lukas.bulwahn@redhat.com>
References: <20260112125432.61218-1-lukas.bulwahn@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lukas Bulwahn <lukas.bulwahn@redhat.com>

The config options NF_LOG_{ARP,IPV4,IPV6} are deprecated and they only
exist to ensure that older kernel configurations would enable the
replacement config option NF_LOG_SYSLOG. To step towards eventually
removing the definitions of these deprecated config options from the kernel
tree, update the selftests net kernel configuration to set NF_LOG_SYSLOG
and drop the deprecated config options.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
---
 tools/testing/selftests/net/netfilter/config | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index 12ce61fa15a8..f7b1f1299ff0 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -64,8 +64,7 @@ CONFIG_NF_CT_NETLINK=m
 CONFIG_NF_CT_PROTO_SCTP=y
 CONFIG_NF_FLOW_TABLE=m
 CONFIG_NF_FLOW_TABLE_INET=m
-CONFIG_NF_LOG_IPV4=m
-CONFIG_NF_LOG_IPV6=m
+CONFIG_NF_LOG_SYSLOG=m
 CONFIG_NF_NAT=m
 CONFIG_NF_NAT_MASQUERADE=y
 CONFIG_NF_NAT_REDIRECT=y
-- 
2.52.0

