Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38113A920
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Feb 2025 06:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740031415; cv=none; b=lYok8FTJkrYIBblrh0UGRT1mCqSq+SZUwuOgUzj/6IDcshHik19ICMJ/V7aZ5Xinphlo37kOuqh5vHN9wjeP615uwSvcz/OVrepxHmtRuUd3CFwTPOqOm46X9CiMjnctufR9kI3lenpBWwo8osfDHi9GI8srzDUcgMYPl52/xMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740031415; c=relaxed/simple;
	bh=XFW86dtLpApkK/L2hp5HTTVLm5XULc+RLfDzbkVQSBw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=ICT90ioGQcnFNI7OtASBSzeke96dNYDCd6S4nMiCdXbJc7wvM3UmlJCPE/PAbKrxTTGuGh/Kz0egVlDof48lPV2Dh+RvxGn1x+ZNRk8ie5OymvlD2z7S6umA4SRhc8g08bEsCz0yuzUk/VRTilhdhh/tO6koT1X1xLTM0A4E2/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RT5N5TE+; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RT5N5TE+"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-abb892fe379so99021566b.0
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2025 22:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740031411; x=1740636211; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XFW86dtLpApkK/L2hp5HTTVLm5XULc+RLfDzbkVQSBw=;
        b=RT5N5TE+akBQMV+n/ugfH0BlVzu4flavojDp/5d7GseCfpLuVkUcfT6F8syuANK9sn
         Eddcd/DQZ3wrPl/YKquzHz/pYW0w4zM4uIXcNPR+rTYdFpzwG3f2yg1S8e3ac7MUtlEV
         oemX+z3Qh3gPkccZSp0UcXd1fhZl8whCFfobJOymGMq6nDS1w1cBQa+BUutKH061ykgj
         sG6/6I5Ut6O1pQAL7i5SUktXwDJ06gNgGSl2WARRLnqR/tbBQaZknnKt9YZbpDaq48ul
         tg1SB1muNtWRuA3wgF8RAJAY6fTYLCkpxcc2pkkUHMjlDVXWcoIarXdGSsJINBmmtVD2
         hvEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740031411; x=1740636211;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XFW86dtLpApkK/L2hp5HTTVLm5XULc+RLfDzbkVQSBw=;
        b=Yv97ktThL+vClpxqYiUyWLXNnU38ugmKm8rElXi2ZUh5sXvwYUWlpi0dE2KRhh2Vmp
         bzYifD0KRY8DxKzCRchyOJqIN/6S8QVXsHeNnPPvM+8I2SaDEL7zRXuY8Why4QKGclOM
         TubTzy4S/5nCZngBrHT3gO7HmPUqLJxexmoiSkJfYfi6t2g+iXpgqKPqgzq/Fo/H7dVC
         Nh9MwDb+jv7WJMLdKTh1bYSMPYMQDcixXnyCbhr88VhRrt9rtG6xl66o3fv3Mq08Cdz5
         Kesx7wPYxtbelJaKvj1QL99HEJP/DxEN7wBJTJzP/mKvJU6D36RH5uLiW9E1BDdeEZdf
         oNfw==
X-Gm-Message-State: AOJu0YzW5dA0TYq76zpjAOdEV+4k60YXRdUJX3N583cM2juAUKj5VXgP
	Ezoi3VBBRO+uTy5a1upFFOJMzEQjteK8Z0GW+2f+4I+7X9pI8QW5jcvn1H5OQeXAT1RcRelTcP5
	IzFRj0o149DDDpy3f0yVQ6rJUwqsbZlaw
X-Gm-Gg: ASbGncsfUnHP4/9kTp4sKm6wXzjN480fsop7cdBJiIHM6fGMNLPjItNwqN/w4IfolOQ
	br4j9lyEmmAx7anJZiswybuUOwbCz7Vo3VUAIHe/NEFbqVJVv5RpXybY0GX9U3eINcM4+BuqcAA
	==
X-Google-Smtp-Source: AGHT+IFSNGANoyfae4+WXuXRvmoXf33u+bzXeTiP0bYdG5eNZ76tBhxdt3wKQ2OVaR14HzyZPAc4rAiEfeYZQBH5VWY=
X-Received: by 2002:a05:6402:34cd:b0:5e0:82a0:50ce with SMTP id
 4fb4d7f45d1cf-5e082a05915mr16705748a12.27.1740031411524; Wed, 19 Feb 2025
 22:03:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Vimal Agrawal <avimalin@gmail.com>
Date: Thu, 20 Feb 2025 11:33:20 +0530
X-Gm-Features: AWEUYZkcAxGtBNHIklNx1FsT213xXN7p4WX1fLl7wg_JRUzhXYkn3DleASKK6Qg
Message-ID: <CALkUMdRzOt48g3hk3Lhr5RuY_vTi7RGjn8B3FyssHGTkhjagxw@mail.gmail.com>
Subject: Byte order for conntrack fields over netlink
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi netfilter team,

Why are all conntrack related fields converted from host to network
byte order by kernel before sending it to userspace over netlink and
again from network to host by
conntrack tools ( even though most fields are not related to network)?
I am referring to packet exchange during commands e.g. conntrack -L
etc.

Is there any good reason for these conversions?

I was assuming that the kernel will send all non network related
fields in host byte order but that is not the case here.

Vimal
