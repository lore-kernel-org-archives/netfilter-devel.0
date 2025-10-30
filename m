Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3CE285C96
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 14:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761836258; cv=none; b=l4McgpqSJKeOBCApT+Ghdi1n+DkEdPEDLLtt8lCY+vbE9u1Wnk9JUVtr/q8BsXyScUdGpoSD92RzuPH1yJWdG4EdBPnJtiTIQrwy3pRmTZ5dd89BjeZ2GHXQhaBKfTt8ZV2zLEs/a5yynXhY+0OOinjdOM83FWhU4YzwykjbUpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761836258; c=relaxed/simple;
	bh=TrRVE0hf7HZgp8ePNasrFBmr9yoCObVIUM9w0G4q6Gk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=lISwCmPUjv1LFjT65XSGWNujk147HzJUa5B5ctMx9rD4SML8OyXyNOoNc/De13O5u52BBVzxyAq72BVL0gg0hwsaIdIMaLHQNiEZKX93z4Bp/lTZTW4rNXG1IF8O3loKRjq5heAMDV9MShvicMdRkzIwJoWJrVwc+qhCboH7ByA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io; spf=pass smtp.mailfrom=vyos.io; dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b=jx2P84P7; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vyos.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b="jx2P84P7"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b70406feed3so107920966b.3
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 07:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vyos.io; s=google; t=1761836255; x=1762441055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=PVHAcf7q+obbngERqw9vi7/nXsztkEyRjj9X2LOlXlA=;
        b=jx2P84P7Jt5URrEBcmgJcCH4fkQVrJmR68XapCOfY0niHBDT/8TiqUGYD6Cv1OKH3i
         KctQzWBOnZgnnYvmN2YPtnrdw9fu47enNPFTosWOvps659/NagCxNLkGscQSmDrTj5OZ
         WFdbrIwrHpO51ZjeBHb/Y+q2VBGujVtD9AyIxbTPEstU8twW8a9KvcdnHKQhYyx6yUQg
         /tSRScN8E9LnhGLIAloG3cffbVfFP3kYCGdQ8mAbaGc/nQy4Dj3zPYSoJC9BTXMn8Hc3
         JaeC4GNdZfp/2b6mhC9OGwh6zGhDjZnv/MkZAW59LdA3ZMDqCzUSsMZMCUtboE/0YJhT
         WHng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761836255; x=1762441055;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PVHAcf7q+obbngERqw9vi7/nXsztkEyRjj9X2LOlXlA=;
        b=BbJSF825ZEK6jkp8JdVKBiD6Lpx/DnUF4AjxBqhie6XzScGKhEyXu+Un19Hx2BAU/N
         i9a6kZDst0ITV/uR8eTWrgznqooUPIvSRtlN+Z8Mhx1T791ZrbVcE403Jeaim5wj4Jqn
         ScUhQ/0cpxLVf0u+ZjLUXYw9jM+mdzYO5Pg9Zx3+QkQ7pInfI6jNQ7FSqtmar3HRQMST
         2h2O5FiY/mKhk4PrlVBJ9thaI0JL4Y1mGZ+pvyq30G4VSHw8khzyC3ZwQ8LqQTM9unTc
         5jJASGWglkBpUA4QT/5a6u7umxuZkxerVkmAdeycmz87wgqyk+i7GBJfwJFQxgxfRC01
         DTAA==
X-Gm-Message-State: AOJu0YzR9x8GvvK+iqUU28P9x5YW4evta+FehkI7UB5K0J4iPYbBXSod
	1aUEiFnZXStbHJJbJkqmRLmm9pZlD3zVFdmEZ7z6CiPxpFpSm0C5kUr9nroigyvUNtVmXgWjRpj
	7waXg
X-Gm-Gg: ASbGncs17chq8MpXqJla2SKRRFSVXeCHQOMfVqArBp3EP9VHTcoGc92bzjWZt6D/nFW
	/DtAx4QNwS4/JUb6Mw5y4UxG1lh/yvy1llNeVbYPY0uylv6fwKSKKyxdgWVtFB2kF53ABa1Qh8d
	+TFdgHae3EnU23bPJSXtHFQGdjtctbrsSyGE0hIXFp1tQBedJaCewr8fg/JozXLSr9fUn9GqikC
	s8GZx3biaWpZe7lByKofJyB31Crv1zrpi1KB1XZzi9QfRjPpI+O4ZqVLSHX5OYRj8fwnltTALDh
	o1jSDNyacdhpphoZlBZSnxKbFbnMQXE5jCA1qkFv8fbxb1nF57+IhAMDSCMPJHkmcIjTuv5fRn0
	92ooYkvaKQn8zWYAZ/k6kJzLkbxy13Sgax0LB1222S5UQaoYu9KouuuXmI4z3AAo2cl6K8Ue78X
	0WUo3dEhQrVwfBw+yljgfeQfur
X-Google-Smtp-Source: AGHT+IGmXoiHuxbHgqQmbzLJi7KOs0eaBQ0Hkk8jP+v31rpzm0syDv5JofUGXs2ELEB6kWAY9Gexxg==
X-Received: by 2002:a17:907:6d1d:b0:b40:da21:bf38 with SMTP id a640c23a62f3a-b7053e2af38mr282636566b.36.1761836254732;
        Thu, 30 Oct 2025 07:57:34 -0700 (PDT)
Received: from VyOS.. (213-225-2-6.nat.highway.a1.net. [213.225.2.6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d853c549fsm1790483966b.37.2025.10.30.07.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 07:57:34 -0700 (PDT)
From: Andrii Melnychenko <a.melnychenko@vyos.io>
To: netfilter-devel@vger.kernel.org,
	fw@strlen.de
Subject: [PATCH v3 0/2] tests: shell: nat_ftp SNAT/DNAT only testcases
Date: Thu, 30 Oct 2025 15:57:29 +0100
Message-ID: <20251030145731.2234648-1-a.melnychenko@vyos.io>
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

Changes since v2:
 * refactored, added double-quotes around IP parameters

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

