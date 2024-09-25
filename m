Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B67E43AA4
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2024 13:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727269481; cv=none; b=ZluvSlPmMfLbvOUk3Sn9Qicqu3QXf6gdBQpHX8wDBTfqZa5sZJc2aTiefHkyJhIkTg4XjYKA7BEFextxO7wvnnXh6Z3D0lA84rLeIv1XA6k+Op2BNBEX0RWAPcdnbVzNxEbSqwRJZSMYY1C+D5jB5WT1frrQEgVj0bG8bOcIMGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727269481; c=relaxed/simple;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=Yb+cetENjhb42P8EWqJ0MJ6C8yPE+NFNvJyTbvzNpH+jXG8/VRFA2KGH7xYfAJhBuQHc2velkhNd1paWhO51d/Du9817fuPM6n+piTJQEYEXFkA8nrHPYK2v+Ii3F4G+mGxo7mlkoYuSPVdIn3N+MGuSqupoMurQ3NLHb/6F8b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=calivia.com; spf=none smtp.mailfrom=calivia.com; dkim=pass (2048-bit key) header.d=calivia-com.20230601.gappssmtp.com header.i=@calivia-com.20230601.gappssmtp.com header.b=uERaPqqH; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=calivia.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=calivia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=calivia-com.20230601.gappssmtp.com header.i=@calivia-com.20230601.gappssmtp.com header.b="uERaPqqH"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7e6b738acd5so888608a12.0
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2024 06:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=calivia-com.20230601.gappssmtp.com; s=20230601; t=1727269479; x=1727874279; darn=vger.kernel.org;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=uERaPqqHHh1IxXuJcSX72ePeKSklLgDyJj+mhsPjPVO/aWWzChRfjIX3MFRbQ/go6a
         +xaJYtjQtYSyk/yBRS6QLofjGEYIfj3zo283CEdXMOHtWO6W9Z3WgI8jLdNWpajiy5NY
         dPi7AOoYR4VzPze6ExSN3aAYngSwVdRBiPOPGV1yi7g3Ibc+eQ6gE7VvB8KM89XXRk1x
         dKpi5QqlQGkxLI/U/S1NvnJZQkZsY3Z7Mc6FZFk2ZxLhyesieRkLCeocEdU2b4pEyuLj
         tHp/KJvi8+jEoj3/pNeG5bZ4HVA2RIYXwRM1+Zgmkf4S4hjm+QHCcqCxYBx7FNf/YNH9
         eADw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727269479; x=1727874279;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=RbfgtNPSGNvI0gGyyW62WNMpoj3mEFdLhXZFbsYI3xBaKU1ylXi7FkEfORJAsC7/zb
         mtuwiNoZfe5TIDzvpSeqCbB6JbQUqmPF+9w1esfrSOIbWxYNj0Vuru1TBUjKrVahdk8N
         Aowlb4GoOzKmNFc3G1OUYCr6tuRtf49GQtdorA6J1l3NmiUlx10uo32MLnsTQCvwlKZx
         bZdDOgl9UTwqKmr9luNqpMnwvO8nl8QLVZ0p7Va9o/CQFSuv4QoXBs2JyI55QWeyZOA/
         8whu12cAIWFNFd2HQ86L6CjHPowAdkU21uGa8caegpAwodunIFBsjxq5ckZK2XQTkZDk
         8nfw==
X-Gm-Message-State: AOJu0YxhvqSZe9XoWOSgImTR3JsTIZBdBnqLm7T1ZyE00v+/8WIZz9Gx
	whTY/tjONIBDnGJDivxwwoL/RskiPGCREnn022mCxLO/xproDq3qEKrCKHjwBdntwS8jvuj/wxo
	y
X-Google-Smtp-Source: AGHT+IHj5NHEqxS2bztLjvz/GCegyArH1Ewn5+/uZfJyo1X/PTGI0kquw/haSPie1SORrZDMBKuSqQ==
X-Received: by 2002:a17:90a:cf0d:b0:2d3:b438:725f with SMTP id 98e67ed59e1d1-2e06ae7e0d8mr3050491a91.24.1727269479249;
        Wed, 25 Sep 2024 06:04:39 -0700 (PDT)
Received: from smtpclient.apple (85-195-230-253.fiber7.init7.net. [85.195.230.253])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e06e23a135sm1459504a91.39.2024.09.25.06.04.36
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Sep 2024 06:04:37 -0700 (PDT)
From: michael.steinmann@calivia.com
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: Unsubscribe
Message-Id: <9A7EF223-9603-47D5-AE5D-750B9AE697B4@calivia.com>
Date: Wed, 25 Sep 2024 15:04:24 +0200
To: netfilter-devel@vger.kernel.org
X-Mailer: Apple Mail (2.3818.100.11.1.3)

