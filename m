Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872012;
	b=kCtKG8O28tZ0sFozS9c4X4UjV3rckRcH3hTBVgvSp4OEwSG3U0m0EqJ7CiLZN7aMKjch
	 9FHowbM+H4gtOJbPHENVIi/Ary2FA5IkV5m3OmqczCrU/YOehAOvedY09tqfOHAkNletZ
	 KMCYISsZlPU7ejsNgu8xOa5VNYZeS2jb9M55x95WwUMFCp/ddsJne7PnBowWlh+wDf8YK
	 Ks1clPCb2gH4s6IcBckUN6YhgkeWvgTHx5Hl96U8ayxli3T5VLDxtI9X7gB8FX5jZKK+6
	 iaZntHPcgAVvOMimsBf8BgHMe8m49S+4V/8fWrn5oZovtA1Mn9MjltUTmh6+YUkfn1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872012;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=iyLm2JJ7Bha5k7fF1WN/RBaS9++WFeK4ddT2bao+YYA=;
	b=vPN8LIlrdbrrCl4aAzpi7lHmVUXPNsZcOhFqf2ElyikIu9+R8geawpVfRopHXUfJUVR1
	 +naD4mmzJSKhcRaP7hQLKdYhe948THFMT5tp3m1IkLQJNGR9ICLY7Ecy/5Z+KoFmfgiou
	 PnYcoXrvGAZ+COwchm7T3Rjcsu/PnHiwx1+8OCY/Q1rNOx9nYchzi511IabQCGGgxNhpn
	 oINZGPt2gTmW6KhCXVb74m12f6rVF2M9OX6oNvHtJqrucF5mPSRsjZXjU7n/nF+qrMw9m
	 wdi0mPCjljFdVasxl6bfKFGgkI/2frP7DQnZldsn49EK2K2dv8BlCX3f+EU3KU073Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SDbEXYtD;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=IPe7dai3;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAD7606A31B
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2026 09:46:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAAD7606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SDbEXYtD;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=IPe7dai3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793872010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iyLm2JJ7Bha5k7fF1WN/RBaS9++WFeK4ddT2bao+YYA=;
	b=SDbEXYtDBFy+nN/VLO/p7fNZ9zQd79FDJSaSgWTNvnSAiAm7lzG979eOakNO9FK3PorFqy
	vRZmOf8r2sJoOCBbNMjKr3wjSK1G6e5NTi8dTMF5oVsLu6e9jYDCFa/+tPmYq3Eek1NCcv
	IDt8qER22bTswxN+Hxih39VvH3j+7zE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-AmBcnIP4MgmNzKJpN_-b-w-1; Thu, 05 Nov 2026 04:46:49 -0500
X-MC-Unique: AmBcnIP4MgmNzKJpN_-b-w-1
X-Mimecast-MFC-AGG-ID: AmBcnIP4MgmNzKJpN_-b-w_1793872008
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a1d1f26a63so13226745e9.1
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Nov 2026 01:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793872008; x=1794476808; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iyLm2JJ7Bha5k7fF1WN/RBaS9++WFeK4ddT2bao+YYA=;
        b=IPe7dai3A3TwSaQxmblHBD5Q4Q/rWHpStHnErIm77+s6Yc5s9qvi766wpSRCdtPWTX
         t4YpOqsSaNYxQIB62IuEpsghxR2yP/0Dadunp4d8kHLfXbyqLR6vj3pS6fee+9MRpGeq
         2arlYDjKzVJQB4zjAWNYzIRHnNiG+t4j3c942+OTR5sdgAx0QToEvm1pF9N5n5/Av8uY
         +e8tyDO9hO3WCJToAEElH0YZ/vIi3Ha5vxb3kItfdutfSRYhhkowAPz6S6jJ7ckm1BZp
         1hSJWq43riqIxkBaOsLQ5f8hEteYXx6j3oG0yb/LniWnX0nlwQ4Bf6+q2Yi2pPnpe2yV
         grRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793872008; x=1794476808;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iyLm2JJ7Bha5k7fF1WN/RBaS9++WFeK4ddT2bao+YYA=;
        b=Er5CjJuKahFzB55WtZ5qglaHtLi/i70coszKkT7sbynypdLz1vRwEz97JWPqFBLr16
         14dQIpwIL53EtKUeH6ip8Na5KVGcn1MdTTRdkoDXwWHgzUbjk9KfYgrR8ZGK77Rap3ML
         5DQl+E7Mo+lB48eBK5mQBPGQjV2qR4Dppv0pzM5b9/AUTwn/az9y2Ppz9ytmQHzeWVBx
         NVL3xEmE9YRfqMVqDpBkfcolqLjCBPPWJjV+Tv4/za/bOirqNeYVg1di6qss3U1lgFFu
         Zf9Syxp5+YCeb4GbP7je29Kt79Gpg5oeJi8LSyMiKfOqxXUMAiPQEIk8fuBWvQ4NO5QN
         WE8w==
X-Forwarded-Encrypted: i=1; AKwUvBx8TH07KFpTxCYSr6u0iyJgnV8ni8ckDxrs1I7Kq60vSzzApf6dB0Nnb9H8+8qTHV9mpEcfg5puxaZoE3xr7zg=@vger.kernel.org
X-Gm-Message-State: APuU4Z8ZA4fzeJHfGuTaGtTMKa1nx31/SKUPvG1+MnjhHZV+LusM2pV3
	vXeqkedJtY6rlfzIPnZt4XDrwaUjVZ4qR9e1yOCNL3JnVzUzn0+RvlsRU0fpNnI13NLtgAa0cVw
	PxuvEfooa+qK9uwYozdMd026ZlQ8NpeCmb1mNqozYzcKgobqLNgJ2WcJZmjoK6aItfG7VhA==
X-Gm-Gg: AYBFou2cLOFsBxfPn48Brif0ATCzhIz1TTgz6eYmbwGwg7rWJl6MdGT38yTakfEcEku
	GoOoL10gRTrGzih3raWoNWOD0s55EIjJdcLmaFSE2LHI2zXkJunWTLWh0tPoOUyVay8RdTlwWmo
	MCoIui6zqGw61iZ3OL0SiQLlmgaBe2caNvUmQmz6vAgzeVBNxZYZtHyojtRh9ch4ZPmOBd9trtp
	Y/4LDwp7PGCm/CJeyPjXpDwmDEBPvXcJgyR+FL8aqwImzPtj4r6p9VJsSEEPAE4zsF7WhVzuJTS
	6/UYoGapSi5Fq04GPBMAGdkpdnbihtmVOr7ugWgqKCQ1oChJZWWRxJxfEtD+zfHdqGWATHeoSTD
	j8XoScWs/q+EK5kU1XRSYqdaoaaYXFg4iicCF3YVs48gp4/laSh7+5g9OTJeP7K6Axramy6u6jb
	3SXY5nyCK5NTkXHDHCC1wixl4aPWdPaITLUcQ1XEDTa7Q=
X-Received: by 2002:a05:600c:848c:b0:4a5:dc5d:20f7 with SMTP id 5b1f17b1804b1-4ac175669d8mr452190185e9.14.1793872008407;
        Thu, 05 Nov 2026 01:46:48 -0800 (PST)
X-Received: by 2002:a05:600c:848c:b0:4a5:dc5d:20f7 with SMTP id 5b1f17b1804b1-4ac175669d8mr452189745e9.14.1793872007952;
        Thu, 05 Nov 2026 01:46:47 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b411de95b4sm84246655e9.0.2026.11.05.01.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 01:46:47 -0800 (PST)
Message-ID: <51aa2527-0a99-4d67-845a-a8b28f822efb@redhat.com>
Date: Thu, 5 Nov 2026 10:46:46 +0100
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net,v3 00/13] Netfilter/IPVS fixes for net
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
References: <20261104090224.750548-1-pablo@netfilter.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20261104090224.750548-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/26 10:02, Pablo Neira Ayuso wrote:
> v3: keep back two patches in the series with sashiko reports that
>      suggest they need a bit more work.

I *think* Julian additionally suggested dropping/changing patch

ipvs: do not create conns from packets with port 0

but it looks untouched ?!?

Also AI review did not kick on this revision, likely because
the bot is confused by the mismatch between cover letter prefix
"net,v3" and the patches prefix "net".

I think a new revision may be needed?

/P

