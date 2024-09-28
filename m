Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C5EC139
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Sep 2024 12:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727526439; cv=none; b=rWsLaMUjhshnf/iS+PMQgOlJ/T+Gkm5jTUMfKFQ7gfmU5oiO6mXtK1mmERxAIvF0b5a1D2WpBZqQb9u32lZGZkI3AUdFl49d3ezUCR1yDJxOdHWheANs1PEXlscF9RuPJqYSrnm+gDSHMnJfxtXp7fCgf/IPAfSWZXZIRylceJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727526439; c=relaxed/simple;
	bh=ZPFUfAw2NdP21fpCL1c63sj/jf8cxcu7YLILwX2yixM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u9eKnVta+6epgV6nQjmIz5A+tZktr4/bWQvmRyRqYwO7X7RTcl6CSC1WwUjVtKVArj/2yWZLMWolsSodfYmP1EkI80ib4RJDl8yrd1cpM+7ewv0IZpCm/HldeCs2eFPci8Oa4ynG+eXKcAEiiIxLJ9ryapgCzu5PAmyNMnz6Xio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bTVVOwKK; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bTVVOwKK"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4582c4aa2c2so20445661cf.0
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Sep 2024 05:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727526437; x=1728131237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0PLAj1gPXy5El6Ya6lcV4fblrWrlf+a6FGDh2pAIVtI=;
        b=bTVVOwKKLEpNds2EYO5y9Z88lC49HpgTtAKdINGqMOu90ibHK4MB8CLEp+hPbXaYd0
         0LqZg88tFgQOUR242g81+mrfw7FEuUUtgWkjkyGt+lqctj3WmfZPN1ZLKClUjynE1ty9
         +pApzF6o9Wq8uJg3RybTm4XL6eT8rzlmfPoxSNz4Fo5VOknpql0dlKWA615XvVtBMZOB
         KG7xkjuf/h76j9aGg0nu59nv3T22wIi6xQ1lv3JkDExMucNE3Jrxu4u/cUBhM2w1VhT6
         uahQoHoyZKoAMvq8molm8hAcUl/zZkBUAj+532uAhvv9+tri/nnIxC3mb1al3xjQsjex
         0taQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727526437; x=1728131237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0PLAj1gPXy5El6Ya6lcV4fblrWrlf+a6FGDh2pAIVtI=;
        b=UKNduYCCJg+dQ07KEKcuZgG0gEDXDgFX+rEEt0AShPY/vDYYt2EaMkh3FqMQga/RYe
         XFI0x0lI1bIZXFo0jEG1JH2nUr/QkdJ49UrSvGXkZgMO3M6pC3JV5om+o7WYIBVvmAir
         UoogPFdfUPcHA4lvE/1WjkPlMwQGlQHj4oTtkjgP2H8V7/jSqyeHVicOVen0K9jziFG/
         Gn9ASZktdV64sIGuBWS2+EV6yGRTS+jvQgxE7fY+6rsC4roS5ScrntY1WNRJ+/m6WBF2
         aeGPnJM5AXU/4SgDnBgwxmQdDxrYfA4qsHttN7rqdyNXFPo1Le1y/JDsj3mJ9aEuJggW
         PHqA==
X-Gm-Message-State: AOJu0YwHf8JpQXsEDxZ4F0tPI7tLZKCu6faVy9etBosv1uD+BrRjdV76
	NHptS63WIMUMMR5hnQnz01/letajuzgNVT2H7VRDn4baV8FdIN5hVQ+XfuCU
X-Google-Smtp-Source: AGHT+IGmueeR2zk+2T321K9yxlVkb223SneAnfgLY+fseFtFZc3AVDkUmUxwp+Di0isv+R8Q1GBDUg==
X-Received: by 2002:a05:622a:1a27:b0:458:4c86:455d with SMTP id d75a77b69052e-45c9f319252mr76231081cf.52.1727526436966;
        Sat, 28 Sep 2024 05:27:16 -0700 (PDT)
Received: from playground ([204.111.179.234])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45c9f2bd3fasm17108681cf.33.2024.09.28.05.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2024 05:27:16 -0700 (PDT)
Date: Sat, 28 Sep 2024 08:27:13 -0400
From: <imnozi@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: iptables 1.8.10 translate error
Message-ID: <20240928082713.3f394112@playground>
In-Reply-To: <20240928085851.GA18031@breakpoint.cc>
References: <20240928001227.2b9b7e76@playground>
	<20240928085851.GA18031@breakpoint.cc>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Ah. Does iptables now auto-insert a space between the prefix and the message? 1.6.0 didn't, which is why I added those spaces years ago.

But then, how does iptables-translate grouse about the '"' being a bad arg if the shell strips the quotes out?

I suppose I could try putting a naked "\ " at the end of the prefix; maybe that would work.

N


On Sat, 28 Sep 2024 10:58:51 +0200
Florian Westphal <fw@strlen.de> wrote:

> imnozi@gmail.com <imnozi@gmail.com> wrote:
> > In iptables v1.8.10, iptables-translate has a small parse error; it doesn't like log prefix that has a trailing space:  
> 
> > [root@kvm64-62 sbin]# iptables-save|grep -- "^-.*LOG" |while read a; do echo -e "\n$a"; iptables-translate $a;done
> > 
> > -A invdrop -j LOG --log-prefix "Denied-by-mangle:invdrop "
> > Bad argument `"'  
> 
> Thats because iptables doesn't support it either:
> 
> iptables -A INPUT -j LOG --log-prefix \"Denied-by-filter:rstr_rem \"
> Bad argument `"'
> 
> This works with iptables -A ... because shell removes the "" before
> passing it on to iptables, so you could amend your script to use
> bash -c "iptables -A ...".
> 
> or, simpler yet, try:
> 
> iptables-save | iptables-restore-translate -f /dev/stdin
> 
> This should work.

