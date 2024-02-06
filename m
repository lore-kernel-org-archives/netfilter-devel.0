Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553B812F384
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Feb 2024 11:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707217458; cv=none; b=urXbzssGkygOaEcIXTBUcTywSASHCjQ5nDM4AJYYj+mKSyMtuqbYoSlzugPqJiEVeOT0t3t22Vko+49k1JzvH2zWJaqUjnuJw4c9yQ3Zjpybg/rmYQxphuMdIZ4Jub5iQNciy3B1Yc/5c+wFTSSc5h+fwdS/0StIC9bqMgLGo8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707217458; c=relaxed/simple;
	bh=x0pbIQk1qP8nN3+ZGiA3qhVlXb3liKdO9iZ/xJXSuMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cbl2vmfIzD60fTrTrB3UDss1aE+1TWF9tJ9Qn/tY8z79noeMDFJJsTu0nqkY4F6GUbIn8EgcCatTsr/Qr7yfYBywxr8461czbAAMStIMx6Nbjk2rXTBkPGO6y+2utoQMJ3lSp3xkUyZG45mmOoFPIigUW9onQxjUPIpDrHyRgk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hVWQbIC7; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hVWQbIC7"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a384a7e6103so1088066b.1
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Feb 2024 03:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707217454; x=1707822254; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=txJ4UfEaHG02zODZo80UumZhELeKYRvUYcjtXa7HnRM=;
        b=hVWQbIC7T6puE1VFjp9sEN9nnaS886cp5T1KAHNeQJHGHe10dnd+9YiVHbNDvjD/jE
         E0BxVBiwfpvkzuo2rTCOucLSL8/oCg3gOJ1wiZzBSuj63ElAOj3HiHjHNeYbi1r10nLy
         N4jhCjp2ZPt5MkWnMTGOo5NrZXqNqnbC8nRYz1Bhu24xyKaOwrXF/vLLUX5hhilICiCQ
         z84DBWNEnbsM/gNFEFjgGqemqslP2++gQYEng6ahu8YAm8hmSLcssqsGbc1nlopV+4Kq
         Mn6nm3sgaP4Q367S43cRxs1pO4a8Z7SqoKtMsVxKwMXA2iEcPyPzIX0EXcpvz0QrtBOk
         iV8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707217454; x=1707822254;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=txJ4UfEaHG02zODZo80UumZhELeKYRvUYcjtXa7HnRM=;
        b=NA4TnT+gFvhn6vnu4CbZmbRf5RPMCA99/kzJTzQfQjfvCK5qA89TAF8o+1SIgfD94j
         c1ZPKW9hg+3ylxsrx+T60Kl9Jvxe8Rj354aJim4SkDhRs26ZAoJV7Bos3Qpow5VgfazK
         jkRUbaAXA2Dzhm1qHDK4RTumpq4a7jFe+Z/Uy09Eg9m0LfA6ivtxHs7BeQb1iUF7tzF0
         Yty0CzfsBk7hM98TZ9ykMRwF85DKCIuRkKl5LhXV6XDrtejZLcFDc653iryrGaTefTGz
         zhqrakC9c51RfZXSMjP5fMJpOoEG9Ck2yU7kNSgiL2hN4qsumd6fR3l699bGSOCPGAXT
         0/+A==
X-Gm-Message-State: AOJu0YzgtOKnvLDV5nIDcgH2bYXYgEcMeimpLfum6Eff36S51q3UR8Il
	AnUNuWkmRbw2ax6zPCUcHqHSF+bJrTMg6iLnbJZq/hDQ+TwRA+WCMczUPGo3MoI=
X-Google-Smtp-Source: AGHT+IFFAR2gf7m60D9sS1D4EdhTLyYgZOu7Cfqa7RjFOFppqcibynNTRpxTea0HEnrawmpmS83y8Q==
X-Received: by 2002:a17:906:5ac8:b0:a36:917f:556e with SMTP id x8-20020a1709065ac800b00a36917f556emr1519178ejs.15.1707217454596;
        Tue, 06 Feb 2024 03:04:14 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCW+eTU1hVRe+dDWI0m3fgkor2XU3vpZXvDha5qQUKJtKz8d5lIw/sHS4Gxbk+qMN2jP9BT4hjHyGqC0lbjHI36V9FSBhKhURsIkoNoxKSYHcN9JYIhD+V6W+EMs9Ot60yde0RsBOWaG0V/Ol27awVPUWuCgmkXQxSPZvTWjomcxSOePUkKetQ6t1L85qdFge5egX4yjR2Gb4rpBt0YAHyTtTVbUbiQwHuXRjwo6j4tXAEQdkcOAvIZItmn6+NE3FCBGfJyQ9nn9F1TXRLTKXECQeQZoT4NH1jPMCv+ARxnqs5cDhCYwgemV1uS5RSlaojgEjHT1Tqq78HeLk7sshVIfaYgHFzkGdv8kngGvICfXAlsQiEUUXlNQV4QHdWwf7mUIg7TtSDkHeQh16qF8UNCGTu7BZXmUqIxzoObLMXLWd+Q+aXoEckx7KK4Xdxa4u9B5tm+c+83qkWA8s0ZkQTHQad5OOxt9QCY6+UKf
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id vb7-20020a170907d04700b00a354bb5f69csm998982ejc.220.2024.02.06.03.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 03:04:14 -0800 (PST)
Date: Tue, 6 Feb 2024 14:04:10 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Michal Kubecek <mkubecek@suse.cz>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, andrea.mattiazzo@suse.com
Subject: Re: [PATCH net] netfilter: nf_tables: fix pointer math issue in
 nft_byteorder_eval()
Message-ID: <032e2c72-c2a1-4b8b-96da-b0da73473648@moroto.mountain>
References: <15fdceb5-2de5-4453-98b3-cfa9d486e8da@moroto.mountain>
 <20240206104336.ctigqpkunom2ufmn@lion.mk-sys.cz>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240206104336.ctigqpkunom2ufmn@lion.mk-sys.cz>

On Tue, Feb 06, 2024 at 11:43:36AM +0100, Michal Kubecek wrote:
> 
> I stumbled upon this when the issue got a CVE id (sigh) and I share
> Andrea's (Cc-ed) concern that the fix is incomplete. While the fix,
> commit c301f0981fdd ("netfilter: nf_tables: fix pointer math issue in
> nft_byteorder_eval()") now, fixes the destination side, src is still
> a pointer to u32, i.e. we are reading 64-bit values with relative
> offsets which are multiples of 32 bits.
> 
> Shouldn't we fix this as well, e.g. like indicated below?
> 

Yep.  You're right.  Could you send that as a patch.

regards,
dan carpenter

