Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBE0215778
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Feb 2025 12:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738758565; cv=none; b=Cu44Xkrn0RVxy3jQwr7SpIY0gHnT2KMoEl5x1f7rQFDpRDywqFRLtV+RkyJgq3xjQLXrtNjwKq+ACMviM95T3phaDAscV/0jfV0Jppxy9ODz/H9l8WSRou0987R9eyMmh8NqBYGsxVMB+PSwcwOnCK/pB3EOw7Y7KDL91GaopkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738758565; c=relaxed/simple;
	bh=J8pjpwfjlKuFsZrNSH3dNGZTIVfLUT/Sy71CrULoMVg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=kPq5vLAWtF4HpplT/a3b3igUWKbMlmtA2j0wjzlnE4m+KfzXvK2kCORmmTiqGJY0LWS7QJalx20z+q4DHXggECd1JcJ0GGcJ2OYw2z4WJEOT65FSDW/0zHnXKNktN7aew94TzRVaMJgBHjm1gqHkLPGv4z2oBV9WTq8Ir56UD2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WRufdSXD; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WRufdSXD"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-436202dd730so47396995e9.2
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Feb 2025 04:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738758562; x=1739363362; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ailJ1pa+lWnaviUDPaFOpeueVxf63fSIe39VMlVGlvc=;
        b=WRufdSXDzSdpMYIDP7WzCR9eknuX4NvLn0b0vJgThgrifa9cAukisLnSZP77urQWN4
         PcnF66ryCxuGhiwudwiWBEeNaKX//Ps2x88cf72OddwZfXa5oa5349UG9nym02mto2O/
         l7n1+VGbKqYs2gHPwah8l4c/AmwEh/wQVUb0qEq1m1E45No63qs5DmQjhL6H9OXzjyhY
         EAMwRhZ8k61xGc40Rfqd28aQML/f5cAm/oQWBCO3cPQwiPdJj5nY3Vgzs4nb77EaXvYg
         /vdRvfq/mPCmPoHnC8bDkOjiqGsgvrCkRHF3Btnr1fgXFiJGHtNch2dnw/+1AXIFwhSr
         73Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738758562; x=1739363362;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ailJ1pa+lWnaviUDPaFOpeueVxf63fSIe39VMlVGlvc=;
        b=k8kSH0iUlo+4yOdgVqmZMs33iL+Ot1USnLF/Sy63Kc6ku1KPJ6Xaff0Pj7FHfWtTAS
         TKO21xU81XBRo8WDM+33cUmytMbCyBJorA7JFGxDwmV7PJQ/RkDF5ijuuvECyfBlVdes
         cNRai8Il12Fh/VXauD+CLv0xy4w+NilMb0Vc1yAFzDhc/ijEIpDpaYwH34HwMxv8VH+n
         Oe75MhBQoVP3waKsQNW8BIPjMvdB2Z1dSUEW9XKCsHYWnU4YgysMNbN2fZTMXMDJZV9P
         9cMyQeXjAJu6pqvqJyBvx7F+SJU1pY7zBe6dQ8cjDUfGCMLZXeoV1r9RdR9Dy4nd+q/W
         PPrQ==
X-Gm-Message-State: AOJu0YwGJCrP2483rvqQc7MYlHcHiZ+dIpx1YR+Qc7NwCIT0cy8yxcQB
	4oZG6ZLJ/b6a/mJO8nX+lcsDgjDxIdKjoZYHs1AciAioAz7kc8nec+RMA/V0
X-Gm-Gg: ASbGnctMkgcvTrVODgYwMbuzVUSeKyavzZjYNtmhTBf9ji+03ebNPJBh3LqK0deeywF
	nKVocanY8m9iduv7n0h/82ROCr9jhkQWtaSGrs13Ai/zGlxruoDYUt+osaXm9a0MKvWUWpNjmnr
	jznpMWdrXnit6xt9y1OYCR/XeYxwR00kCegmX5zZePzzy98jEBAllqPEGFDu+tBzp5iT48vPV8Q
	l07bxHrcID4SUCBgTlcdliiXHkIMzyhI/Xn5mwAK5mKPdPjRgDfDLOZd7Qlf8bit5x3Ud7TAdfS
	dIHTrMl37RItaMDh8BaQPTK+Agc+/wRoNhjbcJTrm/xnCoZw9pfqVZX1euuKlusDJkGTPvTrcwe
	6DffRkg==
X-Google-Smtp-Source: AGHT+IEtv3bzQi9nsi+ukObgSud8LtmCVYdxExhZZLouXFeDnThWOYIGgGUd2FyyO66a4x2BfKJMLQ==
X-Received: by 2002:a05:600c:46c9:b0:434:e8cf:6390 with SMTP id 5b1f17b1804b1-4390d42ce2bmr18764655e9.6.1738758561975;
        Wed, 05 Feb 2025 04:29:21 -0800 (PST)
Received: from smtpclient.apple (ec2-18-184-164-91.eu-central-1.compute.amazonaws.com. [18.184.164.91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4390d964c71sm19371155e9.18.2025.02.05.04.29.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Feb 2025 04:29:21 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH nft 2/2] parser_bison: turn redudant ip option type field
 match into boolean
From: Alexey Kashavkin <akashavkin@gmail.com>
In-Reply-To: <20250131104716.492246-2-pablo@netfilter.org>
Date: Wed, 5 Feb 2025 15:29:10 +0300
Cc: netfilter-devel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <D068290E-A9A3-4CD3-9C75-413626D540D6@gmail.com>
References: <20250131104716.492246-1-pablo@netfilter.org>
 <20250131104716.492246-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
X-Mailer: Apple Mail (2.3776.700.51)

I suggest adding the following note about the addr field.

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 7bc24a8a..9a7ac396 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -820,6 +820,8 @@ Strict Source Route |
 type, length, ptr, addr
 |============================
 
+Note: Only the first IP address is specified in the addr field.
+
 .finding TCP options
 --------------------
 filter input tcp option sack-perm exists counter


