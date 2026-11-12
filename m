Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794494090;
	b=QUGAYXaMxKhWc4dflx4WCZIVxVt/AGuv9EEUQgse67HvwqiCutKYS7V3Q+zowz3suWrg
	 mBdOP3/AuD6vaKrDTCVLZtADyp/gBk1V9UjbYk4tTvJhdFniLFsxGCY/ESE5oNXsrR7yt
	 +Ys9ffJ+fFI/rAckI5uTPXyTvSLI2UEskcY0ySVW8OhKpxHyEXZnrOFS6Bq7d1LfmwWVM
	 pPwAOQtdh7fibIzmtugrpBxdc+ShwdPnrEU81NBQRlte+9/Qky/MskcOlsiA8TVVQSFiX
	 YT4A4ZORupilAq+Gr1I2sv/2ZVMK1pyx0YI80zlQhhDiolyxN+N92RrWQwOzDVAge4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794494090;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=6MtxvwIy73ZQd4T3DqnIV/Zb9NugLeP4diZveyex/dM=;
	b=QGvL8MIpGGJBirhkoHyr9Gl98K+mYjo+CTCy3+mm78YJLkoU/XTwCWEBjYodZ7Mcsv2V
	 /myRUWN99Ob6zP2Su5CPo7ectJ4rPfZFglOEi561/AxZyJsRG/xyf1vXTjw8oIW6ZU1mj
	 2w/rhoHYkiCcUFBiovMTx8okP8YjHcLSjy4Dub6xvyoQS8AaLbBNXyU1+QKgomAdnNcDF
	 xTsnOHgwCQEEMToBiiw2lh/e7haq2LtpvNM2k4aWVXXh+t8tKMHSvTaxcnQuWrS8xasbX
	 LVEttEauZ4pLTbBYK6guZRKAANRptLEvcWwBeQedD8NOZfsxycU79GaHUhRH8VQa6JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UcTEnzY3;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619D0606A339
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 14:34:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 619D0606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UcTEnzY3
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3ac91ac8924so2522524a91.1
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 06:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794494089; x=1795098889; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6MtxvwIy73ZQd4T3DqnIV/Zb9NugLeP4diZveyex/dM=;
        b=UcTEnzY3JVyJHX7wVb1daJ5vKsNuRABAKkdJFDdsdjQFcTP8SSCLCAvdQulbSXIn8A
         iggjFyQB9RGqZr+mEInXST2uZ4OENbWR7IACpJEKhNHaUD6qvzz7DON9j+qbME1WfbQ0
         1ibwTnAjlcQi3Xa4D7BdWjVvUd4jRiwkKBjL4pSMhmq44ctKUTy102EqX9UivB/YKOXY
         Ss0uJJZzDWD2Tj9CPwaFIh3FVgvmhl0sFkbqmuWF077Ty9RvWVlBx7BCuFWDBckwIz+Y
         cKxxdIuYsu0l+AJYT/HOt2nsZx7Lgz6UvDL83onG4P9YMFDy+Uxdpf5VCk6quEjyilXG
         9RVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794494089; x=1795098889;
        h=mime-version:content-transfer-encoding:content-type:message-id
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6MtxvwIy73ZQd4T3DqnIV/Zb9NugLeP4diZveyex/dM=;
        b=sWWmeb/kY7yWqadEyDJ3TECbxEvwXdVLMG9V0vZrsGnuZAe2lgV/2WrNgb7HfpZ6Ul
         DyFju73nZ2oaXg+2lfgMkCYtShRIeZMyE85s4VCdXkNeXIAR0VNf+S+ua86XZUdXw2X+
         Mw4rQHZ+cgr8YXUslElTgGURA0aRdSoqK7rRhIKaTThSfeNHFV7/9vzN7MYCOnQytoNU
         syBEyTNKBu273q5Immz487yFZE+OJrQp8m+xOmOVZcL6AUa4129sU/kz9AOVs62d+9aZ
         H/Uff0QrUV3dww/47d/qw1YLlWp+k7yVNyrTbhcayahGySBREVb2hcbQV/eWtuDgURj5
         tm3w==
X-Forwarded-Encrypted: i=1; AL+hErFGRh7RcUluOPNtDKGM3TMzKy7KbpeAQffhW8rE3B0e8XEXiO889s/l+2ZBJOT/IqB+HNtmG0jFgqmt5v3eJ5c=@vger.kernel.org
X-Gm-Message-State: APuU4Z+V9fV45wM8mDWRckMPFi+EF4eRWfbtBldb6qMM0DYsyo6UU/gy
	UOjob/iJAX1zW5eUE+74XPPu85JHlFsnEhk4ciuSpAvArl07h53QG/5S
X-Gm-Gg: AYBFou2PuOc6r5Juehjy0dKLjRYF2LuWw39edMlnPPcIkF1atwYoEX8R5bLqcsobdld
	kYyG9atMVVahsydiEBMiN6qRk9vpn6xiqLt2A7td6jw0oVu3ugdvMbubQyZIJQWgQmwpKsn0dAc
	1tGAmK4lDlbT1zMtzgs8mV6xs/8XEbovjHX/QdIM7fwBTlj65PE2/3Vi/03WL1ZVooBYwXgJDz8
	MLCz2UF7hvJH2GD4WTNNYqHlJv8rZgiCKCjinRsy8CGHMRxMkPo28Xyrf2ySRUwt6jjIYFXI6rk
	KwLblVpFeGINmBLoisZBqLFXhaY8UjgF2xbbreR/sLDxiw+4qxq54WJScxoIJBvfBehtMVdpCfQ
	Atb6cXRNiHkOyDbcbpUwPBNa264Foszpl3+KxcTn8LBi7YVV9vfAQx8o7UBV+jiW0nqVH59R1i/
	65kB7+Yuv5Gla9CnSsjVutw2YZOOh2d4cqAaD6cIwJtlXhIAkwnozA/q7xy6H5UDaRuZ9u5yJrp
	LyKghKNWssQmPP1MfKqBAFbpyHzRsBIMdyrGowVEqHH/y/FRT8d4wUNxH6SVg==
X-Received: by 2002:a17:90b:2e41:b0:3a7:f4d:b23d with SMTP id 98e67ed59e1d1-3b182f9e1ebmr5131067a91.52.1794494089467;
        Thu, 12 Nov 2026 06:34:49 -0800 (PST)
Received: from [192.168.122.1] ([218.48.198.193])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197c8b2cdsm4868205a91.16.2026.11.12.06.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 06:34:49 -0800 (PST)
Date: Thu, 12 Nov 2026 06:34:49 -0800 (PST)
From: "Baek Kyu, Kim" <pocj8ur4in@gmail.com>
To: netdev-bot+sinfo@kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nfnetlink_queue: use verdict sender portid
 for expectation events
In-Reply-To: <179449333655.2168702.2394012834202740473@kernel.org>
References: <179449287223.132952.1536491080157978119.c244-nfqueue@gmail.com>
 <179449333655.2168702.2394012834202740473@kernel.org>
Message-ID: <179449408688.148684.3959110286947423131.c244-discovery@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

TkZRVUVVReydmCDqtIDroKggdmVyZGljdCDsiJjsoJUg7IKs7ZWt7J2EIOqygO2GoO2VnCDrkqQs
IOyduOygke2VnCBleHBlY3RhdGlvbiDsspjrpqwg6rK966Gc66W8IOyImOuPmeycvOuhnCDsgrTt
jrTrs7Tri6TqsIAgcG9ydGlk7J2YIOy2nOyymOqwgCDsnpjrqrvrkJwg6rKD7J2EIOuwnOqyrO2W
iOyKteuLiOuLpC4g7J207ZuEIEFSTTY0IFFFTVUvS1ZN7JeQ7IScIGBORlFBX0NUYMK3YE5GUUFf
RVhQYMK3YE5MTV9GX0VDSE9g66W8IOyCrOyaqe2VtCDsm5Drs7gg7Luk64SQ7J2YIO2MqOuLieyd
hCDsnqztmITtlZjqs6AsIOyImOyglSDsu6TrhJDsl5DshJwg7KCV7IOBIOuPmeyekeydhCDtmZXs
nbjtlojsirXri4jri6QuDQo=
