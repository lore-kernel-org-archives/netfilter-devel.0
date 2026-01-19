Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C510533D6F8
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 14:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768831708; cv=none; b=EZOk0y2V/4zmgpkQFaXZTgQo2E/AI2N+ov+lK+9H/N3ep2JF/+Y4aBYzPkVmAGFMsdSuKvIfiOTogW3FLostgdeXO956Pc5h9QFpvTBa83j1ysGzoRE5qcnRsNzp9YWHzQVCZCpRWdhKfNjP0fasbfu+5dORrU3y2vdV8a5v6oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768831708; c=relaxed/simple;
	bh=oMaHFuPk2qdWcST6+H3l2cdwk+XiQ5WlBc9PtP8rVf4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Rk7YUINgaXFjyqej8fM2DCdnmsIuinFJ6JTEB3VmzgCjZXAPhl3x+6KTueAyesFK+M8OIH5es0qC9DNAiJH8KK+c4SOHtKmMxyJ1rH95QgDKdJBF6ImfehlNRKVfpoNvJBwCd3HvDu/b1My5h4PrYpn7PfQnt/9w9N1l3zN+2+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fMRXKWAy; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fMRXKWAy"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-430f57cd471so2203241f8f.0
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 06:08:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768831705; x=1769436505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aQT38DfYGgL3vuemDYOgR9fTwZk+vEwLNwzpsN5eysU=;
        b=fMRXKWAydOKKy2biNTV81Rt8yreBB1mqoAc9uk5ZwB1c2wg3ZT0ZC3Sw3mYZgQ+wqi
         HXctCfp8AwOGwMqOZMpIYYLNa7ChTcMBqpaKmLWuHI3fddtatY4D0Py6rRMFQS6TQGel
         SZJEhhqYV3Pb75zXHx6xzimhGnW6BAqFMuPRSY7iso3aIAopbz3Ha1PwxVf6ZrMrlSUK
         y5VeMu4ooE2sHVmoJsla1xpMmHusZBJd8Y0BhdhoXjHiV93o1OWNc6rQtm/JGEyuOx9C
         VBWiCeHaVWs6XiR0qzRvdwe/aFUQzpKnPEJeV6EgZ58mYs2JggL/tHj1+4GD+6hm9hkx
         CCVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768831705; x=1769436505;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aQT38DfYGgL3vuemDYOgR9fTwZk+vEwLNwzpsN5eysU=;
        b=DgZjukQYRzN5+sIwMzX+AI295e6Di41TDT6puQ3+nle+OaFNl/w8VY4Qg32dvh8hoT
         yc/IImgKHoS4nOhpjy5pRn199zogNbZsdtdqyJfdapmABvFsYe3hkdsvanpPrkAbhqdC
         ocWbB1QV2G6zni2cnXaBl6G0W4rYJWqOy/3m2egUOYrYdQBA+QhzENwVmi84VT/vDMad
         thvBma8J/Zik49BEz44PJOsEkPTIgFmKGmyDw834tcMhaLcmVws/XwHMpQ4ncv/Ni9qy
         m6I385LLbmQi3lA+fW7B3F1HkvL9f7+Q94KeMbt4q5Oo4dsElmxenlGsp2XKSRgJIpr0
         3/aQ==
X-Gm-Message-State: AOJu0YwU+31AR8p1QUdE880PmqK5cD8pNztk023xSrufIeG4oztWNDMN
	7UAEQ+1HomYGQofTlV3pgjRUHusYCqNJ+tY1AHNZzi43GY7hy6unZ76V5CjTug==
X-Gm-Gg: AZuq6aJBf9QBZ7qp+LSyf4DAfUj9gsj7Lw7Q3ucJvnhhJDwak7cVdW0IyVonskjGyAP
	ZRusQNLyFJ8fg2LIXCcE2dwoMd2y1HnPAhe9d1OKv4oAEHdYyRSK4GuL7TfyqWD9NdWi4ZmZdI9
	oSKQyJJRmJS/RWxGPeSNkJpZhBBI2QW50puOBnL5af4S2QfClXnOcD+pl+wyFLPG8RE6FdP/5AR
	YqHChzKyu6uvlRc+/AEss+g4lWQNYhghMllpPw8x8XWxoSAjjlRSDgUt2yzVFY/bZDqPFnJYJMg
	sw9mDi0eIJKmO+dz3AwGwwfGF8WkLXpZ/f/KAob9C1h4KeZdMEvGK9eQOaJ19WoYi5uv+RzPqxt
	rJGAEK6SPJlImHZHUTHO1T/fc8KXyNSGsLG42owDg3bv1MT+rBDkomoweoOaAV7iN6vQtryBOll
	YQ4VaQ7YSypHh9Mtsh1rfC8HwOMzrPBeTstbI5Po/DmBlVqOZe5/oYWASbpbIO/rU3UkM4+LBJC
	s6D5w==
X-Received: by 2002:a05:6000:1787:b0:431:397:4c45 with SMTP id ffacd0b85a97d-4356a0673f2mr12130184f8f.59.1768831704067;
        Mon, 19 Jan 2026 06:08:24 -0800 (PST)
Received: from bluefin (2a02-8440-e509-8e1d-0fa7-f9cb-e455-a769.rev.sfr.net. [2a02:8440:e509:8e1d:fa7:f9cb:e455:a769])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356999824csm23233975f8f.39.2026.01.19.06.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 06:08:23 -0800 (PST)
From: Alexandre Knecht <knecht.alexandre@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	fw@strlen.de,
	Alexandre Knecht <knecht.alexandre@gmail.com>
Subject: [PATCH v5 0/3] parser_json: support handle for rule positioning
Date: Mon, 19 Jan 2026 15:08:10 +0100
Message-ID: <20260119140813.536515-1-knecht.alexandre@gmail.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series enables handle-based rule positioning for JSON
add/insert commands.

Changes since v4:
- CTX_F_EXPR_MASK now uses inverse mask (UINT32_MAX & ~(...)) as
  suggested by Phil, for future-proof expression flag filtering
- Removed nested block in json_parse_cmd(), variables declared at
  function start per project style (Phil/Florian feedback)
- Test 0007: Removed redundant insert position check (covered by 0008),
  replaced grep|grep|awk with single sed call
- Test 0008: Added test for insert without handle, added test for
  multiple commands in single transaction, fixed error message typo
- Added .json-nft dump files for both tests

All JSON tests pass. check-tree.sh shows no new errors.

Alexandre Knecht (3):
  parser_json: support handle for rule positioning in explicit JSON
    format
  tests: shell: add JSON test for all object types
  tests: shell: add JSON test for handle-based rule positioning

 src/parser_json.c                             |  37 +++-
 .../json/0007add_insert_delete_objects_0      | 145 ++++++++++++++++
 .../testcases/json/0008rule_position_handle_0 | 162 ++++++++++++++++++
 .../0007add_insert_delete_objects_0.json-nft  |  18 ++
 .../dumps/0007add_insert_delete_objects_0.nft |   2 +
 .../dumps/0008rule_position_handle_0.json-nft |  76 ++++++++
 .../json/dumps/0008rule_position_handle_0.nft |   6 +
 7 files changed, 443 insertions(+), 3 deletions(-)
 create mode 100755 tests/shell/testcases/json/0007add_insert_delete_objects_0
 create mode 100755 tests/shell/testcases/json/0008rule_position_handle_0
 create mode 100644 tests/shell/testcases/json/dumps/0007add_insert_delete_objects_0.json-nft
 create mode 100644 tests/shell/testcases/json/dumps/0007add_insert_delete_objects_0.nft
 create mode 100644 tests/shell/testcases/json/dumps/0008rule_position_handle_0.json-nft
 create mode 100644 tests/shell/testcases/json/dumps/0008rule_position_handle_0.nft

-- 
2.51.1

