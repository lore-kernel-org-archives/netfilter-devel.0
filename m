Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20766189B80
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Oct 2025 09:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759570149; cv=none; b=OZdijLycK4lh8YxRxhyVxC+4NtL3eYkZC17VNcc56DJFWVOkYnM0VJR8zAfHYXeC2sEMxI4yPnvhPxD8NCk22DNi6JnHjclkosaXT9RPWwK+jCFvbH72SIeW+2ZR88aQnIL4yuODooip08CR+jSerCsQM3ewl1h0cyHGhXL6i0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759570149; c=relaxed/simple;
	bh=NXOSJ9CZGQkXqpm9/jnF6qWst7bOH/4fBfH5GV0a1RI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n9PyMmD6bxau/RjuUsuuC8NtqBQX/Ckod69LVeIZeJzSnQeIAj9FVnQo7DTzL/Ag/y+rBOVE7yByvZeREXWieMJtwhH/cq24OlDUM9xOuOL5BiLlr7C20UxABKtHQeS3fNUgL15kayhzxWKoQpdPDXG8c5aPpX9OA/m4bixJ5eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FdiYOx7Y; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FdiYOx7Y"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-57dfd0b6cd7so3826590e87.0
        for <netfilter-devel@vger.kernel.org>; Sat, 04 Oct 2025 02:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759570143; x=1760174943; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6sZA024SC4iXJkCVWilxUMV20JdFfZ/ZrZA7U9hsmgk=;
        b=FdiYOx7Y1WmLyrcrTrpg9r00B7yEv36V8IbqWXQq0CHK/Yfidlc9CikLxq1tkk6sOg
         RHNCf9uduKcyrgfrljSCiwr/6uDulfEMuwBePG2UmflehJbOsrIY8Qi5HtZLPUkpvX6w
         AduQmh5FHVV12JF0afbMuCilCRyhdzyYXNTkETuFLfavVX3rwVUV5b8KZRN+3BL/KmzK
         AMWj/i3hJMneQFrfeezutdR6mhNN2di9gh9EqNcLv1f3Be9+iZEA/KTo6TUUSRo/nSgp
         ZKdcmdqkyzdV3lBUG+izjYlHKJx/47IhoI2Ve2syY/2DHFHsKVKKtqi66XmRpOo5EwVe
         NHqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759570143; x=1760174943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6sZA024SC4iXJkCVWilxUMV20JdFfZ/ZrZA7U9hsmgk=;
        b=QzfUjMR+R9tg1BrTmIzqB7ei70XinHO+CIXNn1c4zvCUpQE8mk8IivWvjdubgyMV9w
         EAO+rvwe6vku8pcbD29eQUEsUHXFkyZW+kTpeESyJ5tdlRgGD/9510CbOuBBjuIYAjRR
         9dnEyJQLzpIjGev1RcM8bNZjTYEuLXCwudgUsgcV9jkO8yFoz9lom42jqehMtDezkH2y
         K6xZyLe6K1j0E2CtkuYerCetHZivemG+Pw7TRJupECzOWX5pyXkPFYD3a0Gjse0Msh0I
         zYypHoZ4MakgfgVEva1QUfaZwzjIlec7wVK6n7mM6sGz/1V3STvzcSlSLuQE+SrPwjZJ
         7jNQ==
X-Gm-Message-State: AOJu0YzU237t0Y91UQqKZqCJY7CWlSzQAUghDVWeXfgffZMJFLts94LN
	uS4BmOdzEPgWF7Z4KGG+2eR9k6QA3JGsAyEHcK0Qyvd6f8Q4lND0Uy7bzKq43RJO1EnBbw==
X-Gm-Gg: ASbGncu4QWp5LQTUKYP2D0BFzGPINGO29uiGHWHzojZZcjTIs8y57wLFXPZXjJVQI5a
	7+7cIOW1IF0B3tC+t7Jbub0WJNKP8QzucLu0tnsQBJgHSK2wM0Aiz8gcFFJvcCKaKuQ0u6zKKW8
	ulcmyZ6xWWle1kx2+5iRWn+lKLpcmD/hzCccKz/s/v2DC8Se4LRI6uxdgeJb7Z+ftNZT7oGX17a
	6qY30WWRnMs/XXiyEVCVjBkUoFwV2GvV1kXwgtUmRtZkzCfuTyNqRONh5IpwmTpEsccgrquFdHV
	M8yRRsd7ZfW5t9Y0gget3YMj2ItDfhT5QVMwY4bLKhPStBbTS+aD6EHJn7l2fGQTYbQjXYDD+AM
	fZlvQIz3Hq7BdODbnGNSAOQOOlFrCuANFwWHkmK/ix9Xjpw+IQzHjfPFAgTUepTvQo76087CudK
	z07ny8p6r0hLCWSmBfkGQ8NJ+YKekw
X-Google-Smtp-Source: AGHT+IE3upucfAIEUAbP5rzy4NpNwkTcEFx50R2fGrxxa2PSs3wo67TK7IbXqzuJ5VwjN19NvKAj5w==
X-Received: by 2002:a05:6512:b09:b0:585:35d2:ce1a with SMTP id 2adb3069b0e04-58cbbdd8072mr1832551e87.49.1759570142447;
        Sat, 04 Oct 2025 02:29:02 -0700 (PDT)
Received: from pop-os.. ([2a02:2121:347:bd74:5730:2ad2:716a:41f])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b0112463bsm2692261e87.2.2025.10.04.02.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Oct 2025 02:29:01 -0700 (PDT)
From: Nikolaos Gkarlis <nickgarlis@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	fmancera@suse.de,
	Nikolaos Gkarlis <nickgarlis@gmail.com>
Subject: [PATCH v2 0/2] always ACK batch end if requested
Date: Sat,  4 Oct 2025 11:26:53 +0200
Message-Id: <20251004092655.237888-1-nickgarlis@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <0adc0cbc-bf68-4b6a-a91a-6ec06af46c2e@suse.de>
References: <0adc0cbc-bf68-4b6a-a91a-6ec06af46c2e@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi again,

Apologies for the delay. I have now added an nfnetlink selftest as
suggested by Florian, and committed Fernando's suggestion to also
check for the status. I have confirmed that the test fails on
kernels > 6.10 that do not include Fernando's 09efbac953f6 fix.
The test could be made more extensive, but I think this is a good
starting point. Let me know what you think.


Nikolaos Gkarlis (2):
  netfilter: nfnetlink: always ACK batch end if requested
  selftests: netfilter: add nfnetlink ACK handling tests

 net/netfilter/nfnetlink.c                     |   5 +
 .../testing/selftests/net/netfilter/Makefile  |   3 +
 .../selftests/net/netfilter/nfnetlink.c       | 424 ++++++++++++++++++
 .../selftests/net/netfilter/nfnetlink.sh      |  11 +
 4 files changed, 443 insertions(+)
 create mode 100644 tools/testing/selftests/net/netfilter/nfnetlink.c
 create mode 100755 tools/testing/selftests/net/netfilter/nfnetlink.sh

-- 
2.34.1

