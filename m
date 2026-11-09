Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794268567;
	b=H7OQb75DJqD0a1XwUmdsJahsMqmsJHFfhkQmQSpsZfZAISqjAqcQqlVT9+ugqKlRqGoY
	 myVg7btbcsvt+YRqrzZn/jlO7wBZ/LHqd48+I6NKCFCw7zDjwy+Sbq3ubEIbG5tZ+YSMe
	 Tna96hzSG9PV8ugvfx5JMurBERI09Ikr9Cm9y/Nv4B4I1fmMYYoVBo71g1bL0/yzhd6wy
	 UI9uuQRiey7QGKEvK0vYODoVZQs7MrulZOUwtixeYfSMk+TAJs1wbOFOry2eurkXEDTs8
	 /SyYjyCy1X4W0lEv6uQXEwqv3Um7FwrnrUkjbeSutdi+5kblGwv3ynHenMfficfUtkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794268567;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer:From:To:Cc:Subject:References:In-Reply-To;
	bh=nlqOFSAQ9H7dnLsW36/WDhDu5EY2v33GDHCwxLLecp0=;
	b=ACxXm6kVNZvtm9W5qJZTBfAuy3Kpvc+hyis82Ix9G4hocVjrheAWkAWDdxLasJZpOsp8
	 Xf64kBntQePGe3YVdeQs4peUYL6jjw4mcYhj5njaBkz+lKDq3ZnUs3QI02u/a8Iz4IrwS
	 c9fyfGsf8ohzV+zJSox7LVj6xcH66X2IPk8eAzEGBiWs2d8eWCRYeGWVxXw/BSVwhFm4M
	 afZIV5IzC4krQomunW0nIUgnMVHaVfsNqPllDxOydrxYlZljBhJ2ETgmCpAtDb8gZS8Ig
	 C2DHe9zmhSe5GI7y2odpZIXaW8QJfy+XQPUsWqVZMymrAL8dcNEG9Q6HCNyaQ2SfI8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=paul-moore.com;
	spf=pass smtp.mailfrom=paul-moore.com;
	dkim=pass header.d=paul-moore.com header.i=@paul-moore.com header.a=rsa-sha256 header.s=google header.b=Qz1X22J3;
	arc=none smtp.remote-ip=209.85.219.50
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9699606A321
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Nov 2026 23:56:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9699606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.a=rsa-sha256 header.s=google header.b=Qz1X22J3
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-91eb53957cbso19921886d6.3
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Nov 2026 15:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1794268565; x=1794873365; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nlqOFSAQ9H7dnLsW36/WDhDu5EY2v33GDHCwxLLecp0=;
        b=Qz1X22J308Z0pwN4ph/SpbaqCDLhrYfm2/s985T7MYAxMwFI6+WtTal8ogRpJXmDZc
         YizbP4AaoI7JqwqSum0kIuNYtmrj9bYTw2Z4ZqOUJEMWH8IxZPx8V600M1H4wTQzMG0n
         dBeqV+zBkY9z6aFUUiYf4j/EHTQUhnR4vW9XpyU5tFEPwjOYWSVYr5d9zhk8GaHU04IN
         kagJuSxM6qk+XMD87K/Pfrwb+4tZHOEClPvbMnUi+Tx1OoA3pYl5nNvkBfepcZArxHiz
         yYOoFFVg1IqBYd+IJerZXSrI8KZgtwv9AVnQbWhlmi/VwLbWbKLyLAtQSSaws5TqG/zS
         p2ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794268565; x=1794873365;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nlqOFSAQ9H7dnLsW36/WDhDu5EY2v33GDHCwxLLecp0=;
        b=gz0ei7uoeY1KGEeKanxHlnPxbPaov8Clx0+LZvD/u0CEO1MGoEV3TQFk/KcBQmwjsf
         7jjob64/988Yq3Hf7dxU/ndmBoyblgPsWgQ73kicxhdlfn2Edg281TL6PJP6fksvhdUH
         tUjruJf8LPT/QjgvW5qSU1NP0upsKVgXPii6B9rEJXOygU+1yIcDSHOKzzN3rKk3y4AG
         Vb4JwMLXsWvw5XY4DwS0Ydymx3f04+bP1OjbYSYmrhoM6q8JV8uKZrXe9oLf2BkIZEMZ
         leojLR+fChgH4fMzDBPNFf5woj6u/6Zv0YlE4HzHd1TrgGjXS3aNtZ29EbasYggUuiRT
         kzpQ==
X-Forwarded-Encrypted: i=1; AL+hErFIqS0HubdP2ARHMcPV0Z8Fj431ZA9Ci0tvA2aEGKrpIvid2N7Fn8c6g6/LfQbOIsTnzISO2nQKLeI12PKlMfc=@vger.kernel.org
X-Gm-Message-State: APuU4Z9pg2Rqc2C2GNxqQCnBpT8UIV0eONi9hpuGeuIpVYWjSyB6t3q1
	o8rNDU5Up24PV4yrXbvWKDVjIK2zHm2yCA9WgNKvus1uCTqB4kEzNnhgHUAwHB2lPg==
X-Gm-Gg: AYBFou0g1i8QzXw+hRpK+y/pHt+gYitI4fKQhlqP3zF/FM1ejIYZz2p2lVGF+tb5Q4J
	BKIkQeX99vdzmFEG438VTTNfJK1nEogl8Pl01IpazoyzKBVxkSCyrshkzI2z/HzEgDPETdzcb2J
	U46sIPozZtrEmIU2qy4jBHYJwrw/hhdTe7diTfo5MYbYUFiPrc/KJdrKeuWL+qwdi4TEmkCZhd5
	IuBYfcWE0b7t7AoLkNBJP7tk6IUg3URy5fBILmt/PfXYdy+Tjc2XSMTQfarcD8GSOs3DAAKS4tl
	EIBb/lVdrA9dNMDITrhryk6XtO1fp2p090pDIm9C6y/mBXgc9qFsTQ+6EI+6Zun+CDZvqOtShJ6
	0PQ0z+CTj4ahxGMbdi5HvoiC7zJPHL1HZUJh6nAdzNib8nPl8dFmK2KhDpATQON4UFYO2ic1ZxI
	J0tgvwO1lLNUayLlS/RXhweUhFYnF6YttwIuzbNKXT2mkJcq5rmwTAmRNoucJenqa+9N6w0t1C/
	qfoqGEJdfAQyCkvW1U8Lr6eWMcKolmvvTvMF2VMU2kmusaPA9rioGVbiUxHux4DuxUwCREzfv87
	N+sSE2qLKcWIRfvcz76rRZq7tjajHps6r4j52BYUCIRCB5iFd2A55wZ3BNGy0418QqDeVyTbC0B
	sKw7Iot55ogGGOO8VjSgTm0Bgllaqi8U=
X-Received: by 2002:a05:6214:54c8:b0:91b:5d39:e13c with SMTP id 6a1803df08f44-91eef8650e9mr21004816d6.49.1794268565495;
        Mon, 09 Nov 2026 15:56:05 -0800 (PST)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef04ae351sm7869386d6.12.2026.11.09.15.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 15:56:04 -0800 (PST)
Date: Mon, 09 Nov 2026 18:56:04 -0500
Message-ID: <a8542108f56e8cac5c6e65977ee01ffd@paul-moore.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20261109_1829/pstg-lib:20261109_1442/pstg-pwork:20261109_1829
From: Paul Moore <paul@paul-moore.com>
To: Joas Antonio dos Santos <joasantonio108@gmail.com>, Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Ondrej Mosnacek <omosnacek@gmail.com>, Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, selinux@vger.kernel.org, linux-security-module@vger.kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selinux: don't label bridged packets in  selinux_ip_forward()
References: <179216146138.25460.7866279004288174372@gmail.com>
In-Reply-To: <179216146138.25460.7866279004288174372@gmail.com>

On Oct 16, 2026 Joas Antonio dos Santos <joasantonio108@gmail.com> wrote:
> 
> With br_netfilter and bridge-nf-call-ip{,6}tables enabled, bridged IP
> packets go through the NF_INET_FORWARD hook, where selinux_ip_forward()
> calls selinux_netlbl_skbuff_setsid() and NetLabel may add or remove a
> CIPSO or CALIPSO option.  cipso_v4_skbuff_setattr(),
> calipso_skbuff_setattr() and calipso_skbuff_delattr() move the IP
> header and reset the network header, but the Ethernet header stays
> where it was; when the bridge pushes it back in front of the packet it
> picks up stale bytes and the frame goes out with a garbage destination
> MAC and EtherType.
> 
> Labeling a bridged packet based on its IP addresses is not what we want
> here anyway, so leave bridged packets alone.  Add a stub of
> nf_bridge_info_exists() for CONFIG_BRIDGE_NETFILTER=n.
> 
> Tested with QEMU, two veths enslaved to a bridge with br_netfilter in
> the middle, SELinux and a NetLabel DOI 16 configuration, 5 UDP packets
> per case:
> 
>   case                                        before        after
>   CALIPSO packet, unlabeled destination       MAC garbage   5/5
>   unlabeled IPv6, CALIPSO destination         MAC garbage   5/5
>   unlabeled IPv4, CIPSO destination           MAC garbage   5/5
> 
> Routed packets are still labeled (an unlabeled packet forwarded towards
> a CALIPSO destination gets the option, 5/5).
> 
> Fixes: 948bf85c1bc9 ("netlabel: Add functionality to set the security attributes of a packet")
> Link: https://lore.kernel.org/netdev/CAHC9VhS+bdL_YnLQtd0sPmKKfy9BvS-LWV_6EhAuu4qfUFe_mw@mail.gmail.com/
> Suggested-by: Paul Moore <paul@paul-moore.com>
> Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
> Assisted-by: Claude:claude-opus-5-5
> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> ---
>  include/linux/netfilter_bridge.h |  5 +++++
>  security/selinux/hooks.c         | 13 ++++++++-----
>  2 files changed, 13 insertions(+), 5 deletions(-)

This looks good to me, thanks for all the work you put into this!  It's
been several weeks with no objections from the netdev folks about the
nf_bridge_info_exists() dummy function so I'm going to assume they are
okay with that; if that's not the case, please speak up soon :)

Merged into selinux/dev.

--
paul-moore.com
