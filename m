Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE983C39;
	Wed, 10 Jul 2024 09:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720604777; cv=none; b=BlU7Dl3JmP6/faM/D6qyuqxdqdUWXh5+HhtUwIaMHGK+yEoW0nPW//9gGvS7Z1uCHW+tXMXjjGG3bVjMB588v82h+kWClYIKipZTWCxZEw0GZsSGz4WkskC7FN5dxW4G2pELhcgQz6hQ2wuihJ1pgWeLPHfLF5H+Tt5igMgasHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720604777; c=relaxed/simple;
	bh=87OuMfoBp1HIgSib8dcBMnekVnZsd8KTyRWTjgXz2SU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NoaWMc4ZOl6I3wFvMk3g1S6iHCc1h9Ywk3TWEefmragGZGGb1bA2wOWxbRyltSuzjD/ojW0VQnn7nOMs3nm005wKzQ/QMpIDaCImbqmVWX3+ijvgtqdtikDwPHegdBV7g3F27z+CR5Odf2+DfwnryErJztupFYeqc1beN9K7kck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dbBOmPSC; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dbBOmPSC"
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-1fb4a807708so50185315ad.2;
        Wed, 10 Jul 2024 02:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720604775; x=1721209575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i3a1COtwgflpykMRm7QZx/0MpqKdO0JXYgUvgqxRrRE=;
        b=dbBOmPSCA312Zb2IMdIXnr+PR9yz6QOx+xMR4tAR0oTh+0rP0dQuwj0c6ArV3u4sWQ
         /oa3eL9e8XggehofBJ2EiurcdgerG7yZj15OHC7r16mLdi09EEOMy1nXH8L+UEDkmVAT
         ut0Ivw9ql8e81tEPItmN+pPwydeMYCkxX4GtWa4A7qY90TnZlAi04dU/dUUoP7J8FloQ
         zmeJNUYjP7bz0ArYpJxlhxd4h3HHPf6ZFEsSgtMbvigX3pPCTx0d3FsxJcYKAxSWBZob
         okRTqUgOmUsEqNr9QTy27ajn9FvQRUVQgrargvD72wW7wI/UnxCtkgmrnfl73BAB+1BH
         Kv/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720604775; x=1721209575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i3a1COtwgflpykMRm7QZx/0MpqKdO0JXYgUvgqxRrRE=;
        b=mtVvwlhVOyvb+Yr1qsgLQnP+MrBCK8poGDcWpADTQ/W9JC018E8HIM7eS+ShL5W2HX
         SJCC7OX6/kAoosXfoiqYqL2y/3O9IcJZZMirmc4AG8eE+afYgqdo7Ck+Yown4nSuLNrg
         kgokiONZ1F/CdGYBGC1NKFGwpca+CBRQW0VxUjj8JMLeClCY/WVo3VPizzb+cD53cIMY
         xSf3lX2qZwXZz7jz+De3YGrNFwYecfUY/Qci2G5Pf/zZZozs6N1Th/XIF8zT0mgJvg3N
         BfNfnP48EFHgFcR37kzZrh0iZ0EdSOECqWhqDIYrIWhZzp4b0njCbORw9a7x4Qcz63Mz
         btGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyozc4LPO3zC5OMvLZ83bBqgOzqhicpF6xJiXmNebOgMki1Bjqu3ztzUaCpq6s41u7S/fU1WHrOSvYV5L3UWo+Zu5BKLfQxIZxS+NMZffqHUswnbrvfaGLMI0yHug5k8TzuILEzrBkBLykHWc2Pibv99hsq1lBqQtTpOGGwVXc6g/uXswZ
X-Gm-Message-State: AOJu0Yz8vRzJ1SqZjCIqHGK6pw2wdhu5euKOw41EQ6fG/Db1rqC+7fYs
	OT+W5pg/jot+tXMjaIbR9+u6e18tbIubK6EYr6Ojt4T29xUK6m2Y
X-Google-Smtp-Source: AGHT+IGvdJH3+OVZQzebmwVF4nk/h4qXhnEwC50oELwCdSIdGXrrNeQs5RPx3J9NVn8La2ZNmCKYbg==
X-Received: by 2002:a17:903:2448:b0:1fb:7f66:250 with SMTP id d9443c01a7336-1fbb6ed578dmr44493075ad.46.1720604774874;
        Wed, 10 Jul 2024 02:46:14 -0700 (PDT)
Received: from localhost.localdomain ([166.111.236.150])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fbb6a107d2sm29972995ad.18.2024.07.10.02.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 02:46:14 -0700 (PDT)
From: yyxRoy <yyxroy22@gmail.com>
X-Google-Original-From: yyxRoy <979093444@qq.com>
To: fw@strlen.de
Cc: 979093444@qq.com,
	coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	gregkh@linuxfoundation.org,
	kadlec@blackhole.kfki.hu,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	pablo@netfilter.org,
	yyxroy22@gmail.com
Subject: Re: [PATCH] netfilter: conntrack: tcp: do not lower timeout to CLOSE for in-window RSTs
Date: Wed, 10 Jul 2024 17:45:54 +0800
Message-Id: <20240710094554.483075-1-979093444@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240708141206.GA5340@breakpoint.cc>
References: <20240708141206.GA5340@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 8 Jul 2024 at 22:12, Florian Westphal <fw@strlen.de> wrote:
> We can track TTL/NH.
> We can track TCP timestamps.
> 
> But how would we use such extra information?
> E.g. what I we observe:
> 
> ACK, TTL 32
> ACK, TTL 31
> ACK, TTL 30
> ACK, TTL 29
> 
> ... will we just refuse to update TTL?
> If we reduce it, any attacker can shrink it to needed low value
> to prevent later RST from reaching end host.
> 
> If we don't, connection could get stuck on legit route change?
> What about malicious entities injecting FIN/SYN packets rather than RST?
> 
> If we have last ts.echo from remote side, we can make it harder, but
> what do if RST doesn't carry timestamp?
> 
> Could be perfectly legal when machine lost state, e.g. power-cycled.
> So we can't ignore such RSTs.

I fully agree with your considerations. There are indeed some challenges with the proposed methods of enhancing checks on RSTs of in-window sequence numbers, TTL, and timestamps.

However, we now have known that conntrack may be vulnerable to attacks and illegal state transitions when it receives in-window RSTs with incorrect TTL or data packets + RSTs. Is it possible to find better methods to mitigate these issues, as they may pose threats to Netfilter users?

Note: We have also tested other connection tracking frameworks (such as FreeBSD/OpenBSD PF). Also playing the roles as middleboxes, they only change the state of the connection when they receive an RST with the currently known precise sequence number, thus avoiding these attacks. Could Netfilter adopt similar measures or else to further mitigate these issues?

Thank you again for your time and for your efforts in maintaining the community's performance and security!
