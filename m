Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75200135A53
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Mar 2025 00:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742345781; cv=none; b=s9irtiUiSiZbEDnrHAUXRIAKNBkcOzi4QlclNj1MqqES3lT+/o0HHoN7E6AiR6JGXXIwinjy9JUn2YD6oAm8+9bURxGcA5Tfv1fApuS1soj/OXPIeZZloFfav1ZSy8ZytkIlMKEx5dGE1yIAAmEayEelpTWBq2FWB8SLfMTknCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742345781; c=relaxed/simple;
	bh=vRj1OqRqRNWhn/k79DsZg9jynMzkEBaNjD/JAYVLMMM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=V8wUtKtF34Zt7wMX01nd2lusRZzNKj43taU9MXjLvT1WqxKNbqFX5vQa2Gn2jFhM4w7++j4BQIo3ZJ9+k+nPNt0zxMOdJJNLFOOpHd6YKpqAZeB5yyhRw5SX7OlRIITk5fOfjc1i/kMO5w1fMvTVwdjjI4tueDBn0v7XH6mluWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FG9h+NH/; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FG9h+NH/"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-300f92661fcso6436967a91.3
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Mar 2025 17:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742345774; x=1742950574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=cnmU9Few8JeS1vhKfc9eVBnK6kBN3YHdQ3JvozrBSho=;
        b=FG9h+NH/8hkrYPRoSRVhcXJW/6mnx8dt8WIPNV5xnZKPn6PrU4gDE3KV58zBT/ESmA
         l7wXKT2XQxnwJb0TFY4RfJSWq2TzdCX9BNi+QH9IdNI3yXOUk2nhpfYmoE0S55058I31
         I0uQ5Q4NJd5p5fr3mE4byVv4g5vlkNNuAn+17cNLlzItIh4Npbctvd+22dvec7cIRyB8
         oCOPVT6ydUIgWh+HfTDL4ebs0JsWb7B31DWl/bSNWbJDgv5Cwac0cki42hF/dNs+fISU
         zWCipWNEd2Fyt+1BZuLFJSp4AtrRIPR2kArxbfwqWVID+NujAH56iOa0FDhGbZJZu4KA
         2Yfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742345774; x=1742950574;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cnmU9Few8JeS1vhKfc9eVBnK6kBN3YHdQ3JvozrBSho=;
        b=pkoICoAtvjJ+0+FnDN7Wr6UemGJiA7p+uE22WQzy2lDVBtXIfPdhw76P5W24fToDgB
         pZHmBKGRnm49e7orB8AeDRfRXOuTM1V04nt/VGg+icIYHin4otFNcjXIo+/3VUY/t5JT
         0VWDlEZT+qsg2Za3cpjy6UyLFj9JTIFBHS+WsZe8jTK+B3HQ9Oe8LUNxfa5TRELtUPFD
         vYP830t5pk73G6AjcKx4WmhDzH4tH7qMWHiZ752OU9B4TjFta2sQeBoz1qU4GbzMmaat
         VYRklGyYt6bWgkE7cP767hs1iky2n9OK1277N/GOYd1PRahphPsL3cbpJTwYMW78TFAb
         IuGw==
X-Gm-Message-State: AOJu0YwsMiz9yZmEP71Dgz4AXYlwq2mkOwtU/MjNvahkTALsqY3RsBoc
	WwCj2siuSeVufhoR7y1qJ5x9FwQF3fcg0KcenmdAS6S90MBj9okpQoareg==
X-Gm-Gg: ASbGncvGcNlSvlE6rq/Gz8CIulYIpA29fAhPASzBMZ3zNlaSVBRvCRptcmyR5HCdqjJ
	prDOXX5Mjw6xcQhYXc9Rh4JLU3Fz+Iie+HRLIsNi4IN6Xd3KQSeDeKYA/5g/UyiDNQNkoQYIybq
	eb7ArQBOiQN3wR0AOEwlWjijscCRQ9bWKo68yefoa24LH+Y6DIPBRKdlhwxUqMW1R8Wg7J3uw0H
	sjJ4kuyvf9bSk4vsae3xBLv01IOR/9Y75Iv3A7VAGvivBNNqGhbKdkqqu0J9QuHpDQKyHKqMxZl
	NdLjDMdH5X254Zt36liLpLHqwmQn50e9H1EZBPlVG5rIhynI7ZAxqDYGakPlKHGG7YbLKlMQjrY
	Y4lrcqBGow1JKsXE/O0+EkekuTXbzVQ==
X-Google-Smtp-Source: AGHT+IHFkXjPY4oA02Z+tdOgri4hpLPBc68yOD2z0eZ/BaLD8kU9ei9XavoqYvU8fU0hARMGx7pZxQ==
X-Received: by 2002:a17:90b:4d05:b0:2ff:5ed8:83d0 with SMTP id 98e67ed59e1d1-301be08e808mr1123914a91.16.1742345774232;
        Tue, 18 Mar 2025 17:56:14 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56ea7c87csm8095925a12.57.2025.03.18.17.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 17:56:13 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Cc: ged@jubileegroup.co.uk
Subject: [PATCH libnetfilter_queue] src: doc: Re-order gcc args so nf-queue.c compiles on Debian systems
Date: Wed, 19 Mar 2025 11:56:05 +1100
Message-Id: <20250319005605.18379-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the order of gcc arguments following the discussion starting at
https://www.spinics.net/lists/netfilter-devel/msg90612.html.
While being about it, update the obsolete -ggdb debug option to -gdwarf-4.

Reported-by: "G.W. Haywood" <ged@jubileegroup.co.uk>
Fixes: f0eb6a9c15a5 ("src: doc: Update the Main Page to be nft-focussed")
Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/libnetfilter_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index f152efb..99799c0 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -86,7 +86,7 @@
  * nf-queue.c source file.
  * Simple compile line:
  * \verbatim
-gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
+gcc -g3 -gdwarf-4 -Wall nf-queue.c -o nf-queue -lnetfilter_queue -lmnl
 \endverbatim
  *The doxygen documentation
  * \htmlonly
-- 
2.46.3

