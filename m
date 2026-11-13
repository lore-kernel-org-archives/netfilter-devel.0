Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794603390;
	b=eEx+XnHV5DV/udQ6oInzXHkKMFckzYh8jybx7fqONTM9tGEbS/Gv3VC9EK+9SsG2PqEl
	 OifNOMmh+d50tOvZH5NrWaAnnxjsyZAs36zkQWLWAWHb8mq83q4+3yYBIfzZx2BPLT6Xi
	 QUTDtww9Sp+BCvwmbyuJgEXxM+s9ItOJzw9Kr6n9FRWEtMkiRZWdLxqQeb3qsHNQONwTW
	 wmlBaEwFbHbLE69CLVhuEc/qQX2+/S2RNI1LCp0aubEEB72ebZ8DjXByMtV5v7fNGDDaY
	 fzYrArUhdK3TwNYqcWRQkECF+UVdBmznw+kzzGB8VsTORzwvlnJg8mm5i39Mn37260A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794603390;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=eAX2A50EYtJkcTfS6TxnLukDj/BxU0JA6j0fOn1wRUc=;
	b=hY0GyBRmkc8wt+sAGCdIiO8OfefRWYDSEqhIxKhvtYRFxy1Bzi1Hb+gM1ABbdJkQHwab
	 wP3SgPXL52cgcyw7SgnF5i23tjQ5CBjhjSMYCYHYh9VtqwcsRWXAEZPbdZB/ijfCMWJVG
	 eiyT3XAxnekMvBESrY6AA4q4Bjefgy0Pwr47xpols2HXj/Y89nRhLcHQaiGBNVLfiVJGg
	 nYGUdeGhmJDWos3QuuHJZExFmGOkrdDNQThMlBNQd0qrt7uONYLZxNhoA08Hz7vSXyg7+
	 tM7z1dyuoGtsXhzGU+j8uifke/tgYvCc7wmJugyTQe3ahSFrskxoPKHjzR3sa1KhNmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CCln0kLE;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96893606A332
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2026 20:56:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96893606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CCln0kLE
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4bb61185057so1035015e9.1
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2026 12:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794603388; x=1795208188; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eAX2A50EYtJkcTfS6TxnLukDj/BxU0JA6j0fOn1wRUc=;
        b=CCln0kLEhSJ5z/Gv6ubHO3pZCbefSWHsaYX8/0cV9VWC9X1FC5faPbwwUCuN14LhRk
         zE6u05S+Frwgj0owddD/YG0SHivRXsEvfcRl24hnawrRKapgFFlPpHPLO2zTsfT8BiE+
         /f0lpZje+DIN68Aaf+eEAiUyy+6TH9Uc1BoGNRICQZ8SbrSRhlf++YcAMxvC2wtXwVDd
         fqsc1E83i+xZu5IdTU5D2ZasR3EfHAtr8EfxlRnb8twcyY1tE4la0hwu09EkmF/RKUUJ
         OzOuk5ft8wKUMyQW2AII43cP81LJoSYQ9zvByT+Jsaw2bAbnFuj/wwXnkJbS/fQzcpQg
         Berw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794603388; x=1795208188;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eAX2A50EYtJkcTfS6TxnLukDj/BxU0JA6j0fOn1wRUc=;
        b=ndYVxBMHYX4UoTt0PfQoftA5C8f1gcCItnfg2y3VNcYBpuXIoxInN0gJQsdEoHzPOu
         hsamndU6MqjV3zUi6qdGd4By07kahtUwctCXTDZstCmohgWBaF5VzOHr0vJykIciqC4D
         ty/24QoCFnDlJZ1K0PAq43UdvXM6GAftsNwLRBnElUF/g+Xg0BvisGJLBY24egbG+A53
         c5mLhX8w3L17tuwyuWjvEPO5NOyNgNFeH8yja25yD6g+TQ0fjJ9NVtMCRUpddp1It0BJ
         VNGtSCrbK9Zc7BakRwiOMRJ9a+dVgQQj5RAXdmtxCTt5uFDrjfRaJ41z18YDHZZ+rze3
         y/Uw==
X-Forwarded-Encrypted: i=1; AL+hErEYBqFrBonkkfkmf/2HJnTy5mvyTDOFhaPBT6LumE0SEc87m+68GvmXZsoXnYYzAvyKxlhnuyConRja44sc+Jo=@vger.kernel.org
X-Gm-Message-State: APuU4Z+OJz+LbTvpsXrdWJwOfPF0uW6MMCoMvQnO3Qe97ZcVpAzhzEKv
	rW8KalwkcjbOHqI5lc6svc++6P4y0R7YhFhhqtmUOOxZ9d9iWkK85Dk=
X-Gm-Gg: AYBFou0lFfAbgplmADQp2nwmTion7v1B9QRq4n6kTNnB/DnxZ9ycEExuM9SeYnign6I
	b3B9I/oaUTPyeOSZoaehLdYfehI2G6L4jA7wo1HtyzKqn6tYu91SL5gxKbql5iKuo25phHsz2oK
	mmSJsztvleodKYu2DK2TI1qoPMljzRJNXLfb/AHvPNwX9imIhrd2LoO3JKsjPvgTzGmBG0ANNYY
	fnQMNnDr4jZlqhGoPLtqWKA+x4bzPYQutc6tAnKl6dWJEArVy3uPZ5yDfAAvQAaVDrTNvqRgk5I
	iHaTWX4qWQ5JGzpyBK8/j/LYsrWO9bsfD3Bme4knhowC1p/biBBWe74LqYhgrBHAJpOYKoIkwKq
	WczelJHCuzcOkoND0yl0KADSILOzqVr2WrhSRlRoVJW5m+P7PqLGjkix0c2WNPjRXPNhKVzZUr2
	3DmObyHvuBuc68tNSFORl9uqI5+cs+cpIXRSe4DRqbUZZcX1uGtC12Z2rXWafKI8eopQLdls3F4
	cxvYFlqXxQtmE7bo0V/jqUVE5ayDOa5j2toW96L+u7vJDxpGBw2TnY+Ds0Y0xKiwm2SdOg=
X-Received: by 2002:a05:600c:e557:10b0:4a9:2a92:231f with SMTP id 5b1f17b1804b1-4bb55a4498amr53684645e9.7.1794603387760;
        Fri, 13 Nov 2026 12:56:27 -0800 (PST)
Received: from debian ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f77fc47sm7529816f8f.22.2026.11.13.12.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 12:56:27 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
To: netdev-bot+sinfo@kernel.org
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, brauner@kernel.org,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH nf 0/5] netfilter: pin file with get_file_rcu() before
 reading f_cred
Date: Fri, 13 Nov 2026 20:56:26 -0000
Message-ID: <179460338684.2413387.5393789134820648556@gmail.com>
In-Reply-To: <179193541159.160550.12220807019134258858@kernel.org>
References: <20261013234329.2797868-1-tristmd@gmail.com>
 <179193541159.160550.12220807019134258858@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

These were found by manual code inspection. After commit 0ede61d8589cc
("file: convert to SLAB_TYPESAFE_BY_RCU"), I audited callers that read
file->f_cred under RCU without pinning the file with get_file_rcu().

The issue has not been triggered in practice. It is a theoretical race
where a struct file slab slot is freed and reused while netfilter code
still reads f_cred through the old pointer, but the race window is
narrow (a few loads in softirq context).

The same bug class was independently confirmed and fixed in eventpoll
(commits a10fbbe74e1c7, 0d8cd9537c641 in v7.3), which validates that
SLAB_TYPESAFE_BY_RCU file reuse is a real concern for unpinned readers.

Thanks,
Tristan
