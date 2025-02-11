Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CCD254AE0
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Feb 2025 16:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739289612; cv=none; b=nCIevNVdcpi8FNZNRZUCwqhExxVaxvx+PG8Bt+J6p6r2tSvnvoFKYfNOJCVwS6GXfSJk1jnlSbdxXrRG3VXLKHzT80hsEreInzlDgKufCrWr3QxZy091fgK/I/yXNkrvUpAFikbHZghVz421vk2oYABUXyQXDhWF7mKYMSYhbNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739289612; c=relaxed/simple;
	bh=367tBOVSTQNE68f9evXGvkRc2n1V8n4iAsIeEbOEs7M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jNj7o4NsOtjjOgSeKg/G4D9bvsnFahz7BGFU1KJbh+WLVNLrl/ASpuXbOSytwxX6g04Myef4Q/OeAeIEEGz1TEnrWVDip+e1Ihb088cjGBWNilTcbOBD+8RupntIJp0RmveiapJMS3lvxNwtj//SQQi433OGYo/74AxUTGJkIz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b=PAfX6H3I; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b="PAfX6H3I"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ab7430e27b2so1098242166b.3
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Feb 2025 08:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20230601.gappssmtp.com; s=20230601; t=1739289608; x=1739894408; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hI/ECcJmQ5+lRsmCQ33ubWCT5i7ZlE5HoQwEXVHTSj0=;
        b=PAfX6H3IXurM2KFL7dkio3W4u4fg1aQj/lhZQ0vzFZXxrBvHGkIEh5qa1rdCway+/0
         oKU9dphjhzdnk9b/Vdn3cFy0qIxAVL8Vdc/x/urq9wmws4i8F50armq4fo/oP5G43Ps/
         JRjQF+k8b3tnmeRk7LH/6J0rp4rKDfde94w4Gf0w3ukOagclMo/j7K/PqugVoKKeUVkg
         tgJdAeZgni5ws6DBcbEVyuDfVf76I6U2sKDImzZgDTab+WXprsnOfpprkb9dvh7DdVvn
         Tc5/hVoUwcRWWv5Kt7HD++LimcvKsC/D5oeS8EumXW2ont/827c8Km0ITIYELVsVRYaj
         1i8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739289608; x=1739894408;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hI/ECcJmQ5+lRsmCQ33ubWCT5i7ZlE5HoQwEXVHTSj0=;
        b=Bmyl3/JOws6JRQx6UuxVwVV2DK1H2cuwnUqlH2ohnsif64+6zB41V7u9tJiPJygApt
         HPvzADMfLU+xGglhuK7qpsi2R6TzQAeU9Xak3v/SyBYCZkdSRE7uewnGv9qcS3eL/JJC
         9KDDSbo8Eu/zU9ytQTGrQJ5t6aRTR48aNq7AcsqMzdEU39DDaK3UIODMYlkdbFdEJcDn
         YeFUflaVzbBDYz8O2AfP7s7D4XZHHmTHhA6g60/ciDYum2Rh5N9KL99rNXVvByBUczdD
         chzfsMgdw4nmUmr2ywHcdsenpHhJCp+AL9JRWK5CesSl7E9SUP2mj4LKhX4WJEnHczYB
         nnWg==
X-Forwarded-Encrypted: i=1; AJvYcCXFhW+GzuvAGqwRQg6NK9WaRVJgnhESfbxBRX53fmCT2azCfYqMhHhOLfbvkCpmemn4u5ykxk+WKcFSn7a4Tq0=@vger.kernel.org
X-Gm-Message-State: AOJu0YygyoHOwU9NWNcbLcvx1C1reTPK0uhyoUtsTEta22b6nk8BOBmv
	B0ssE8DGLFIxFX4XE82pgRm06JFTjsDtz2ydkhDJvwI7et5R9aFKtqfCYpGcryI=
X-Gm-Gg: ASbGncsSvkBVGidarpX4F+Y2Z9kVVLhLxL2JWxO5FjCMul1m2KHNSZrvBsRs93iceba
	f4gfVptWtZSdF1uTXgGhCewR0WXwpTsYf0AHsiRiSV0nRhvcp2vX4wABw1hsNnb7O3c1oiT4uoV
	/xhIde5+D61vQvimR9A8Q+nydFvAs49kacOqrWEiXiI3J78efOIlvIv6dEXaMYGv1ntZq0OHBke
	B/4aa3jKGl09LtA2r7V7lux5CLF67YetY+JJeEzVN+dAIi882DhrJKeMKmdsUgkm8hsPMjlkxDt
	rKr9UAxF4EEOgRXH1CnbFwq7aqF6sc5ZzMa8C+pIHbuZoNI=
X-Google-Smtp-Source: AGHT+IE7ksSku6fs3EFiOJ7qMjT+Xj86y9WzUfaIKnMbJB/roCniH1bXiqumQdCG0sjm3B/UGhh56Q==
X-Received: by 2002:a17:907:2d24:b0:ab2:ea29:b6 with SMTP id a640c23a62f3a-ab7f01cc9bemr17039766b.35.1739289608146;
        Tue, 11 Feb 2025 08:00:08 -0800 (PST)
Received: from [192.168.0.205] (78-154-15-142.ip.btc-net.bg. [78.154.15.142])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7ce2e91e9sm307325466b.117.2025.02.11.08.00.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2025 08:00:07 -0800 (PST)
Message-ID: <91d709aa-2414-4fb4-b3e1-94e0e330d33c@blackwall.org>
Date: Tue, 11 Feb 2025 18:00:05 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 net-next 05/14] bridge: Add filling forward path from
 port to port
To: Vladimir Oltean <olteanv@gmail.com>, Eric Woudstra <ericwouds@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Pablo Neira Ayuso
 <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>,
 Jiri Pirko <jiri@resnulli.us>, Ivan Vecera <ivecera@redhat.com>,
 Roopa Prabhu <roopa@nvidia.com>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Lorenzo Bianconi <lorenzo@kernel.org>, Joe Damato <jdamato@fastly.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
References: <20250209111034.241571-1-ericwouds@gmail.com>
 <20250209111034.241571-6-ericwouds@gmail.com>
 <20250211132832.aiy6ocvqppoqkd65@skbuf>
Content-Language: en-US
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20250211132832.aiy6ocvqppoqkd65@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/11/25 15:28, Vladimir Oltean wrote:
> On Sun, Feb 09, 2025 at 12:10:25PM +0100, Eric Woudstra wrote:
>> @@ -1453,7 +1454,10 @@ void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
>>  	if (!br_opt_get(br, BROPT_VLAN_ENABLED))
>>  		return;
>>  
>> -	vg = br_vlan_group(br);
>> +	if (p)
>> +		vg = nbp_vlan_group(p);
>> +	else
>> +		vg = br_vlan_group(br);
>>  
>>  	if (idx >= 0 &&
>>  	    ctx->vlan[idx].proto == br->vlan_proto) {
> 
> I think the original usage of br_vlan_group() here was incorrect, and so
> is the new usage of nbp_vlan_group(). They should be br_vlan_group_rcu()
> and nbp_vlan_group_rcu().
> 

Oops, right. Nice catch!

