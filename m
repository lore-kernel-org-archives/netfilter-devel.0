Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE0E14286
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488079; cv=none; b=qT3OzQS/KNA8/av4IOjviudSfauOzuStiKsKsbo0fTeEQ6+/lTjBCxY9lJeFSL7CBvpK0iXOf3FKazhd4WEDsm/5lKbaaJhxxalYZ1pr+oSmG/k4D8EtxR7hkOUb/gDnB0BcBOo5bsi9k6x+oAoMPFZCVlwBf1+HQgTXmt/KZiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488079; c=relaxed/simple;
	bh=CqfE93ew+BL/lnGenSxiNtdsgIhxSlz1mPkW37LseM0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O0qsVK0/PZha2wRa8I9bky84FO+nHiqTkDoWSpk/1i8MaUVRqjOasQnGiz9syUefWBdvGjEQGC4VS1CQ6024mD0RQlgz0CrBhDsgRUAfYoPjtY3V2JpqVO6hIRM2gcIm+ogbxOlNMfnXcEhmj1RcC7VTkHDeO+G8CxJAj503c+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kdmpuq0e; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kdmpuq0e"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1dd9568fc51so16146735ad.2
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488078; x=1711092878; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e4FZ3Ehq1zzSA9CVOmwKyH2t3JejQ0GQBH6MGbYfESA=;
        b=Kdmpuq0emNgzUyNOMUG/qXmvT2woylfGjY/5EpccO55Ts7UxBJ1lJTnF9kF6PQ3hqa
         WdkAxI1kFZmOKpURim466m+YZTpgRzF9Z+Y+wAPuSMOdLc5VpqR4ilJjW6p6uLNIo4bH
         8evIKc8qC7JIVl6KluOvdvVJDwmZ8MYYmEheNuaNzfHaOVFPPHBUKbTkAX3YR9UB0mpP
         9OTbXsKALxjYMuOLPuc1YfLlL6m47QFp5R5ckRvI1WmJ5UAkfNh9+5hiqAFZQ7KYxyQv
         /9yT2Som+uip/ao7NaDlcDy6JMpgpaecT3c3Yd+xVslvmSjN8IG7EPMJuWx5Jtj7FOor
         L42A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488078; x=1711092878;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e4FZ3Ehq1zzSA9CVOmwKyH2t3JejQ0GQBH6MGbYfESA=;
        b=vcnCDT55O2kgjFME3t0V2efjec5nLbz8EsgNWcHSmdsyBbyC1jHmAIaVDh1Sz81NtX
         w0Y+VbQiXUoIT9mQrXuVKVjGkxY0lVi0C8JW4Ab/Ccu/4VQKYJRjUJsVoFj9I+Pe6z7y
         jlika5T1yWX7T+jEBs6rrrMLcnQ/PjOa44OO2E4spZbShu/cfXJtCM6ah/ejQsheI3o7
         wsG7NOyaKQ9jl5utkAvEJFy3E7dnTRuptkgRGbB06w6XS5lBI/G1EHf5EM2U1pljE0ne
         WXVa+Am6gUIDQOtGHTkRMssWy5MNEI++ddLwa6s5b0atohbq/5EpK7adz635XNeW0gSL
         BgHQ==
X-Gm-Message-State: AOJu0YzBascMifxgIYtNJsXSu4zsKMj4fFuX5CGzRFpy8bjrRzZAZOCp
	dG48CnaaxcE7/O1LtWX4YHS1r9qRD/hGO/Glho0sRK8dUqWI8Zdk/xlaac1c
X-Google-Smtp-Source: AGHT+IHpOYnduj0BIXv8A+J5GMwdcJQnbkkiiWY2EOvyCrdzbUNIAIyqLQUHXr9GFgkQ6yyvLFbiuw==
X-Received: by 2002:a17:903:2349:b0:1dd:d0d3:71a9 with SMTP id c9-20020a170903234900b001ddd0d371a9mr5060326plh.45.1710488078034;
        Fri, 15 Mar 2024 00:34:38 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:37 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 26/32] build: Shave some time off build
Date: Fri, 15 Mar 2024 18:33:41 +1100
Message-Id: <20240315073347.22628-27-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <ZcyaQvJ1SvnYgakf@calendula>
References: <ZcyaQvJ1SvnYgakf@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Modify function mygrep in build_man.sh to use pipes rather than the
temporary files. Saves ~20% elapsed time in a make with no compiles on my
system although real & user times increase by about 10%.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/build_man.sh | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
index 643ad42..0590009 100755
--- a/doxygen/build_man.sh
+++ b/doxygen/build_man.sh
@@ -304,15 +304,12 @@ delete_lines(){
 }
 
 mygrep(){
-  set +e
-  grep -En "$1" $2 2>/dev/null >$fileH
-  [ $? -ne 0 ] && linnum=0 ||\
-    { head -n1 $fileH >$fileG; linnum=$(cat $fileG | cut -f1 -d:); }
-  set -e
+  linnum=$(grep -En "$1" $2 2>/dev/null | head -n1 | tee $fileG | cut -f1 -d:)
+  [ $linnum ] || linnum=0
 }
 
 make_temp_files(){
-  temps="A B C G H"
+  temps="A B C G"
   for i in $temps
   do declare -g file$i=$(mktemp)
   done
-- 
2.35.8

