Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C8A14658D
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Mar 2025 08:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741162960; cv=none; b=bhAYy4MUCROEYlkw6PeqSsyFZer1/oXE6lgIh26gz2+AynukkOIWY/Vrn7ojAQ7PqJbVzNn1xUTjT6PLkgOXlVrPYWMZItsqYz4H1lej3YgEOyhw5MzVVzdNCYUVp4zO2XXT8QReCWRHwzUDDP6b4FJ02WHwTPIF+d6e/lgsoHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741162960; c=relaxed/simple;
	bh=nefCuvZh9BBXP1HgTB2e4dXo3Ejs7pSEpE8D1o/5fHU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BcYKqTjo6v4Q5abU/qQPxWvEQ/DH+KeCkB59HoTRQ5fmY84aT0HjdyNv4tgKbJu36xPtnr0b1ssWUaAIPpt9FA4MiSK554qWIy3zkYf61w7EhTH39lA4tNNPVgaeK7U3NhBCgs6P05mNJD8PU+FZOuDVvba1+V+QU5zScphcA/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b=oy4gfSHP; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b="oy4gfSHP"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5e53b3fa7daso5384818a12.2
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Mar 2025 00:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20230601.gappssmtp.com; s=20230601; t=1741162958; x=1741767758; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1brnVJAGUyBrrxRVaMvTP6y55O5yEMp4c+P5cyU9eYc=;
        b=oy4gfSHPVrs6EKnJ6VdugQ/D6WJbu7Hvhkz/xOUGN0u8aq8yhPGUChia/pc0qJmEkE
         lmzGcuI4p7AnUFYt0/ugjJj3EIqjrRyNDPk0ecPp/iKW+w8ddqSv18fJGyDLuujNpOXE
         ICZuDdFncPvzWlUXFd/i1+TbRPF3pjx7zNi6mqkGLT7+3RZwwJGOR2DgLKi2lN2p0muU
         3s7XfKBdYXh/q0I2kdIa3Q0qf90okSt3yO7qpkKiXB749GKIuKXUOtJnXfWMvPoa4hQI
         7jnDk4CwU1HRimIFfxegfIdqvSPiVGoV+QGM27bpUIhklGcphgQgq2IbMwPLCTYNG3M3
         ig9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741162958; x=1741767758;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1brnVJAGUyBrrxRVaMvTP6y55O5yEMp4c+P5cyU9eYc=;
        b=IdVb3ss5ZifsyEIqh1Td0epJeXHl0pkmGIvyqB8dqkZ1KlnjV/SEoWrq0o5AOHuAk+
         LbcIliXtp+EcK8Y7BT++gn0hYBRa91+iPbqNf9EB8SczLEqEeFk0JM3qzrGQA/FjIdy0
         evJw0eDOni+wref3RWAvNqep1AhoQFlM1lMPlP47yAWv/g8tRK/FuenJ3nGvGxwV0EP8
         gmIkACQqimHs1/asa8Fxj35aoPCc6MQRuUJ49ZwFkjST1GXxCLRewUv9FcRvlhbKnEGb
         kMjZt/cD1pulleHn45Lxog+2omVBO2Bju97HcJPbURgB2+g/jet5dpRB4n4ObP69ZskB
         Vtlg==
X-Forwarded-Encrypted: i=1; AJvYcCW6yAagkixEwffgRFR/JvRPksCrGSdc5Uu4dG9P8PjfzIDsj3dwss6Ai36WokUuldhCYOXL5tNAmAI88ReVu7w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1Q1/HqTRkdE6igboeVDmyM1E33hVFpGbg2m2OMu0led87/D/d
	PlrYu2DpJhfOZvsWEOMPR36Yh2GIfxX4JlpcDCwjKCFVMVr3qxOJmqwIMN7u6qc=
X-Gm-Gg: ASbGncslercUrZ54S07E2gaiUngymSwSFnMeHyySucdsrcrGaM6WPgVFIt82cSVD3im
	Xh+/o1mK1PHTsjSGysZgpUuEslIRf0acgzM+Nsnn3VwEBFjDxxyTtoT6nyP2WMNb9VbWHYYT1Jb
	k07qDy7MYa8C+cTq7wzKb0cHJd4aeUt0uQDZ3FvbY7GgrPDCE/6ViEXlVxsFiYuBfWIAMOB/DL+
	dIcWB2jVzlUSKbUgVMWfUXZ0FBc/ro/53cIcZ9eV/Kf1k3w/QaoeJG6jfZtYwxfeNZtb9q2+nWw
	5yPjdxPxOwIxDJyFZ7IEYmPU0HP/F6fn5BvFD+6WURMaPE3UehCx9tgk8BbjhMMAR5h8TVhNkQn
	0
X-Google-Smtp-Source: AGHT+IHSB1wDKnA9pHV1GSviWm2eGdZkD28ziFa7v6M0Rd/G5QVSKS+XqVwTfVjxopyszVvymfpwQA==
X-Received: by 2002:a05:6402:40cf:b0:5de:dfd0:9d22 with SMTP id 4fb4d7f45d1cf-5e59f470c8dmr2220203a12.22.1741162957444;
        Wed, 05 Mar 2025 00:22:37 -0800 (PST)
Received: from [192.168.0.205] (78-154-15-142.ip.btc-net.bg. [78.154.15.142])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e4c3b6dbbbsm9395036a12.22.2025.03.05.00.22.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Mar 2025 00:22:36 -0800 (PST)
Message-ID: <350a057e-39ae-4e8d-a4ec-12b2f78f51cb@blackwall.org>
Date: Wed, 5 Mar 2025 10:22:35 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 net-next 11/15] netfilter: nft_flow_offload: Add
 DEV_PATH_MTK_WDMA to nft_dev_path_info()
To: Eric Woudstra <ericwouds@gmail.com>,
 Michal Ostrowski <mostrows@earthlink.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Jiri Pirko <jiri@resnulli.us>,
 Ivan Vecera <ivecera@redhat.com>, Roopa Prabhu <roopa@nvidia.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Ahmed Zaki <ahmed.zaki@intel.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Vladimir Oltean <olteanv@gmail.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 bridge@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, linux-hardening@vger.kernel.org,
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
References: <20250228201533.23836-1-ericwouds@gmail.com>
 <20250228201533.23836-12-ericwouds@gmail.com>
Content-Language: en-US
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20250228201533.23836-12-ericwouds@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/28/25 22:15, Eric Woudstra wrote:
> In case of using mediatek wireless, in nft_dev_fill_forward_path(), the
> forward path is filled, ending with mediatek wlan1.
> 
> Because DEV_PATH_MTK_WDMA is unknown inside nft_dev_path_info() it returns
> with info.indev = NULL. Then nft_dev_forward_path() returns without
> setting the direct transmit parameters.
> 
> This results in a neighbor transmit, and direct transmit not possible.
> But we want to use it for flow between bridged interfaces.
> 
> So this patch adds DEV_PATH_MTK_WDMA to nft_dev_path_info() and makes
> direct transmission possible.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  net/netfilter/nft_flow_offload.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index 323c531c7046..b9e6d9e6df66 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -105,6 +105,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
>  		switch (path->type) {
>  		case DEV_PATH_ETHERNET:
>  		case DEV_PATH_DSA:
> +		case DEV_PATH_MTK_WDMA:
>  		case DEV_PATH_VLAN:
>  		case DEV_PATH_PPPOE:
>  			info->indev = path->dev;
> @@ -117,6 +118,10 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
>  				i = stack->num_paths;
>  				break;
>  			}
> +			if (path->type == DEV_PATH_MTK_WDMA) {
> +				i = stack->num_paths;
> +				break;
> +			}
>  
>  			/* DEV_PATH_VLAN and DEV_PATH_PPPOE */
>  			if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

