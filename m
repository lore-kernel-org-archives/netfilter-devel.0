Received: from mail-yx1-f67.google.com (mail-yx1-f67.google.com [74.125.224.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5B13815F1
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2026 08:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782377013; cv=pass; b=TrDSQ3hsIbz6Hzg9CNsOzP39XXG+UeAxQQYaQ2tQIVL1dbCaDb1HPge1GejXFyl5EERhLlWwcXxSB0zu8eSH6RXzvnucW9VH+lyv3T3KlEV8TBoDBIfV/uzHJSCVts5y2bedvk2oUAvI4B5LMT3MEDiClmbKrdp5R8UmJf4Ndcs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782377013; c=relaxed/simple;
	bh=mGpT0mWPqC2KWgtwKNzuMrjVF2VL6ygAEhIG5vWOrM8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=FWeYk7woiEJNJOCbuoV2Zyh1ZuaTfwe+BGRbVzE0ucd4fblzcHztSbdTJbicCIeWgyWAjhdlgSFK9znJ46BPU9PRxO095dQNZ6gb2s/GlXCwZVZq6St68Zs1khFp5Ao9VJilSEG8DuYGFlII+T+A1Hqtz1P3kA/EEf8wGa3w+jc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BeRcCdCW; arc=pass smtp.client-ip=74.125.224.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BeRcCdCW"
Received: by mail-yx1-f67.google.com with SMTP id 956f58d0204a3-662bcc30fafso2074098d50.2
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2026 01:43:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782377011; cv=none;
        d=google.com; s=arc-20260327;
        b=joxVsnVon7ZgyffV3NlSQdevMn8mdXlqnj+iDUxBYb9muBZKAOSDrBrQChx9OwFXqb
         DzrOsFDricSPDhnKPMUAOsCgwtUwNMH5AFOn25/vfDBOr+NzqOAVB/wgNCFYLCgnQjBW
         cu/t99d0BeLWMi+ME94XTUzSzcfiwTK0YphXEINJIuvV0o6dEu3M54kCYOJIZrZTYmfT
         gpnc1B1kvfHEklRR2+fk0h5MGCRTFRsXeBCJw49jxXXdFE24mEpVninOHIlDxQVJ0jUM
         XCnsujICj5+N7+rdjrmVLeiY6mzz3w2hBetgokozYNjsFA0CvjVPoCpeW3ftF7mJBuu/
         COQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=X17+C6koDcrEHBhrTALNZmXozmPiBoMdmIQHg1KU3BQ=;
        fh=i8nWucUDDcuJZrAc5F/lTqZ3W31vqALi8eeFadgPUj8=;
        b=JNeoFa4rDMpHFdfF7XbhRmZIi5uQ1TopdCW14GgBd1/yP+NJR/vERYpXx4SPFMY4he
         7HIERtyREW74TjWJ8fExA/UfXld5SpIzG3ELVE8mXYN8dowYjoKcQHak1T6qfroOwIPj
         d86EL254d/jN4ogO6CQO1xHQJaQi26ORiVkSoEkBclKGbFX3ZbrN80vRrD5sMsiPVndY
         2rvyd8/u3Qf/U7I6KL5CV5JAd2uNrkJCj6ZfEH4bA6MgN5uMrJ4Lh15G+qTxDUbUMFYc
         YCf0Y79HJ/zmZC4ySlha5PprSAoPzyYc/VBsIU+GCOPs1aJ3aKp/4Q4GFesAvCw+s6Mz
         x1ww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782377011; x=1782981811; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=X17+C6koDcrEHBhrTALNZmXozmPiBoMdmIQHg1KU3BQ=;
        b=BeRcCdCWbDifYM12stKKZ1VWkpFrSUkPkeesuKQ4hkfOz77SYSu1LRXQSlFGC3iDqh
         /vQoLulqNxSHgnMngUd5ZYDLry90BaO2Dea4/87L9OCDQY2FHvcf0MEyfz5IQPNRJyzU
         IKWDbxpYSeOZ2nb824WTOsb5r69TO+6I6zUk/Os+UUpt0Xb7dxRkEbkvc3C4mK09wU5V
         CL0Eu+EhyiyCLKV/z1vIIS1Fsc5d9DDciKBsTiSlWW6kqVv6KpICB0t6nYbzWmgWIHNd
         +r60JCIwyrTDRtd/Y2v5JLTyRG7iWQzGgDqGp1p8bnWQkZv7qVlCJ/wL44JM7/oqbj35
         kqkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782377011; x=1782981811;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X17+C6koDcrEHBhrTALNZmXozmPiBoMdmIQHg1KU3BQ=;
        b=m0szjwR12tYzxM9zPib4fJJZRtOjwTn5DRs9AdE0R9BfOvCECiPp/Frxak50Ci0ZpE
         lXNZ4W0Km7dxSZjT9ru/VJmITxdVWAkUE2LhD++MUOQqC60oGYKuIBnVl5l+a0thwHrT
         gdq2OMPOsOqypQt6Agw8lCJIcNygkczTxVaVVOUwoLRwcfWgbgcG7S2IGy6+990qZnMV
         ViNxhXul4oBsD28X8RV9SeSM+F+KqhU8yY5tmEGL+PfkxFz8zjc77ELpQaKXtwfxQd51
         xZqp86C3ntlsJI1nClt1BaXRmHNHvlpy6qw4mwIvQ7138a+k1K2fJBMadoNHjmnHd0pv
         JU9w==
X-Gm-Message-State: AOJu0YzPg1DrWtft3oJaY6shyalzPPhiaUoH/JnABfGs0qOOzAl1ytbY
	8dWPuKVQgfYSPxhoio4eqcUPD/G85fROEXN0OXHo8GleSfJDJITlUuevZR0BPIuW7aYOO24qpk8
	acX++oz8Xo4f9Oy0yk4kByv7gu0hJOPDBa5+O4WE=
X-Gm-Gg: AfdE7cktC2SRwS0/iYQxNVsqIMR86Y/BwOwd2Udo6DvStFWcGAfsZ6ttPND0ZWP5I4c
	3hg3qdztR/HOAVpE3A1L/d0YDZddGRG+c6oxW9HQJYHtG4ilWqZ/4kC6vq4xg18oocgHRoj/Wth
	kGZkw0cgvtYjqkTbW3bYrzdyGWJADgl7z7aERkCupWP5GwGoo0/e23w1so12spOT2kSO2RHPLvV
	uJLr+yy2ovINCiZ/HCfS+BuOHdZ3Zg8JGjRBO67S/8fej0fDcnuQ7d+LG7xRUKadChC8WnWyc4=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:690e:134f:b0:660:689b:1539 with SMTP id
 956f58d0204a3-66487e682femr1073729d50.58.1782377011426; Thu, 25 Jun 2026
 01:43:31 -0700 (PDT)
Received: from 487349027555 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 25 Jun 2026 01:43:30 -0700
Received: from 487349027555 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 25 Jun 2026 01:43:30 -0700
From: Feng Wu <wufengwufengwufeng@gmail.com>
Date: Thu, 25 Jun 2026 01:43:30 -0700
X-Gm-Features: AVVi8CfXLzdxSFa0FRKNcMquZjDzC_Yca9ov8ej143IYc6uF_1P6-6ARF9jtWhc
Message-ID: <CACK3muoty3EohBmdjcxygMSMtWW0EHKNsA+TYBB4uavyaZ0=sQ@mail.gmail.com>
Subject: [PATCH nf 0/3] netfilter: xtables match fixes
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"

Three small fixes for netfilter xtables match modules:


1. xt_rateest: fix u64 truncation that causes incorrect rate
   comparisons on links faster than ~34 Gbps.  The match function
   assigns 64-bit estimator values to 32-bit local variables.

2. xt_dscp: add missing checkentry for the 'tos' match, which
   currently accepts arbitrary invert values without validation.

3. xt_tcpmss: add missing checkentry to validate mss_min <= mss_max
   and the invert field is boolean.

Patches are independent and can be applied in any order.

Feng Wu (3):
  netfilter: xt_rateest: fix u64 truncation in xt_rateest_mt()
  netfilter: xt_dscp: add checkentry for tos match
  netfilter: xt_tcpmss: add checkentry for parameter validation

 net/netfilter/xt_dscp.c    | 12 ++++++++++++
 net/netfilter/xt_rateest.c |  2 +-
 net/netfilter/xt_tcpmss.c  | 14 ++++++++++++++
 3 files changed, 27 insertions(+), 1 deletion(-)

-- 
2.50.1
