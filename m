Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D7B219E8
	for <netfilter-devel@vger.kernel.org>; Mon,  3 Jun 2024 06:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717395909; cv=none; b=euqD5cyOp0+blSmI+yE3iBBhWP6HVYkQl8T4hIdK8ooBHivOPaeeaiDpN02l1D8NMp4c45/buA/ejXuRc7g0jbLoCrXXSnGqW7CzepFufdGFtOEfA23OizvOq1r2dZgynNE41NqF6EpAR/6IcN+XSB70QjkYoWBfUYGthBym5tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717395909; c=relaxed/simple;
	bh=ExwE1fzElzuSGQd2fKPnl2VHsSCEX7YIXIslNWYFh5U=;
	h=From:Date:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=BYVVVrvQSorWHOKRyb1JEZKVW65KUZiEcuDgbJrcnJdqaOVEkDtq8tss4eKL+s0CqehMj+O6rp9lxP6exD7Is8UzGMWiNi1SY/alwDqvyB98avZWNGorLhwOo65seTvt/rn/LvOYUMaKphZI/eNYrQ3adzVppZ+vanm+ytsMVfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gsi3z2G2; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gsi3z2G2"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7024791a950so1630510b3a.0
        for <netfilter-devel@vger.kernel.org>; Sun, 02 Jun 2024 23:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717395907; x=1718000707; darn=vger.kernel.org;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:cc:to:date:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ExwE1fzElzuSGQd2fKPnl2VHsSCEX7YIXIslNWYFh5U=;
        b=Gsi3z2G2J4NRqdVhbTQa5gin436a0TRY9RwfOvZE7UUpHe8I/MkqxTaiJIw6W/FB/Q
         XVtqAumkA7n37KoYSmOXpJ+QrK3MxXFtsI9GSoXEMM4EBB+vZjhTXDXSEPnX1Szfznyi
         GuCd9kkzh5OKcYcFk4qMRjs+iS6WamMdE74YBXkIUhlHdaBlsx4wHs/Wgg547LjpBt2d
         cLtLpbsLcOO+650G3LPbnePDCVtHY/JA3uiBgwd+o7bOFQ7fK0OlfMbUB3zbSARSl3GO
         APKcbi6sYmq5Zg2gr651BkUgzxVJWnkE0TkQWmVyKh1XfgYHH0txIXw+e9FLu08d+xIJ
         oWaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717395907; x=1718000707;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:cc:to:date:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ExwE1fzElzuSGQd2fKPnl2VHsSCEX7YIXIslNWYFh5U=;
        b=i2s9rh6pEQjVdlbqpWMNd33bKwx0PyJI5a8JGhbsvCj2WWIgxQep/85Q/0e303ibBF
         9JH2EbYmHyIHCn8A4e+iId9ZLhTknwfI4xNIE5p4cm87wvUghjRViJrDrCiMw4VN4v0e
         raMT2s9kYJidsudTNOtj/VcqoINm5ZaQCwrhuwlZUjHfZ2rcn9o8CRWask1j7jzSLAv0
         c8Nb5BIBCUa4/2uA9i3mEO3DC3WXlUyrblHDYY5/+WUnz9fOuAKxR6Z21Q075dtwnEQH
         P6X68XFoJlISfBQI5NWwDinQA3N/DwkIZ8vxwf/sVBY8sYqFFXjtRPH+SgjChYW8eQQo
         bI5w==
X-Gm-Message-State: AOJu0YxHr6LdkPAgPtnEmcx7JARwDk6+1bxzu60rdO53/KExHiCcw0uQ
	Lpqhbab9WrRIUGjOzmllnuovZlfk2Q3oC8a6PFZtly6h2NquhZAzYmIrsA==
X-Google-Smtp-Source: AGHT+IHY3PqG6+ZyOWtHUyGcUdltvcQZtxqRcY098eeGH5lKd4q5vUIW9dhUIAFOXC7CgtKfbvdByQ==
X-Received: by 2002:a17:902:cccb:b0:1f4:75ec:9968 with SMTP id d9443c01a7336-1f61be6be90mr182880685ad.16.1717395906975;
        Sun, 02 Jun 2024 23:25:06 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6344d5d59sm55616125ad.241.2024.06.02.23.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jun 2024 23:25:06 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Mon, 3 Jun 2024 16:25:03 +1000
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: libnetfilter_queue patch ping
Message-ID: <Zl1hv+2qBAr4QkCP@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pablo,

I sent
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240506231719.9589-1-duncan_roe@optusnet.com.au/
to the list.

Did you see it? Patchwork picked it up, but I never saw it from the list.

It's a small and surely uncontroversial fix of a memory leak in nfq_close().

Cheers ... Duncan.
