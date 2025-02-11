Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5211F1908;
	Tue, 11 Feb 2025 14:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739285174; cv=none; b=rabKC5Bv1d+WRFWv6lSr7lnFRXYjMWxbOX57XX/twm2QyBtZlDAgZ8WOqhMdwcIdP7KgWe+O16M7OoV2Y70LJE2xKWJRt5IGjrmt8yDxf1lOGJkC8hWrCLyostXIhFQN6flPAzn3ICvWHGjaAPNlgUmMRT3RRHBTCTd1uu6P514=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739285174; c=relaxed/simple;
	bh=6uWVDSjgS6JIISR3Ig9ZHEbq8J0PF0Iw5i8ZVq3tF3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rX8e8EUhy6h0nuIFIk2gjwKqcSVkGlRoi1wmd/t2yy1wVYmAifhRMajePotj7sSIxuSWTOI0fuQLN38PMXW9diNDdDE4vZc+7EeJgzNDaH3TjslqKy5+0zXm2Hqk6OLwrZjxGcOZ6G1eUsXUqRQp1KHfhgIBDOVnqiOl/KtoBL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GL3Sz9j0; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GL3Sz9j0"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ab7bccf51e7so33210766b.2;
        Tue, 11 Feb 2025 06:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739285171; x=1739889971; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6uWVDSjgS6JIISR3Ig9ZHEbq8J0PF0Iw5i8ZVq3tF3Q=;
        b=GL3Sz9j0jqAPdP98Mzx0krb3q2xM3IFGvGdl4uIbYtP9JQsCawSMyedKFOJDmhxoDS
         bGKe0Qhk0JQq9Kv1U/UvtTA6Cv0GO9F/Uw2RRL8Rxq+9JMGQ8O3eTNgTsKPgVbdo6YA0
         3lU+QTv3fgF3M54VvLt2n2fmLJIp+qe2zeYq8HFH12RM7N3hywlyldpP56HBhTSHyyYn
         XY0B3CXx+n2FKzYz4LJc7M4pAiT/9fuDOZIC+AzzfKx4rYGBtyADe5IWA69ry9Il3KZS
         w1cixFP4Mon2LNoC3leIz902sCemH1sUdeEeQCE4t0i70MV2dPWbs88zWZjK7tMPcfXE
         QncA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739285171; x=1739889971;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6uWVDSjgS6JIISR3Ig9ZHEbq8J0PF0Iw5i8ZVq3tF3Q=;
        b=JuYxnsiIjI4zf+kNm/RqgbGO7aXGUV9OqfADKc/VrXo3Tm6doVKFHNM/6b7pPzQm8y
         iMjgMiYAhMByyV7MIgveUUt7VHCFrqfHEqKPWjmCVJaV2+d045viRJmqnNlyhvf1FE+/
         mxpKN37L21l8JW5epXl1r/MmC4P3wzM5tQD35F9bAz0zsHBU1+oD/ZdDdZxTLC7XEw88
         XbObE/Qk+y6Nn3AN4X7a0e7A2SzWNeVS2yfZFNefAA3ekGVtakLrKCUe46sLwl/Ak7jM
         DiL7NOXyAp2IK58WJWxem0YUYsjPRHIHG0i23hzpRwMGJGja4zCudV9e4EPf1oSPw70C
         d0QA==
X-Forwarded-Encrypted: i=1; AJvYcCVs2kWMXqE2SlK5t9RxoiKgWaES+F04a0bI+Y4/Tfkt4xDwH5RNSycK5L9yz30SJ6CIxZ73PL3ixoEDpMhveo+L@vger.kernel.org, AJvYcCWnYNE6m8JHKoWUDsMph6Zzd2XmmvCVkDdMz2ZH91Xstq22X+qPIA/Bc0tI18kMsXu43Gx0TMoT@vger.kernel.org, AJvYcCX+yf4NhoNWjtujBrK9j9CUMxgHlu19lPriPWofE4T76otkIeKFRGmHODmD6znH7rAJCODhI6xF9tNmYFM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz07MLQ99TT7XBmSeRD/gQrDXfIo6RF2VSKjsPzt0ZQDMgq1bw6
	qB+bLCeQTAoNqwF9gkX1GxwDKeWzIiJASxkbBLaOTLj04Cl1Oz7n
X-Gm-Gg: ASbGncursPJ1E1zqW98xTRz0TR8sTmeL0FpVbGJt2/DvoqFfkS4yOfP8I6xshIxLxY5
	QYtxHCKXv12+hFFuQ4HIrUxic2mz8ZvxpUkvP3hLEo4z0otfDHRoe3BOaxG1Z77+TyWkuswvf3t
	sONxDVUZWk218zBUiCN/EPO8EOl2VZM2yAbzCPeEp3DRqydrozrEKb93m7vhDVuC/vR0Dqc2jeW
	Dc6L3CijR32Twxmy9Kd9lJJAihnTfLd2QgVKXrvfOGDGk+ZoiHJ9ncqrNchKPa808se1h70gzAa
	DEE=
X-Google-Smtp-Source: AGHT+IERuaTSU0FjfFqdLB/FrYmkIXox+hXTzqKNJOTUEB7oHG1m+Cn9NfYp8r8pLkOryAH3/WRqyQ==
X-Received: by 2002:a17:907:96aa:b0:ab6:eec4:c9c2 with SMTP id a640c23a62f3a-ab7e0eeb604mr95768366b.7.1739285170925;
        Tue, 11 Feb 2025 06:46:10 -0800 (PST)
Received: from skbuf ([86.127.124.81])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab78e561ba0sm898239966b.137.2025.02.11.06.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 06:46:10 -0800 (PST)
Date: Tue, 11 Feb 2025 16:46:06 +0200
From: Vladimir Oltean <olteanv@gmail.com>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
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
Subject: Re: [PATCH v6 net-next 05/14] bridge: Add filling forward path from
 port to port
Message-ID: <20250211144606.ljj2rddz32p6gooe@skbuf>
References: <20250209111034.241571-1-ericwouds@gmail.com>
 <20250209111034.241571-6-ericwouds@gmail.com>
 <20250211132832.aiy6ocvqppoqkd65@skbuf>
 <9ae3548a-844e-4449-9c00-5dd79e804922@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ae3548a-844e-4449-9c00-5dd79e804922@gmail.com>

On Tue, Feb 11, 2025 at 03:43:22PM +0100, Eric Woudstra wrote:
> Thanks. I will correct both in v7.

Please wait a bit more for v7. I'm trying really hard to ask a pertinent
question on patch 11/14, which currently I don't understand very well
what it does and why it is needed.
