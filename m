Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A001B2D7B8
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2024 05:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725255546; cv=none; b=VXrU7yRuncO4FZZaLp8Q9/8sJrpp8/sUnWIDtt6T2ANGQF1QIezVsuTpX1p+ybYbmeZIpq7swDKI1Ey1OOuiAAE6ocnTSsLMZLML2JJE7sClDhM5HBDshV4Z6+0qRemGsoJnc0AN9rCJHh/kK4eP3xtIZp/iccMO0xRZQXOIfLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725255546; c=relaxed/simple;
	bh=utjtaKZ5i8NaGhMWZCQCbPysyfjc8nK7JeOUPhmAu9A=;
	h=From:Date:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tG8NcbXgD57yCS9ylSXal8AP5W15VRgjECYQKOZ0uF48p9bP8Np/XQh/2W7sZU9XCjktfTUmcECFbZDyw0+ruRFLG9o5c42oRrqSr9Wt37dLtj0kSQcQtjLKDEBWNI+X1BMyioXRzkGN+eQbbUfnmyrqOk7Qx0HA88NNgU/WL34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g3Okoo7A; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g3Okoo7A"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2059112f0a7so733255ad.3
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Sep 2024 22:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725255544; x=1725860344; darn=vger.kernel.org;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:cc:to:date:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=utjtaKZ5i8NaGhMWZCQCbPysyfjc8nK7JeOUPhmAu9A=;
        b=g3Okoo7AIdtxygiajmxFlGhPXjGNEh0jCupHM2wJm3NaXOcfLYeg1ULLXxJUCdVsBI
         9XsPoOOogIyD8Vs2vnNJyc5XDl9HrPovTk0S05YxdPAGICvVMI/4kdjFo5R9flHtTv+v
         ui/2JupR0fVpieTsOT3xw1CuxJNXnuKhXrTAeJyip0vXk7KJfJ5Q5ZQbx8OdrHfF0i6C
         ZAu6RD9LzPkrz5nFEHrW0pfVDBCrqS6blm4VhsHhPw/ADEXNZp3pSbBX4KAW33mXJsBl
         hwy803xrY2Y7COosqlh/sPnhsjX5MFzW9BbxE9L2vfn9wOhueKadEFZEDQFhZnp3BToa
         nlOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725255544; x=1725860344;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:cc:to:date:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=utjtaKZ5i8NaGhMWZCQCbPysyfjc8nK7JeOUPhmAu9A=;
        b=Mm5eeekdv1YASFM6R1svIofKh/bqldaJF2PbPemerot8X+8FIduJfZrXqJn4voWY9r
         9n7ucoqBNCkZew2LVShSjSZ4YoLnu7k0iOHKvd0X+ldEvX/xfd/ZW+j1fVosoZKJRlZ5
         V11CFPbzFYTJ6yFYLDeM/4nKQwvVhWrbkmvYnWMSNo1XEypX4hhR91mEbRNIjXSHa279
         PDxGmSLLhujByzzzKxQKnDTrtkdSEHkEvdRmspye3gUgTqvVCeQ1ZOoOyqlgPB9F5ZDJ
         ULbmQ7k9QsLFNW2QcMMBYiIKQEjLKAo1JyZfO9baSrtpkeCoarvJjHzHftMqfEMTksQK
         qNwQ==
X-Gm-Message-State: AOJu0YwQANe2U6hPAwo/UZ2AakVlqHUOdgRjVObnwUd8tAX6LOfmuaSX
	8JByUPkXM8wj13KluRIEDlHVGJpmHuFvElwYeUXqWUFamOi0C8DrzqpQYQ==
X-Google-Smtp-Source: AGHT+IEaUhoIYWcTWQIUjjjf6tALy+9bRXDCZSqzakbxb/y8idbusm15GjzmD8PJDnj0vYu2/gimbg==
X-Received: by 2002:a17:902:f550:b0:201:f568:b8fd with SMTP id d9443c01a7336-2050c40de86mr145130785ad.42.1725255543839;
        Sun, 01 Sep 2024 22:39:03 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20554108fc5sm24184165ad.147.2024.09.01.22.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Sep 2024 22:39:03 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Mon, 2 Sep 2024 15:38:59 +1000
To: Florian Westphal <fw@strlen.de>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Request for comments
Message-ID: <ZtVPczkT/T9Zz0ep@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Florian Westphal <fw@strlen.de>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Florian,

Recently I submitted patch series
https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=407990 which
converts libnetfilter_queue to not need libnfnetlink.

The series re-implements all the libnfnetlink-wrapper functions so they use
functions from libmnl. I understand from previous correspondence that you had a
shot at doing the same thing a while back. With that in mind, would you be able
to find the time to take a look at the series and comment on it?

Additionally, the series re-implements the nlif_* functions from libnfnetlink.
conntrack-tools and ulogd also use these functions, so I wonder if they belong
in libmnl. Would you have an opinion on that?

Please disregard my use of kernel headers - I now understand the idea of cached
headers is to be able to do standalone builds without them. v3 would fix that.

Cheers ... Duncan.
