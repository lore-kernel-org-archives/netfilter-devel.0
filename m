Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m4nc7VEE"
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169CF10D
	for <netfilter-devel@vger.kernel.org>; Sat, 25 Nov 2023 22:01:20 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-6c398717726so2555549b3a.2
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Nov 2023 22:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700978479; x=1701583279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=GH9mURrWMHeNoVPzckJ4zsw2y9Hg8SVFrqyCtWh8T2E=;
        b=m4nc7VEEtMbkMteJmJIRoWNXgfhs9RsEWiJMjikRjBja2yvFmys+yh1+hNh0Afn4mD
         fXRRE1i3tCeZauiRsJQuy8QKrIAdXJNbfs2yGPXc8sVs/rGplwqwKd/lqhEnq6B+knLl
         5FV/9bnL2kvuPmAYdKdzCzVYmzHJsv7yhxBUWIMkTj6DGl7GtwHUF71A/7KhLM6B/3cK
         kT15VHSQb4bDjSF0mwzSfg2LcI8SPGvi90relPw1JOav8Q/FDO9OQD45pEYedh67ZPGB
         PyoiHx2mfLm0Ntl4Ov0pHQHvJT6kdlnQ4U7WaUCcOw0OoEgklVuLBWBITjJJuhNn77tF
         yqRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700978479; x=1701583279;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GH9mURrWMHeNoVPzckJ4zsw2y9Hg8SVFrqyCtWh8T2E=;
        b=TLYtzz3feRDJr22wXitpkiHyJf4VjB+WT+xT1KUZe7OkxCBSc2lkccA/haLe241q2P
         dXgWqy/YKERS4+dYcIDISU/8DADvqd8PnLLICZSva7JAdR4tDo/Y9iI29UXbT7B5eDyr
         rTIls8PX8YZJGuS+ew5JCH4v5dHo9hoDL2EWa0rcLfWwDvqBGMvGJ2HZ31mUcnbUzEOK
         OJg/g3yyQscqT5Os6py7COUIdK0o5nqcwRMBaVrWr8/d7fGK4dMQU1vDslDirb8z5431
         SUWgm8iSl4xyxVPdEkqyZ5xoXZlQ26VqDL72XK+qMxkBzDliLbkWrgpnoHr3vFFwTU4Y
         FBHw==
X-Gm-Message-State: AOJu0YxnWCBgl93XHyru7wsDSjtZs7xDKrmGPZCv4Yxx3xcwQiuoF0qc
	V4/0h9iq/D9G+VrNPrKrj9j9sfkOMsg=
X-Google-Smtp-Source: AGHT+IH0kCZJ8LzRtQkf9hGFmh3/VJqz/v0xkDmJDrIV9hS12kSQvz5Oyxa7tOgjvvs+eSwFXaWuDw==
X-Received: by 2002:a17:903:643:b0:1cf:6453:b23a with SMTP id kh3-20020a170903064300b001cf6453b23amr5900880plb.53.1700978479480;
        Sat, 25 Nov 2023 22:01:19 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id o10-20020a170902d4ca00b001cfacc54674sm3112812plg.106.2023.11.25.22.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Nov 2023 22:01:17 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 0/1] New example program nfq6
Date: Sun, 26 Nov 2023 17:01:12 +1100
Message-Id: <20231126060113.17314-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Pablo,

I've been using nfq6 as a patch testbed for some time.

Now that nfq6 has matured to only use functions from the code base(*),
I offer it as a second example for libnetfilter_queue.

(*)This iteration uses nfq_nlmsg_put2() which is not in the codebase yet.

Cheers ... Duncan.

Duncan Roe (1):
  examples: add an example which uses more functions

 .gitignore           |   1 +
 examples/Makefile.am |   6 +-
 examples/nfq6.c      | 782 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 788 insertions(+), 1 deletion(-)
 create mode 100644 examples/nfq6.c

-- 
2.35.8

