Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01CB7462;
	Thu,  2 Jan 2025 07:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735804507; cv=none; b=h2IkPSWjGtA5upviDhpdlWtFBmFBny2fWSKWCwAO8//IsXYmAodCmnX0ciVNQ1Z3a0hcDKdk1obiQ4r+pK6UOUvolhd5pw6Su21WdLlHVMDG4zQxEm8+0UJ/sWwM2dSBrFxcEMIlTaFwEZSLgBCP9HSsE4ad3n14yUTKuibqgsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735804507; c=relaxed/simple;
	bh=NVFfblbS3lMcWK/GL8mdFjfUXmqxf9KDwkl4KTFviu8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oUf6ELbD1tHJse4T/6OuZdpivtgMX6JClYLaika3qi67hD77hPapl4/pYOlq50Y4vv6K991DPtvHyEJZ9n6b2eT6GTclrzmB6oilKp60oA8sGXYA24KYpTxuByFTeARvgmVWavNa7A1+PR5rUPVkHjBoHRe7eBO6cGrj36TGGjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MzGZZZF8; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MzGZZZF8"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-385d7f19f20so4915726f8f.1;
        Wed, 01 Jan 2025 23:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735804504; x=1736409304; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=21PdAWMAUs+juBjbrgiF/HUrZBkf63En0qTbwNFDMII=;
        b=MzGZZZF8cMiZNUBszhNK5wExr+UutVWoG1UrgXkKK5PXVcH7XWr3NDae10N3ZJjCD4
         5Cbr2FvmM7riHv93t9ThBZqxs/M5tpg+yk0GnK9DeSU6a3ffcJ4yyMftS+BGTSpzqg7U
         I0v8vK2z8uiA/fArdEYyiz8mZva2jboGqqn3LEXfz0VblfYOzqIM2ACIqVOUb1RGZXmR
         jdoA4B1wQx76TNzWYXg1eizvPsb22kBYPh534nVGsp1OWYDHN4pLHORFkT8Xq3XBgWzW
         6L/b8H9XChtZ0CflbdxLIXpHndOMJlD/orYzxOYxVVr9GZc4PMANnL/I6RBwGcruM3KQ
         SSRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735804504; x=1736409304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=21PdAWMAUs+juBjbrgiF/HUrZBkf63En0qTbwNFDMII=;
        b=HOxoeT998ft8Cyll5e5iMGMLhNlx1JSn19noPjv02daoAuh1xs27TgqrGvrur4kjRf
         oxPP+2GFCqWOOYZ8PxCBcwzppy1SoM+I+XvOPn9njIXI/1ZspfRCmzcRO4zSHf3ntGoR
         JN/IdnyEzKxMvs2KLx1q/ZSu0mWeDH1XW5CIaekjqqJjRO8whn3Ihp63NwbBEDfVCA3B
         gUVUK6xnF16bCl8YUOTDPYAuUoZ90nFjjTgQnC1+1N2tPR3j2WB/37fT3/5nMLZfT/G7
         AObKQ4f0D3n7iEx/r7EqIdwsqD5J1nxPwIstCEKBvwi/x9Vvx1SKJj7+2B1TrCoThI2I
         xDDQ==
X-Forwarded-Encrypted: i=1; AJvYcCX57OVxlSWwkrvNHpD1p0vV+LXezZ7118JQ1ufvGuU1hmubmBw1J4M3+eaJ1jDeQG6y8cstrZ3f@vger.kernel.org, AJvYcCXGaEJLbUZwPp5ylLqINBp6dLI1UEYZ605P40X7uYQwyYs4vaTLQbhpGB87rqsRWhdrxu4nCSvVPOX33wk=@vger.kernel.org, AJvYcCXYTbxwvZXV1xs5d7MD76NlLU+t2VgmFjAkbPc2qphOeJAhNWTRek4rY/Z0JppaOOM1YdmmNfFHQTFHxqP+mw4s@vger.kernel.org
X-Gm-Message-State: AOJu0Yx43TjVFZYR94iRLps2QKFUnntSsKiuhmPVDsnZ1AO8jNOUEu4H
	TqDmkebGAGi8S4VHpBslZL10pDTc0mFxCJ4MrKMvnrl7d/I0vcKF
X-Gm-Gg: ASbGncthat9J6TFLIAFRBIxJqmUw6BSZtTQxuOyUnPRMyhXFP7bgMyWlW5AsagfEeJV
	k/7DV8QI97f5l7F8S4OktCDQtdouAxqnGTrZjMrYvymuKDCUxQwpJlnR9ERxyaLHpYbg9AOcTDJ
	5STVEIEA6pW/LGFVrkGZXNjHf/QsAaL9Zr664oBwBtnxzKeeNW45slfEhbAIHWmlbZK/M3Voef+
	ahLV6D5xP2rk5RvBHt5LLucIuyUd5zrdLwxsL4gIwq9unWpW6JzS0ibk2uMa8aq42wJTsmxnCcm
	bhwbUPAqrzm4ejyhQtuDVZ4=
X-Google-Smtp-Source: AGHT+IFS3ftjCGfPxOh+oOILCCwBruzBoy47uyjrGLknOFy7mfJf06BTNHs52HcejXh2iAiLvau77g==
X-Received: by 2002:adf:b30d:0:b0:38a:5122:5a07 with SMTP id ffacd0b85a97d-38a51225b64mr11240653f8f.15.1735804503927;
        Wed, 01 Jan 2025 23:55:03 -0800 (PST)
Received: from dsl-u17-10 (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c833280sm37575763f8f.40.2025.01.01.23.55.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 Jan 2025 23:55:03 -0800 (PST)
Date: Thu, 2 Jan 2025 07:55:02 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: egyszeregy@freemail.hu, pablo@netfilter.org, lorenzo@kernel.org,
 daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com,
 kadlec@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: uapi: Merge xt_*.h/c and ipt_*.h which has
 same name.
Message-ID: <20250102075502.3b8fbc95@dsl-u17-10>
In-Reply-To: <20250101224644.GA18527@breakpoint.cc>
References: <20250101192015.1577-1-egyszeregy@freemail.hu>
	<20250101224644.GA18527@breakpoint.cc>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 1 Jan 2025 23:46:44 +0100
Florian Westphal <fw@strlen.de> wrote:

> egyszeregy@freemail.hu <egyszeregy@freemail.hu> wrote:
> >  /* match info */
> > -struct xt_dscp_info {
> > +struct xt_dscp_match_info {  
> 
> To add to what Jan already pointed out, such renames
> break UAPI, please don't do this.

Doesn't the header file rename also break UAPI?

	David

