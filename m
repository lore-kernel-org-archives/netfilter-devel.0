Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MpFzelLs"
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F4C107
	for <netfilter-devel@vger.kernel.org>; Sat, 25 Nov 2023 22:14:04 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id 5614622812f47-3b83ed78a91so2009193b6e.1
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Nov 2023 22:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700979243; x=1701584043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=GH9mURrWMHeNoVPzckJ4zsw2y9Hg8SVFrqyCtWh8T2E=;
        b=MpFzelLse5LKJnw1f6nnqBWtRr5Y/WTnA+Q6EYuwk7MpFCB3zpUahZLTYLhzqUgSXm
         Zdwa5R1BWpbNK9q3Pqrlz3kIN4H8cs3LLgybepO6Zu6ZVWt6WrUSdPDxH4wHPumxswEZ
         k447AcfTvhwzTTpkmLDqKofqnVvTbJgtuF1CCfAHopoawUQoqJ9UUiqljDyVrAYB2njj
         sETcxrGsZLgcUvyMCfF0z/I3tfyYrdJvp5NNpRP/2fUxB9DLd3f0bkL77U95NCsRE6nz
         Pu47PjN6hPe0nf2T7znwvBcErScFqJ0NNJe0aJVe1fmSMuH+feU6MJj5/g0wFwfZ1flt
         xEjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700979243; x=1701584043;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GH9mURrWMHeNoVPzckJ4zsw2y9Hg8SVFrqyCtWh8T2E=;
        b=Sv2xQzlRtjnIFSuDZMXlUEKaZ+2H2hf8u99fb4gnd6ObuoBwPYbwhRVMCsr8vz/Zf1
         Tu7A2fsb3C3GRu2efGR4myA3DwVGG7KD+KvTbEHCNbvD27DGqvoflO3YOgOE6RF5nNXP
         G7euad5oF+p6Cz4QIJjJtZmOQ2AZwQ/Cito3ee5J1Z9/OBcNp0raDD/KrC9eA60a3SzN
         FJ2zP79e/Qz8L7dZdJrvI7JeEfmi77u8YqvABWJY6b4Np8BJqYCouip81PPy/FIFk9TF
         rUllk9SeddjEhr25a0b8i+R7PfvZFwt/82sdTiHvSQuXaUEcA2sy6QO1Wm6aCRMWV6Oj
         2l8g==
X-Gm-Message-State: AOJu0YxHCoVUc/4p0awGaCeMOANOxBfIcgH7j84ifPZpwWehoaaHoQsx
	/wB/M3gRhJ4Sbb6qwDFGJNP4ETFNJLk=
X-Google-Smtp-Source: AGHT+IFUkZ/c0MXkaX7TouTjgprbTTSBUaCJ8J9TtIYkNLlYKNa77+uty2Z0A0frJgKKUNGtcx3RWg==
X-Received: by 2002:a05:6808:1483:b0:3a7:1e3e:7f97 with SMTP id e3-20020a056808148300b003a71e3e7f97mr10629521oiw.4.1700979243503;
        Sat, 25 Nov 2023 22:14:03 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id f13-20020a056a00228d00b006cd7d189aa9sm908183pfe.131.2023.11.25.22.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Nov 2023 22:14:03 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 0/1] New example program nfq6
Date: Sun, 26 Nov 2023 17:13:58 +1100
Message-Id: <20231126061359.17332-1-duncan_roe@optusnet.com.au>
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

