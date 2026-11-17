Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794909628;
	b=O27E1DpvNULTLX5jE+VJ54nxTPtidwD8I5oxwWbsNL5PeVORWzT5Z6SIekOg1MLA7VjN
	 31/gIc+eP9g08YDdrY922umA1ACi617+lROHTFui8FK0FgTOCR32lww94lZ2UZxkvvV2C
	 ir+iyPjliECDnCqb/s4FpH2RLPp2WGELvHxYJxzkVgSXwYELctJeVVOrFP2SY8OE2TET0
	 Qk/KamQisYUJHnlCAdf0dGs4WFR19OIOh4VYzAWFvWVJD5I/FZQ8PC0IhpCCEfBVLqyon
	 astEnxm3TE2pvh/5MmvY06CvrEvKXM/fMUSqOWDSgAvKsxxaZOQsT6KFb2O+p732zeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794909628;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Y9UjBOHnP3jYIfHPwpekDZ4sBjaCiEDL56fvq3n2mz4=;
	b=GiSUneoQBMkNXTtUyFPcczN/0U2CC6J5E4/y1xSsYUWSnQCtPcJrX/yDqIlIXmFFCtar
	 DjhtOUah/xgjnthLarx2BGFASsTopRaQz7Vat5hLox911YAgbH5WVsYO8zDTD/kiMDNCb
	 DuHRHtSZsYuAzxzMvRa0TM85/H64/KGQp76K9TeNP1r5rV0o2P9xLjz2MQH8vsERgkfek
	 ruA0PHfcnIsRtv/5HP1LSuHqMUENGRo6Qhcr+4IFbcEriOTwAhNIOSVCisq1XdInremOO
	 DUsDQzKxXJKAmC1LUSYwqQRcbkhwLo+8PlJyXaz2JFW/+osS07bhix2xhhfV9dTqXMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=AUexgs8I;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=nOnO0rXH;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92314606A31C
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 10:00:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92314606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=AUexgs8I;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=nOnO0rXH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794909626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9UjBOHnP3jYIfHPwpekDZ4sBjaCiEDL56fvq3n2mz4=;
	b=AUexgs8IOWwS2bHNsQjRU7kGzR/10jQ7e9Kukd3MmI360Kv+cwRjcy2S4wqZ/Bnyy31n6J
	FUAavlHu1dDFxwWNgBmDNCFT6kYVo+7XSXHTtgWxeUTxT5R+fjmyS8rhUIstDRZvS0w++x
	ntZN29df17RLXqidHTcWKuS1aMqrgzA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-XP8zBnq9Pq6vASzwXwhvjQ-1; Tue, 17 Nov 2026 05:00:25 -0500
X-MC-Unique: XP8zBnq9Pq6vASzwXwhvjQ-1
X-Mimecast-MFC-AGG-ID: XP8zBnq9Pq6vASzwXwhvjQ_1794909624
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48e0af48c18so2964220f8f.2
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 02:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794909623; x=1795514423; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y9UjBOHnP3jYIfHPwpekDZ4sBjaCiEDL56fvq3n2mz4=;
        b=nOnO0rXHXTwBfhMosBAqItH9ba6ta6tG4MlrNIjEVetywkNj2Hawl+5tf5wZkKzD0W
         gtQF8ekO/DCnUzKiCQmB58sP1VmW4ZlGT8gyrlRtSmAgvrj42yS8tpA/2K7eDooHOaxc
         S9Pj0Q40duwHgpm/4259hbvlxf13RcIrxV5/pIRLVBZTUT7Kx55LY4vlpV1AkawwacMx
         4we8CG1md5yAS1dHrBTY4+Vqo2rWeyYyvBjvmu56HQfgxfyAxn8KcjG+fa8mHYULIeTl
         FDrb1QULyfkbWdWJAh+oC68bNTu/abDTjPsYm0AHLabKoSCKMVrfCExM6Zswg2+myVe3
         1/xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794909623; x=1795514423;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y9UjBOHnP3jYIfHPwpekDZ4sBjaCiEDL56fvq3n2mz4=;
        b=JmsE38ionB5+qBavgvGF1n1Mt3JUESqEUkjFTUG3j7JInC1O8x4aNf3gLTDratqhew
         Ami4jqrRzFBAbmWsylKSBqlk1Fq5FMg1uAVph8rNId9Qe+HaCwgICJnszly7rJWvGXgI
         84UY4qnRMbQF1I6VPPGgFaxEVWgVsCmIGh2fHzeX/U5QVuxWL7MAsrSsrwudrXbSravM
         O2LBhq605buZTRekynrR1HEJhscwROKCWS0ZlmB8SA9G3iEPKp75jxr7DkNC8Puriup3
         k24hfSnNjUeaI404FJQjtB/OHZrQdKnYyBGMa+a2nVlihcXyE6foYbnyZ4VbQ6yzIhNI
         JoHw==
X-Gm-Message-State: APuU4Z/NQ3BMwPWBX9EYWbQ3aPz0muNF0nA86i4qSPpYg0Hl2hrRZlr6
	fsN01oroxHzDH5SOfZhuYDk26NqZ8ZGjkQIyWmc+Cq1uKNNtByweQDtTJESMBKdTg5KBP73mU2u
	MvzsXkcDP5t+Of4Rd20Mw0z8nktslkOWNHv0B544SfqBKGvainVCNSTcOXgPeOmxFA0lhvw==
X-Gm-Gg: AZFdTZdzdLipMNmau7kberUaVDdDp/lE/xgIUZbZeAPDrO1lGik+u8ksxemV7wvGbNA
	z+VjDvlsi+S9TSWvBBvkfXXIQfJE+xZhxRidT8VhB6txyu5Xhbt39Ke36WrHdkLUxHnPxOl/Lrg
	QyLwVuIeKNpSDiNIROCu8QEMUd6YOjaV3lPngroB24JGU7R+dv0iZN9bB/heRC7DFTUf6ZDtzUt
	1OiwMXkFE7ITF6I4pzCsLk7NOjbP+TRnHA/0LAbLwvdAlKB7HVegXmfLc7GGupUomwXlWKWuvgs
	FnEnPdeXulynZv3iVE1vscLCO8sCLuAJo821tQfkwbEvR0SEKLCWJr4qbPJuwHCnCEoR3I1/OMj
	hhmccrMEUmHFvCxQ+r5iE57qPe3pWC4wz5dIro5sKVNKQSEh+B0hBzKtKB2IkWuwtJHROUGfeEP
	A5YLUYZ1ypfLKhstZ45x6EkUfT2RjMpTynQq/wy8Car+P5
X-Received: by 2002:a5d:5f47:0:b0:48e:4115:f3e8 with SMTP id ffacd0b85a97d-49c712ac6c0mr28211627f8f.27.1794909623166;
        Tue, 17 Nov 2026 02:00:23 -0800 (PST)
X-Received: by 2002:a5d:5f47:0:b0:48e:4115:f3e8 with SMTP id ffacd0b85a97d-49c712ac6c0mr28211557f8f.27.1794909622639;
        Tue, 17 Nov 2026 02:00:22 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a4de4cb1b6sm1436394f8f.3.2026.11.17.02.00.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 02:00:19 -0800 (PST)
Message-ID: <39940277-ffc1-4ede-a9d0-605ba0f8ad3c@redhat.com>
Date: Tue, 17 Nov 2026 11:00:18 +0100
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
Subject: Re: [PATCH net 10/11] ipvs: do not create conns from packets with
 port 0
To: pablo@netfilter.org, Julian Anastasov <ja@ssi.bg>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, edumazet@kernel.org,
 horms@kernel.org, fw@strlen.de, ja@ssi.bg, netdev-bot+sashiko@kernel.org
References: <20261116004404.2821183-11-pablo@netfilter.org>
 <179487963329.3136.11227226787276094605@kernel.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <179487963329.3136.11227226787276094605@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/17/26 02:40, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] udp_conn_schedule() (net/netfilter/ipvs/ip_vs_proto_udp.c) now
>    drops every UDP packet with source or destination port 0 that matches…
AFAICS this is the only new/unaddressed comment in this revision.

@Julian: could you please have a look?

Likely no additional revision needed, a confirmation this under control
would suffice.

Thanks,

Paolo

