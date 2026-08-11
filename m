Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1D736B906
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2026 13:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786455786; cv=none; b=BLoaek0DH1FAtjF340vc+FTKM+5FVtmGNEQWw+QH1tnxCAZMw1T7rCLBbMzPPjL06wVp4RuWob9scQUfqE72qQgOJY8H/5aTcaD0eOhO/AUsw1Htf6KaQaqfmxkR8JIfMyJK5EzvkPR4XxL6qp+hbSN2JkNUZrvLKdoIqhUGu8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786455786; c=relaxed/simple;
	bh=cOZ6JP01feQLUHp68DDVbv41+ssgioWgmMLcZTORTfc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DHw0E0bEhj/Q/bi2Apn3x4Fzfsi8tehfVC53X4Rdd9hW01fjkKLTWLKh9hnePhB53ufhHLJPzJ1g4Y+y2Xqc+9IVdFmAC5ph47STDc3xHp4xzPTdNAQiJwYb+2SlTKkXTvyA4pv4/9r8Y3UfTTx+GHj4dKxnjrlbi4z9jH4tnkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qj3zRGPW; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qj3zRGPW"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4954aff6088so26861245e9.3
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2026 06:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786455772; x=1787060572; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fnsyaFjt0uW6OMr6+HX5hTm52P2wN4lBKt7G3It5ZGU=;
        b=qj3zRGPWG+YbCM+ZhYn2IaJW9me6IN7GJ+iawjU5Erfmvo1sETkOsubyF6PYGkui+w
         uLxA5tafKOtQdJWdk2m96k1pi/pwLbwYeV4b9i0+cfBRGl5nLs4aHgvP4GztWvuITXvv
         tq7KIOgM8XYV3xyp7IfpHsCq6RDUr8HMoZeZstYrt4XY53iYjPba2lIK4qwVVBVaCn3t
         CM6DYYz2WYKVqtQJQlZTfHuWBm213pb5zUvz+ECXxzEHjBqvbdms/MsAXJliQQnBXjou
         czIBilGPHdkfiSRJa+IIksYqPjKY6vJfitKgGcPnbkYYyDkF1kmar1ZY7jYDyq33RGN9
         o0jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786455772; x=1787060572;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fnsyaFjt0uW6OMr6+HX5hTm52P2wN4lBKt7G3It5ZGU=;
        b=mhos1deGvP5d2OgpXcuEySciqWmkMQjxK/5gaXpEmX0iKMNEl3KxrAbUxVsMo6IAq2
         KtjTFsY+I5wtf2gQXSuZgyIQO2QUONYepFkQerxM019ugIeu2+GLihVRHkZGqaQPiQes
         SrVfFwlKabE7uSV6YaMXVEGIo5O/mPiqrggAjEI1Ypp2ag7OuFuOdhCQ6nWYPWFcW6D+
         18ArXuuHg3E6jqq7OEDIebPmj0s5hsBRaLqiA0TeMff/OYUxHOgw/Q6sq//ae/iKGucq
         zanofeJkchLxujToygjqBc9Z+v0uP+og3VgOOqT84EJZvXYpTcmTczIGdTRnq92yX+QZ
         7YnA==
X-Gm-Message-State: AOJu0YxTVX6s678/IjgfxZZyzWRkTDGVs5qN2zr2VqVJCnNFbulIK6AG
	0eNz052/nEVbqpoA2iNmXgpLSdFUG7wrYraIrneBC+7sTD+L/4wt51FymfppiXit
X-Gm-Gg: AR+sD10oGcaM77GTSCcdnorVtGNrdY6Ok7lDp/c5hlmiT9hVlTdrMPrwoCf/A2InbxV
	Yheh/AmQCy1F/sZYA4pSA38sRfYfULwoG6T8SkuYO/s+UVaNSWRsy5kRrX+0wpck45GJnZTX+1x
	zJL9Of8MoK2O1QiNltY0P2n2KnQq1O/5XHRwXSDM48oNaQsFxdihu5PrfcAyBOx64zUN14E5BZD
	DDD016SL5MfVwjcmgWgsKqVfOwpo2x9XlehmlBqP4rhmhNTGLpeBrg59EMp6u5hcrPoCRXLPA8t
	qkvhA/qoEOirBtEEmtBuaGpSbMGHGy4OuFLIMotrTGhr+ll1pk7PdjN3CPBsyfDxt17w9XF87TC
	K0uIVSjiovgIHv88khY57vDuX6dqDBq8QBV6+SqsWn1aY9aVfKtMggwJfr69ip5cLyZ7/vj5dSd
	mVpMbgfXDNhr0MwGiW3gZc+8AQvi1RP3DQpiIxtm0hSMCy8WVsnrz7UFnrUudSIwl0g87ldorj5
	ODmnNffS43bKg==
X-Received: by 2002:a05:600c:4e08:b0:496:bffb:fb7b with SMTP id 5b1f17b1804b1-49978444820mr64036945e9.10.1786455772238;
        Tue, 11 Aug 2026 06:42:52 -0700 (PDT)
Received: from DINA5CG53728ZV.evosoft.com ([136.226.199.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49974146933sm80558755e9.10.2026.08.11.06.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 06:42:51 -0700 (PDT)
From: Gergely Palotas <palotasgergely@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Gergely Palotas <palotasgergely@gmail.com>
Subject: [nft PATCH 0/2] parser_json: fix JSON delete of ct stateful objects
Date: Tue, 11 Aug 2026 15:43:24 +0200
Message-ID: <20260811134326.300827-1-palotasgergely@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

JSON delete commands for ct timeout, ct expectation and tunnel stateful
objects have been broken since their introduction. The dispatch tables
passed NFT_OBJECT_* kernel constants where enum cmd_obj values were
expected, causing the delete path to send the wrong netlink message type
to the kernel (e.g. "delete chain" instead of "delete ct timeout"),
which returned EINVAL.

Patch 1 fixes the mismatch by using CMD_OBJ_* constants consistently
throughout the affected dispatch tables and the function itself.
Patch 2 adds a regression test covering JSON add and delete for all
three affected object types.

Gergely Palotas (2):
  parser_json: fix CMD_OBJ/NFT_OBJECT mismatch in delete path
  tests: shell: add JSON delete test for ct stateful objects

 src/parser_json.c                             |  34 ++---
 .../json/0009json_delete_ct_objects_0         | 140 ++++++++++++++++++
 2 files changed, 155 insertions(+), 19 deletions(-)
 create mode 100755 tests/shell/testcases/json/0009json_delete_ct_objects_0

-- 
2.47.3

