Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794938330;
	b=HmeZ2aNUCLuDsYejMTnKBLHnkd0V3ly+pvGENbOaTjG3IaRG/aSE2Yau+U3fdKuAFH84
	 7E1zVONEUH12uIGycZPXpWoK2NI370yqRAg2R1UEvsIPrVXfTHjSs2Zoy9T4HJV/T2lN8
	 5M9yFLFwazx0giRlV5NXtllOrf4SC1PfLcqSWpK7KSvLAivVlIEeGNOPqitnVQQq8wjdS
	 UllDNfrKsOYYar5uY07YklgcAh+omfJElef/J69B4Dmi8xHfxoEmCi7rK6ac6EvvqpjCK
	 fPJpV4RjCScFkBjIuCxMcDWNJwjKBRdKAA6Q8w/UdS1rDIBC1bHKFxqV5p1N+EdgOgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794938330;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=FGXhRut/xd1S3Ev/WWVMlwTf0b47L1BOYI/6dZtuZa8=;
	b=y1dXJhH10wu+Ecr161orxI0Lm0yl20iaaa5aKbRPTG3LSRwa9rlXXN95e12z6LAeLAo3
	 Sj+pPysvGJV7iddxkjVqlLMmDfMN2OWhD3/aYfZtmKKYECFp26BRuxq6PiyN9ciw07MJm
	 BZG/Kqdr5t9E37kCh9nRN47efSNV7JHKdG3B8D1AhfeKI096U30uwJbRPxyoOMatPKgaJ
	 uCJmDeSHqN7NPMv80Adq16zcvBRRpgcK0ofmBEwT1/Gbsuv5mOE67gFSqpxcJOdNgYSV2
	 h9Ai8WMeSuWbiFvXXXU7cTw2u9r8inXdrFrXpDygTKQjdPNcyU3ZrmmGabMW6ukHJog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GdZ089KM;
	arc=none smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887E6606A32A
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 17:58:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 887E6606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GdZ089KM
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b785ca42ebso174142a12.2
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 09:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794938329; x=1795543129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FGXhRut/xd1S3Ev/WWVMlwTf0b47L1BOYI/6dZtuZa8=;
        b=GdZ089KMPSC4CV1Urj/q9YTTo5jFACSBOXXgxTurpVg37Gc+VW5GMF25CWl2KX/ifI
         YdEEAMYFQ4cC+9pD19msQIKuc8hKj9CoXdL29rSFAV59V9AlgrhXC80BXPmaurSGx9WT
         I4OdwHZlSaI7YyHkH3U014RHPj1eaicWsGIMf+iHJQ9Wl+ICCDQRY7I84xNX1Yh1h5+n
         3ZV4md47UwzHhB8WxYf5alDYmZJN1i2M6o/qB33hL0LjMgrkSAmLKy8iFXJg2WkRgsee
         ryNp/qrkHYiCj6yruSydmWvjDhkHlIdd6HitcuwgSxGJX3rAgYk5WJ+AhWQShUEmQexP
         tDwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794938329; x=1795543129;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FGXhRut/xd1S3Ev/WWVMlwTf0b47L1BOYI/6dZtuZa8=;
        b=onwtZkNuIO9ebeHnoAmVa/gJEnpsEpChCJG5ybOO4XUXgbRavySI46yqe7raxWagvP
         b09ullQEMN4u6EiYS4K8uD0TcTy2/vgS998ifynF3dmldFNd4akc/W5hUNRoCWlnQYT4
         a34PJUK2uk3OIjEhrPYyiJH3rYgH+IYRdmSRpMNglqPTCeeKB9HXx1h4HGSJz88GiaWx
         z6VZ8gVgopXAqWr8QdVqf5BTMezcAVsO4b1MHnesgt4B5vT+CXaXiwca3qJEM7OXDBoz
         p5zvKr17Qwl75y7A/HpvxEumlBC9b+WbLGwmEVC8oFffEf0FBnIJICVXC/hb4fCh96mR
         x0eg==
X-Forwarded-Encrypted: i=1; AL+hErGaYl8/rZuDL9lZgwObs8r0gcruyhPSqOjytnscR7xbaCsu60YRcFXWM8ycIkzUSNnC+cuNLeSrgDl31RpGwX0=@vger.kernel.org
X-Gm-Message-State: APuU4Z+MFDEm+FHQRqAstP0qmtbft7OYHu/+M8W9YQ86TduPy1kJot/f
	vJnbFytuJftMbFaXnDAITO7Shn0G4AHgl+SJSi5+UHbwuk32sFehAiCo
X-Gm-Gg: AYBFou1dcTrzzCxzuwdIlqoYMf/47LpaIqzLmjqPNfLFP7AVHAQDk2/r/g8206nJeSz
	L0JnWhVHvQdmuyVYpWmq8ERORa49XXMBl0NWrSjHveoOCOqd2XCu6eYMc2alt3k991EnHToF7sp
	QUD0bq00OQCrEyCOOIIt/pEHvlsoxMjIkYhe1FO6DKwibhfn/9JRuwVK0cADa+y3nA280H/Dav1
	T43F7ER+EDpIDi0HgiWS2XDdNhCa5EhkmKwhh7JEFqXxSsU6flsSsV4k02ki57eBsQZ+PdegtvO
	falDn6E54B3riWqGORL/t/kVgrZ0RVrV5gP5NKv3HItHQ/bNNicscIosToDDpBrdFBex4QN/kYp
	DcB+0Fdr3PSZvkTrTtsGtyL0DwKNnuvLGCqiufWCp2CbL52+f9dLqO2oWNqVoOeHVyMx6olaK80
	ZlqZt5WAyKVMWl29C3zPtOfFH79lO1grn0of4MQRHax42UQ6eus+NkhA0DQERnIp9m36HG6Flg8
	z1G+N16NFuaUb7YFZzFsiJdM9VcqpdHAV7QIfzg8Ut70bjgk3T1ATrWRXnIOCKsTlrdZE+o2Lr5
	8X3BZZhdWS7/lwwDmCgSJjyj5LgSfXYEFjocJYItngtkwPu29CiLlPViqFjwWQ==
X-Received: by 2002:a05:6402:3991:b0:6b5:87b1:ba05 with SMTP id 4fb4d7f45d1cf-6b887f18279mr13984a12.39.1794938328780;
        Tue, 17 Nov 2026 09:58:48 -0800 (PST)
Received: from theodors-laptop.. ([5.255.118.7])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b886a82951sm78666a12.9.2026.11.17.09.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 09:58:48 -0800 (PST)
From: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
Subject: [PATCH net v2 0/2] net: do not point a pskb copy's mac header into uninitialised headroom
Date: Tue, 17 Nov 2026 20:58:33 +0300
Message-Id: <20261117175835.745796-1-theodorlarionov@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A pskb copy keeps the mac_header offset but not the headroom, so a copy
of a received packet has its mac header in uninitialised bytes, which
nft dup can return to userspace. Patch 2 unsets the mac header of such a
copy, as Florian suggested on v1. Patch 1 makes the nfnetlink_queue
bridge adjustment check the mac header first; without it, patch 2 turns
a queued GSO copy of a bridged packet into an out-of-bounds push.

v2: fix in __pskb_copy_fclone() instead of nf_dup; add patch 1.
v1: https://lore.kernel.org/netfilter-devel/20261116105113.128791-1-theodorlarionov@gmail.com/

Theodor Arsenij Larionov Trichkine (2):
  netfilter: nfnetlink_queue: only adjust bridged skbs that have a mac
    header
  net: unset the mac header of a pskb copy that points into headroom

 net/core/skbuff.c               | 2 ++
 net/netfilter/nfnetlink_queue.c | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

-- 
2.34.1

