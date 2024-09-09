Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985738248D;
	Mon,  9 Sep 2024 08:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725871590; cv=none; b=LiugymLk0EJyW4oDyy/mOtnMaMrP7Cf9/vNx0H9soPNLPAJsKjRoNkQVV83xCvpLs9gPzRVOQ39guCErjHbzDL+NUZBQe6a5QaYpHUDfiuhE1pOpQcNtYK02dte0wkgIclvYhEsfizlgtwODCK8Heq2rHcMIfHYTe/pquoG1fRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725871590; c=relaxed/simple;
	bh=tcUl2hCs4k0Q7H9hc2H77LL+imHUhLH4tI42YObtmwI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jGVCplIFLmjniYTuNRl1c8j9sDVc7YfZfKaOKHAaSR/bE653BFAVX6lFmMTf1wOK4QBwHNoFLK3YnrINajZft0cAW+0CuxD9HC71Yn/xiz669+FaHdDSiWGvg5wixaCNfzg9Nfqup1T4gykxJMqL2V+D7AfkvGLoTUi8LSPAcXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a80eab3945eso376854066b.1;
        Mon, 09 Sep 2024 01:46:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725871587; x=1726476387;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SmgQkL3g7cnLq/WT19j17mFChxgwR1TulLJx2sAHcA8=;
        b=ZpnxW/Ks/Ju9PGXWywNOzd2UfjZtP6/IXl0Xczlv7NE7pEtrh076iyP10VERT8UWNa
         Hu1ufptFwGKVyl5O4y/K7h6tQVVSLP0sumwBb/QGqldnpi2lYMeL7TQizd0+Z1BrsLC8
         SjngvtgZIi3UCYzucl72f1tABHl2X6bXIh7qyv5PqSa5NknbxxRBAFUJkHtlnUDTcnn9
         jUKyRKNSHZ+AeQE1iWAchKakouH6A87VvNeb50IS1d7TzD20u6/zXtwTIoETBDbyNbzP
         tivD0xDrc6tNeLYi/0CVXppDh/SmpXdhehEzguHzHI9gIX79yo5vaWWRjWD7NcZkVFcy
         yX+Q==
X-Forwarded-Encrypted: i=1; AJvYcCViTyrAkt5GI6wItwncyriN4kuJKU13L581BgkkntEwTVNHPxUTN8En9A60ur2vr2Aa2JaKx6rWonYwGbAxt6+a@vger.kernel.org, AJvYcCXLO97f9/+Vy6bOAJXpV7O+sDm/kM6jtWp+XfSWelbH1jbeMX8BfW6RrMZw1fTbpb9doHW4ovxW@vger.kernel.org, AJvYcCXkagtEgfZQOf3/mnr4qz2ajM1YuL9tgqXWbmNI9VxlIxfjGOiZldm+JcAa3+qkHaHnKyrkKW5nA99McK0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSSXNRHdjG9DVGfZmTlRnbMHnGmqWQN8W3Ps0EMNqfXzWi6uRF
	qrt7aCbgWlKjfM/MBsTUIyxtLN3U9iasqXpDHwvGZM5Gs7pj/qOw
X-Google-Smtp-Source: AGHT+IHxHadVd7VvU1e32hlaXMljf9Ap9vwWQBYo9425NNaSR/MUDpXF1PwjCPOtWnO2AoT8TNlpKw==
X-Received: by 2002:a17:907:3189:b0:a86:743e:7a08 with SMTP id a640c23a62f3a-a8a88667f0amr776575466b.31.1725871586044;
        Mon, 09 Sep 2024 01:46:26 -0700 (PDT)
Received: from localhost (fwdproxy-lla-006.fbsv.net. [2a03:2880:30ff:6::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25952632sm311706866b.60.2024.09.09.01.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 01:46:25 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: fw@strlen.de,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	pablo@netfilter.org
Cc: rbc@meta.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v5 0/2] netfilter: Make IP_NF_IPTABLES_LEGACY selectable
Date: Mon,  9 Sep 2024 01:46:17 -0700
Message-ID: <20240909084620.3155679-1-leitao@debian.org>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These two patches make IP_NF_IPTABLES_LEGACY and IP6_NF_IPTABLES_LEGACY
Kconfigs user selectable, avoiding creating an extra dependency by
enabling some other config that would select IP{6}_NF_IPTABLES_LEGACY.

Changelog:

v5:
 * Change the description of the legacy Kconfig (Pablo)

v4:
 * Remove the "depends on" part, which may come later in a separate
   change, given its intrusive on how to configure selftests
 * https://lore.kernel.org/all/20240829161656.832208-1-leitao@debian.org/

v3:
 * Make sure that the generate from  tools/testing/selftests/net/config
   look the same before and after. (Jakub)
 * https://lore.kernel.org/all/20240827145242.3094777-1-leitao@debian.org/

v2:
 * Added the new configuration in the selftest configs (Jakub)
 * Added this simple cover letter
 * https://lore.kernel.org/all/20240823174855.3052334-1-leitao@debian.org/

v1:
 * https://lore.kernel.org/all/20240822175537.3626036-1-leitao@debian.org/

Breno Leitao (2):
  netfilter: Make IP6_NF_IPTABLES_LEGACY selectable
  netfilter: Make IP_NF_IPTABLES_LEGACY selectable

 net/ipv4/netfilter/Kconfig | 8 +++++++-
 net/ipv6/netfilter/Kconfig | 9 ++++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

-- 
2.43.5

