Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30148746E;
	Fri, 23 Aug 2024 17:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724435154; cv=none; b=l9kKGrYSW4TMkFV9caj6rFIDztirMlb+pYfw0PDPWgHyf1yw/2eCtkAxKWhjNW5yT9IJmZZw5ih2Y1Ihf+BPHYKjiR8u7Y2Z7S7G1VSKIUUtiP2GTXeZpwt5kW0swZyOYZSdJwoew6BtROjS+MVwygdbQx4vZE739zrkz1+HMBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724435154; c=relaxed/simple;
	bh=GhdIXIa2iFBz0ObCH3R+GDVX+8jNuSe1xiAsWtGQrWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dl4GZQJQMgm8EQss+3GRLz+LgPwKVt6fu+FEE/dWAeSIAAMYGPxKAWA9Q73jF5c2+Mne8X1VKzHDqH4QIsz03/ReC1ZerHhV/mzMT5R/qu43ZjEOffMs0nGhuIXM0MvYHEh8iZvEmvFPM1riA8FAePt+2/RhWShb3nZWNVVd//A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5bed72ff2f2so2838131a12.2;
        Fri, 23 Aug 2024 10:45:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724435151; x=1725039951;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TDVkIQsG7ReEAwuaOoTp5Z2jTqt/qPXpRDuJxygFJmc=;
        b=f53i34oxiki3Hx2gB2Rhk+e+iz+HA04tLV0MBN8stnErMrix7Nsl6ViQ4kZXPZZVNY
         g+qitTeQ6yYgegT5KgAUjhCMTf3xjCwupjggaMSO++A4LISiD+SAD9wFfr4wuozlIu6n
         /Zoi7zJot1kh+A2ZT3lqBPx6+C5ASWJNGTxocs2fqAzN9hq71SK009bExkuj7hjx4iZA
         4UpwN/nQKnNCnqL2h5Aa7BAc1plfa6mLTzTBl3LCE4i03HFqFBbF9UuR3xQtc/xtbB9S
         ClD/YYUbBoWJmt9CQRYZdqUE4pdumSO0wgHNPTs+l2cfPMi9Sp/DFvFMVplDUnoUrzv9
         gemw==
X-Forwarded-Encrypted: i=1; AJvYcCXE6bxf46OQhBDeuoDd7okssG8Vr1sn/4ynC3MQwhtYXDQUVbg+T3Q6FNvZGZwXpV/9scwyjM6G@vger.kernel.org, AJvYcCXo1FnGjxuIdH18Pd2ZZW2cNow33g2OOBk6TawMHOkGrvgq4SGuBEnw9vpFrQ5SaPyhH9zlBTksBRH5GmJiQGw+@vger.kernel.org, AJvYcCXvF6f6XRcg3hJfiAr+zM+/dgxcYKON717clD6zcUM3t1pCd/MX+T1yHwMqJdAn860U3RIF6TJj92LGVSA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzvchjuc0pPGcY444gYePCYXVcmoxYbdofW91bi/FA3kzbmKehm
	w9zU895nWMnXh1QgMkb4deUXxQK1ILldbbX6fBwIPrdQsDQhJVQe
X-Google-Smtp-Source: AGHT+IH7djN+JVRUeLR9+jisrbq0RFvo8Ky4eTod2kWJoNlKjO407qXZ9Vb23bx9eG2roP6CZ3iCuQ==
X-Received: by 2002:a05:6402:5187:b0:5a3:3cfd:26f7 with SMTP id 4fb4d7f45d1cf-5c0891abad5mr2275476a12.32.1724435150670;
        Fri, 23 Aug 2024 10:45:50 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-012.fbsv.net. [2a03:2880:30ff:c::face:b00c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c0515a91afsm2341200a12.93.2024.08.23.10.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2024 10:45:50 -0700 (PDT)
Date: Fri, 23 Aug 2024 10:45:47 -0700
From: Breno Leitao <leitao@debian.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: fw@strlen.de, Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	leit@meta.com,
	"open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
	"open list:NETFILTER" <coreteam@netfilter.org>,
	"open list:NETWORKING [IPv4/IPv6]" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH nf-next 1/2] netfilter: Make IP_NF_IPTABLES_LEGACY
 selectable
Message-ID: <ZsjKy1YBAzh96DBn@gmail.com>
References: <20240822175537.3626036-1-leitao@debian.org>
 <20240823074444.7de6a99f@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823074444.7de6a99f@kernel.org>

Hello Jakub,

On Fri, Aug 23, 2024 at 07:44:44AM -0700, Jakub Kicinski wrote:
> On Thu, 22 Aug 2024 10:55:35 -0700 Breno Leitao wrote:
> > This option makes IP_NF_IPTABLES_LEGACY user selectable, giving
> > users the option to configure iptables without enabling any other
> > config.
> 
> Some tests seem to be missing options entries from their configs after
> this change: amt.sh, udpgro.sh, udpgro_fwd.sh

I realized that IP6_NF_IPTABLES_LEGACY and CONFIG_IP6_NF_IPTABLES_LEGACY
were configured in the selftest suite before due to a dependency
"selecting" them, and they are not anymore.

I will send a v2 which adds them to tools/testing/selftests/net/config
config file.

Thanks
--breno
