Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F451F191D;
	Tue,  7 Jan 2025 14:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736259803; cv=none; b=d3KfE4tLcBzJfXPgXB3dC9fMOtGLQT6/9A54Zr5YOocynBJ7t+IRsFhPGYda2zfYs7gcRkj/lo2MsIQPdhb4XEcPPJGar+jD8pAxFq+9kkA9e2i6acYYbXf/ZNs9qzSZRZcGd9I1egZWXDZN/XqOiDkX6qPPCzE/CBBE0gKzKkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736259803; c=relaxed/simple;
	bh=Bm1DtQK3Zmv8psZJ+NOjFV66PEzHEkw6lMPzpKko7Jk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iWBF/rwoqAcJnCU918w4XeG89fno6AK2PQUCWIQdoHbw2D7mTkefcJhx6ehsI8N+M/h2bRMJlahA9NMyefmI/p+uCgTUiFtULF6j6Yzz4Umyl61VjI2rio3i9di6mpb5mumup6FhgwEpcp1sB2KjxN3CZAZ1uiTkod1px1xB+2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H++drWf+; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H++drWf+"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5d88c355e0dso9050323a12.0;
        Tue, 07 Jan 2025 06:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736259800; x=1736864600; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XE2LBycvBfRVASiRxD8GRnH5rQbRkw6izbBARG4PHOM=;
        b=H++drWf+KZRlAjecygx2GsGYSFEBHKwGssTH6bf00fH9JXPSFBE0xY9sRtM9GEXhNL
         FLae73N/Lg/8spjh1b1RJ5qQIcWOelyBBzKjv6EkK3RUd+VGOSjednoz03bxwEDIKrDR
         BauHvPFgy21ayOcXtTr4crSgru20KUmMwxZwwUxx+nDQZzrHrSQdHXsBfNuloRFc21b/
         cGe6jzRisCKf60UeAnCRGEM7xvS1VHlaXuCd/+2K72q9Q1IBAEOeuCIIFmFdW3XJx9YO
         VIevwYOVwPvdjDuby7cjGEROHKde6NwssWsrkQynKC/A/88FHaQqXJZsGRVuVbS+mJ+P
         trLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736259800; x=1736864600;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XE2LBycvBfRVASiRxD8GRnH5rQbRkw6izbBARG4PHOM=;
        b=HPmwZH7uQ6Fgyb2fxKAfwa3ELEMwbKrgp4mgGjnNQRZBwIl6QOz4l/H+dx82enye+R
         ngBnBG2HFT7FpjlqFMUwepChV9gAD068GcF21XOes3vi8Zg2pr1rvyEoKTevcM2VYiKC
         c+rkQbOxRa77g3h0QHE+20z670nKA+ukMOYigHk9BnWhE79+Q890J+hWrMTA1b77b2cT
         Uri4Ku3fU9/mHCvpPeOhyXWidQ0q69YKGO5SyAoWT3qWB/ZgJF3G9ugNWoqaUFGXy9kg
         LQGKoFVfFWwJFPW0eG5WbW7QziMjqUEt+EnKZ/24bki1fNYXBdlLUvyHhQzvmgMkMW7m
         2rtA==
X-Forwarded-Encrypted: i=1; AJvYcCUabPsOqqx9WIovWBih6LoPknJOfRUQ+z632CL8EdDD5FaF3hJ27J0gkTA7bjL5wJbL0PdS4yyi@vger.kernel.org, AJvYcCXBpdPdS9XePfjhxKyEBPSdPxuqJZPr10dZy9E/6dwnTWVPxmu983H10efquS0F2aO7yQ97Mmi5TFvpdV8=@vger.kernel.org, AJvYcCXomBvZAxDm7hKKkiKJAgCjNM+sa4kEMlGBafPOuM2tWYsxSi2p59jLyzTGqrL8OHsq4lg6D/WjhV/T6z8REf3e@vger.kernel.org
X-Gm-Message-State: AOJu0YwCfv97RQGVHnqmSbacyA2QfkPVs7XWnwlZTVvkeTguOMM1Pzbx
	gw4az2vsanVRx7/XrFSHiuhAJJPUyWEP5fJMYQgWwn2sc9IEgWhD
X-Gm-Gg: ASbGncsTcjUP5WoiFlmUo/hmB7c0QZGb4lU6ZH0KGl7rwnPFF0VKWxuJDnMKGm0qka9
	ahMpLlzaRFroxTPnO43pmdCmW58pV9meo3rNskYVHGHF6ojnj557x7chLNbDPKyTRllEyuq95YJ
	t8zflARvvMut8dNqZcK6htWT0tc/BO1iUummvk0JxHzMJtJDHJlUWBs7WgMRmJ7n1vZMFUc6zVH
	69feFN7RsSjc0G1bkBEkv7VxCj1aDJKxpbXJXQTxS8a+ndm+4+dToruRFS60tQlvlsBPk4F/VGQ
	uOJ2HErZPKBcPa7XF/3x1DZVcf1AmXEyexQH5eXGbRyJCvTHD+9NvE4Cpv9eWR/6gJ2HMWlveNO
	Sk1g/O+hB6IP6gzKeaDJE5ua6TanMqCk=
X-Google-Smtp-Source: AGHT+IFTKXq+cflhxmBLnsZ30k5zI/b1GmBG/qIWiM0wUuk9AhpVGKtgpK8+7CvsgQoYKL8T/INBNA==
X-Received: by 2002:a17:907:d87:b0:aab:71fc:47a3 with SMTP id a640c23a62f3a-aac3379034dmr5727225766b.60.1736259800081;
        Tue, 07 Jan 2025 06:23:20 -0800 (PST)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d806fede4csm25126108a12.63.2025.01.07.06.23.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 06:23:19 -0800 (PST)
Message-ID: <b7705a4e-5559-4fe3-a302-4c60d7224e49@gmail.com>
Date: Tue, 7 Jan 2025 15:23:18 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC net-next] net: phylink: always config mac for
 (delayed) phy
To: Andrew Lunn <andrew@lunn.ch>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
 Heiner Kallweit <hkallweit1@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
References: <20250107123615.161095-1-ericwouds@gmail.com>
 <Z30iUj6DE9-fRp0n@shell.armlinux.org.uk>
 <4b9b2a9a-061b-43ad-b402-a49aee317f41@gmail.com>
 <ed29e632-332b-4af1-bf7f-97498297e731@lunn.ch>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <ed29e632-332b-4af1-bf7f-97498297e731@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/7/25 2:20 PM, Andrew Lunn wrote:
>> I think it is because pl->act_link_an_mode stays at MLO_AN_INBAND, but
>> it needs to be set to MLO_AN_PHY, so that only the phy determines the
>> link state:
>>
>> phylink_resolve() {
>>     ...
>> 	} else if (pl->act_link_an_mode == MLO_AN_PHY) {
>> 		link_state = pl->phy_state;
>>     ...
>> }
> 
> phylink tries to determine the whole chain is up. As Russell says, it
> could be the PCS has not got sync with the PHY for some reason. So
> even if you ignore the PCS state, it might not work. This is actually
> a useful pieces of information. Does the link actually work end to end
> if you only look at the media state? If it does, that would indicate
> the PCS is maybe missing an interrupt, or needs polling for change in
> state.
> 
> 	Andrew

After phylink_mac_initial_config() is re-triggered with the phy
attached, either by the patch, or even with:

ethtool -s eth1 advertise 0x28
(switches to sgmii)
ethtool -s eth1 advertise 0x800000000028
(switches mac back to 2500base-x)

mode is set to MLO_AN_PHY in phylink_pcs_neg_mode() and the link works
end to end.

So the an-mode can be 2 different values, one after link up and another
after these ethtool commands.

