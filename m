Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7865614286
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 04:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728706112; cv=none; b=TIIYd+L76zElsUviT+vNWWF7SHWN6llpEDWFlUOfh/r+09N/i8Qjx1oKzTjGUibdCq7A8nhtF1rqGjRUa52oHFRsM6M27/NAXj7vTbtC1sppjI2CgbonUxGAteqbNIvA0vlrB+zsAlVAyuAOF1VD6RFq30iBN9PcRrVp9RoAl/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728706112; c=relaxed/simple;
	bh=JJwV2oxVp6yNg+K6DgnJ6t+kMUOM7woJQ0xjrJo100M=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oh3GHI3NAKg1/OAgvbVOrptR3hgwbfsMRtvM8Y+5/GGOL77CUsswjY946uDkCdWGxmZOH7hQ5Kk2lpZeSgt9lO+IkljyjMMaAZJ+OatvqiXtz9aO38qU4EeDQhfFJ6PfXqHH85TvEAn7NpZJ407Ff7dvQW54azYVNYH5XuEYPbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EoeGkmAz; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EoeGkmAz"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-20c9978a221so20688085ad.1
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2024 21:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728706110; x=1729310910; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JJwV2oxVp6yNg+K6DgnJ6t+kMUOM7woJQ0xjrJo100M=;
        b=EoeGkmAzWjoCNeQspm8/et/ksSV4/jF/yUF6X8gUi7xSouHEhQJSuRpDO2kYwHZzIC
         FlOS63JD7o8Pw8Eh3V5qYARTo/baQVQ8c2AMwqhjnX/mljbDfIs2zwkHr6BauaZTEaex
         xUdjCKFbNtYZJXlGCRL8Ifuq4JzIs6nxbVwS8i1BioqYswwhdco3tcSBns5HeYXcOnVr
         gKqE8H576drcr13Eg1LeVxjQxiK0Z2IifNjLNUJV5HDJeb6nMfeYST4Luy2JsCZ8vqFG
         nplb5UBRE7gDATPlVouslsuXinDtYnX85bx1B3VTiPCXewijmg6FwQtG6VTtrYZqf3vq
         OZNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728706110; x=1729310910;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JJwV2oxVp6yNg+K6DgnJ6t+kMUOM7woJQ0xjrJo100M=;
        b=fdurrzIQ+SiqM4xgSYDn3aaigBmEwoI/jTbksaikk15y+D16dpGqo3ACvO/4wrD5c7
         bu/ml7s+hOUQ7Jk07v0vn/CHjTdjG69lK23ALLd9W27RZGwirr898vjuIFa26uzmjuO+
         IqwIZ1WJ7Kt5vu0Uyi8PTAYQ2KNzgDazQlq844p3DU9ai3430WkSSKQbGjS77j7tta3Y
         Ct9RSkwqNh9Z7mlR3yqvElw+YruukNTR5u2e/ec00WXzL/tsLCG7eRXkHjzfzWh7pyGu
         sb9pkJijVo3HoLi8g8L5tYgENZA4pzetvqnK9Jjugzx45I44vsVj4AsQg4XYFlSX6ZD8
         9/eA==
X-Forwarded-Encrypted: i=1; AJvYcCUivFqKyvbbc4GFD5knmxWoMKy1z+5NDsOLwbezhBdIUK3hHB0yGTNpumkwCxNDcU83+Tft/DelA1Hcm5wmSxM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj0rhEoYrJRKoQauHgNbkxJwDLWazFvgfKEHLFg252sE7W9R+z
	TbxuWzZMQEaFP+7MknHWohCeUAbggbgnZVt0feMvebvZWIs1xjHDmFyr9w==
X-Google-Smtp-Source: AGHT+IHOVxIXu+lgotAeDL2SWjY5KY77vHUtP36k6Q/DaiHcrcYQNoYIz8ECNHDd93MYN0K9s+zu0Q==
X-Received: by 2002:a17:902:d504:b0:20c:5cb1:ddf0 with SMTP id d9443c01a7336-20ca142a258mr74079785ad.10.1728706109733;
        Fri, 11 Oct 2024 21:08:29 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c212ff5sm30933455ad.190.2024.10.11.21.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2024 21:08:29 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Sat, 12 Oct 2024 15:08:25 +1100
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] build: add missing backslash to
 build_man.sh
Message-ID: <Zwn2OfIZW0sqE2Yd@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20241004040639.14989-1-duncan_roe@optusnet.com.au>
 <Zv_rJM6_dyCVA7KU@orbyte.nwl.cc>
 <ZwMi1knK7rqs+iEy@slk15.local.net>
 <ZwPS-3s2-wUcVBzU@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwPS-3s2-wUcVBzU@orbyte.nwl.cc>

Hi Phil,

On Mon, Oct 07, 2024 at 02:24:27PM +0200, Phil Sutter wrote:
> On Mon, Oct 07, 2024 at 10:52:54AM +1100, Duncan Roe wrote:
> > I'm happy to do it either way, LMK your preference.
>
> I don't have any, just stumbled upon this feature when checking for
> when/why unescaped backslashes are interpreted or not.
>
I'll leave it as_is then.

Can somebody please apply this patch?

Cheers ... Duncan.
