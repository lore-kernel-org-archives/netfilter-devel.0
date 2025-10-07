Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2101FAC4B
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Oct 2025 09:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759830558; cv=none; b=TEM933WgroM+FwnLVqRNzgwoDcYCRzh8stF15cMVV5nNZBFjsEAaoSdK8BFe4hPNjnelZKofvWCN3h3npjNEU8ylE0e85LgZe/dUJPS68CB7Cz8VWAW3ASvUujM/jqBwTTJAii5PcjL+FGEmk2gpiKXxOiJhINAvaD0A4yNEttY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759830558; c=relaxed/simple;
	bh=ANui7nSl/Xkn2ryxgPBWTRhh5bFK2D731iJyqedJeoI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AOtcbb3QyCMNfutQMhieuvYZwscYENqfa68YJvJqYQim8f0TOEnMdJI0UmQniHFC518JzYE95hAh/1tadqOGcq17KJ2sAAZ0IohWwO0bY4gSAgEyldtRQYla9y9V+mG/dTcvt9xzuioVDl0m1ZyaX9KSJZ5mxC03ZrWJthrF7+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kk0mX2po; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kk0mX2po"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b3c2c748bc8so878859966b.2
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Oct 2025 02:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759830555; x=1760435355; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0ueLJVSJGp+dH7ceTx92kybEsYvh5wShqzWyQZKOf6c=;
        b=Kk0mX2poGQA2CWwjSFblfgjNFKZBEagFMVfqQLdG0MdzCAszip7pWWdYxUR5DgxtFT
         JBG6g/vSM6XKV8WCQhD06GaLdYmODIIW/lbzhkPwuTMVFaMNUB1rsRySjga9FThcPXZ3
         xLwKXo3GectAcbOEtSGBoPwjlZFGGIz3gIkPYiaw1/Gsdra4Ld2pllhPSNWeDjSPUPE/
         l5fdNCXTCt3wYVfZ0vweXq+e1fGEzuB0GVGk800OypkBo5+DO1inBFXVMjElVGqEyJy9
         ZAUdFMc/s8haZOHH0Z5LnHs39sKOjvGub5u2qf0TGXBVJN1lWb3sZbquU2UyfsjS5I+G
         AzWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759830555; x=1760435355;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0ueLJVSJGp+dH7ceTx92kybEsYvh5wShqzWyQZKOf6c=;
        b=hBfTlPgsPAbkiJQmy7jc3X0ztmou3YNMgIJVvvtvhn8/9PZ7d/cqidQu4VcUvEgG5i
         J7dgvslV9jpgJFilePylj0K8p0FmBQk9W5KpBiljZh81sdwopJ/YBDaHwjB+5htQbUU3
         zp42znxGHPtwoearDIgenE4DJa/yfdqDjeIp+SqVnW3e2HYlcaLmXWHK8/Q2hWVyUoyy
         wBO69kgbc2pVm/K1hijxzH4XDZMlaF3T0NyrlEayEa8xjKqw7hRjSKdbBpXBgCUg14Pz
         ONLDmpJBQfQYI6M3Mn/FC1r2slvsikB9jG2nV5hP5PIc9+r9mggCuKTWdPAr5qtV3Sre
         N6Lg==
X-Forwarded-Encrypted: i=1; AJvYcCVmkKpX/PcEGut+tPBL6qmjcJyYPTfG2kr50Vy0i80A2gxEujwTPEtKs7xD26ovcvz6EEuiSlNw4vrg6ayXUyw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxPzQTk4Hqhi0rWNTFDcKMn1HNdaWWBUvsZdF0BXMBnjAENHGL
	KeBrrQG6BLzyiYlPlrPihXVNNnuzmkZkFC2S4i46fwHOACDTbpn46S5f
X-Gm-Gg: ASbGncu86vFFJVfDkdWvYxjJ6HeTPp1HK3BLLSA2ROqer5rvpgice6rJioCVx1Tx26y
	OmPMG/oZBYAc0pVss1XcaaGAPrdm9iP05J3F+wkVG70dAInoiFc06rkfs8QQNjPy0eeZE7msqKP
	NtRg39dUeVrwpRpViM+xcWmq0Ty49FYysFus6VcDV9s6CSl76yDpSiLeQVz3oAAUfgCFh7aOqkB
	VvOiiVy+glq9sbpPlPNUwfB57kU47d2I+sFZBHc82OvuowFXQYqaS+NeQzDp27YYlKROYK89OzA
	+Epex34qyhjUiWR7ofCiLBi+4VLynbo+sXKce9gCX4ggP6VeE1PzezTKsl1DJ4zJ3zzEn8Ua4+4
	M0wcciYPsenwHP7ccIqaMrHHykqdpsReDQaB46ToUu3Ogv2TM3lNARYXTOKK3/OwgUFAWNAwdFi
	dk6kaod6dP/qs0ArSJ4R8vkMEa5hRgLthJqVXMSTANVIAosFwxUPAWQ1vsGdsHms+B21dGBLGwf
	zGeUXHtGruF0JvpIvYyIIGg
X-Google-Smtp-Source: AGHT+IHdNBmo5UGL2aStNRTSljzwJlK0kWlaY3a8GMcFcknx+xKS+ZYnKBtQkBIZn2wOkHQpRft7Cg==
X-Received: by 2002:a17:907:d78a:b0:b3e:babd:f257 with SMTP id a640c23a62f3a-b49c1d60ce8mr2043921466b.10.1759830554682;
        Tue, 07 Oct 2025 02:49:14 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b486a177c9csm1357244066b.89.2025.10.07.02.49.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 02:49:14 -0700 (PDT)
Message-ID: <5b332473-b552-489c-acd6-d0b67a1df098@gmail.com>
Date: Tue, 7 Oct 2025 11:49:13 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 nf-next 2/2] netfilter: nf_flow_table_core: teardown
 direct xmit when destination changed
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Nikolay Aleksandrov <razor@blackwall.org>,
 netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <20250925182623.114045-1-ericwouds@gmail.com>
 <20250925182623.114045-3-ericwouds@gmail.com> <aN4v1DB2S-AWTXAR@strlen.de>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <aN4v1DB2S-AWTXAR@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/2/25 9:55 AM, Florian Westphal wrote:
> Eric Woudstra <ericwouds@gmail.com> wrote:
>> +static void nf_flow_table_do_cleanup_addr(struct nf_flowtable *flow_table,
>> +					  struct flow_offload *flow, void *data)
>> +{
>> +	struct flow_cleanup_data *cud = data;
>> +
>> +	if ((flow->tuplehash[0].tuple.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT &&
>> +	     flow->tuplehash[0].tuple.out.ifidx == cud->ifindex &&
>> +	     flow->tuplehash[0].tuple.out.bridge_vid == cud->vid &&
>> +	     ether_addr_equal(flow->tuplehash[0].tuple.out.h_dest, cud->addr)) ||
>> +	    (flow->tuplehash[1].tuple.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT &&
>> +	     flow->tuplehash[1].tuple.out.ifidx == cud->ifindex &&
>> +	     flow->tuplehash[1].tuple.out.bridge_vid == cud->vid &&
>> +	     ether_addr_equal(flow->tuplehash[1].tuple.out.h_dest, cud->addr))) {
> 
> I think it would be better to have a helper for this, so
> it boils down to:
> if (__nf_flow_table_do_cleanup_addr(flow->tuplehash[0]) ||
>     __nf_flow_table_do_cleanup_addr(flow->tuplehash[1]))
> 
> (thats assuming we can go forward with the full walk.)
> 
>> +static int nf_flow_table_switchdev_event(struct notifier_block *unused,
>> +					 unsigned long event, void *ptr)
>> +{
>> +	struct flow_switchdev_event_work *switchdev_work;
>> +	struct switchdev_notifier_fdb_info *fdb_info;
>> +
>> +	if (event != SWITCHDEV_FDB_DEL_TO_DEVICE)
>> +		return NOTIFY_DONE;
>> +
>> +	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
>> +	if (WARN_ON(!switchdev_work))
>> +		return NOTIFY_BAD;
> 
> No WARN_ON here.  GFP_ATOMIC can fail, which then gives a splat.
> But there is nothing that could be done about it for either reporter
> or developer.
> 
> So, how much of a problem is this?
> If its fine to ignore the notification, then remove the WARN_ON.
> If its not ok, then you have to explore alternatives that do not depend
> on successful allocation.
> 
> Can the invalided output port be detected from packet path similar to
> how stale dsts get handled?

The flow needs to be torn down, when a wifi-client moves to another
bridge-port. Both old and new bridge-ports themselves are unchanged.
And in case of the flow being hardware offloaded, the flow also needs to
be torn down.

