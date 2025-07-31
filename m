Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD80223ABB4;
	Thu, 31 Jul 2025 19:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753991920; cv=none; b=Gl92X94qxWUmTBjvU8gPaqzWgGpuADD/KSg6J7DkzF5/qX2kzWLy3LN82ceIs+H65ti7UVe0ACEN098tZdy90e3syfw9zebwwWAr5m8IcUTIN5tp0zBm9Wk7WCVrefp08ewUb9QPVIqsedtP71oaMsC1pfqo3kGoM4hHoMs9rJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753991920; c=relaxed/simple;
	bh=VE3joiXSw99qAb6jVz6lsKUWuKipwIyRAFo8ArBr8qk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TCVuHpGptRsaWeeYP+4OM/8tFr24R/36QWFcqi9sLO94X65ZSrdWGRkjOLMbyl9dprueX55rJ8Sjzd/7bSCoE467bxBTHyoWd+9LYNYGA9guRn383nMoJMzkuyNnqnim4vD6etL0kVd17JtlPex+vwW+V5M7+h8+OhyeCebX930=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ae3b336e936so29529066b.3;
        Thu, 31 Jul 2025 12:58:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753991915; x=1754596715;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JOub6JEULz4NRTq/hirUiArEKHDk37KcHlXQ+q2/ZHc=;
        b=J2h8BPUK2FUW5YvrpFJh53oPvkp2dkZbyie3/A5wdffgrUY9865IfeosOdmnVM6FtV
         z4l8NX3k/FIcjEZo6x4KOnS4GnE1RwzkWIzqUGB0HTW3CTT9rOfiKcDo8QisAiIp4e9U
         eJKkc59oonEFrDaQZNFBIQDWkscFtxLAVCalK188B1V5zAMLk8frGJB0dGLQOxiQjZ9J
         5miKzQdMuW6He/oyanxFwI39nN4ANgeI0l7U1sIqju0BH9ptmC5k80MpL/Sz5F8Dy6UZ
         HzFzQ65hljHgk1TyTVb+wh/CquOw2QRRcm8u/bYIWuK4eCePpNowQRhb4JyV+HYzlb4q
         Ru4w==
X-Forwarded-Encrypted: i=1; AJvYcCVrFztzi62TagY8FEACwosLNbReDY6sCB6EW/JY5qRLUJufmhuVOCm0JlYGWH3FOmO97tdKEheUNlTILVE=@vger.kernel.org, AJvYcCX2Nk0xmrsa6O1ZFH489aeK4SFSOEiMD6c5ErT8IJ1KrwgJTTL2+BgX++qKXXTOeLbzIAkCGTN8@vger.kernel.org, AJvYcCXTUA8Gld0LCDbw2QoNNoxEj3f5xNTnrV3aNF2S8g8lKi6r5r+D4XpS9JE8/DpCXEpouGiPP3WpmFgxdbB58kYZ@vger.kernel.org
X-Gm-Message-State: AOJu0Ywbyf2vrxXL+FROB2V3Llw3ApMxHytwUv/U2OyWOgFP0LdddDnI
	qkc1TJfN/vMj8PRTPGWCWOhKJyLIecDrUQXlTOdffwD3vgY/MbvjEJQy
X-Gm-Gg: ASbGncuTrj0zlSMOw9A2vewaL2UynD0XaHVTbJhbYaIxleyz9W2ATjgrFO4pT+f4c57
	s+rzsqRsr7QWLM167rfYydi7HYnCpVEBfFUHP22D3kbYkNVeNVPYE6dLvBJkQplx0zUVmZClQZX
	0ddQP9wq6n8FfSgpTzYxers0MImeleNXJp8UYgSoGCDDP/13qn5+hSt2zKRUZOoe82YzAP90w6R
	dEHElsxa8jKx4hSaj5FK3ta1IFsz1Wm5AcFi6QMsZaW5hyd5CSNzAh3au7ZVOOXSc+xlaCMqqzd
	5BsElLmAm0UqXgSKXfeBBCH40nchjQfjFUr/5GjUPGKkQnCZXke7TuT74RLi/guS49gq8jeoIkM
	UnTUt11j3nxXpmOvgHzFj
X-Google-Smtp-Source: AGHT+IHi5E7zdxk5Xx1zNsFA7iW/9W+ly6JoYYOQpr1wOvbx3PwGi79d4r5orR4ephm9fAhIPcGSfQ==
X-Received: by 2002:a17:906:7951:b0:ae0:c355:2140 with SMTP id a640c23a62f3a-af8fd9f7520mr1057608066b.45.1753991914859;
        Thu, 31 Jul 2025 12:58:34 -0700 (PDT)
Received: from gmail.com ([2a03:2880:30ff::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a0766f9sm163674566b.24.2025.07.31.12.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 12:58:34 -0700 (PDT)
Date: Thu, 31 Jul 2025 12:58:31 -0700
From: Breno Leitao <leitao@debian.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, 
	Jozsef Kadlecsik <kadlec@netfilter.org>, Nikolay Aleksandrov <razor@blackwall.org>, 
	Ido Schimmel <idosch@nvidia.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Arnd Bergmann <arnd@arndb.de>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, bridge@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: add back NETFILTER_XTABLES dependencies
Message-ID: <uadem53d2ymvjweqjdvilrpr2vwsfxu2gbwyaopacyl3x2zmhl@raeakspbvdiw>
References: <20250730214538.466973-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730214538.466973-1-arnd@kernel.org>

On Wed, Jul 30, 2025 at 11:45:32PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Some Kconfig symbols were changed to depend on the 'bool' symbol
> NETFILTER_XTABLES_LEGACY, which means they can now be set to built-in
> when the xtables code itself is in a loadable module:
> 
> x86_64-linux-ld: vmlinux.o: in function `arpt_unregister_table_pre_exit':
> (.text+0x1831987): undefined reference to `xt_find_table'
> x86_64-linux-ld: vmlinux.o: in function `get_info.constprop.0':
> arp_tables.c:(.text+0x1831aab): undefined reference to `xt_request_find_table_lock'
> x86_64-linux-ld: arp_tables.c:(.text+0x1831bea): undefined reference to `xt_table_unlock'
> x86_64-linux-ld: vmlinux.o: in function `do_arpt_get_ctl':
> arp_tables.c:(.text+0x183205d): undefined reference to `xt_find_table_lock'
> x86_64-linux-ld: arp_tables.c:(.text+0x18320c1): undefined reference to `xt_table_unlock'
> x86_64-linux-ld: arp_tables.c:(.text+0x183219a): undefined reference to `xt_recseq'
> 
> Change these to depend on both NETFILTER_XTABLES and
> NETFILTER_XTABLES_LEGACY.
> 
> Fixes: 9fce66583f06 ("netfilter: Exclude LEGACY TABLES on PREEMPT_RT.")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Tested-by: Breno Leitao <leitao@debian.org>
