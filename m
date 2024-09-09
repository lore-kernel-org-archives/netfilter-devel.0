Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FAF8248D;
	Mon,  9 Sep 2024 08:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725871594; cv=none; b=HTlVcf1Nf1lcNxFdI/XjjuXFnGljOCCKKbH7RCVIL8e5itKxMLQ+CWxcR9nav9KAuVXM0qRRRADOqLtNWUhSg70Gn2wiqKS6JxGBfThd7xTli1Gc/G7g4ak1JcOFyRBYpXr4lDfq3bkPlO+rKmFVNiqlRI/NxdZJniAOFXWPxXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725871594; c=relaxed/simple;
	bh=8YpVFvMnp3u+NudQyo1gRrfi+EtbOf2uFD9qQCX4dwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOX+PQGen+Z6uQmW22R470PEhgM+8XBzsT8dgs5XvPwYGikeVoldf57IZKQiE81IK2b1A0rz9QLcBWrcctn+H/pEPMQu3wPBXlaLhywovpPNcDumz4sN/WD/lPcCBBq0z1KkTKnPkz+c0zBW4AyJHDVnkJeBKRxtvKsHiDTCY5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a8d2b4a5bf1so187127566b.2;
        Mon, 09 Sep 2024 01:46:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725871591; x=1726476391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WvP4IgFr7uYS43Nv5vKDTvOxaJwNv70XgHo4eK9tLiQ=;
        b=bmkKaj6WIc4ZKmW10feuVLN5aBxnJv7POIXYf8zODYnCoPoizUA/KE/8bL260PzeX4
         cjJftr/p5vXBX5KeXxWfqH0ePJAWhtcbLWr7uStVYzTKun2j4BoN0Tq6qKrchN745bi0
         OiCzao78sJwrnIxzrmtfS+ObdwPaDEVJfbXhyQ7vQ2LR4sC0Lwk5icL/EtENkJx+QysV
         Q/3NMtVIM6ID44Nhb2qBdbOV9fQeUzzv3Cu981GDRa4LHp0JelSD1OKzMEamp2ZMRPLe
         TPerKyjui0X6K+MCAvMQ8K25xPCHBXD4o0Q9dccpOst6De3gyZzOZTjgdAKaJQtj7Hf5
         8VTw==
X-Forwarded-Encrypted: i=1; AJvYcCVrGcOH0sQBQCMgM0fINwT4qfXdjUKsF1FF77OOuKT9tteDi7B/JgrUqp6AxpEgEwDyLpmpmVgE5QP2URhiXLIj@vger.kernel.org, AJvYcCW4AY227ZjdjRRQ8xM6AzJJnEbg0k5Zy21y6yt/ApwNeShSVNXoQmjdQBNN8wZS35TwEfuyB2Wl@vger.kernel.org, AJvYcCX6LayD2274vyhGZCOCPw/l+fz1bmlGnVeGy3LzR6xf4BNQAL2jerbUvc9HyrCPGSX7VWkN/lqAIivmXSA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyV6oZ3kSiYLFG1bH6c/1AqJbhi716kXtGl2UF250QFgqx6HMNX
	pG5wXciQinoiDihmGRu9iG/u7vIRNy3jbrR2LBdhYecW5Zb7Arjs
X-Google-Smtp-Source: AGHT+IEIHXrF0CvPfeVbwkGyMWiYS8VLG5DufppNzacRWPF8bZew7Om0j9ji4aJX0S+EZqyIPuaA8A==
X-Received: by 2002:a17:907:3e05:b0:a7a:ab8a:38f with SMTP id a640c23a62f3a-a8a88841c41mr855103166b.41.1725871590464;
        Mon, 09 Sep 2024 01:46:30 -0700 (PDT)
Received: from localhost (fwdproxy-lla-009.fbsv.net. [2a03:2880:30ff:9::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25979e90sm310933966b.72.2024.09.09.01.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 01:46:29 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: fw@strlen.de,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	pablo@netfilter.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	David Ahern <dsahern@kernel.org>
Cc: rbc@meta.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org (open list:NETFILTER)
Subject: [PATCH nf-next v5 2/2] netfilter: Make IP_NF_IPTABLES_LEGACY selectable
Date: Mon,  9 Sep 2024 01:46:19 -0700
Message-ID: <20240909084620.3155679-3-leitao@debian.org>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240909084620.3155679-1-leitao@debian.org>
References: <20240909084620.3155679-1-leitao@debian.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This option makes IP_NF_IPTABLES_LEGACY user selectable, giving
users the option to configure iptables without enabling any other
config.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 net/ipv4/netfilter/Kconfig | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 1b991b889506..1fcbf6db40fa 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -12,7 +12,13 @@ config NF_DEFRAG_IPV4
 
 # old sockopt interface and eval loop
 config IP_NF_IPTABLES_LEGACY
-	tristate
+	tristate "Legacy IP tables support"
+	default	n
+	select NETFILTER_XTABLES
+	help
+	  iptables is a legacy packet classification.
+	  This is not needed if you are using iptables over nftables
+	  (iptables-nft).
 
 config NF_SOCKET_IPV4
 	tristate "IPv4 socket lookup support"
-- 
2.43.5

