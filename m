Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A126C27510E
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 16:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761670574; cv=none; b=BWjZ+p/Uu6LDUViBiGK5T0e8a8FDMClm9ll4NHN9/B/+5tQMCTQ1A2/KEEijV7rImo0FQs6kijidyjHjBBKY6ARHD4AK7in2QmaYHv8ZVwErellKANczVkEkR1nOe4cBWuJdtq7oOg0O8RunT8arDqGOhApH4PH5ZYPdaHvUa2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761670574; c=relaxed/simple;
	bh=BGK5qoQNhhxfb/N0EqjBrjwRi2tWTX85OV0/OfmY5QM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ax1pjSq/c0nofEWxgGlCNqk209huD833lzVzvngw9mTIqfkFzusLzRxNDzX9v8Jfzhxb98HcULRLhuJiCiD/QpYso1F5qVHnIA5sSXWBHNiXngUqneDtJaeVVNSrQO/+gIjO6RuuwiDTOlsmEyEYEPW5F51G3PXOeHpRf+7ErzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io; spf=pass smtp.mailfrom=vyos.io; dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b=UYbxvSaw; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vyos.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b="UYbxvSaw"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b5b823b4f3dso848756366b.3
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 09:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vyos.io; s=google; t=1761670570; x=1762275370; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=U8xgHALpJVa6mRxOAPAoIGs8ZdJDuQc5W3yCAtAtx4I=;
        b=UYbxvSawM72b4+V82UIZMUogVUOIFJNMbGwOquso9UE/F71hiY4C8Q20Eo4nHfbUzl
         daTpAUyY9RkBcouRzzW7ZLDC7XXTV0NVdzw6IESmmhAAn0stxL+axdDRcfl5thoaW5H1
         ApT4sIVbeo8YbKeRfzmE5/Fv6OrKE3Lh9Z3MAFoPkZXao3VgmSjKb+DT7KGJa2AZkGYI
         ICpy1kZ4QPgb4ElGRhomtnbiSSr1dI5ZKaTB65alIFSb973lgi3zl2INrbF5SIjmeIlE
         tV97ms6KJNNztNlATS4MPU3++nFLoYFIFRUITYkENTeM9z64zZdW26DI4yx+yq8heT7o
         RpwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761670570; x=1762275370;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U8xgHALpJVa6mRxOAPAoIGs8ZdJDuQc5W3yCAtAtx4I=;
        b=ej8PGE9+ApchAHJ9JmCiRavcw3C0i9pr8CMw3w7aGcT3kn//IrUeXECQAt55pzqa7B
         yV+e1KZ0BadeVwZwQXUC8p34Y8fuOZSiWhezH3lNT40ok6vhVBvqWzCA4yZ4ZspYK+ns
         sVmtDNXROrfET1MZCEyQ6zV8jJpOqEroSXPov7guT6tCquDIlE0oYiDWaGSf7EG2ijJX
         bhfwMxMWZNC05YNRObn7pqQdv0e7jpky4newdH+pk54GjEQioX4XR9igQcwqSqCHuLTW
         SLmwP3eFmoBQiGwyLhZI7ssnWzjiRpcnu/tBzwfPszjjFyKKNeW5GAd+skv6rYLLDtzo
         oPOg==
X-Gm-Message-State: AOJu0YzegCwWympnBKo/MKwoeA229cy5w+w/BzA/JNv9VgS/tvJoZcmI
	+S6DlGtvSt6DULHPtwJbSZ4D4D0s57IlGJfKq7wTQRhWRtTLfnU+Ir64ztg+b11IizkNtxvtb5x
	52Yje
X-Gm-Gg: ASbGnct/KdxNwmisGfzWTWOeJo5+GxUVIHFuBl60YkWFD0IYdlHDCwxtFWHqG0o7pX4
	6ZxLmrZWXVisi2BBwFAK7BWb1AC8+7nl8s0oSN2PKemFNalyGY8V8k2v5Hb7Myv1qRA0zAzru80
	N2qdHOuWu7QJ8sQv52VDgbazqI2+bYT5sIQ+DtraW7Wc5AGF+fGrzoH2oHXwrA7/UMZkCHTLKcG
	mWS4zSptr/NZOMutzMo2782Gd2PjTuabwrL7KAa/1xAVocB07ltc8g85lwSHF3LxGVZgGIcCSPM
	yfeAYDAUJ1PswTs0mc7B5mzvOdB2YiiM8Mfmd4cCR4MCsXebugJEndqGrh5l8pH/xcuWw4nJ+u8
	dnx+OE5Gk1rby9trThR1YYzao3B0qU6TfFoVO7Y+coOlcVCjFJi/C6V5PDbjfwbM6uHpaYUvwIL
	9cWmScAtVhw9+P3Jvd6CnqRcZc
X-Google-Smtp-Source: AGHT+IFlAxP6r6qwSqgYRjv9wLhebMWKkqpFThWTkHsU+1lqFJsQYnnkzE07msT6r+K/qXyPsLRq6Q==
X-Received: by 2002:a17:906:f588:b0:b4a:d60d:fb68 with SMTP id a640c23a62f3a-b70327c88f4mr23247766b.6.1761670570511;
        Tue, 28 Oct 2025 09:56:10 -0700 (PDT)
Received: from VyOS.. (213-225-2-6.nat.highway.a1.net. [213.225.2.6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d8541fb5bsm1138462566b.56.2025.10.28.09.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 09:56:10 -0700 (PDT)
From: Andrii Melnychenko <a.melnychenko@vyos.io>
To: netfilter-devel@vger.kernel.org,
	fw@strlen.de
Subject: [PATCH v2 0/2] tests: shell: nat_ftp SNAT/DNAT only testcases
Date: Tue, 28 Oct 2025 17:56:05 +0100
Message-ID: <20251028165607.1074310-1-a.melnychenko@vyos.io>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Added new testcases to test SNAT or DNAT only for passive and active modes.
There was an issue that DNAT doesn't set up sequence adjustment for NAT conntrack.
The last patch with a fix to the kernel was present here:
https://lkml.org/lkml/2025/10/24/1254

This series of patches adds tests that should cover an issue with seqadj for SNAT/DNAT.

Changes since v1:
 * refactored/split patches

Andrii Melnychenko (2):
  tests: shell: Refactored nat_ftp, added rulesets and testcase
    functions
  tests: shell: Added SNAT/DNAT only cases for nat_ftp

 tests/shell/testcases/packetpath/nat_ftp | 108 +++++++++++++++++------
 1 file changed, 80 insertions(+), 28 deletions(-)

-- 
2.43.0

