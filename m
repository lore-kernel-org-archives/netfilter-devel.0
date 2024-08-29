Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9111B0132;
	Thu, 29 Aug 2024 16:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724948229; cv=none; b=PSDIgMiDqr04L0IOCD6LAT4sWWqJPVkVpiBdAa2er9mZbof3NxDgdKWOg8hguvmcotr4cx7ZDMeaGdxScSoOqRQxMmJ/UAkISIKGD5hVNEDZLJNUjDsYXyecCpydd94YMCEWd/a77ShtCYoSj9l6XlJg7N+nrUpnW1q9FduIq+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724948229; c=relaxed/simple;
	bh=QO7AvKeKUYKjhD9JCpJcMgmbNtqlRhAYgMyPkP9BLoI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sSsEQkcYdGprRWtDd1edJJtC+kXPX9vMHhtJaRa8TnPRhzGqwi09YW3SnPZ+De7KtKc22sZrbFBXORgl7nz/Hz5vCgEmXPAa6DKuWMdzEDHb2p2yxMIpMN1NncvuDwjRoYD0ThLa4QMMvRJN5S6czEHwSSbqFpGYB+8rsUJDmkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a86b64ebd8aso60946666b.1;
        Thu, 29 Aug 2024 09:17:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724948226; x=1725553026;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PmiVoCqkpTm1fR0+qxgPcUI1LVSiOqIdzCopqFmVZvk=;
        b=ww6NTX5ccFUecE85YWYYbDKdmRJ9u0+u/uZRNr4BTo/G6JF+lmrrfIcqlBJMHoZVY3
         PB61guPyAIEGDijzRTmWOnog6urv5UoqeE/Fr5dixoPfiODQwUzxR/2xcCJL5TZUYmAP
         SFoHOnjVRkqN0xp+nlbnYrOoNAoC80WvGtvvLtn9xk90+E9ymuRlE7h3AkhbuTIXdhU0
         lRtT7NBgrGBnLTebse4f0+Wx7EcyYUeMiVxWN5OZlOuZqMwdyQq8a43HRPSFMa5+y07g
         o6JiLzLUMyyx0vR+T/4Tf69a8pAwCA8cd1SFFyEaQWkLSySB15TCV2DL5eihF6JZlwRm
         xqog==
X-Forwarded-Encrypted: i=1; AJvYcCVDocuK1frBmscHthcG9wkdq/anOcFmex3GDsipxosxiMA3IRDw+DUj0elfkO/0pR29igpPFH8kCYa7i5E=@vger.kernel.org, AJvYcCVj2HuSf8slY4mcS4KA9RCaYQn1I09EQlfaIJ11dsRlbCa8TdtVn1OaMDilOxxNvvkwF7fz++ti@vger.kernel.org, AJvYcCWOmSqCG7H7Aq9Zhvp851MwTXYM+ezMKM8emcbZ7Rl3iBM/zTZfUpgjf4ApMiUOsVEKQjpnS6Z+yA86SIGIQxd/@vger.kernel.org
X-Gm-Message-State: AOJu0YzbjLiBrlp+Nm8w6wATiSTEmWYtisBw/s+eaGCSeNiugu5kidnp
	Z3s4kd2qnhUM2Eed9vVf2LoC/XR9MxsGREi2N8ebY+PeVSmGme1w
X-Google-Smtp-Source: AGHT+IGlI2ObNhmxpHo2caYpwI+WseL6KODVNU58UJmvzFGKpoXdnpR/8Hm0Vpc3HMYGwlkrhlHclA==
X-Received: by 2002:a05:6402:4308:b0:5be:ff75:3aa9 with SMTP id 4fb4d7f45d1cf-5c21ed8c6a2mr3646921a12.26.1724948225141;
        Thu, 29 Aug 2024 09:17:05 -0700 (PDT)
Received: from localhost (fwdproxy-lla-006.fbsv.net. [2a03:2880:30ff:6::face:b00c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c226cebf6esm844131a12.97.2024.08.29.09.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 09:17:04 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: fw@strlen.de,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: rbc@meta.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v4 0/2] netfilter: Make IP_NF_IPTABLES_LEGACY selectable
Date: Thu, 29 Aug 2024 09:16:53 -0700
Message-ID: <20240829161656.832208-1-leitao@debian.org>
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

v4:
 * Remove the "depends on" part, which may come later in a separate
   change, given its intrusive on how to configure selftests

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

 net/ipv4/netfilter/Kconfig | 7 ++++++-
 net/ipv6/netfilter/Kconfig | 8 +++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

-- 
2.43.5

