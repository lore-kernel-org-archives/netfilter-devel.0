Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089B43D0A9
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Sep 2024 06:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726467898; cv=none; b=YO2SgZwrVglKDHw3TFTUptc/U5pcUmOGKm3WtzDS2IO1cj6F7D0sFzInnqlkATpRZ0zThfAcqxwKtYhztt/HQpW9mqPpE9i4Ckc5NGoxvT/3UOK7ezDTmfO181AoUfOTrnHZXstqxIqp9/lisrbUXLqe/JE79sSzf1/HHrGSdzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726467898; c=relaxed/simple;
	bh=Lwab4ERc6wKxR4m7tesLNrG+vxB6SKCwvAo9IkgSHbA=;
	h=From:Date:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=inco5aL6Byq7ADSUCUs+6MVYgUrjwP7l19fX20BsxrJt14HATIFQbQXiMKUklkrEzt3vZbTTEPiVd+lIUH2mxxOZhNCUoxmKJ/Sb8U2lGt0gDZ3SYpN6IUS28qP/cjQLbMVcCxuhds3cr1Q8EUfqWN4ynaRODh+NjkIjnJFwMJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mYp8jLgP; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mYp8jLgP"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7191fb54147so2888063b3a.2
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Sep 2024 23:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726467896; x=1727072696; darn=vger.kernel.org;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:cc:to:date:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lwab4ERc6wKxR4m7tesLNrG+vxB6SKCwvAo9IkgSHbA=;
        b=mYp8jLgP5LdWdEiDCaodsAHxdl89M2yhpRneMLqaCrr+4MjJtHDf8XA4Db/aedSwsQ
         t/hDOsbP/unwJn0aYakd2jRrIgkDJltq8inzSVYrKGzSj5SM4pUkPU8g5fsgLjmeyCnU
         6XAF+7SwcPHVLIFBeZVCojtiTKcVDexMaUPv3o6gAJh+EUh0E0/YnAD397YfbYyFnQ2Y
         noQA+aardWlVWqt4G7xTCn374CK8/34iJSUN+MBQeDtbaf4GKrAL/RaKniWhajRFXudB
         xKujmszfEHZIYtAnY6YfhO3gqzGyTwY6Z9KEk4rhFyy6ItPis5nVqW+K2XBzgMTKCWrV
         Hgrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726467896; x=1727072696;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:cc:to:date:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lwab4ERc6wKxR4m7tesLNrG+vxB6SKCwvAo9IkgSHbA=;
        b=boARtccFoN4ndvZzvgLdVVq6V8wDhOUuT9jOCZhhFaut7m1xE7GSEKzSGVjZEU0pJk
         57rE4OmK1HhSWWEmrJ99e2UYK90ibwdkzRxfgAdXl8oY7Pc5NgFAWze3JuRqgzVZkbJj
         pC6ZYbPZ4BUwxRGbdG1ZJrbQCY9T038MHsUlQQYFcxazKspisVp9ykLtLdJqPlMCiDHx
         MB0zry6MReNxHs5xHeqRv4V8yg5vtvdLsprWRSRu/5+Ur3wqf8mTzZ8DUib6pwpEs594
         Ww29988rDkAoSlJaq+zZSO8+NW1UTtL8dmk22TORKO1m3sxBLDC2knjTv3xrcLfUvcaH
         cceg==
X-Gm-Message-State: AOJu0Yz/Jg8aad24irPKswA8u9aQaFtPHsobHnm6qNEn7Z8d/LzL9YY3
	f7Ti7abHPqM+gS0O8+pmQMTckKAKg7coRJLoWcWsiudOn7naUPvC2jFzqQ==
X-Google-Smtp-Source: AGHT+IHnnEogSLHnEy66wyvY78DyLYb340mKCZpgCf2yFnS4/ryPthRxl8yr6Xi4XZWas5FmqDhrBg==
X-Received: by 2002:a05:6a00:1ac6:b0:714:2198:26bd with SMTP id d2e1a72fcca58-71926081831mr23385430b3a.11.1726467896225;
        Sun, 15 Sep 2024 23:24:56 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944b9ac05sm3110447b3a.155.2024.09.15.23.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Sep 2024 23:24:55 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Mon, 16 Sep 2024 16:24:52 +1000
To: webmaster@netfilter.org
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: "libmnl" project doxygen-generated documentation
Message-ID: <ZufPNH0p/G7IMK1T@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: webmaster@netfilter.org,
	Netfilter Development <netfilter-devel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi webmaster,

The documentation on the project website is for libmnl 1.0.4 but the
current release is 1.0.5.

This is particularly unfortunate as function documentation is broken (absent)
in 1.0.4 but fixed in 1.0.5.

Please update at your convenience,

Cheers ... Duncan.
