Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E167F19F47E;
	Fri,  7 Feb 2025 20:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738958674; cv=none; b=nVjzz+jiq97lpVpdD8KdSQjRmnPkaR+cK+Z6qreLGnexoxcz3Qfen6dVry2Sak/3YcMvHCp37/HIBQzJl5iOicotCnn/uaBY44A0+gqfm7+udTDyt02/hnqf8+teelMxe5BkD0jPxVjOYFp5BbuXXa97fbcFkOET6lB0vSddXSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738958674; c=relaxed/simple;
	bh=c0HE3fhR5sqsIIunJnpVU2sofmoEc9yrKyaRzinguC8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=grBGPYP5L4ptu6S1luAtH6TR72Oh1g/nWRocd4i+nSq1D+ka96efmbnGgJvhQ39YmdE0V/TlepLySzFztaGpJPmQGS6uw4XsX+eSXKAVSL5Bfr+0JxIbnJAdkncTDBMdk6AOXsY9ORxk6mCvChcTwTIq2WUylU7IEb6EOjXek8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SAXBQJiy; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SAXBQJiy"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5de4c7720bcso1505588a12.0;
        Fri, 07 Feb 2025 12:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738958671; x=1739563471; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G2tTSDZ2XD8g2DNn6kyimdWtnPTRpKW0MbS5kEtAlX8=;
        b=SAXBQJiymYy9Sbzdk6toeL64YqaicGu6DZtSrw4ip2ukGMFdd7no7pBXA2iZ0UzDlS
         WCkMpk0A9Rxb0DSgly46vFJY0qXX/xWW0T5mjlr7BiyxlKT/14uYYRdj5KlQuLdFivD/
         4OsKK33/NZMDHbXZSAUS/aV8Z1prc/+5PjpgSl5+V2WmbJ1k5tmH2VhdhfvcnfyoF35b
         xRuCJZSuQQ++UGC5JVMECbX4vA1rLzUq2nL0fVWFRVNTPl1jFJEeu2yRgSiPS2h4g5j+
         O9WsJN0V3NHr2iwkHkO6Fmmwvvj0qSAwQxxjoLi58dVAnjX4DEvpqfcaUgNY1MPBu0D8
         8aKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738958671; x=1739563471;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G2tTSDZ2XD8g2DNn6kyimdWtnPTRpKW0MbS5kEtAlX8=;
        b=mpYd+7Tu7uT9DJnqLMT5kZekW6fWirdOMguttaxJBN+MzCyIwwP3gBNd9gfIG95aY7
         wBGGdHwmvKoduPLV6yRGcE2MpMttpsGLwcCn2bW9affcaoTQUHKkYNLQQhQIHUW5nN87
         yqiP/RfAznrRmjWq+9OhSZfz1Tb1v1ga25GOV5QgzY+UDX6elSHsaLcYaWEHnmTYg/yx
         BeTeZWLA+66ZMJDIyInA9++MpI8gudEFlG1//K6zK7lt9WVubLSuTPaseNpHBicJCx74
         UOLfM14/VCWJ2+lALVIgLg6lRbWHqDs68+OYrGWLl2NzhmMaNvgAxEpLuY4xM5u8qUVF
         z5ng==
X-Forwarded-Encrypted: i=1; AJvYcCU2iY+8/UWpoOWwF621dla/l0I8odqlmX4gL5VgG8/r5GMzQBl3b4FihurC+1YZZTQkhoOLphHuvlzxsM/VUw1M@vger.kernel.org, AJvYcCWnMamlCoNS4Yt4skDYM8nQdnbOb6Bbr7a/1av/Us3zxN4oGFlD0jPjoLEkwagztGomExDVBmpMva8fzBI=@vger.kernel.org, AJvYcCXN0JoZQLSnWb6TnbVq4istIVzBIu1BsiBKO1UC9lzD8zK4CeX0zVrzD2bw9ARA/gkyJRC1YXtx@vger.kernel.org
X-Gm-Message-State: AOJu0YyTiRwDlWBcLECEMFyEriVoM/FjqN7ryyRLjw8UCJLoIO8oMc8K
	OOMF4ejNdRrbFzUgkHqzaRsyQ9RH6IIfvxIkY5TNWa+hDrtXX226
X-Gm-Gg: ASbGnctT2jsEHFYh7wqRk8wylplwNMhTFrKFbfGkyHmcKQ1Ak1vnliP7ACREPFxZUnG
	zuLHXmV0N0e9YviO8Z1qMX4hxojoPRIq8C1sd97e3HSh5GlIDdKZAJ0PbkAu65VBFLu+cXSbb7B
	xghqyoWbYenFF/iEpi6d11ExhPVzayjBL3Svysip2gYWcB7tEwQ70sfBMj3ihIAnj/+qaFBguCV
	V+7aAgnbAUlZafhxbxPhut8Ow+8eUIQhDIpuH/NXKgnO2SiF3j83d3PRWiUbOkL2Qvx7VqoDJPN
	iwvaAnT22MF5V4yz9ifGNuk6hXPTH6GUnPzgHFstU3B1Z8qH+nbeehWxraHnWW0Q/77idgSRMVh
	fhdF4ulERK6B7TcY6dtWYVCSRnFhlc7wMlK+/4zxU3EDSDR83lF9/J6gI8xtpIme+ZA==
X-Google-Smtp-Source: AGHT+IFwhFFxWKhiLiV5wk2B71s8k88eNWyrwlatwlmZhNRtZGKXQn0gb2lgnlR7Mo2Je7BPaqOlyA==
X-Received: by 2002:a05:6402:2383:b0:5dc:7fbe:7313 with SMTP id 4fb4d7f45d1cf-5de44feb7bfmr6015830a12.6.1738958670962;
        Fri, 07 Feb 2025 12:04:30 -0800 (PST)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5de39feff59sm2298672a12.77.2025.02.07.12.04.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 12:04:30 -0800 (PST)
Message-ID: <78a30eab-cae6-4026-b701-7d7002fe3abb@gmail.com>
Date: Fri, 7 Feb 2025 21:04:28 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 net-next 12/14] bridge: No DEV_PATH_BR_VLAN_UNTAG_HW
 for dsa foreign
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Jiri Pirko <jiri@resnulli.us>,
 Ivan Vecera <ivecera@redhat.com>, Roopa Prabhu <roopa@nvidia.com>,
 Nikolay Aleksandrov <razor@blackwall.org>,
 Matthias Brugger <matthias.bgg@gmail.com>,
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
References: <20250204194921.46692-1-ericwouds@gmail.com>
 <20250204194921.46692-13-ericwouds@gmail.com>
 <20250207150340.sxhsva7qz7bb7qjd@skbuf>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <20250207150340.sxhsva7qz7bb7qjd@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/7/25 4:03 PM, Vladimir Oltean wrote:
> On Tue, Feb 04, 2025 at 08:49:19PM +0100, Eric Woudstra wrote:
>> In network setup as below:
>>
>>              fastpath bypass
>>  .----------------------------------------.
>> /                                          \
>> |                        IP - forwarding    |
>> |                       /                \  v
>> |                      /                  wan ...
>> |                     /
>> |                     |
>> |                     |
>> |                   brlan.1
>> |                     |
>> |    +-------------------------------+
>> |    |           vlan 1              |
>> |    |                               |
>> |    |     brlan (vlan-filtering)    |
>> |    |               +---------------+
>> |    |               |  DSA-SWITCH   |
>> |    |    vlan 1     |               |
>> |    |      to       |               |
>> |    |   untagged    1     vlan 1    |
>> |    +---------------+---------------+
>> .         /                   \
>>  ----->wlan1                 lan0
>>        .                       .
>>        .                       ^
>>        ^                     vlan 1 tagged packets
>>      untagged packets
>>
>> br_vlan_fill_forward_path_mode() sets DEV_PATH_BR_VLAN_UNTAG_HW when
>> filling in from brlan.1 towards wlan1. But it should be set to
>> DEV_PATH_BR_VLAN_UNTAG in this case. Using BR_VLFLAG_ADDED_BY_SWITCHDEV
>> is not correct. The dsa switchdev adds it as a foreign port.
>>
>> The same problem for all foreignly added dsa vlans on the bridge.
>>
>> First add the vlan, trying only native devices.
>> If this fails, we know this may be a vlan from a foreign device.
>>
>> Use BR_VLFLAG_TAGGING_BY_SWITCHDEV to make sure DEV_PATH_BR_VLAN_UNTAG_HW
>> is set only when there if no foreign device involved.
>>
>> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
>> ---
> 
> Shouldn't mlxsw_sp_switchdev_vxlan_vlans_add() also respect the
> SWITCHDEV_F_NO_FOREIGN flag? My (maybe incorrect) understanding of
> bridging topologies with vxlan and mlxsw is that they are neighbor
> bridge ports, and mlxsw doesn't (seem to) call
> switchdev_bridge_port_offload() for the vxlan bridge port. This
> technically makes vxlan a foreign bridge port to mlxsw, so it should
> skip reacting on VLAN switchdev objects when that flag is set, just
> for uniform behavior across the board.
> 
> (your patch repeats the notifier without the SWITCHDEV_F_NO_FOREIGN
> flag anyway, so it only matters for flowtable offload).

Or should mlxsw_sp_switchdev_blocking_event() use
switchdev_handle_port_obj_add_foreign() to add the vxlan
foreign port?

Then all foreign ports are added in a uniform manner and
SWITCHDEV_F_NO_FOREIGN is respected.

I do not have the hardware to test any changes in that code.
