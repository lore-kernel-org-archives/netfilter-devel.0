Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB41CA6B;
	Fri,  7 Feb 2025 15:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738940630; cv=none; b=sFl1RboYeYpMlGW7BpccFjKOOFtSN+QrbCsG2oZnuQzT9V7Mc2X1m4OPxGZ4M2xDzUHSFm20qtifK5n+kv7RknXBSboU4IkylyU3ndbOTvScfP1Dua7s4KwgH5YCeWBFVEvioHBNRs5IYRNi+1T8kGhUjA+Aanf5iK538UBElzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738940630; c=relaxed/simple;
	bh=Dv/Su0DUCWL65dbGc50TWvwNdQUcJSM82wl4CKW8Ybo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ena1/X332b3f28n+35Q669+8MYr9D/EqVb0F2tQRxGY9QzNzxo3BaUv5t06s5A86esVReq9JPIQKdYvI3T477eSEgZAmIty2xQIn95N7M3UD3xdIxbOMYEwiTdY5LUP8BH4PdY9n6bJXIumZyNU1n1CPxGRXD8R/n47BxosMnWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ccn3nv3r; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ccn3nv3r"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ab7908ecb31so9819466b.1;
        Fri, 07 Feb 2025 07:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738940627; x=1739545427; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oe749KfJTlBXfu5CFXqHM08pOCrnuopnGGzvAlfhP8M=;
        b=Ccn3nv3rAcWR47XaI+p0pinCGXZ98RMKlgZMQ1TmV9qcS6N82S3Wvzh9WfwVLy43yd
         7i85RQk0PEtFIxhxfPOs7WP6HwLlmQSPFAS3StUnSdAYA59QiekVA0sEZz9KjsYarKWz
         zviStzLO6Dtao64yrbu9eASmD5RNFTUT1R7juzAu1y83b7u8eo14clFBFhfD7R9WDPSt
         BK6qT3sd9HbT9CtRyPbXEeREOI7rdj4Np3ekD1Ou+SjURsOXjotHXfRjE4jKzBmjC1Ci
         K9PR/ppq0awLPVZ+xG+WatDcpH/QDp8WjLKWs7Vo1CgP0hdRAC1UB06baN7TiV03aSKC
         wdGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738940627; x=1739545427;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oe749KfJTlBXfu5CFXqHM08pOCrnuopnGGzvAlfhP8M=;
        b=hXAH2hGQK0kpUp0NlQF0VKvjJIVGZ/lwRuWt5eeO5QW+8J1NS5aKpx7PJeMk+QJIvb
         vD6FUdZ9axbFgmvyXznfcPI/9WxzlhTL+UznKoqKObKR/pV+bc4m/UX/RqZ0gbmvzf8H
         hTwmQKXN+dy0wPnL16ewgHByG8/1DWLjt3rsdiJ9l9Q7IUwwbshHxXwMNjDUE/VuJZ5i
         FenLqpouI3lKIgIDLJ/0F5MvLTCbJKN0yM9i5Y2tMp8i7WckmjtqlNz02y0eeZAXu5kz
         gYSJX8/F90Dm8sfsKA2zb2Kjgm3zBmNx/ulX+fBIu+d26SN73m9/LRNgdtYtTLmUfq0Z
         kpjA==
X-Forwarded-Encrypted: i=1; AJvYcCU8Iw+4y/lXg3KpVAcuS80TjRo9V1Q9n28Nmsj0eQwZanCSdcyl4Fs5+96BX0JE7Tr+Ej6TruquEd6HnWg=@vger.kernel.org, AJvYcCUW97b28TpU0/WPbH6H8NT7XEAo23T5bSl5UTuxOU7CjAPU7KAUt46SbitePWozbsyizidTMmacGOw0wPfiyTgw@vger.kernel.org, AJvYcCXwREiUfDarKYilRsQBuxNjVSgfoQTzquBLuxhki6W1a8OTTaHZJiKukSiN/OQOo087FxyXdrop@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5M6kKP7p/ctDr0Dx+nXHcgFCiBh7Gnvs8v5dV87n/6ta7J8bP
	1Uh68aKdufJykRkvR1GmRYRVelUcGS6tYfaGofwUiT2d9OQFdb8L
X-Gm-Gg: ASbGncuWVOewCyNTdsMHf3HC1qqmGP5MG7R56gpJeDZF3GLKx2O9ZHoty9HwJOvMYxk
	Fa7DYwy7oPRaliFTldwe74+odZaQ3LAfwqsJJQAtR8ZjaNuq0U10sI4tFcLL0G495FIceJPz+uA
	BEEpUghJ6LbCFvrSoUB95SJwX0/WsdXa8HuCHw9nAirAuqxJdFLtP3VpuFB/8gP5adJV6Q4H0OI
	ztTin2EoktatGJNU+7o84SJNFU+RRR1XxPqMOl4lgv2nNxWPXq0ZYMaWd2TaD5MI1Pgbf1HSfFe
	y+Q=
X-Google-Smtp-Source: AGHT+IHsKZDrEgjFzsjOHb6AegH/WyuF+q13HWJO6Xd2xBaxIXrpB2eiffrWM2ZlqpgeNqo0xDb4cA==
X-Received: by 2002:a17:907:360d:b0:ab6:ed8a:1593 with SMTP id a640c23a62f3a-ab789b6045amr110408366b.7.1738940625225;
        Fri, 07 Feb 2025 07:03:45 -0800 (PST)
Received: from skbuf ([86.127.124.81])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7732e6192sm278238266b.121.2025.02.07.07.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 07:03:44 -0800 (PST)
Date: Fri, 7 Feb 2025 17:03:40 +0200
From: Vladimir Oltean <olteanv@gmail.com>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>, Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Joe Damato <jdamato@fastly.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v5 net-next 12/14] bridge: No DEV_PATH_BR_VLAN_UNTAG_HW
 for dsa foreign
Message-ID: <20250207150340.sxhsva7qz7bb7qjd@skbuf>
References: <20250204194921.46692-1-ericwouds@gmail.com>
 <20250204194921.46692-13-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250204194921.46692-13-ericwouds@gmail.com>

On Tue, Feb 04, 2025 at 08:49:19PM +0100, Eric Woudstra wrote:
> In network setup as below:
> 
>              fastpath bypass
>  .----------------------------------------.
> /                                          \
> |                        IP - forwarding    |
> |                       /                \  v
> |                      /                  wan ...
> |                     /
> |                     |
> |                     |
> |                   brlan.1
> |                     |
> |    +-------------------------------+
> |    |           vlan 1              |
> |    |                               |
> |    |     brlan (vlan-filtering)    |
> |    |               +---------------+
> |    |               |  DSA-SWITCH   |
> |    |    vlan 1     |               |
> |    |      to       |               |
> |    |   untagged    1     vlan 1    |
> |    +---------------+---------------+
> .         /                   \
>  ----->wlan1                 lan0
>        .                       .
>        .                       ^
>        ^                     vlan 1 tagged packets
>      untagged packets
> 
> br_vlan_fill_forward_path_mode() sets DEV_PATH_BR_VLAN_UNTAG_HW when
> filling in from brlan.1 towards wlan1. But it should be set to
> DEV_PATH_BR_VLAN_UNTAG in this case. Using BR_VLFLAG_ADDED_BY_SWITCHDEV
> is not correct. The dsa switchdev adds it as a foreign port.
> 
> The same problem for all foreignly added dsa vlans on the bridge.
> 
> First add the vlan, trying only native devices.
> If this fails, we know this may be a vlan from a foreign device.
> 
> Use BR_VLFLAG_TAGGING_BY_SWITCHDEV to make sure DEV_PATH_BR_VLAN_UNTAG_HW
> is set only when there if no foreign device involved.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---

Shouldn't mlxsw_sp_switchdev_vxlan_vlans_add() also respect the
SWITCHDEV_F_NO_FOREIGN flag? My (maybe incorrect) understanding of
bridging topologies with vxlan and mlxsw is that they are neighbor
bridge ports, and mlxsw doesn't (seem to) call
switchdev_bridge_port_offload() for the vxlan bridge port. This
technically makes vxlan a foreign bridge port to mlxsw, so it should
skip reacting on VLAN switchdev objects when that flag is set, just
for uniform behavior across the board.

(your patch repeats the notifier without the SWITCHDEV_F_NO_FOREIGN
flag anyway, so it only matters for flowtable offload).
