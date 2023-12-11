Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y07C6Vot"
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203D3C4
	for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2023 16:56:41 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so3304024a12.1
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2023 16:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702256200; x=1702861000; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=k1X2Ss1026IFFx8tC/3sbFAideYqAenu33ahJ71sOk8=;
        b=Y07C6VotFjgUZOznsQ04LltzMiZg3YfOcoUx5VeuXyUWA8YUgNRTH26p1cp+wdrAJm
         XWFDqDV5lYEei47gp8G0zaV6lrIhFkzuhGIQP5j6TgNUfshquYTlMDBnWd5qcIQ+1xUM
         HshFFv2EXRO3U6qc94LVmDp4L/ffhdqTv7SYS6ZUTvZ6a/vDS4rIQItGAQwzliEmDP26
         EXfRcFXSWk8qok/7KvyN+GowmmWGmYiR9dj0GwjTzrKEMYTDd4OiDilXqwq6kJ1ttgqm
         hD+t7MTMbp1+jJRi04egbTkLx5bOy8BaFEopkpCWi1zEROBZ+3OsAOTxHV7MxiPV/LCh
         tMLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702256200; x=1702861000;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k1X2Ss1026IFFx8tC/3sbFAideYqAenu33ahJ71sOk8=;
        b=nZ33pOeGkV4+Vd0ois++xGjNckRPCkSKeilFGn65VRqcZLvBx+v8bbe+wVwHE8Lc9X
         wDYb4W9FqLeobfneC5eMk5t5kjs+d4rZN5B0z3lT3X9iZ6XAQQAOqE2dYeduVngh7H2O
         RFbL7oJuOAjcipOlyjqmwyxXERWX8Waqqa6RPPoZpi2RvusDL5LwFTgUGk/rDxZYfnmD
         6+nPghVgJTlLi9nRbBTqwGKBkE/G+jbiMPw6upLmBWoIG0eLitYVpCs31uNrQ65v2VaT
         5H/NPRrOaCtVQkt67NPjl31wQNwn211aQ8mg5MFeTK6iqeyzxOfj9KrjylyqSHZeDr+2
         G8bQ==
X-Gm-Message-State: AOJu0Yy0/T6GkDQA+vhydgh5KzLDF5e3wtOCGydLBnTHx0C8uhMZZmzl
	lO5D1JZ3jBvWJSk7GCi1nxeNqFYIQfo=
X-Google-Smtp-Source: AGHT+IF5UwSOmrQmuvscHPnrtf7MS1yCxO3q7bhvYqEyGBS+0X6nS9bUG0M4PhZRqfYy/QwJ5hkLuw==
X-Received: by 2002:a05:6a20:6a1f:b0:18f:f5b2:a891 with SMTP id p31-20020a056a206a1f00b0018ff5b2a891mr5150462pzk.86.1702256200516;
        Sun, 10 Dec 2023 16:56:40 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id z20-20020aa785d4000000b006cbb83adc1bsm5063767pfn.44.2023.12.10.16.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Dec 2023 16:56:40 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 0/1] src: add nfq_socket_sendto() - send config request and check response
Date: Mon, 11 Dec 2023 11:56:34 +1100
Message-Id: <20231211005635.7566-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Pablo,

I  had a static version of this in libnetfilter_queue.c for libnfnetlink
replacement. Have already called it 4 times with at least 1 to go. Does
make for more readable code.

Cheers ... Duncan.

Duncan Roe (1):
  src: add nfq_socket_sendto() - send config request and check response

 .../libnetfilter_queue/libnetfilter_queue.h   |  2 +
 src/nlmsg.c                                   | 54 +++++++++++++------
 2 files changed, 41 insertions(+), 15 deletions(-)

-- 
2.35.8

