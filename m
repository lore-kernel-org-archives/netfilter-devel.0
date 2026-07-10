Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3443630BF
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jul 2026 15:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783696610; cv=none; b=VgBhPoW08M4QVTQIZauT+ZQaqKCF4PWeTZ5jB1ZMmUDVxIwFnq7DiefCo0sNMYSYEtk4qmCrNx9CZWEAOZbK+C9+iyZtWes902SDezVMzzI6NXA+0egOP7Ync+GI2eUJJL9xrHqI9bKfu47LGAf6gScYPn/36wUYHIenKRs+MVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783696610; c=relaxed/simple;
	bh=1JtLlpRRACfvKsroXlBPtY0Dc9Plol0JKs7d++0dOtM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=P48TfFkpKm3+DjTyWvT0g/L3c4T3wWVns3kcY0VWz/XzTQVUCPd4pHiBRqvlpSl8OwKjE32DuR5l1kJQtIEKBB5x9WPwoInNQ0awSp6rPGJeQG5dNcviPA+zODkSZUZ+jQ6Qh2TC1zjNWhiV4epB/4AFUGbIo+nYCUL7m0ARhpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OafPM210; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OafPM210"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c15f6d667bcso137783166b.2
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jul 2026 08:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783696607; x=1784301407; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pzG2aZr0GYhbw005TMkhGo2BjpwTfepBU/AvlO3Dhu0=;
        b=OafPM210nDaTDDA0Jg3x2Z8y87YzQc3bg8n/ui5vv5NunACoDuAUzdf6Yvu6oao8SF
         VNddYkFKarHiSMzNaCKTArgnXBeJfXOfTnz2/qcbV9BCRMMToNVw5y4f6mszoLZo2BkC
         F4mZIXAKijH/M226GGDS92ln3iQN5OVmAsWS0yy9KrKSM25lXDQIa5v8aDNRVdBa5JVj
         M9pxdyF7sgtfjYYA6VdP+iu9ssd4m9+NM+9ekd09xVpUh2lcZ6/Kmq1b2UoVK/FHWlxA
         +OdMAlcia2875nCE7howYpYa/CAIc4kmZTlPJkbag4RCp4lDYh506M0m/+KUXfzDX/cj
         OvSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783696607; x=1784301407;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pzG2aZr0GYhbw005TMkhGo2BjpwTfepBU/AvlO3Dhu0=;
        b=WEqsfVjv4zbmbUWqfsmUWq2fMlRuHBbEfeNvnEJHAixM3cxwdMcHZPPmOC8hI5ZKss
         m1dkdHV2kM4Lo2YwvyGLRvEDAQ74DB1Pdlwe+cmE9mOy7DXyYq9qZjBIuHP/OSL0tXu1
         eHBvl3IbGQ3/bsv5AUu2TTl8kpCtBdkEjMvtFJzOVgk2UY8xuK9n2hwQqS1eGDaxf7Av
         v5LKuu0x35buaUxuHdEVEjsyArIoMQ5Mua+IsyvUl6oWl7vpibB16mmo432BpU2anhb5
         bDVFp+rZIY/Ki0b9yUdUMHkEJgGwy8GkSH/euh/CKas971bDYAEdrHWsvfW6gxENyv3G
         ujOA==
X-Forwarded-Encrypted: i=1; AHgh+RrrxsTMT9X5iY+UX0dNmmdRijDfrWIeLRlWmzE7vNhh1vZ0dijqZLir1rE6BiFdTb8oktns1u6Z3UoVRO5BAnY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrwLlC7LdLm8QHeGem2s5rUv23FnLxFApz8GzFTVKIolQ3SUKm
	9GbUCyCA9dGdG6NGKmMXKwYq7d8DyKFofVMm77lOjCfI2XDCOKHh+u6b
X-Gm-Gg: AfdE7clH2XvLOQnyb9DFh6Mh6f5pvsY/eELONxkAlj/HfjkpToQYJAUkqm1CAbyK4dE
	sgeTrqS+J/0NVkxPfR2lPr0mDMVmPyKefpzcqJicfpd3LSjD10b3iigzLKAhnEN3Ugfdxn6X3D/
	kJtUnHdZLsFanJgbbOasua5Lc1URSIQfC4aBgqyn1mABPA9GIdbg7K+w+HDf5cmO6s4v5tBvaeA
	/Zv5Vj2GsQKWK9ZT0ImwiTQBWsl3V+cnXLTIx6W4qHCjJbp6bMw2zM+MrWYtE1ccBoIsLnSKDIT
	oZQljPbsdATb5KZH8BnNykewlC05exD/UFXN7PPv8RR96LQTcQP7OupIoXHWUd7Ep4q3GrmTiSU
	Og4hAI4xcnyE6GOJ4C46Ra5r6clwp59SuGpv+91vYevg3At+eUjG/IRYFv+X1eWutkDI/TIngcO
	MzKnRYlQkH3x3Xo68UPTYsL+02yw4WuMI5d31t+LQYo3fPusib19VfZvsNWth6XTxVMb90qOggp
	fLzMKGnhCbIgvt47tfrC/9raI8F84pPBY7OG/GKGV32KZhAcIFz+hV8dRdv8sCuYoz7Q9KNKW90
	e0u3TpNG58jPBRkGKobVA9M=
X-Received: by 2002:a17:906:4fcf:b0:c15:b96f:c3d1 with SMTP id a640c23a62f3a-c15ce06ed7emr537056666b.41.1783696606976;
        Fri, 10 Jul 2026 08:16:46 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15f272141dsm204948866b.59.2026.07.10.08.16.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2026 08:16:46 -0700 (PDT)
Message-ID: <12451f0d-7e5b-4697-a734-8200944b204f@gmail.com>
Date: Fri, 10 Jul 2026 17:16:44 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Eric Woudstra <ericwouds@gmail.com>
Subject: Re: [PATCH v12 nf-next 3/7] netfilter: nf_flow_table_offload: Add
 nf_flow_rule_bridge()
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, Nikolay Aleksandrov <razor@blackwall.org>,
 Ido Schimmel <idosch@nvidia.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 Stanislav Fomichev <sdf.kernel@gmail.com>,
 Samiullah Khawaja <skhawaja@google.com>, Hangbin Liu <liuhangbin@gmail.com>,
 Krishna Kumar <krikku@gmail.com>, Martin Karsten <mkarsten@uwaterloo.ca>,
 netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 bridge@lists.linux.dev
References: <20260707091045.967678-1-ericwouds@gmail.com>
 <20260707091045.967678-4-ericwouds@gmail.com> <ak4dAXHDmTDRr7-b@chamomile>
 <81c3bf65-b19b-4f80-aa8e-c0c4b3f5d6a7@gmail.com> <alC64Vg_xihR-huW@chamomile>
Content-Language: en-US
In-Reply-To: <alC64Vg_xihR-huW@chamomile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/10/26 11:26 AM, Pablo Neira Ayuso wrote:
> Hi Eric,
> 
> On Wed, Jul 08, 2026 at 08:36:11PM +0200, Eric Woudstra wrote:
>> On 7/8/26 11:48 AM, Pablo Neira Ayuso wrote:
>>> On Tue, Jul 07, 2026 at 11:10:41AM +0200, Eric Woudstra wrote:
>>>> Add nf_flow_rule_bridge().
>>>>
>>>> It only calls the common rule and adds the redirect.
>>>
>>> I decided to use the new _unsupp() function, so we don't pretend
>>> bridge hw offload is already supported. We will need a driver before
>>> we can add this, this stub does not provide much. I guess your goal
>>> was just to avoid a crash here.
>>
>> No, I am already using hw_offload between bridged interfaces
>> on the mt7986 succesfully for almost 2 years.
>> It works dsa-port to direct interface (lan1 to eth1 on Bananapi R3) and
>> between direct interfaces (eth0 to eth1 on Bananapi-R3-mini)
> 
> Do you utilize the existing mt7986 driver in-tree without changes to
> achive this hardware offload? Or you have still have out-of-tree
> patches that need to be merged to achive this?
> 

I do not change anything about the mediatek drivers to achieve hardware
offload. No patch needed to fix hardware offload.

However I do have a small fix for the offloading towards the mediatek
wifi interface. This is a fix for the software fastpath already.
Also with hardware offload to wifi interface, once the software fastpath
is setup correctly (needs this patch), then the hardware offload functions
correctly without any further patch. See patch:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260317101525.358016-1-ericwouds@gmail.com/

It is not reviewed yet.

>> It can also be tested with my bridge_fastpath.sh selftest script.
>> This script uses veth-device pairs to test the software fastpath.
>> It can also use 2 real interfaces interconnected in a loop of copper,
>> when chosen with commandline arguments. Then it tests software- and
>> hardware-fastpath. It also tests many different scenarios.
>>
>> So this is why I've added it, as it is already functional. If a software
>> fastpath is setup correctly, the hardware fastpath is also functional.
> 
> Thanks for explaining.
> 
> I am targetting at a minimal subset of the flowtable bridge support at
> this stage. There is a need to make progress with the
> nf_conntrack_bridge counterpart before the flowtable bridge can get
> more features (namely, bridge vlan filtering support).

I did send a newer version of my patch-set for nf_conntrack_bridge,
last version also adding support to defrag/refrag. See:

https://patchwork.ozlabs.org/project/netfilter-devel/cover/20260512103347.102746-1-ericwouds@gmail.com/

I've added testcases for defrag/refrag to the bridge_fastpath.sh selftest
script (v5), so I know it is functional.

For proper vlan filtering support, I do also believe you will need to
introduce DEV_PATH_BR_VLAN_KEEP_HW, or do something similar. See:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260317101722.358640-1-ericwouds@gmail.com/

