Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B3E83CD4;
	Fri, 16 Aug 2024 09:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723800241; cv=none; b=J3z/Imopoo4B4gXz1nDofMndgaO4Zp4rne2SqHeRAkD9OYsJ3+pQaO+IqEt4/FuSWPUG2NyOeyW7yvUiCNtqUqXzt3mZbhqArr3Xx7dOQRhnHqjMtVKuP4AjFrjPW59PmJguJT6/FYUnHrgtJzVJj/532NdNks0s+UZKhz5p4fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723800241; c=relaxed/simple;
	bh=m3y9VSRCjdkoykpMIAxaGTB5aNTul4nyfgxQjfA9ynE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DrQSW3UV/V/e+mfhsCz+qV8x3wNBph9+vHnYW48Zpal8dvwyxUJcX2zjUNOMmfjyICIpyollZf6UPz1LTWQ6WXq92YwhNlk6wPXGq+L/58oyb3JipPyIGO3AuvPuL/QyLKEOm0laaUFi0HjjmQYp5zVUv4vNFNLFqeGY2AFTj08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5b3fff87e6bso2283850a12.0;
        Fri, 16 Aug 2024 02:23:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723800238; x=1724405038;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+1PfiZPj48hhcKTqT6o8oLw6kje0ZuL2iF0YIiVSIc8=;
        b=aW1eQBLGTQFk7sxgoOZWgviBUyHy+2BRPIrnTZvJyhcFxO+2mtCByGYTTNNqNDpswV
         EaJ+DtYvpvbtx5xz7vHne04zTaqnBO1eY8S4BhcjQY3ns+FaXUuTuGhSgtNhKhwpebsp
         zzHu0TuiI2DN6iN1AD9PtQK/1a6juUyXDZWPt2yfk/6pl7GYdAygrYcfdbS9wHynIR7A
         DU01/1UPz8mgkonuOWvtJ4z4vlMlhf6n1A2rM/8zRMYn/Tfw2oiWjjFtdar3TVuMsJU2
         s+FxqYOfzrSyQ/ZkSRQ2tW1OosGlZXfphs4XPwmw0CawpXiGiuuoVFBZYH4S81epZB64
         tGLg==
X-Forwarded-Encrypted: i=1; AJvYcCUnmDa6Jid6UYZIVrJl0VdPmODbRME7oogkNqiPZ1B2XMsB3Ugg2XzrZLTRktofr9DVoc6Mb+pgFkg/q3Hag/gp4OWlZLoSYqih+VJgYyQcZqhPk1bQLVGhNI8/TjdJeqctR6m6CIED
X-Gm-Message-State: AOJu0YyTrvsq5b+YlYvMErNjLKEx1Myz+rSg29ZYO2Ym4OpKLtxvf/gG
	pXJhRIWslA3WxCdxOWyb0tLWz/u5mwh297MS8gml1b61URXMfvFY
X-Google-Smtp-Source: AGHT+IFw1Pdn/ifVczbODmQY1OFS4Lg+8mWWhzLTVWw3TzyTylceGD+JKDpmySMSJ+a4fKu9NMahvQ==
X-Received: by 2002:a17:907:e219:b0:a7d:c9fa:e3b3 with SMTP id a640c23a62f3a-a8392a2234bmr146374966b.54.1723800237388;
        Fri, 16 Aug 2024 02:23:57 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:69? ([2a0b:e7c0:0:107::aaaa:69])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a838394645dsm228530166b.144.2024.08.16.02.23.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2024 02:23:56 -0700 (PDT)
Message-ID: <3f714aad-43b8-443d-a168-db02cb9453af@kernel.org>
Date: Fri, 16 Aug 2024 11:23:55 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 4/4] netfilter: nfnetlink: Handle ACK flags
 for batch messages
To: Donald Hunter <donald.hunter@gmail.com>, netdev@vger.kernel.org,
 Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Jiri Pirko <jiri@resnulli.us>, Jacob Keller <jacob.e.keller@intel.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org
Cc: donald.hunter@redhat.com, mkoutny@suse.cz,
 Michal Kubecek <mkubecek@suse.cz>
References: <20240418104737.77914-1-donald.hunter@gmail.com>
 <20240418104737.77914-5-donald.hunter@gmail.com>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20240418104737.77914-5-donald.hunter@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18. 04. 24, 12:47, Donald Hunter wrote:
> The NLM_F_ACK flag is ignored for nfnetlink batch begin and end
> messages. This is a problem for ynl which wants to receive an ack for
> every message it sends, not just the commands in between the begin/end
> messages.
> 
> Add processing for ACKs for begin/end messages and provide responses
> when requested.
> 
> I have checked that iproute2, pyroute2 and systemd are unaffected by
> this change since none of them use NLM_F_ACK for batch begin/end.
> 
> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
> ---
>   net/netfilter/nfnetlink.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> index c9fbe0f707b5..4abf660c7baf 100644
> --- a/net/netfilter/nfnetlink.c
> +++ b/net/netfilter/nfnetlink.c
> @@ -427,6 +427,9 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
>   
>   	nfnl_unlock(subsys_id);
>   
> +	if (nlh->nlmsg_flags & NLM_F_ACK)

I believe a memset() is missing here:
+               memset(&extack, 0, sizeof(extack));


> +		nfnl_err_add(&err_list, nlh, 0, &extack);
> +

Otherwise:
> [   36.330875][ T1048] Oops: general protection fault, probably for non-canonical address 0x339e5eab81f1f600: 0000 [#1] PREEMPT SMP NOPTI
> [   36.334610][ T1048] CPU: 1 PID: 1048 Comm: systemd-network Not tainted 6.10.3-1-default #1 openSUSE Tumbleweed 5d3a202ce24e9b465acfbb908cc2eb4f0547bea7
> [   36.335330][ T1048] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [   36.335906][ T1048] RIP: 0010:strlen+0x4/0x30
> [   36.336204][ T1048] Code: f7 75 ec 31 c0 e9 17 e0 25 00 48 89 f8 e9 0f e0 25 00 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa <80> 3f 00 74 14 48 89 f8 48 83 c0 01 80 38 00 75 f7 48 29 f8 e9 de
> [   36.338921][ T1048] RSP: 0018:ffffb023808f3878 EFLAGS: 00010206
> [   36.339802][ T1048] RAX: 00000000000000c2 RBX: 0000000000000000 RCX: ffff9291ca559620
> [   36.340735][ T1048] RDX: ffff9291ca559620 RSI: 0000000000000000 RDI: 339e5eab81f1f600
> [   36.341177][ T1048] RBP: ffff9291ca559620 R08: 0000000000000000 R09: ffff9291ce8a6500
> [   36.341639][ T1048] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
> [   36.342063][ T1048] R13: ffff9291c1015680 R14: dead000000000100 R15: ffff9291ce8a6500
> [   36.342517][ T1048] FS:  00007f2ee943d900(0000) GS:ffff92923bd00000(0000) knlGS:0000000000000000
> [   36.342732][ T1048] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   36.342868][ T1048] CR2: 00007f9d4769c000 CR3: 0000000100b82006 CR4: 0000000000370ef0
> [   36.343044][ T1048] Call Trace:
> [   36.343329][ T1048]  <TASK>
> [   36.344518][ T1048]  ? __die_body.cold+0x14/0x24
> [   36.344831][ T1048]  ? die_addr+0x3c/0x60
> [   36.345029][ T1048]  ? exc_general_protection+0x1cc/0x3e0
> [   36.345674][ T1048]  ? asm_exc_general_protection+0x26/0x30
> [   36.349001][ T1048]  ? strlen+0x4/0x30
> [   36.349423][ T1048]  ? nf_tables_abort+0x67c/0xee0 [nf_tables c16b4fb993ee603261e060fba374eb60b413741a]
> [   36.350380][ T1048]  netlink_ack_tlv_len+0x32/0xb0
> [   36.352876][ T1048]  netlink_ack+0x59/0x280
> [   36.353269][ T1048]  nfnetlink_rcv_batch+0x60c/0x7e0 [nfnetlink a5ded37673006e964178e189bb08592f3ffd89ce]

extack->_msg is 0x339e5eab81f1f600 (garbage from stack).

See:
https://github.com/systemd/systemd/actions/runs/10282472628/job/28454253577?pr=33958#step:12:30

thanks,
-- 
js
suse labs

