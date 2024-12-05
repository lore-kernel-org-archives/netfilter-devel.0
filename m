Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5611E49F
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Dec 2024 14:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733409927; cv=none; b=qHlSUW2gGB4Mj1DhA8sJLvrnnPRwxRY3bwq5HI5qNLVxEOcfojpDPfArSQqhK+kZLz69faaPOOB/nePmCEtbtTcXI/dQC3SiWVaA1j2qPPNMOf610iSnLGxfl0sUg5gZOR3aK2xYkwy5xm1qNGNPRYsEE6YS8rIFDhdKmTOUz7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733409927; c=relaxed/simple;
	bh=pbEz5c98jHDR4/DFEeITucEm+AUIz6sv1d8BE2tw6rI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=KqOMIB3SL4z3bx2pU1JdwEQfTGqFz4pg2FO8/1K4EMnwVf0CcnZzKRthc+p1BjGFhla/O2UUT2nctMy1kLMOpcanYrDeJNnrmJlB4DLoGehkFrYW5BVA7bgfbK91QATmVGdjxORRinmycyNRa8xYXyKW7xhQICyxo9NcQWnXv2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cC284P4K; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cC284P4K"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-515e1d6b63bso162657e0c.3
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Dec 2024 06:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733409925; x=1734014725; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Fgrv+GN2LBEaeVJ/FTM/TTU+8nfkJLCFn3FWcldv84Y=;
        b=cC284P4K1+jI8wOSxidxBini7PllRxfoJD7Cp0Im6qe9v9nmlN+b5Woeeu+DQGuHpQ
         a/5xYKarnp6YAGrLHM6zTSD7Pip4xxAnS3kUWdfYGWoNNYcS1yKOa7RdHXjfnWZlK9sL
         3CLtEprXd5ltdKR8dooNvo5Dg2BDDudRpO9eVkx38SIfxmx7D0kybYqx0uEXNqzBSLd2
         S7oVwnnLSZw3k1tL/aoRtFavHlwV2MBC2ybawdcroYg7903DEZzHDqIRYPkGruHCoBz5
         Eb/u9wcyeb2OZq6eb84Xp/sErjyYadjjWlXzlkaSy+gChX0jMzwLuoi+n3LgCZd5vacF
         q7Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733409925; x=1734014725;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fgrv+GN2LBEaeVJ/FTM/TTU+8nfkJLCFn3FWcldv84Y=;
        b=OC7KCf3T3khGpb8/9IZqY5hBfXQzKxHEopP1zcDdJRCrrPeAnOzhxYuF666Xgpd/Wp
         MSkxdM44U25QlDBRCQLNiI9twUTsMGtP2/E3Ug8CV8Ba2lJtwNgnUk02L43O5fhEzmcB
         o2dduoqQZo5lXgSH72St8mwnqXJlTmPiz9N5KG9A2pibGRuRdl4iGILSpcPGgXgTEJAs
         VD6uISUwtuuhAWZBWclZY+wtSJQ+PXfXS4YtRGn7hk/j9KGulNNj242wSjNFPsB8r8rM
         65Ek9untmmAmqyiH1zcw7ZYOnueUl8m+fw+EpwT+nOOSA7/TBH3WFfbTjk2HnIRbZ5wT
         3O1A==
X-Forwarded-Encrypted: i=1; AJvYcCXbvgexWK8J9C8HJTsIUP0dCGD/qHiJquL7kFWd/v1N01JnI4PrsIKWRGvyZZ6OKA+bhfRFDghSNfXxZIxJBe0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywg0NNBXVAaKjwkBUPb6qW091hlKUEPa/9v2oeoJS0/0HyuzvjD
	KCCWK7XIst13y80aDkIqgsOXfkFhhLKTEPNsdA3btNCcBkJJ2y4IuDxIF+tfoMEn4c6TbKCQIxS
	KiW0whFIKd0kIl//hpEkg6hnS+yJbK5EZeSWbXA==
X-Gm-Gg: ASbGnctmY36UgA8t8neL4gt7ciXLhrlA5/DQvFa2E+YmKPoqoQFcKbPGU0z8gp84JL5
	OW1hiRQbNa1yfhW8W/0681D9DQxfdlhTX
X-Google-Smtp-Source: AGHT+IFOiMg1tiV2s1ALxvVSXDETAQk3njW8DcCcpMAV58xChVISoFfkqq0962KUxkCR0Kys6OBR8oG4VmY9Ee3TIiA=
X-Received: by 2002:a05:6122:2a4a:b0:515:f27f:fd6a with SMTP id
 71dfb90a1353d-515f27fff47mr1440208e0c.8.1733409924732; Thu, 05 Dec 2024
 06:45:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 5 Dec 2024 20:15:13 +0530
Message-ID: <CA+G9fYsT34UkGFKxus63H6UVpYi5GRZkezT9MRLfAbM3f6ke0g@mail.gmail.com>
Subject: arm64: include/linux/compiler_types.h:542:38: error: call to
 '__compiletime_assert_1050' declared with attribute error: clamp() low limit
 min greater than high limit max_avail
To: open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, 
	Linux Regressions <regressions@lists.linux.dev>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, netfilter-devel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Johannes Berg <johannes.berg@intel.com>, toke@kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, kernel@jfarr.cc, kees@kernel.org
Content-Type: text/plain; charset="UTF-8"

The arm64 build started failing from Linux next-20241203 tag with gcc-8
due to following build warnings / errors.

First seen on Linux next-20241203 tag
GOOD: Linux next-20241128 tag
BAD: Linux next-20241203 tag and next-20241205 tag

* arm64, build
  - gcc-8-defconfig
  - gcc-8-defconfig-40bc7ee5

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
===========
net/netfilter/ipvs/ip_vs_conn.c: In function 'ip_vs_conn_init':
include/linux/compiler_types.h:542:38: error: call to
'__compiletime_assert_1050' declared with attribute error: clamp() low
limit min greater than high limit max_avail
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                      ^
include/linux/compiler_types.h:523:4: note: in definition of macro
'__compiletime_assert'
    prefix ## suffix();    \
    ^~~~~~
include/linux/compiler_types.h:542:2: note: in expansion of macro
'_compiletime_assert'
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
  ^~~~~~~~~~~~~~~~~~~
include/linux/build_bug.h:39:37: note: in expansion of macro
'compiletime_assert'
 #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                     ^~~~~~~~~~~~~~~~~~
include/linux/minmax.h:188:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
  BUILD_BUG_ON_MSG(statically_true(ulo > uhi),    \
  ^~~~~~~~~~~~~~~~
include/linux/minmax.h:195:2: note: in expansion of macro '__clamp_once'
  __clamp_once(type, val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_),
__UNIQUE_ID(h_))
  ^~~~~~~~~~~~
include/linux/minmax.h:206:28: note: in expansion of macro '__careful_clamp'
 #define clamp(val, lo, hi) __careful_clamp(__auto_type, val, lo, hi)
                            ^~~~~~~~~~~~~~~
net/netfilter/ipvs/ip_vs_conn.c:1498:8: note: in expansion of macro 'clamp'
  max = clamp(max, min, max_avail);
        ^~~~~

Links:
---
- https://storage.tuxsuite.com/public/linaro/lkft/builds/2pjAOE9K3Dz9gRywrldKTyaXQoT/
- https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20241203/testrun/26189105/suite/build/test/gcc-8-defconfig/log
- https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20241203/testrun/26189105/suite/build/test/gcc-8-defconfig/details/
- https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20241203/testrun/26189105/suite/build/test/gcc-8-defconfig/history/

Steps to reproduce:
------------
# tuxmake --runtime podman --target-arch arm64 --toolchain gcc-8
--kconfig defconfig

metadata:
----
  git describe: next-20241203
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
  git sha: c245a7a79602ccbee780c004c1e4abcda66aec32
  kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2pjAOE9K3Dz9gRywrldKTyaXQoT/config
  build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2pjAOE9K3Dz9gRywrldKTyaXQoT/
  toolchain: gcc-8
  config: gcc-8-defconfig
  arch: arm64

--
Linaro LKFT
https://lkft.linaro.org
