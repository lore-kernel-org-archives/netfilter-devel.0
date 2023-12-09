Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iSQnCoxO"
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D9A1710
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Dec 2023 18:30:25 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-286867cac72so2133486a91.2
        for <netfilter-devel@vger.kernel.org>; Fri, 08 Dec 2023 18:30:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702089025; x=1702693825; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=ebeHtESDbUjEjQ7LFFQdXPVPqQhL7pIUecskNY9xMBA=;
        b=iSQnCoxOd+y15AQwDMl8WWbBWCmRlVEZruYV4Zki21M43txEBbZ72vcqti0JfXpKtd
         RaMcL7h/M+I+VtOL0CFYnC9shP/oYu4BzFDhANj+C7sMDOah2jG3t0nMS6mU+rLVFh6d
         PApn1667vCIZaULF141n9XMT2datKMwteRAamdj+8Hwql/D/DXZPxUEEW3H0MsslyWp+
         xfjDO2i5Ikwh/QXHHKCU6ACMb50faE4VVn/urQlQgJgA63aqzC82VgyXAIDvtaGSkXs/
         2tNtJA/qtm5wF5ax0Ki/odVm5QNiKY9sHJjoJS3vaIVNT/26nEwKQ4xKnmrp6cuLGIwK
         rRbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702089025; x=1702693825;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ebeHtESDbUjEjQ7LFFQdXPVPqQhL7pIUecskNY9xMBA=;
        b=TS1XyIpDHm1k3MU4HjzqdqYKhjjjhtiA4KKrzEPh930zgGQEkaT3PLUBlvVZ4B7apq
         lHECH8JqfbuAIZjd/0Df8t0jxrWFiHHnaX8Ubn9JogV6FMYNamUhShdjNabhxtnB8quo
         6Gp7K9TNHB+0Xs1maKU3wKFzK7qj+1Nqyoj//M9//wYc3/ZmVYrxICEYH2FyWj2uWIX3
         7AmgJAlkA+IbGpOyPW732rafZPlSbVjl+1brrv9mBEF/8hHrj9st9sezxfye+O8hEA/5
         4ArGrm9YDMl3W6CW4A68du5gsiZK3xeqA5wMma7VO1MOUXsjtCbW3pgHiym81kJ5DPxH
         uH8A==
X-Gm-Message-State: AOJu0YxOJ9atTj4Xvnq7aVx1ZVoCv3YsKoSvIsTUp5BsNihJbyPdCmW5
	iPiEmaq8hm9Ec1ATvXslrPxe0NmsS3c=
X-Google-Smtp-Source: AGHT+IFDgzqSu709GWtyU0BKf7FkOZj0BS2WkUu9V4ck2h7DEGHwQafvOum9qws/9zv86VNXFiYW/Q==
X-Received: by 2002:a17:902:d4ce:b0:1d0:8abd:4e30 with SMTP id o14-20020a170902d4ce00b001d08abd4e30mr835874plg.87.1702089025139;
        Fri, 08 Dec 2023 18:30:25 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id h4-20020a170902f54400b001cf85115f3asm2384089plf.235.2023.12.08.18.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Dec 2023 18:30:24 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 0/1] whitespace: replace spaces with tab in indent
Date: Sat,  9 Dec 2023 13:30:19 +1100
Message-Id: <20231209023020.5534-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Pablo,

My text editor auto-corrects this unless I remember to turn the feature
off. Would be nice if I didn't have to do that.

Cheers ... Duncan.

Duncan Roe (1):
  whitespace: replace spaces with tab in indent

 include/libnetfilter_queue/libnetfilter_queue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.35.8

