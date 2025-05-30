Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0899476
	for <netfilter-devel@vger.kernel.org>; Fri, 30 May 2025 03:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748576250; cv=none; b=pl15tGM1RD7QGlRTpSc/lMQZpZknZVBL3jAeSaZTZg7QtsGadtw0NIdXgdP7/6lf1kBQGaSO49pxMYkyrFgC6rQntZrq5swS6oVKMeUcooYaDnQyrvnqbDvJ9tRPEazPe9im+D59u3Y6zalAB9oC2wZcF+rIqZLfzawo61uGYCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748576250; c=relaxed/simple;
	bh=Up0HiaiakkrpLdrnmiFk4hxdpFmuYdS7etC++J0geqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cll0Fjt4OjgEPKWd9vDVMVS5SlbYhdkrM3aP+edCp+fT8MtOtdIuicaBdlSD9Y1Wy8rvgJPXTbzkFtdHUGPh229wqOVvHpc07x0ZGJ8WxAYQLfQbJ+wBRF/I59cGg+rsT+P3VYbZWmlc3nNCW0d7AG69HKh1v/BLBGIoDHj8Xrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fiGlru31; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fiGlru31"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6fabb948e5aso18357986d6.1
        for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2025 20:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748576248; x=1749181048; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uMZpc9ivsRJnSv+k3TPwudG7Qh9/zGUEcpmC73qcVyQ=;
        b=fiGlru31F3iNRJImuBH4ABZhXk075w1sVkglkWlhWJNKfdKl8OJVx3SHJC48WIrRPf
         rg5X+V/dEb68eVSsVhttJ/Kc1pTayX45Tlzj8boC49G1ToN+6PX3l6ot3H7iNS3FZYU5
         9/Ghh+p6aWQWVqXQ2Xbgkvo3H9a+ILDYz0HO+eCx5/1ComR/0ovCE0xhy2b49xU7VxWP
         HwSPR4iwH5sWkxdxawc3QxVp+gVAxJuLOfo+NTpnFTNUBo1pQ+KdoOdlkzTHT5GSRQC8
         yxp0O/s86ipGgC0wc9i40ErsMqdHo+Qe2f49mFF/MedtXCq66YIs4x4r0sfpvI2SINKu
         zRjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748576248; x=1749181048;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uMZpc9ivsRJnSv+k3TPwudG7Qh9/zGUEcpmC73qcVyQ=;
        b=HV0LkRciTb6ClSiw0ljzqtJuof8fP+OV9R2wu2U9CI0T/IDn51NPlDgwGfjkSUWh2G
         8B8usJnRx5K9CZ+QbI/wIEBvmT+LNWI9m96NZelGlTN0Jbp/QI63Ee/th0AxDuewL7RO
         Cuczz93K/9Viu56RAy8gWeKtkU0un+PQZ4CYvgwRGw78Uns44ZiGAQ+GXqqdgt6WnM4s
         UEom24LL9tUKXKRQ2jyBULM8pfWONHIhH1wQg38OZDAiGWz7Z/88uzSzuBI5Azc8Usd9
         FFyWHgBd6Y7MLzzt5Ca2Whdwlx9WN1wnO6s0tuES3zdW+HuuXZL9gQ2q4vj4MwTUdCET
         lfHg==
X-Forwarded-Encrypted: i=1; AJvYcCXrf4tMZKxHj2ApAiKwcDeav54Lh1VLy6+Mn6GiFOtJCdr+kzULgbLa7O8aci0eR2Q1mXBqwINfnECY1JFMAdU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEMyiOetW9q4Nm33u5eGG8CnRhtudvTEXJbfRh407K+FxmST0m
	p4HbvAzh0zpDetQhNuhLUGoaOILJxnT2krH0BNRbV7e0tQyjcRcXFC/gfmLOaQwf
X-Gm-Gg: ASbGnct680jgu64L5Gh8AsvOAGFRcep0XBEUdTVX3+gAbCVbwWnU/dxmWlaABA276Lf
	KYX9G9AXws5ODFzQgZzeCqQ7mHUtv9VWIMOlshJqXRBUX7i72mMh3BcqgcnIjpkUa/3AjmkYpeq
	pixh6yXo6F+f8J8MnfH2u8/hAFdisf2zi4Vq7eSGFA3F7gx2uJzigeH3lc32WovRP7mcCZbhycJ
	p5VR0nFotGuwCP/dFWuNi7c1ts51fGgEPnmvzeQO1/kr5FsdAndGfA/380hZLChNQy5eIevDDRZ
	+RrNq9GNNw2qV5I57VIkJcpNTE51pcwxykTCtCVcQ4eeDEfDI8h7y8O0vASVDlvIk8ZPGw3qlqN
	UgzFjPqWl
X-Google-Smtp-Source: AGHT+IH8AuGzRmadBISmtattLlS42nxY3GQAok0rPcHHGrl0u0S0IJ2cRAr1G+vYLGJuCN4SbGab6g==
X-Received: by 2002:a05:620a:8019:b0:7d0:a10c:95af with SMTP id af79cd13be357-7d0a1fcdef7mr344724785a.13.1748576237461;
        Thu, 29 May 2025 20:37:17 -0700 (PDT)
Received: from fedora (syn-075-188-033-214.res.spectrum.com. [75.188.33.214])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d09a0e403dsm169697485a.16.2025.05.29.20.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 May 2025 20:37:17 -0700 (PDT)
Date: Thu, 29 May 2025 23:37:15 -0400
From: Shaun Brady <brady.1345@gmail.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, pablo@netfilter.org,
	kadlec@netfilter.org, David Miller <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [BUG REPORT] netfilter: DNS/SNAT Issue in Kubernetes Environment
Message-ID: <aDkn64xDW6J7R1NS@fedora>
References: <CALOAHbBj9_TBOQUEX-4CFK_AHp0v6mRETfCw6uWQ0zYB1sBczQ@mail.gmail.com>
 <aDeftvfuOufo5kdw@fedora>
 <aDj_oGBSNIUFEZFF@strlen.de>
 <CALOAHbBhSAO5aQ=mf8Dn0=MViWQNbCy9zyDx=UF-dbx_dHKH4A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbBhSAO5aQ=mf8Dn0=MViWQNbCy9zyDx=UF-dbx_dHKH4A@mail.gmail.com>

On Fri, May 30, 2025 at 10:44:32AM +0800, Yafang Shao wrote:
> 
> JFYI
> After applying this additional patch, the NAT source port is
> reallocated to a new random port again in my case.
> 

Not surprisingly, it fixed the test case I had too (I think they are
functionally equivalent).  I'll update the bugzilla to report a fix
inbound.


SB
