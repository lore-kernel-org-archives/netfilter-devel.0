Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D2B34CF5
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 11:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751629204; cv=none; b=kPTAvMVB8PEDj+wnlkCG0xoWiUU97cqsmb1/hzQNOZec50b/v8FhSvS9qPc6gPAVXWmJH9z2I4taLmG/JlTE0qljoPjg0oCMgSKKRgNEcuSUVcIvLCuVJKeuQ3RW/fmYcp27OdrnaHygdmaxUOuzekWzBMEq2zIRhJDCUvIh0v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751629204; c=relaxed/simple;
	bh=2//bCdT2DLUCzIWLuTB0QvjTLKMl9K1umuIBJmiqa5I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=osz+JhJUXxWwetEPhCThgCX+xEmrI/I5Kay+QZykbpKAsZNcvk2AjrEyA+X9h+Xkben2CppWpbqh22igcnhs5ut9CKOOInEUWyax7sXFMz6oUwoN6L4ieJ20reySGE0o/3gnBIAcphBTXPGYbAZRZ6OsTOCXG5nFbNlZ7eBu3wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AtLnqkPj; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AtLnqkPj"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-23636167b30so8983505ad.1
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Jul 2025 04:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751629202; x=1752234002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xKv50sYmrmDYIJadHGsG78Y6jy/v4fptBIgSbVHDYX8=;
        b=AtLnqkPjUW72ttGB0r2Y4iNpv0di4x32GhmifzM8W2Faqo3yPwZNgQ0+zfBIGIxxEj
         u6ZFqCeRuC3Ruys5cPuwXHO1BrWZteanX6Y6iWuw/w6fpc1kN8U+jZM8vLI+mrLW4z6Q
         HnhryjDndrc5mYJJItALtIYyrr2q2cGbCtD5gl93EExapv2HQAfmKFo1+KlSaj7azKTv
         xJk+G34pGG9G+istjbp/GD/6wHZmnqPgEwM7fp4GMeC9NJYAumObvhAn9ECZJgqv+9N0
         vMyg6OvuNNOpFcmWrUx/KTEjPgHG8OLvdKB8osbz4ZhiwBQLNPIeM2QUZuSjfE4ZaoX/
         HhFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751629202; x=1752234002;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xKv50sYmrmDYIJadHGsG78Y6jy/v4fptBIgSbVHDYX8=;
        b=QFkb6z446rTyI25oWQnt0Yv9eGuQe6fU8BzQBd0o2dSczFVTZcp84T6ak9TzfPpru1
         zLg3rv7d91Evq/C3TLy5OTsD1MQi4P7EnxYO8So4v0BjYfm1MaA8BK87aMyPEZ3NeLe3
         OSaH3kXh4FyIPf/TqYZUTH/6j0muQ5L48UNaJBs9d8gG787ZnpO3IO3sKRo0UTe+g6YQ
         CS3Iqyl4bDR7huuAuR6e63Mx1T4Enkdq6K1bWj5dsmR0zhKukntfFQdadqKpT+svXd2Q
         atihYscJPI4x9TgaFebu+VoboTVYbpsL2O3g8U7b2dBO+u55da5RMSQsoTzo4IKlLr12
         3TUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvnsNp24PvdVzMVBC/5PcN/TJfrYT9CrICoujGmkPooaFS0zZws9qplp2Ac+BLeYxntb4Cin+dKM2EQlZbZd0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJcpAjQZUiR10w7MQxlR8UfQxks8JyJ1EefmDzCkNLTCSvsC/O
	oO6ZEfKW7tVJXYuWANVH4TtzZ9Mx1cclz73dIL8thmXvG+u8RsqFcVoYnQMw3A==
X-Gm-Gg: ASbGnctal5Z/67DP29rY+g3uv0TrT64s7I1Dt8aTrr1KO8cR84Rbf0yQS1UcC0SGAZE
	IPTREIcH3IH4yHKWtoHuYYnWdMEUd27jVkViT/2sa2oJ2yATU7oavgIT1/uilZ/m82V6/+4kfZR
	7dYx3lsR3yHBxKa15aP2pCiW79ya41fx6dXEsXtird2Di4EsgIRxZjvYe6IHz46OtfANIOrHXhd
	5L+yDa225QA9yVQsEt4/mEyZfcEbRVr4OAOEIVlYcjW20Y0jYorvA6dgeKAQF4BdKaTPzPWY25r
	2E+M2bYTCEa0auodielFsdmEu86dM2jOnatkYYL9cPaP69W8qo2qAlisCKsfVBV9K9q5DJCwhem
	w
X-Google-Smtp-Source: AGHT+IGvoLq7jJqkb9wLlI11+tVnAG2OYbA/cJl0bvDb2e3r91LsM5XXdcdOVdwBemW9fErwOxL4Mw==
X-Received: by 2002:a17:902:e80f:b0:237:c8de:f289 with SMTP id d9443c01a7336-23c85eac7b7mr33722015ad.36.1751629202160;
        Fri, 04 Jul 2025 04:40:02 -0700 (PDT)
Received: from localhost.localdomain ([103.114.158.1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c8455e74fsm19585365ad.99.2025.07.04.04.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 04:40:01 -0700 (PDT)
From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
To: coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Simon Horman <horms@kernel.org>,
	Fernando Fernandez Mancera <ffmancera@riseup.net>,
	Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Subject: [PATCH nft 0/3] make the mss and wscale fields optional for synproxy object
Date: Fri,  4 Jul 2025 11:39:44 +0000
Message-ID: <20250704113947.676-1-dzq.aishenghu0@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 makes the fields of the synproxy object optional during parsing and
printing. It also makes the order of the fields during parsing insensitive.

Patch 2/3 to print the synproxy more pretty.

Zhongqiu Duan (3):
  src: make the mss and wscale fields optional for synproxy object
  src: do not print unnecessary space for the synproxy object
  src: only print the mss and wscale of synproxy if they are present

 src/json.c                             |  9 ++--
 src/parser_bison.y                     | 63 ++++++++------------------
 src/parser_json.c                      | 26 +++++++----
 src/rule.c                             |  4 +-
 src/statement.c                        |  2 +-
 tests/shell/testcases/json/single_flag |  4 +-
 6 files changed, 48 insertions(+), 60 deletions(-)

-- 
2.43.0

