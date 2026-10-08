Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E113EE1F8
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2026 11:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791458338; cv=none; b=G0VEi/c/0IQcOsJq29V8n/zO6+XaZXqrIPsktezw1FfylOWm6CNEHKqTLwN2BwjgO+wOMIsHuj0OIhfQ5LabY1pEMSTfEoJ4Ru4jhnOWtE3swueV/5IfcbUxIyrzrIE4DHu4jjnQ+qzZ5ernWjp0WmC8pTYVMTCJXldXAZ4H6dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791458338; c=relaxed/simple;
	bh=EExW1k94qxqJzDLBNcXAe1CRJKzbkc8M/lq4PoGuabA=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References; b=CI64FPDVWVeKhn80C12vFiaPj5v5fUm6eHlA+Q052RnyjSahv3/KBj0+3ERgHdH2tr0HxS4Z2ChpnvW25xaWWqwEM4AgNqpPNPRueEeDXhax71IRNEMVUZJuUf4tE5GgZOZyE6BEa5sjLCUGY9GnyHGO20mImy95vCuEJEGcZdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GH1GPtz6; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GH1GPtz6"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2db18e5cb56so24309095ad.0
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Oct 2026 04:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791458337; x=1792063137; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :content-transfer-encoding:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=EExW1k94qxqJzDLBNcXAe1CRJKzbkc8M/lq4PoGuabA=;
        b=GH1GPtz6Cy3YRBbU/PvREeBQXKlOijchz1AA7q4CIFlO0ShwXCYcX8NKTT0Y6DWeo8
         nDW5OXSxEeOS1QvHD8PtBdYcv1Qo/Zgy/ZZSVnuItRxFKjbOvpBpqd1XQoTeerSglRZV
         swaa+2DDJhNq1d49Kx6uDWiw9Xmtm60aBayPIKLmzLIv0fEBtBOl6MPdAlbVR06iSvl4
         4zr+UsueseiJ3u4eQU+JQf5XHRsLJPNH4hs1/hp3bs4QHtGffRXpC9mRgCTf/HQLUGDQ
         mbFEv0lgsWTyllcUhP+MLmY/Q4xn2O6WXmWVbZvbi9p7MWmxmbmXKJcRHAI5T8xaE/tC
         XdQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791458337; x=1792063137;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :content-transfer-encoding:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EExW1k94qxqJzDLBNcXAe1CRJKzbkc8M/lq4PoGuabA=;
        b=CE46YbGghISqqNCNUdf44OzHzRV+A8grrc44owQcHS2seWYctT+NQPqwuaJu9VVQTI
         mCsLEALMf8knrttLmm/l6XG35H+I6ZfWI6cRYUcUsnBN/v4EHxaGQAftcA8d29lnAeM8
         wQPK3hbeQFS44rjH1vUjttOQiZN2iP22XDzqpquJpAb609YQ8XA1Zrv20wx6IW4d3tq3
         Zs+zz3ya4rIfTfh4EHnHhgKy3K+QUwYr3wQ/7FIuCq1MC4QjkKcsEP6tSQV4XQt2/Iwq
         CBlOKoFJm2/wB8aJvIiitsJFv/d1u3NHGNss+CRfVscStOSS2M//HsS5vRuZwGvDgp8y
         wlrA==
X-Forwarded-Encrypted: i=1; AKwUvBy3KmPExFqaJdrZ+GU3HLqjLDREs5yLIQpqaa76h1vK/N/JzN44qNWEoNLS+zWvIqsehptYWv8EmjpoGD/0xDw=@vger.kernel.org
X-Gm-Message-State: AFq9FYLUWd01rgLXo07FKXgpAgZEpCnW9YNQTv+AXurlJsv5myhfKmWY
	oEY/JAza5+e/5y9HKQ//OUFa4c7niNg9l7n04SzUS8Yiy8QT7MsbsPav6YBwEQ==
X-Gm-Gg: AYBFou3mU/8t0J1CeywXtcrecyDCqeLivnjwgih3Kr0SMPxxvcKwbEe1UjF3k7jXapl
	/3gQaPEfxcVU7o8sKpRLN4ajBLaUkKZAp7dR3FkzZPv6SBLtV21t1wqAX3gfUhJhQCDUluQz1DE
	HDjFoHq0H3D+FMp0PCJSS8Z9gPBnKTaZpbJiC3i6V9KUjolZxlfzyBrDR28gjUO9Z0tJ6CQhU0e
	mpaeH5TVwODwdT/Jb3TMMgfTazFgbrh+57lC7SunqELsokj19UXCjU7+KRjziiLTAZCurTDY+hK
	Utc92ju0IoKPWJzWFXYRYZlKAYO72qExaK++ZDlXnV+wNkkIvaDhkqzdBWxgubOR/2AVAxWOrrV
	owGe5lCHxKG5x7D8inPuoWYBbfLzIWWg2nKNpQ4skd9R07w9/Ca90KDwdz/oAmMgNObgqbcmbZY
	1IRKogIDfUwbxo5rZ2KOOoqy81ErbhcF2tpDDfBI1tXf8WzsXNdyl/cIQR87N+coaxOT+8cw==
X-Received: by 2002:a17:903:2cd:b0:2e5:cf8c:633d with SMTP id d9443c01a7336-2e6004e72dfmr41869325ad.34.1791458336730;
        Thu, 08 Oct 2026 04:18:56 -0700 (PDT)
Received: from [127.0.0.1] ([58.186.69.27])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e60482d316sm22914955ad.49.2026.10.08.04.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 04:18:55 -0700 (PDT)
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: Bui Viet Dung <dungvn2345@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_set_pipapo: skip transaction elements during GC
Date: Thu, 08 Oct 2026 18:18:51 +0700
Message-ID: <179145833177.61895.7787702708373982202@gmail.com>
In-Reply-To: <20261007182057.332512-1-dungvn2345@gmail.com>
References: <20261007182057.332512-1-dungvn2345@gmail.com>

Hi Pablo, Florian,

Thanks for the clarification and review.

Indeed, unlike nft_set_rbtree where interval end elements do not have a timeout
extension, pipapo elements track their own timeouts individually. A newly inserted
element cannot be expired during the commit window under valid timeouts.

Please disregard this patch. Apologies for the noise.

Thanks,
Bui Viet Dung
