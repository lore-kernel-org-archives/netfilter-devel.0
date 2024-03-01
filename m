Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C2C2571
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2024 17:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709312858; cv=none; b=gEXy9IDNx7CvQfLuYT/CLKDxLX0xYr73+f2wcr5Rm9XelHf9HF26nSfWve2dzjaFZ3MdX9j0V2tclD3thAiMwP6VPhh7cKqquKFCLEGr1/vJ7CQEBxV4aqvjwM72P6OA0s+ysuhHJRghaqtSPKuiA69RmgRruy+WQMVC00/ij9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709312858; c=relaxed/simple;
	bh=sVy0J+5Act7u6FCv2ZW3AlRVlEj2espWREK29mM/cxU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T9GRBEmAZ3BuJfJ/M47oQLPKMll6JH682wUmfgfRegCqsrGAv6mgMB6EW79Btq724IbiICjZW4RQfRPy+NhIH0R4884zmMqxC0wGoHDdUnuMlG8PFMO+KR7cdqM27KJIiTD+4wpzCAfwyqWDDJ2gAnlP+gDcngwSj+8mH9Zorik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MElf6+hg; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MElf6+hg"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-787ba16a236so141990085a.1
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Mar 2024 09:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709312855; x=1709917655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eKicZecYENtTflNF24apnhCPV/qRAMWSRRt/4Z0yDKg=;
        b=MElf6+hg6QdriLC2+/PXhaoBJTDLZg1zMprmr/Dhu2fzxdQjAc/LAQ1JLw6oBDB5Jm
         PZqMeygcn8lgJZmGY8fNu9FGmrJ3zd45rptClYEK2MD6y4NbvfTYD8FcWVjGgp2QzlP3
         +wKuNM7Ub65ZNf/PCogaP6F+Eukmv2kyo84Xpba82mhiJ3/kWZhnxrd8uDCg2ZCIWoKn
         Y5m9U2mz4iNPgjW1OCpuM8qafDrlZst14GMHGYU9SYZpp0Q2IKFV2pXORpmZu9+2N1K8
         FuWhGS/P5jxAqJdBa728VOcOXKmDzZujTqaPz6RQ97WeU8wGoJ0AsrzvWTNru7hWUkOB
         HNRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709312855; x=1709917655;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eKicZecYENtTflNF24apnhCPV/qRAMWSRRt/4Z0yDKg=;
        b=ZdmhGTNxKpRbKY9nWExPwqWPSQCbIsu6g2LsRBs8rwUXdCb9jIJndtLydmc9t2IPiS
         edps/fJ9O7tJJwGOB3S8IFRC/79ZOmg8X2Xjqdev7nmeuzCAaoxav69B9Fr/qBT8FREo
         Vtk+vSBMzSE7hlJLE629tHFNiggMxujylMkcX0MttE3BI7qRAJmpQjUap8kwgYs3XcQd
         C8nZ4XCrVIlznDSU6A0BB0pQxYDG4sZu5Ia3fVZP1FBW3vbajo7wRoZzTM6w+Fy4XjhN
         YfaAFFSRqGW+KWniR66P5mcuMbzdji4OvBK8ZeM7MvKpM7tCBJmvEWjolreO5EVi2cju
         GZtw==
X-Gm-Message-State: AOJu0YwoBWNPJkZ7S277AqSsNV5zqgXaxEIg7THW00ny5r35wlwS5alU
	yEm088let4DZLlKBf8tJ196jt/fJ/TpGwQpWgH1X//reV5YDMOpVlf417yUh
X-Google-Smtp-Source: AGHT+IE6MeRP7RMb+D/kRGmNg8avwMFumA1YI4P5BEwJ6Sb7lyqx+jQBT0wwSHbSAIi5xQD9OkAFjQ==
X-Received: by 2002:a0c:fb50:0:b0:68f:b7f0:65f4 with SMTP id b16-20020a0cfb50000000b0068fb7f065f4mr2303552qvq.63.1709312855460;
        Fri, 01 Mar 2024 09:07:35 -0800 (PST)
Received: from fedora.phub.net.cable.rogers.com ([2607:fea8:79d7:c400::557b])
        by smtp.gmail.com with ESMTPSA id nz10-20020a0562143a8a00b006903af52cbfsm2067261qvb.40.2024.03.01.09.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 09:07:35 -0800 (PST)
From: Donald Yandt <donald.yandt@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Donald Yandt <donald.yandt@gmail.com>
Subject: [PATCH conntrack-tools 0/3] fix potential memory loss and exit codes
Date: Fri,  1 Mar 2024 12:07:28 -0500
Message-ID: <20240301170731.21657-1-donald.yandt@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Vector data will be lost if reallocation fails, leading to undefined behaviour. 
Additionally, size_t should be used to provide the indices and sizes of vector elements.

If no configuration file or an invalid parameter is provided, the daemon should exit with
a failure status.

Donald Yandt (3):
  conntrackd: prevent memory loss if reallocation fails
  conntrackd: use size_t for element indices
  conntrackd: exit with failure status

 src/main.c   | 5 ++---
 src/vector.c | 9 ++++-----
 2 files changed, 6 insertions(+), 8 deletions(-)

-- 
2.44.0

