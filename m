Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A2120E319;
	Fri, 18 Oct 2024 18:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729277620; cv=none; b=Er+lF951nbFmI28oFnCv1w2sJirxDQKwI+8hM1oUnuCW7CLY64jSX3FnHZtYnJCG0yPWRXXVfpbUB3HcV8Hc+m3sqsga+8I0Ibe6FkzWH8TIqKuTtlVYnoG+LZHXNHUvB3QdM/5MpBiTA6M1ow2+ZpNUfcf+K7OEVA6/LaabhjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729277620; c=relaxed/simple;
	bh=wfRkbDUEGNL++oybIfRhyLJViztO7ln5vIkSu4O5LH4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kpl3MoErRyx7BMfZ+uK/1LwmDqVpW4B8oIixrlkw3Yby8bMh3+W+1c7l8GMuJ2zoW2E7g8st+2bMkPwUN9uKWwSS//91H09vNSZhB79cSTtotnPappvFbuQsGb9RCkLjwB2aBJsyBCFCNvyEl9n5vt7FAa9b7YDdzHubDKiIIms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m+jYa6wI; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m+jYa6wI"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-539f4d8ef84so2787645e87.0;
        Fri, 18 Oct 2024 11:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729277616; x=1729882416; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N+C37RFzcILnMsZFYBuRVkaO1NAcl0ehLYM/0ikIXvM=;
        b=m+jYa6wIG3NKSZ1FOWqroxGNQ5c2zusFJMmzoFyCR0pH7YHzvB0WYhLShIQxcM5gLI
         3yyZePuEJAJcXyXrtSIZ3iTd+F9R1EKX6j2HQwDAFoTwHZzaWhNFL4m7QaMhkR3TOisd
         0t0Uazp/kvEI7wfq5I7xk2m65dELxOQX2m0/nCLsUkfMEJoUbfkw5I/oSnu6RihrQaZw
         3IXL7sxmrJcQ07klDseAqQSeXzlY06gLJjQnwFT4yzEKZMEfi+TRvSUFczOxCvZgEi2V
         6EdhUNd34Mt1xm+BrRvWvbGltGzqbKtuIhn+hTjAbmx5Onk/YZYsukJTV8iUWRW2X41/
         C3sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729277616; x=1729882416;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N+C37RFzcILnMsZFYBuRVkaO1NAcl0ehLYM/0ikIXvM=;
        b=J4v8l28uS9hADn4A6MVtIMd9iu7Xy/Fqpz07v8ChmGl/c15+S07NMWD1m4eCdwiwqR
         DkwYbjtsIOdVLO3P9DR3OcbHg+JhliXMhXS3xp5apLh6rCTEG0ILAhAs9nRaO/VpSc3x
         TvcYFbFbDbFkI615R58RvLm0uV97GCvFeTeQbTeurC2iuU6UWt5vKM4o/Lnw0kmDqAnK
         90B7uvGIye6o+/m5/Rdv1rT38+P75nr2hdktZHyarplqnQhALNdChuyhFhEjHsf9i84C
         KKETg+tk7ng/eo++R0DT6LYsTCj+9S7awPaNRhXlCTdMLdOBTyCncbOr7iPvoW1moHcO
         +qiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrHHxhYlg8sl3w9ogsDff/HSnkmMP0oU+ogN+KyrNSQBFd29y1qoy7P147bfhUxl/4MjHnrv+I@vger.kernel.org, AJvYcCWEiTRBg8d/VhRXgUOg00ayR/SbgNWQ0SENcAKE5nGZE4kdlCaEo9kJZi+rOnVcEPBtr9vubTCKXN70u2c=@vger.kernel.org, AJvYcCWo5OtvZfP1dZI1Zrah0QYPisIOUHEtRWcW40zvGBN6Tl2a753hprj/qKBmNpkgTGQuIbzcBkKJjqun+UqXyo62@vger.kernel.org
X-Gm-Message-State: AOJu0Yz507ricOuiXZiLdIAzCiUPVF7+V5LDU5EHgM/YxNocCOA1PWaf
	oOsftE5jGh6918fQfE1rQEX1xhH2SxMIm4kFwMLJ6+EUbE4qEt1A
X-Google-Smtp-Source: AGHT+IFTECmpui4bEAd6LfXlK56bk60zCpZroN7QeGRG8HvefwSVsCLjpZDdolPkBbtIu2/ZZR22ag==
X-Received: by 2002:a05:6512:2352:b0:539:fc45:a292 with SMTP id 2adb3069b0e04-53a154fa754mr2044964e87.43.1729277616138;
        Fri, 18 Oct 2024 11:53:36 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ca0b08c3easm1036170a12.50.2024.10.18.11.53.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Oct 2024 11:53:35 -0700 (PDT)
Message-ID: <56c3d435-e93c-405c-9bf5-e9ea9c038d13@gmail.com>
Date: Fri, 18 Oct 2024 20:53:33 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 net-next 02/12] netfilter: bridge: Add conntrack
 double vlan and pppoe
To: Vladimir Oltean <olteanv@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Roopa Prabhu <roopa@nvidia.com>,
 Nikolay Aleksandrov <razor@blackwall.org>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Jiri Pirko <jiri@resnulli.us>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Lorenzo Bianconi <lorenzo@kernel.org>,
 Frank Wunderlich <frank-w@public-files.de>,
 Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
References: <20241013185509.4430-1-ericwouds@gmail.com>
 <20241013185509.4430-3-ericwouds@gmail.com>
 <20241018131754.ikrrnsspjsu5ppfz@skbuf>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <20241018131754.ikrrnsspjsu5ppfz@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/18/24 3:17 PM, Vladimir Oltean wrote:
> On Sun, Oct 13, 2024 at 08:54:58PM +0200, Eric Woudstra wrote:
>> This adds the capability to conntrack 802.1ad, QinQ, PPPoE and PPPoE-in-Q
>> packets that are passing a bridge.
>>
>> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
>> ---
> 
> Whatever you choose to do forward with these patches, please squash this
> build fix here (you can drop my authorship info and commit message):

Thanks, I had already fixed the errors from patchwork.kernel.org->checks
for the next version of the rfc patch. This is indeed one of them.

> From e73315196c3143de2af2fe39e3b0e95391849d6c Mon Sep 17 00:00:00 2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Fri, 18 Oct 2024 13:59:27 +0300
> Subject: [PATCH] netfilter: bridge: fix build failures in nf_ct_bridge_pre()
> 
> clang-16 fails to build, stating:
> 
> net/bridge/netfilter/nf_conntrack_bridge.c:257:3: error: expected expression
>                 struct ppp_hdr {
>                 ^
> net/bridge/netfilter/nf_conntrack_bridge.c:262:20: error: use of undeclared identifier 'ph'
>                 data_len = ntohs(ph->hdr.length) - 2;
>                                  ^
> net/bridge/netfilter/nf_conntrack_bridge.c:262:20: error: use of undeclared identifier 'ph'
> net/bridge/netfilter/nf_conntrack_bridge.c:262:20: error: use of undeclared identifier 'ph'
> net/bridge/netfilter/nf_conntrack_bridge.c:262:20: error: use of undeclared identifier 'ph'
> net/bridge/netfilter/nf_conntrack_bridge.c:265:11: error: use of undeclared identifier 'ph'
>                 switch (ph->proto) {
>                         ^
> 
> net/bridge/netfilter/nf_conntrack_bridge.c:278:3: error: expected expression
>                 struct vlan_hdr *vhdr = (struct vlan_hdr *)(skb->data);
>                 ^
> net/bridge/netfilter/nf_conntrack_bridge.c:283:17: error: use of undeclared identifier 'vhdr'
>                 inner_proto = vhdr->h_vlan_encapsulated_proto;
>                               ^
> 
> One cannot have variable declarations placed this way in a switch/case
> statement, a new scope must be opened.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/netfilter/nf_conntrack_bridge.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
> index fb2f79396aa0..31e2bcd71735 100644
> --- a/net/bridge/netfilter/nf_conntrack_bridge.c
> +++ b/net/bridge/netfilter/nf_conntrack_bridge.c
> @@ -253,7 +253,7 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
>  		return NF_ACCEPT;
>  
>  	switch (skb->protocol) {
> -	case htons(ETH_P_PPP_SES):
> +	case htons(ETH_P_PPP_SES): {
>  		struct ppp_hdr {
>  			struct pppoe_hdr hdr;
>  			__be16 proto;
> @@ -273,7 +273,8 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
>  			return NF_ACCEPT;
>  		}
>  		break;
> -	case htons(ETH_P_8021Q):
> +	}
> +	case htons(ETH_P_8021Q): {
>  		struct vlan_hdr *vhdr = (struct vlan_hdr *)(skb->data);
>  
>  		data_len = 0xffffffff;
> @@ -281,6 +282,7 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
>  		outer_proto = skb->protocol;
>  		inner_proto = vhdr->h_vlan_encapsulated_proto;
>  		break;
> +	}
>  	default:
>  		data_len = 0xffffffff;
>  		break;
