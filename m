Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AFE63B9
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Oct 2025 21:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759957318; cv=none; b=i98SbqrRisEbgcWnQWX6W+exvZwt0go6+hQCNcMxbkYSEkwPim2+Ln6lukFEMbk6aIOR/cyLh5IMH87R2v/Q2AnPl8WydApJub1mr3mcWmBpZYntQKsluj5FnuXOxiXvsHFV8VpvTg9qJ/1bn6DQD4nr6qLrog2bP1g9dtgn48Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759957318; c=relaxed/simple;
	bh=yjoG0nWHeJ/l0oPz3dHC9ZcV6U456US62dWQwfyxvQY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R5xQVkhINWAahdK5YgSSEhYtIkZEEoBEg5DSkndmwiGT15Via/KzoMT1mKP9XRxZ9YOAfx9r5BGCyQvgk/qhz76ZxiDIrpMrp+O99D/CadSOr8Z2dkzmFYJ7FaHQE2aLpon68/ODuXafFl8wsyhjYkUm1pRekOJ+sgKniySRwhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ee2WYsd1; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ee2WYsd1"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-875d55217a5so25218385a.2
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Oct 2025 14:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759957315; x=1760562115; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=60OsxgD4U9FITiBGJ6QPC9fN3MgqA/5HjaHm2BMKSsY=;
        b=Ee2WYsd1iERfe+ZdTTDX9fqhBTz+L9agOTBqbod3JaIkWIRVnpSoG5t85vYuaYc81y
         0ZB2UGRaRNpaiUsTWIbAvelkz1ge8Az1typxxLC5h7OIrrnhgz9e8XGKcUVR0gyg688S
         PdPKVqa4Bk41v2ujqPClwtdw3FTlU3tFMGrI+4OEtYBgPNINUGlfUe3G3/fYChMRvH1k
         OpHgGzYzDVUMYNJc9oWmFYFtmqsofSFCFTR4PijoYD2hMFzWerUqQDUFeKWqp408+lZV
         Jw0assOVp+8QQP5uVaXLXwCSuTETwT6cvBrgHHGcBjGStGIOZPKOYxJFMczV+aevxb43
         w1Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759957315; x=1760562115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=60OsxgD4U9FITiBGJ6QPC9fN3MgqA/5HjaHm2BMKSsY=;
        b=LF6B+sIrkk+r9J837Cw9wYc7zuXQTjDyiv+8/6M5zM4CZTnj/3eVUN+0pbQWwrAHXw
         2haDphtvsXLUaUb+tcfcBVZl9CwgpeBtOPjNq91NiVH3gxNlLksuMaWm6ExGiDD3G4E/
         5piH8tLXMJVN2o2kBe0ukpH/vZjt5u/BYfsSRRVvqeCgfoXGypfLhBN4tdcGwh+UxAKM
         crzGVeWo7Yi465Mf+JnN+lDIRuJ0vCN+CGsX7wUFiH7XeyyZnEqnU3ilZ/wcQ6Pfz/N7
         wDewpuVWfJ4UozUFY2dc4jTp9ts3/Es7gbCvPrw602bOweiDqZQhnp6fykagwyxQNJSK
         MzWg==
X-Gm-Message-State: AOJu0Yy6QYR7F1XIASMMivsvJzplRFiLj44l8br8qzHTHCF1rxjhKKGW
	m0oCIqWJ27QDFS/Ez+bfX+AYNH3E+883Bi9Wl/DoVqLolMgdJgATpnP7
X-Gm-Gg: ASbGncvpzOpvSc0R425oiUPWfBw0Dz8ntzpQ97tbiFk0jwXwh0gaozVmlLCIo2/tBIE
	kwGcUMTSa/kUH/OQWbhEtoAjufQhCDE/T5jNaNLZRPAy9QOXiyrgqKtpIas/OE0z4gECFBwajvx
	/ZByfDhFBmfLeUJtw02KbXekL4zUEYhoqikKrbUfaiks6IHuSAgPgj9Lf0l0Cd0Qxa7NuZZMHwJ
	FC/mSKGUJrNI5IFtUWujAMG3J5UJEtEiNBR6Nptn5WxWJ06I80+5yExWlzxr00YC3CR2HvqtSxX
	lU+CgYiFUOiZudeB81Ebn39EVXLB1rZ47xhd1KzJ5xLqvt43jJH3j/NmAJwu/21Hzx+eTwlcuLJ
	XO0LZB9Nwdrgx8PMTRot6j6cfb2sPyFwHPg+jdORK
X-Google-Smtp-Source: AGHT+IFundR4DNjz1TylTGwjxQCRlhfiy1A4aJPyVFzJHYA29dK6doqpqaD+FLMAxUw77WR7GbKBmg==
X-Received: by 2002:a05:620a:29c1:b0:863:ff43:bc26 with SMTP id af79cd13be357-88355a5397bmr881523185a.73.1759957315312;
        Wed, 08 Oct 2025 14:01:55 -0700 (PDT)
Received: from playground ([204.111.226.76])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8849f9ad8f2sm68424685a.20.2025.10.08.14.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 14:01:54 -0700 (PDT)
Date: Wed, 8 Oct 2025 17:01:52 -0400
From: <imnozi@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Subject: Re: nf-ct-list and nf-exp-delete
Message-ID: <20251008170152.7d8e13c0@playground>
In-Reply-To: <aOZP-v75f5yMTdrk@calendula>
References: <20251007051508.049e8821@playground>
	<aOT1NhYSS65KwwJD@calendula>
	<20251007184531.73f3404d@playground>
	<aOZP-v75f5yMTdrk@calendula>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 8 Oct 2025 13:50:18 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Tue, Oct 07, 2025 at 06:45:31PM -0400, imnozi@gmail.com wrote:
> > On Tue, 7 Oct 2025 13:10:46 +0200
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >   
> > > On Tue, Oct 07, 2025 at 05:15:08AM -0400, imnozi@gmail.com wrote:  
> > > > [iptables v1.8.7; old, but it's what I have.]
> > > > 
> > > > Why does 'nf-exp-delete -i [id]' *not* remove remove some conntrack entries even after being told to remove them multiple times? It deletes most entries for my purposes (if condition is met, delete conntrack entry and block the IP using ipset). Blocked IPs are DROPped on internet side, and RESET and REJECTed on the internal side. But from time to time, I see ESTABLISHED conns that don't get (can't be) deleted.  
> > > 
> > > nf-exp-delete -i [id] ????  
> > 
> > Given:
> > ----
> > # nf-ct-list --tcp-state=ESTABLISHED --reply-src=10.X.X.2 -f details
> > tcp ESTABLISHED 188.132.249.148:57992 -> 204.111.X.X:443 10.X.X.2:443 <- 188.132.249.148:57992 mark 17488 
> >     id 0xf016f3da family inet refcnt 1 timeout 10m 17s <ASSURED,DNAT>
> > ----
> > 
> > then:
> > ----
> > nf-exp-delete -i 0xf016f3da
> > ----
> > usually removes that entry from conntrack. In my experience, some entries are not, and cannot be, removed without drastic measures that would interrupt firewall operations.  
> 
> Where are these tools in the git netfilter.org repository ?
> 
> And how does this relate to iptables v1.8.7 as you claim ?

Sorry. My mistake. They are from the libnl package.

Please disregard.

N
