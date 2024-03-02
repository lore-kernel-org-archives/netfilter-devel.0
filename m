Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147B917578
	for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2024 16:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709395688; cv=none; b=DtiWqmTz5kw1f+osNM7ijW7nc1un60+2wkA1WJjkBGxycCq2Nn4BJ4E9I2LYPZvMYoVQQPzGHX3Pu63t9dLJVNPYrlGoZ2d8XIGijSHlkXqWNxmjrOgAw6+8AtZdVCZy1+EztMzxJT+AslZh6juX1ueVhtqJ2AnQ0Z0Lpp0u7LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709395688; c=relaxed/simple;
	bh=0i3iSMG1dQ64gGRKpmiL7dyc/5Q0+ZMKg9UFBjZ6VvE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ubzZJpXF4UxPDDg3MM2B49KstLcFyFS8vlax+cchqDi9dUl/dYPtaXF+wUznxMqOJenTRXbyt0XavtK9yzSDC8nlVvqQx8vsnvCFectN2SyTSpacemucyDmBrHXjUAU/eeRQOoVfZxe2gIFDnXimkQIxp9bGp43ogxujHW8aQBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AkDK62rB; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AkDK62rB"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7810827e54eso224759885a.2
        for <netfilter-devel@vger.kernel.org>; Sat, 02 Mar 2024 08:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709395685; x=1710000485; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iVYyCBainUMMNNsc5xqVXZSD8Va39W9arr124MQq8nI=;
        b=AkDK62rBIUNYu7TF/w4RhLKcEvWvgECCTkMimesfq51LFNcvM1tUTD8DzfDfIrWVyU
         SUZEJ7QfHGBgNQlM/Oje5KJAX7XP+hfTOaNfj3Ch2GaUw8oHqKQIu92ygGbMiArVTH9g
         Nr3N5tryVXsQq+wVM8eWYCKFXCQYTl7yNaNEVLtExBg46616gPxCnoOn0JZzeqxJaNqR
         GXK2CCR7dWYmKKKuEN9lV8JIg6zgqLm5jVSkSjwIdatidK1Bxcxq2Du/3pzyM/nqy356
         OM8tGU0ZdygQFoOuFKyV1ASnr11y/CrXANTadQKFDgi4NYbwL7h8nOhWweKqAwbhPmyI
         Y/ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709395685; x=1710000485;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iVYyCBainUMMNNsc5xqVXZSD8Va39W9arr124MQq8nI=;
        b=eQtUbkMq8SIK+EkZuVsmJMVTU3pWONN1+vrDdbypEEgrGUIgkZI8JbcL01Q9nb3zpp
         zPx9ODv1syPtlhMzTHVBJxDLl/WWzOVWJ7snuLtP7ZXFTDQycVxJ1/JBSLxwQp5amYAz
         uA8ITJK2n47mZTlH5Un4BGuPtqz7xgZ7AdJ7tUwKpcwNRxa3PNztoORA/SKBFftAbGdY
         1amwOk2WJRl6j0n0CYXVbQ7E9BygADm3we2pJl8l3qDEAFoflMBMuakat8mkk3T8kbJp
         U1foErh6K/r5jXfaz2ZoHOPGr9BlPAr/tBIfgPqpwktWbsBjQffWdB2f4lTU5khkJ6GN
         FGJA==
X-Gm-Message-State: AOJu0YydSBlEKpSK2HGosuD9V+Pa1khgx/Aj4KcnlHDSlZb/FN94EQSQ
	oOlNlwnLO/wMAFBUcG8ol7BQvHPqhwUeR3pdBhgn3/8kNs9hPs4FvUNbZmFu
X-Google-Smtp-Source: AGHT+IEGAXia/ShLAtDtFV/zdnFAw7J7yqrM3FWch5a9OdRe0hCvPu3IGb/E/aoSECzExOAotGkkow==
X-Received: by 2002:a05:620a:d4a:b0:785:8c17:dfa1 with SMTP id o10-20020a05620a0d4a00b007858c17dfa1mr5152385qkl.61.1709395685585;
        Sat, 02 Mar 2024 08:08:05 -0800 (PST)
Received: from fedora.phub.net.cable.rogers.com ([2607:fea8:79d7:c400::557b])
        by smtp.gmail.com with ESMTPSA id k1-20020a05620a0b8100b00787c7c0a078sm2666118qkh.121.2024.03.02.08.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Mar 2024 08:08:05 -0800 (PST)
From: Donald Yandt <donald.yandt@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Donald Yandt <donald.yandt@gmail.com>
Subject: [PATCH conntrack-tools v2 0/3] fix potential memory loss and exit codes
Date: Sat,  2 Mar 2024 11:07:59 -0500
Message-ID: <20240302160802.7309-1-donald.yandt@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Vector data will be lost if reallocation fails, leading to undefined behaviour. 
Additionally, the indices of the allocated vector data can be represented more
precisely by using size_t as the index type.

If no configuration file or an invalid parameter is provided, the daemon should exit with
a failure status.

v2:
 - Moved variable declaration and described usage of size_t as suggested by Pablo Neira Ayuso <pablo@netfilter.org>

Donald Yandt (3):
  conntrackd: prevent memory loss if reallocation fails
  conntrackd: use size_t for element indices
  conntrackd: exit with failure status

 src/main.c   |  5 ++---
 src/vector.c | 11 ++++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

-- 
2.44.0

