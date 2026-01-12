Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B76358D21
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2026 12:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768222508; cv=none; b=PMMKi4JmNr9v2uYbfcW/VmmxH3G7+Z1RauLieCe6GW9QCQ8EkdziXMXTykrNcLLTHSwasR4nZc4Z0hRC81okLn1/edI8UgNoLobxnbzDgJRvvH10z3VjDKz6cq8BPzdWuU124etxVY8okorWDSUmgY8VqPXipCMlZsR0LKr7hzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768222508; c=relaxed/simple;
	bh=9AA+6Xkc06ZNRttRTO7oNESMzk9GkeD69hB4TdB8dWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlmUFoF6kZV95uIBlrkDoj067eXUEmUs9zV8QN4xFR9QVUSHJ4dah4PQrkmdNCdJhYBOsK1tMz9F2w97XERKuGo2tzEl2cHnkPZdOSVIiM2NH2fPTNIFnCS2iO/Jog6kPaTC+giRwrzf6cji7wVy4thS2xed/9eAXd/C3IzlRxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZOnv6j1x; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UvYoMKc0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZOnv6j1x";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UvYoMKc0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768222506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Aw/NV8LRyH0v6ORkecK6sJJhDNFc4SC6s3IiJQNZsCk=;
	b=ZOnv6j1xUx/4jsfruIXXHNtUHDFxwCwCXW4OZ1T1MQ+PNYjVuTLxvZc7nTaqIqdhv8uixW
	4Z46ZxsGsW+/of5uc7v/M5/h0KctYB8VBI/HXfu7LpSriMIIgB1qqdT3de22zHgPut05xa
	wKEshQ0KyAzp+oX9mLQxKRFaN7GCfKk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-uupy7PssOZaK_4GPwhXUPw-1; Mon, 12 Jan 2026 07:54:55 -0500
X-MC-Unique: uupy7PssOZaK_4GPwhXUPw-1
X-Mimecast-MFC-AGG-ID: uupy7PssOZaK_4GPwhXUPw_1768222494
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b7a29e6f9a0so626160766b.1
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2026 04:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768222494; x=1768827294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aw/NV8LRyH0v6ORkecK6sJJhDNFc4SC6s3IiJQNZsCk=;
        b=UvYoMKc0kKHzHOlmfPz746OTgXzILzb5qA9R/0Xv7FL7h7kvLMA4nZSHablQURMXSL
         x7t2Pzs/23OZhL4nPPY65DFjdM9XY+ac3pSA8P5mzsguFS7sC6Zy6IIM2jEZtPVbESuP
         AqH8aiuFL7i++fRBST5zLOY1rlbwBPhBR9oQmzrnfgAKyu90ASEpyGb50fPVMt8KJ/cs
         EbueGRx+IKpaR4x3X70Qm1Y821iO5EngzcUe9xzD5YZRBzbfpH18D/1+zdmdl9uQL2Kt
         zKCdOFI2aokPbRcV8dnnxnWgQbk6kJ8xEpJBOVx8HQBzO5xX/t2U9RI/9oKQsU6EzIbq
         uNWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768222494; x=1768827294;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Aw/NV8LRyH0v6ORkecK6sJJhDNFc4SC6s3IiJQNZsCk=;
        b=eX+NILqEBn/4+us6ImOrwt/6cENVPrFNGwJ8e8CJf/BFhpTfnI3D7PYFqySkNB7dwY
         XvYhKnVRV6ZyaR6M0blChO6XbHJ9EIP/StiIjM82yUXC3TLmamfknG7UocITxhqXqtdv
         xcrEavLOnYTLh1vbrbl4XHIn7E7LeWh0bLI13cnJQJokGrUCU8fKoQlD5bLBbNLumRwp
         IsFM1Fh2t/rdUQoG3g6667uyh67dqF4VWLQrWdFEtga+XeRGsZRHezlspaM5oR76ZnLR
         k3F8hclBLcfNF1uhoPLdRrn2GnVXpbrfpj3mXm7PkeNco1GvvRRZXAWLrpgqVznOc/ew
         zgLA==
X-Forwarded-Encrypted: i=1; AJvYcCXmRg+7+KP2QFElHsnJ6Qja9ccq+fQ5YVly8Y1AyiGwifpUgQgYyDOrMIY9Q4xOuvPxYIhxOEc2bATvmMTb4W8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbRolQJxpS5wOerHji9Mw88yeFYxJvJ2wVEkd99UWJ0aIe7clf
	ivf5go8sF/ta7gSnavsfiDhV3YrlLdEix6Z1u5Grl3KNRKJvjtKi4CimryBApTuwaeOeUfEJ3Pa
	b04uns9py6vhCiqCGzGJwfPSGYYlUUro7AeeBIPDmoPi9UXii8QPWGiXKOO4xWbW8urtgzg==
X-Gm-Gg: AY/fxX5Q8+hFdbqtGAasw1LGSSJc9Pmb2COfpofE+SdqnVDBRWd0MDOHBfXDAGEN9Yv
	v73+kj0FdsYENeiLJC8HZTmmPQoM6GvYyVDAsjiESvKvY3waizyLIkRRqVrq2/h2W1YlTqfvxq8
	qDMJREG/E+/JsBgSw0S6vulssN4aNZ61jGvbDdANJ5gz61UHdlWpoZe+ydDJjiP1BLefj3ETZ4d
	Bk+yRL8b4WDdd94pHMCVT9Ja8o3WS1JnQNCWL647/cmPQSXaGWoab0gksE3Lgj/TyShB1ndGjCP
	cn1TbCIoBlYk9iNwL6qRQoSG2LXiLDrQ0Lx/svJKzQvw3VtZUbFiaR7FY1lTXmxaLxoKWmKkX88
	g+pjmYTyywHFRglJa6BzMc3dPuPZ075nZGir8mEImNYjpeKemqZXYMNpRLgg=
X-Received: by 2002:a17:907:b59c:b0:b86:eda4:f780 with SMTP id a640c23a62f3a-b86eda503ffmr427900666b.18.1768222493911;
        Mon, 12 Jan 2026 04:54:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEQQUtq3Zy/c64KpzKtlRB+1NOLYJQC+enp8zQ7vlFIka+NmHMqyup9Wyx1StgQLyix4fqkyw==
X-Received: by 2002:a17:907:b59c:b0:b86:eda4:f780 with SMTP id a640c23a62f3a-b86eda503ffmr427897866b.18.1768222493414;
        Mon, 12 Jan 2026 04:54:53 -0800 (PST)
Received: from lbulwahn-thinkpadx1carbongen12.rmtde.csb ([2a02:810d:7e01:ef00:ff56:9b88:c93b:ed43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8706c2604bsm497062466b.16.2026.01.12.04.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 04:54:53 -0800 (PST)
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
Subject: [RFC PATCH 4/5] riscv: defconfig: replace deprecated NF_LOG configs by NF_LOG_SYSLOG
Date: Mon, 12 Jan 2026 13:54:30 +0100
Message-ID: <20260112125432.61218-5-lukas.bulwahn@redhat.com>
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
tree, update the riscv kernel configuration to set NF_LOG_SYSLOG and drop
the deprecated config options.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
---
 arch/riscv/configs/defconfig | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
index cd736a1d657e..0b99a73f43b2 100644
--- a/arch/riscv/configs/defconfig
+++ b/arch/riscv/configs/defconfig
@@ -64,6 +64,7 @@ CONFIG_INET_ESP=m
 CONFIG_NETFILTER=y
 CONFIG_BRIDGE_NETFILTER=m
 CONFIG_NF_CONNTRACK=m
+CONFIG_NF_LOG_SYSLOG=m
 CONFIG_NF_CONNTRACK_FTP=m
 CONFIG_NF_CONNTRACK_TFTP=m
 CONFIG_NETFILTER_XT_MARK=m
@@ -75,8 +76,6 @@ CONFIG_IP_VS_PROTO_TCP=y
 CONFIG_IP_VS_PROTO_UDP=y
 CONFIG_IP_VS_RR=m
 CONFIG_IP_VS_NFCT=y
-CONFIG_NF_LOG_ARP=m
-CONFIG_NF_LOG_IPV4=m
 CONFIG_IP_NF_IPTABLES=m
 CONFIG_IP_NF_FILTER=m
 CONFIG_IP_NF_TARGET_REJECT=m
@@ -84,7 +83,6 @@ CONFIG_IP_NF_NAT=m
 CONFIG_IP_NF_TARGET_MASQUERADE=m
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_MANGLE=m
-CONFIG_NF_LOG_IPV6=m
 CONFIG_IP6_NF_IPTABLES=m
 CONFIG_IP6_NF_MATCH_IPV6HEADER=m
 CONFIG_IP6_NF_FILTER=m
-- 
2.52.0

