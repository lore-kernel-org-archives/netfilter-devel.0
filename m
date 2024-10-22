Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE6914A4F0;
	Tue, 22 Oct 2024 07:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729581944; cv=none; b=Jk6KtcYnOiVGd1dio/QeYjZYsCc6ZXIV4EVjI7PwGA6dgnEY1Kyhb4eqb9MG1Ajp79HhkM4FYyzIPU0If2noR/p3vW1X7czuu/hWIjKT80fXvOGVS7zK5Ujv4ECEruqfj3eoyz7/G01vIeD5Q+zRr/rDxlPH2Zl59uFwy4UL4C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729581944; c=relaxed/simple;
	bh=RPBvFd0csLQUXJSE14s/so+mpDpWxuoXRgoonDdlEEs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i4gTd4QZFwuzzE41us3pkfs5pf8UhP0LQgE7kaVaqPviDxuwinO5lPVT4OlaKGErZS+tKI+7QSwts5Su6d3WVfIOGFecn8Mm9cHEnqqFaOYvqu0FxeQmEYCH4dTG9pfX8NZXDHDzT6l1G0moLJGV/GHg2HJiaA0NylTW3qHhW/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DqBLPZtM; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DqBLPZtM"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a9932aa108cso784929966b.2;
        Tue, 22 Oct 2024 00:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729581941; x=1730186741; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RPBvFd0csLQUXJSE14s/so+mpDpWxuoXRgoonDdlEEs=;
        b=DqBLPZtMJSnCdh5DdJxF9VP2/VvWUARqX5G8V5K90RqMBI7B4iVZ9Z2CAwOxxj6ZUi
         MQG9J3VNRxaAgTHgLdswumJ4RAr2oPPbutlOFThK65blf9o9MszQEVlQe6QUKWcqscK/
         jOfcC0p4QWmRnm2bLN1I/0z+S5Jf5RoE9pOdY+KMCaYnbmtqdtEhMxvPUzML/+vdT/hG
         h7ML/9GwmcNlowoC4Vk7UNoKJJdhy573YfP/df1sG+PtObdLOcpZW4+EJpKSm+4WnSNs
         vvk7Dr7a4yI5KFfsEoHftvw1LfejRVKs0c5gp9fD+r/WHPR/2Zvy4juP/FAHCsW/Pmyg
         4BYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729581941; x=1730186741;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RPBvFd0csLQUXJSE14s/so+mpDpWxuoXRgoonDdlEEs=;
        b=ne4N3brIx0a0AUr2VYEsiZlvHUwet+HmfaMoQ7K95mpHm49BDrUxN0dg8WMkTylSyF
         Qq2adEPotz7AVF92Re2D3S7YdHh6YdwBAloLmoNcfrixuiSXNcCGvfVKC3zkUk52bBce
         DExpru1yLZ1s5xw0YGPzBY6Qvhu/kl6Yg54GjoR5JMMA+0vn6lfA3sbdXOT3vcrszvh3
         6T7dlKFOH0ETvtoLl1vWbPu/hRp0QSGAtgVj2m5PoXU6CzHpeM7N/vGjluq6m2oun6MP
         JwOuSutb2QR0iOnLKj7esbTpFvMbRpd0uRlz9wvnH0TA04RrCqnXhq+FbRJrDB5iHT45
         GCRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlk6rD1taEVzUSVXHDE2yZ3p870p5rAOWgsmYjsMkwncrlzC8Zw8MRDhUN+NJYcgNcbKNWvxv0w8mw+GDTpY/x@vger.kernel.org, AJvYcCX++1rUgVBQCn0XkNUVvvk+/8lzrK82HQAaAVj/uYUDlr6luV9zPVaYZvOH+QzF5StReh4srma8L+RuZlg=@vger.kernel.org, AJvYcCXpiPVvVKvTSd1RHrY5k3r+zpDXlvota8Hky+RiWY0BubKTEHv1j7LJpZEYAu1++MrEu2JUhe1M@vger.kernel.org
X-Gm-Message-State: AOJu0YxR2UfkLBwZvORopkbC8A2IwQYL5xsXBHgIUx5GBY7ypAVxg3JC
	mx1HraepgtYaXBLWuZ0mGICQ04nHKWV1+ZCTPUP3S8Y549mkzFjr
X-Google-Smtp-Source: AGHT+IFgOViCVHZGVqc02ueX63hUlO23JFELymqv7xnRaAD5bkA+z0a7m5o4etcnJkf9oA9PvbTbqg==
X-Received: by 2002:a17:906:730d:b0:a99:e850:deb3 with SMTP id a640c23a62f3a-a9aace512d4mr147614666b.18.1729581940590;
        Tue, 22 Oct 2024 00:25:40 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a91572575sm299075866b.156.2024.10.22.00.25.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 00:25:40 -0700 (PDT)
Message-ID: <540a623c-3e7c-40a7-ae77-6833e81fa11e@gmail.com>
Date: Tue, 22 Oct 2024 09:25:38 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 net-next 11/12] bridge:
 br_vlan_fill_forward_path_mode no _UNTAG_HW for dsa
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Nikolay Aleksandrov <razor@blackwall.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Roopa Prabhu <roopa@nvidia.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Jiri Pirko <jiri@resnulli.us>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Lorenzo Bianconi <lorenzo@kernel.org>,
 Frank Wunderlich <frank-w@public-files.de>,
 Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>
References: <20241013185509.4430-1-ericwouds@gmail.com>
 <20241013185509.4430-12-ericwouds@gmail.com>
 <281cce27-c832-41c8-87d0-fbac05b8e802@blackwall.org>
 <6209405e-7100-43f9-b415-3be8fbcc6352@blackwall.org>
 <20241014144613.mkc62dvfzp3vr7rj@skbuf>
 <b919a6b1-1c07-4fc9-b3dc-a7ac2f3645bf@gmail.com>
 <785f6b7a-1de1-46fe-aa6f-9b20feee5973@gmail.com>
 <20241021134726.dzfz5uu2peyin3kk@skbuf>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <20241021134726.dzfz5uu2peyin3kk@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/21/24 3:47 PM, Vladimir Oltean wrote:
> On Sun, Oct 20, 2024 at 11:23:18AM +0200, Eric Woudstra wrote:
>> So after doing some more reading, at creation of the code using
>> BR_VLFLAG_ADDED_BY_SWITCHDEV would have been without problems.
>>
>> After the switchdev was altered so that objects from foreign devices can
>> be added, it is problematic in br_vlan_fill_forward_path_mode(). I have
>> tested and indeed any foreign device does have this problem.
>>
>> So we need a way to distinguish in br_vlan_fill_forward_path_mode()
>> whether or not we are dealing with a (dsa) foreign device on the switchdev.
>>
>> I have come up with something, but this is most likely to crude to be
>> accepted, but for the sake of 'rfc' discussing it may lead to a proper
>> solution. So what does work is the following patch, so that
>> netif_has_dsa_foreign_vlan() can be used inside
>> br_vlan_fill_forward_path_mode().
>>
>> Any suggestions on how this could be implemented properly would be
>> greatly appreciated.


> I don't know nearly enough about the netfilter flowtable to even
> understand exactly the problem you're describing and are trying to solve.
> I've started to read up on things, but plenty of concepts are new and

Another way of shortly describing it, considering the software fastpath,
only there it is a problem:

Same case #1:
When looking at the ingress hook of the fastpath for a bridged
switchdev-port (non-dsa) with PVID set, the existing code is written so
that the flowtuple needs to match the packet INcluding the PVID.

Same case #2:
When considering the ingress hook of the fastpath of a bridged device
that is not part of a switchdev at all and there is no dsa on the bridge
(so it is not a foreign device), the existing code is written so that
the flowtuple needs to match the packet EXcluding the PVID.

When looking at the diagram of this patch, wlan1 would stand for any
foreign device. Because of the use of BR_VLFLAG_ADDED_BY_SWITCHDEV, case
#1 is applied, instead of case #2.

> I'm mixing this with plenty of other activities. If you could share some
> commands to build a test setup so I could form my own independent
> opinion of what is going on, it would be great as it would speed up that
> process.

I've only setup the bridged part with systemd-networkd. When trying to
re-create, it will only happen if the total action of the bridge,
towards the foreign port, is:

ingress + egress = untagging

So in the forward-fastpath, tagging in the forward path is done by a
vlan-device and untagging is done in the forward path of the bridge.

> With respect to the patch you've posted, it doesn't look exactly great.

Agreed. I was experimenting now with having br_switchdev_port_vlan_add()
first to try it only for non-foreign ports. If not successful, then try
it with foreign ports. This way the calling function will know if the
port is a foreign port. Therefore, no need for the switchdev driver to
communicate back to upper layers.

> One would need to make a thorough analysis of the bridge's use of
> BR_VLFLAG_ADDED_BY_SWITCHDEV, of whether it still makes sense in today's
> world where br_switchdev_vlan_replay() is a thing (a VLAN that used to
> not be "added by switchdev" can become "added by switchdev" after a
> replay, but this flag will remain incorrectly unset), of whether VLANs on
> foreign DSA interfaces should even have this flag set, and on whether
> your flowtable forwarding path patches are conceptually using it correctly.
> There's a lot to think about, and if somebody doesn't have the big picture,
> I'm worried that a wrong decision will be taken.

The entire usage BR_VLFLAG_ADDED_BY_SWITCHDEV does need a careful review.

I also realize my patch-set needs to do more with the switchdev and vlan
combination, then it does now. So for now I will leave it as RFC, as it
will not work properly with switchdevs other the dsa.
