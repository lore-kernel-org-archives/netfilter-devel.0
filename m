Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KoRS/VcC"
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89350172A
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Dec 2023 18:30:27 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1d053c45897so24578605ad.2
        for <netfilter-devel@vger.kernel.org>; Fri, 08 Dec 2023 18:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702089027; x=1702693827; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fLoN/ASBS8wHZxS4fXG989G7Mi3kxRHz8mA6tJB8T/s=;
        b=KoRS/VcCsOe/CGeU/mnfB4xccb4SHiNAhptIL0qnyaYZG67mf6FvpPnoAWr4HCyYdY
         E0QucG6oEZ7n9trLmId5oz5VTLEhFyynOJPmr5+mmt7ye5ofkmk2gWIE+TLNc4QZNyk+
         C6piXpv+Oetf2FtxdTCnOi+OPyUeHGFFs6GlBkvPO55BOIbS2uOoQ9y2nh5KCr1Ik41n
         svEkea+nCDLFjYLUYjRjeUDVw6QjoPKYJLmfUHZRFeTBmxZd5VF9oFcWqHOxus1uz6cD
         0iA3A7W500hfAsZzXocLSIXJD0No8fyvsS0+3Y3o0NS9kII1EXNjktoTs+NaZo+mkuPq
         TrpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702089027; x=1702693827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fLoN/ASBS8wHZxS4fXG989G7Mi3kxRHz8mA6tJB8T/s=;
        b=HPMOrozRCAtphwKGa4ZTt8Jq6/8Z0sTPVjmZH2HgWoBr0wiYw4bjLEQaP0LtvC5DLl
         mKkLMjHPIiphd1tUVnWrOpG3mjraK/nRO5bagRjGc1ckc0hFzeKQdiuTdJldwjWPT1rY
         R8X+lA0iKX/0dweC0Nok5ffpufgLC8A9hb/c+WuQ5TN5MLA/HuPIHKE1rm15/GT+WcbR
         DA6LrCScAyQkm64P+VZfAv6xJjG0Mp7kt8qXQk1HITCEUx5iZPROz2zrtcreTD2LxwtS
         RnKcUj20UdseTZnIrgSTFFiHy9ujicgpww9qRRU3joQ3lqt96HZHZJYELo3XfGdIkX0y
         3H/g==
X-Gm-Message-State: AOJu0YyfWmEjk3g+2cZFlod+RidOTqJ+EHMBJQNN+BbwSofqoQadgZKx
	wN+pWD00fvirJ3GnSYlkJyQ=
X-Google-Smtp-Source: AGHT+IHKfMdNsCBONoPzmCoXCq2+BKfPZA2XlqQWK6E1WSm0u5BDrkKiByqeSyxxtJy/CUVr7KD3qw==
X-Received: by 2002:a17:902:c944:b0:1d0:6ffd:9e20 with SMTP id i4-20020a170902c94400b001d06ffd9e20mr1196975pla.114.1702089026988;
        Fri, 08 Dec 2023 18:30:26 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id h4-20020a170902f54400b001cf85115f3asm2384089plf.235.2023.12.08.18.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Dec 2023 18:30:26 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/1] whitespace: replace spaces with tab in indent
Date: Sat,  9 Dec 2023 13:30:20 +1100
Message-Id: <20231209023020.5534-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <20231209023020.5534-1-duncan_roe@optusnet.com.au>
References: <20231209023020.5534-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

i.e. this one:
> -^I^I^I          struct nfq_data *nfad, char *name);$
> +^I^I^I^I  struct nfq_data *nfad, char *name);$

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 include/libnetfilter_queue/libnetfilter_queue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index f254984..f7e68d8 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -111,7 +111,7 @@ extern int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata);
 extern int nfq_get_indev_name(struct nlif_handle *nlif_handle,
 			      struct nfq_data *nfad, char *name);
 extern int nfq_get_physindev_name(struct nlif_handle *nlif_handle,
-			          struct nfq_data *nfad, char *name);
+				  struct nfq_data *nfad, char *name);
 extern int nfq_get_outdev_name(struct nlif_handle *nlif_handle,
 			       struct nfq_data *nfad, char *name);
 extern int nfq_get_physoutdev_name(struct nlif_handle *nlif_handle,
-- 
2.35.8

