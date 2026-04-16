Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA31A3A7F50
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Apr 2026 11:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776339379; cv=none; b=FsKArd54H5IHS7oTN6O+KHjMkZh4vBLVsLh5o8I1NLLuOjAQRo0yA4+wTbuRfUnL+0y4ti1Fw4eXDJ40vBtpoKFrG/yCOTdMdFpDkSNa0LXVvfNxUWoLHkSFXWjAGhwRfHg3/MeXlD8hLeh+TU9EajSY36Kpu05uZ767tAnsHo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776339379; c=relaxed/simple;
	bh=ATPXPRSUwMhlt8ECwRArkbXzpHSbMy5MlkubYNi7w9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z3rVZwl8qw+tkle3X+HqnXGeNQOVUUOTHF4s1uao0tzbMIQpTuxqIGJdD6EEWpAaBZUDLRpmPD2BchwQDV74rZ+PugxSpaDldTJ1FBMp5B9Do/1wkJrc24nFhGYJA4ZKtpnnECfZtoVDXxqUrouHvHnOsqghAzakSMrocjqQPDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L1/22gGF; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jx/g9tNB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L1/22gGF";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jx/g9tNB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776339376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gwhKAmoYjds9QSiVSsV9iNgED3v7mL/c4iVZV29Op3E=;
	b=L1/22gGF6nPVw1e/mCWysQeTHGeqV++uZ0EALF2ysOnkVKi/1AMUMVYKO3eFcbFpaK1ZHb
	RLiBLcG5TuvHIisTnqUntAnxpgGkZcXqEd8+hndxj2fTW0lNxn8n5pRIGhY2e2WpfqU4uZ
	Muk7WLzD1iMFPcgWNGtc9bmTqweHsCQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-478-qYeWDY3oMdqHMvrbx749fw-1; Thu, 16 Apr 2026 07:36:14 -0400
X-MC-Unique: qYeWDY3oMdqHMvrbx749fw-1
X-Mimecast-MFC-AGG-ID: qYeWDY3oMdqHMvrbx749fw_1776339373
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-488d6ebe9cfso53668435e9.2
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Apr 2026 04:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776339373; x=1776944173; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gwhKAmoYjds9QSiVSsV9iNgED3v7mL/c4iVZV29Op3E=;
        b=Jx/g9tNBMqQi/0CCFeq0Cu0mvKaxMyk6pS9vZlHJEoSG0PDbMimi3OuNdFpwiq+4C0
         lrAqsndP3gbbpCkhKRAeFk+BPtTt5dSZAK28niw6t5g/DVW6bDUIq7mSPkJ7OlZkMeur
         sN8yQzjBzVpFBebIMUMHA0iGBRbHf4YvT66VaECDkWBrqOvq23V6obS5miZLbQjwcRzV
         MNHwjEIcwvQBjCnSpJ6p2LBOuMm1tvD52vdpVRcl4bP4q+s82ZpNNR8lzcVPCOGcTNGm
         Bp9n6C/rnaZ7qhQcnk5VPH+qwArUZxE8yIM+a1dPp6sctLNFzvUiMF6Xhs2uA1mDPIel
         bAkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776339373; x=1776944173;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gwhKAmoYjds9QSiVSsV9iNgED3v7mL/c4iVZV29Op3E=;
        b=FuZdMqFSKPeGFpkic1FsIxQqrFYGRAg12KurZ4mULdPotOINPDIrFG/yvqkMTjRf/3
         VZMVcX6wavZ2IG22xwa95MTsJ+d6UDFofewJNCBbfDVqtgm6YuLansfW46aljNJsCp+u
         xwPLCrDb3hp5Qyw2ayfwo2JtaTWtaoPCQ3td1vKJCq5idDbdWtiGPMArD4L0n/5lGzjk
         m4CbFLe2P25wi9hFbbz8eos2CtH0MArL6J6EYcyZ5rDaUHt2l+PPSB7XKwqF5rnyEws2
         nBmls9Ik/qa2ZJ1QMXrJ1iILGlpLXyft3+OOAi1Bmm56cQ7732FbekUwCtgRjaaSWwea
         PnIQ==
X-Forwarded-Encrypted: i=1; AFNElJ+HMnHWkXYwKkV1guxAFUO4QXDQlG4P2h1STU6aB5xIiuSrAAQFXOjV6jwIdnmxUon+bzqGKbE+dBL4OU1T+ds=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+lMizVO8wpxVvuT6Qh1aFjW5GmNXGuO/VyBN2h0JD782HM2e9
	YVcjTZBaRU3jpMukJDkLM1YBeB4zicnjKgnT6IK2T7zXhB1FAcnaqHxWDsyh9Pq4CA1ll3/a/Ob
	PamgZau5L4Vl7N2NqpjgNLZLDZAnpw/sZZk/FL7KewTo/SrIvZiVWGfvCDOZdSPA7O8BnsA==
X-Gm-Gg: AeBDiet4CWyLHZerwLgvnpYsaxQ7NJnT+/GVsuV3k2EhpoH6MsaItlPRCEmT6dWcgAH
	GozM5CBNgfWKhMODw8GfPwxdH8QXU6AzG2CkPEnukKfRK38YX8p6cZzaD21m0itJMcVGilYiGts
	/D5XS69SlVbbljJoqqdNWN02PtpXU9mkV/JZ9A/IM+j92kfcVMwp4ikaqssuFVgoViluFnKSNxY
	luyzv13q0hsOm66nn+vQnMOQVJnVZACj3oeb66W72CG7nmUEuOXZvHYOWCXzYvhwjPesd0zcvbD
	QL7mt1X4A5tQMnl4FQ6NCKl7+ZVrf9qMiIbfTcdosqzdh90HsqmmH6q45Un/3YwrTEiOkRIA+FT
	EpMB0L1Kl+kVwKwTIN9aqVs9rAmbcUcMwZXsiAIE/wZf6PaMCK3t3RCm+pnoDM7V4CMY=
X-Received: by 2002:a05:600c:5249:b0:480:1d0b:2d32 with SMTP id 5b1f17b1804b1-488d67fcf67mr326261795e9.12.1776339373383;
        Thu, 16 Apr 2026 04:36:13 -0700 (PDT)
X-Received: by 2002:a05:600c:5249:b0:480:1d0b:2d32 with SMTP id 5b1f17b1804b1-488d67fcf67mr326261255e9.12.1776339372865;
        Thu, 16 Apr 2026 04:36:12 -0700 (PDT)
Received: from [192.168.88.32] ([150.228.93.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488f582368dsm56423145e9.11.2026.04.16.04.36.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 04:36:12 -0700 (PDT)
Message-ID: <46239684-3c91-42d9-b7e1-5d90c3169053@redhat.com>
Date: Thu, 16 Apr 2026 13:36:10 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 14/14] netfilter: nf_tables: add hook transactions for
 device deletions
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 edumazet@google.com, fw@strlen.de, horms@kernel.org
References: <20260416013101.221555-1-pablo@netfilter.org>
 <20260416013101.221555-15-pablo@netfilter.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20260416013101.221555-15-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/16/26 3:31 AM, Pablo Neira Ayuso wrote:
> @@ -10920,9 +11007,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>  				nf_tables_chain_notify(&ctx, NFT_MSG_DELCHAIN,
>  						       &nft_trans_chain_hooks(trans));

AI notes that nf_tables_chain_notify() can now receive struct
nft_trans_hook arguments and it ends up calling nft_dump_basechain_hook
which expects nft_hook, possibly causing out-of-bounds slab read when
accessing hook->ifname.

It looks real to me. Possibly worthy strip this patch from the PR?

/P

