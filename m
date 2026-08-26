Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADD7480DD5
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2026 22:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787781897; cv=none; b=Lnx3rVof2mPzny1b9IpdWTCbULJflifZg5t9aeTZ17BKmiPnV7WicMgsiCQAT2JL0SE+czJN771q1YFQpea9bYY5EK2v6DM7fw6SwIeIRvhtzFi0H3nfUWGHoaXTAZFpQNYOEdP3/IK2045W+r0dK74F2tIo1Cv8dVp6za0snv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787781897; c=relaxed/simple;
	bh=avWavNZj+ROQsclS9fDyynsASSegrDqu/qCZGFh8iYg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lz64NrC4b1ZIDY2tbJ+KLIFpuajzlGO835Wed6dG/8MFsnLKBaTjcBZN44w8NofNvPmGbgGCgBSMx3VBevBfMvixxcKN4DE4AFHrERF/oIzZ3DndSRtd1IIyeppg+O+1Fn1LSrEgotq8XcsnqEJysF3QzeNG863Ugb0VLov9pic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-482e1bfcc63so257362f8f.1
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2026 15:04:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787781894; x=1788386694;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+OIG0D3qhm2TUglRdX6PNbg8gac3xIElAw7x8uuU1sI=;
        b=mzui9Li8t+1+Ggh3GLQpcUAFou4taIXFHI4qLZHdgrY0eVdcK9ZNh/Aca18qIcs8Lp
         5ZkDxskcBW5pMVlBK2khvYCwQcnzo6EIQbw0BH8yXFLMmsQPnNsA/uSuju6xfzCFT0i9
         N/4yfgT2AWTFKuxx1W0c3QX9HSZnupQcAywej2ZRPsEwLYNLuh+KTk+CVVb8h4eLwQRF
         7A3mMT7CZS3blojuwNJrWnj8Xn3PJmHlfF1Ffwwd73yUBeNveKqqY6BLt9KgbzqxItdQ
         jCCDBSj5vTNrgfLoChR33otdRnxLJ0PgpJrJbeKz3uXTn78YPWmhyj2Zjo305Dj91WmB
         PLGQ==
X-Forwarded-Encrypted: i=1; AHgh+RpD1RulwXoDLy8A6Wd/s7KLabntfV91CZ9wLkTj9CjliFaGH+5tLgqjrj7m90RwYlRiBn7UvUyyz4+qGrli53Y=@vger.kernel.org
X-Gm-Message-State: AFuF++m+jfF2zPfO4nYpTZYdkgLKeDYqjj53VENIbajhgx3rg3lFsrKU
	HHkIyh+nlt/0OA1MXugocWtHgRqt+NB15FqBEXg8SG89Ulem67DYkCG/
X-Gm-Gg: AR+sD11zl8r9REwlsH5WiLvZCuRA6AwhMg5fbq3l5zk8fZcsIVyAaCiVGlf1OXgZZjM
	wb2gs6hbvGxB+9jkVMsWdI98G1Pey2/3mOfY1d7TFP1ygD5vjgVQ4452UUGMvamNuozb608Tuad
	9MlMQpiXlYwKsXF6grTtjCUmDF/nVWHgVLOUsDuGmbEnbzea82vDepdxa55Sa0sXLeEULifKKpX
	Z5UGtr9AeFsVjnKXjCT7IU2XRnmyK/x68g0qwQNehCgYxcN8Dkr75ilkK5FONruN/D+Qg46LGRm
	kgAtPpvBuIYOLgWbxyP9wRlghl4yavU3KjqCSCixOuJJZeJbt+qWq7l7UQzxvqXXsiascIj4OEl
	QqpvACsNPPqeoNQdVf6MygZ1DPD7mbCHM9Zizv3tWDbDqIc4cB+koziC0aTGwQLT/HhkayGLU8C
	Q2xiTYIOcTw/nXlAHBL+IR4gmp86PmbpeZYQ99SXONHEDO/17BC3frXfQazrL6OeO5fdnB2HScu
	TAO85HMSMMwiPzRwA==
X-Received: by 2002:a5d:5847:0:b0:482:dd86:348 with SMTP id ffacd0b85a97d-482eab6a866mr2110147f8f.4.1787781893856;
        Wed, 26 Aug 2026 15:04:53 -0700 (PDT)
Received: from im-t490s.redhat.com (37-48-53-4.nat.epc.tmcz.cz. [37.48.53.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482e27a9f0esm4446370f8f.10.2026.08.26.15.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 15:04:53 -0700 (PDT)
From: Ilya Maximets <i.maximets@ovn.org>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Donald Hunter <donald.hunter@gmail.com>,
	"Remy D. Farley" <one-d-wide@protonmail.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Florian Westphal <fw@strlen.de>,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Ilya Maximets <i.maximets@ovn.org>
Subject: [PATCH net v2 0/2] netlink: specs: fixes for conntrack dump filtering
Date: Thu, 27 Aug 2026 00:01:10 +0200
Message-ID: <20260826220444.4054714-1-i.maximets@ovn.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Version 2:
 - Also added missing tuple attributes for the dump request.
 - Converted into a set by adding the patch 2.

Version 1:
 - https://lore.kernel.org/r/20260825155832.3685714-1-i.maximets@ovn.org

Ilya Maximets (2):
  netlink: specs: fix the conntrack filter type
  netlink: specs: add missing mask attributes for conntrack dump

 Documentation/netlink/specs/conntrack.yaml | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

-- 
2.55.0

