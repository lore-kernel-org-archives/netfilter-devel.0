Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA82C3BFAD9
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Oct 2026 04:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790829600; cv=pass; b=YXlsAX7lFhtU/+98oYQngo1xNAYxl31yz4Q8Ag4wUIg9I6NMXFvfDAu/vQoZQqkXtUE//pa/5TC/AESDapC8n2+eEtb5sUaPjReC/sE3l8WqcSPVSqdKKrBLaVzFFfpcPuay5AgjSGQPGjeCozp9AALIByHPn9+UjV4QCNDmMRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790829600; c=relaxed/simple;
	bh=nDas30tPSxRmkTZarnFIxktE9WqOwZyfqBZjaJOotF8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A409VG6wGD9UPpo6e9Ck/RF4Xrz0Kt/hb9FCrzN1+1BgEJ3hGQxk9XlIbLUhKUWIgHT++OgS0TGPqLVzTXe8XfGE1eqY0Gngzdo/8lAWijN5UW5q8CF2qP1Zjm8k7TN6tLGGaVI6Wiwfz6V+bVy6ZerTcY6aBXWGinkyqK5yjRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UiEcbkyV; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UiEcbkyV"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c293c683202so875983166b.3
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2026 21:39:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790829597; cv=none;
        d=google.com; s=arc-20260327;
        b=lVU9/0auXdKXxttE8EBP10upIM8RMWGwkTgbFdHI9aUrYmMJvQ7Ry5RSjkM7T+rQfW
         YjL/O5coe5EMpDbAHEZUm69oFnTWLdgFp+1BwdJ9a60nQ984t1Uux+5gr9u0KVl5cqN1
         uPPCUoS+kslnCFQoMCKKzBE/KzQR+YDvJsSti3cllO6dtqeTtRgBxdBuB6q4oUw8t2eq
         riAUakfYbN4P4lL5CyBGRxkGhnnZoIqlcAu9sr376UD/IhUO79iIsS3er6HrtlpDkV9r
         XiWpRM919zYPTU8/J6v6JTbWm1pBWFYV0jfAlWKQhxgl7ckMMBChp6oEr6vvnxHtCuJC
         4Wcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=nDas30tPSxRmkTZarnFIxktE9WqOwZyfqBZjaJOotF8=;
        fh=8rUK/wgONi7Rpu/tWE6ySJgvXJnk1LaE73iLq6XkpIY=;
        b=KYbgZoSrLZGmFd3aKCfVSEK/+nRyx9bbws9qN8+upVfwThOy+vrIacJAxV1Nf921ae
         4FXew95PdwHhoy8nXGaT1s0HcKoEFeHUKG5oDXircMJ8im4kc0zYusLti3+TYmiEGzxQ
         8jdo/9J1VUp+JOQMl/Us1WZ/IiJ8EOKUD4eeUOS65O/ECkeSHGRwTQWXKZZs6VWk/pmz
         dxq2IqMI2wgi2/Hp9A+skUwxAsqLgDLNbW9TkVm851lgFz250H/S+K6rVgW4cJaEW79b
         hH+i11uNp9i7PhbE6DcYojLPG+MbIJ6Buz+cRgUmARObp7mNDg362z7DS7ElBDOMtkNb
         v9UQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790829597; x=1791434397; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nDas30tPSxRmkTZarnFIxktE9WqOwZyfqBZjaJOotF8=;
        b=UiEcbkyVNIUMhWJVyn+9JG0V7GlKzWDUqST50o7uZbjD2aP3yc1bGkMz3mv3rlWMri
         ddG01q47E5ZAaz0GjpeO4mkwku5DtuP1CCndIEf3hNB8ix2tQZFtJsYk7Q5zEDB5pNso
         nILZBHRjr8bB1vieZEe9QiHf4qDwCUdrfD5CKuvNXEOH+WXjqwqYGtYx9J+ImxAcgn3l
         AUzMFApvIVTiZ5zpZF7hcqWrgrMyorV0WxntmOvWrKoKCuzWkAwmR3nQHEBA/cYwOGcA
         /yFQP25txJiyYT28rPGPYqnzpt5BmfexCyC4lPWwgG/WQ4l+pPHoJAJ+aelDJbdP9hWs
         OgQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790829597; x=1791434397;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=nDas30tPSxRmkTZarnFIxktE9WqOwZyfqBZjaJOotF8=;
        b=h3Ha2QpZghjoUXR/PwtReetupivGqPD4EtH0RcFoqckXggSCvkhlvwMcvjxGH2VZ1K
         iHNqPaR37Q7kB6aamVP9Wxkhb79Ug4iUIy3maxXaoEIUashmkDwdFB8DpfU5sSJbOW5X
         AG/RMyrQBpNivjxQmTJqczP9BYs/saH6Ew3yifqdFOy6eC7cIEGJ25M0Gm1rdVfxwdaU
         eCb7J5/0hlCd7jt1uEEdTQpb6nzbBYe6HHE7Ww1WDWcz5A/WoN19oofuQ/msX7OFIVBu
         RVn8cds0wnTian+M38SXADIO90palVgtZIHmvdZYbyqf9RZem8+Ehek8pCzZu3CvI1Go
         tDfw==
X-Forwarded-Encrypted: i=1; AKwUvBzUIGHKOmmKhUjBKH9bXObfp9SMEV8yYTzhz6J1kPg28WiBoj7pa5Bw3+2GJ5+4OQQAyLB9XwqF9Mgfk6Ier54=@vger.kernel.org
X-Gm-Message-State: AFuF++lZnyXacW+6szQWkNYyGdXqwX05g3azLSuFCYsT86EyibQY70Yg
	Eo981HGrdJIlGDQZE6ccodRwJ2tELKxfErKuJ29UqeynqfY/iRnYlnw8xSCxnHrwfyPOq2FaHj6
	LogrEn3L7DGK2G4UoUng4i9w6kvt1qhU=
X-Gm-Gg: AYBFou3gaAvQ5ln/agxNn9FIAzEMZEq4x3bg449wgcj++QPO7u9QeCTNCZkMLXf5378
	wLTk9DOqkYygmPGk6WSSNh2Fi6vMfv3ValgNpUob9mTp48MMAOl4FhlgnX6Umioff5KZyAzwvyC
	OE82KjPQeCtwZfOW6Fm39aBn7OqAGChzTATHBQZekNsDEkb7r7Y59dfskjIbCubpH7zNiuM8GxH
	ItliY/e4B7Yp3FLujiQ8J3TOiS9KmCnRsy5FR2Uk+uZGqeD0+RNKFKykQtv608eYFUcnG16LmO5
	jIg/Hk2rcP0LAhUjBtwhr7udIG4yasoEgQYLAe+u7yxVw7EtCrK3sN/F
X-Received: by 2002:a17:907:6d25:b0:c2d:c739:30e0 with SMTP id
 a640c23a62f3a-c2e23e24b86mr265473566b.38.1790829596884; Wed, 30 Sep 2026
 21:39:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHeizqHDqx3ue1=0QL92ef+6C63Ur+v1Z=d93smgdD5zTj_-Pw@mail.gmail.com>
 <arORyXjxvZUoEAIw@chamomile> <CAHeizqF--yGMCLGBEv9f7Gs=dmbZO6+DwSh7KZjpDgbNonCotA@mail.gmail.com>
In-Reply-To: <CAHeizqF--yGMCLGBEv9f7Gs=dmbZO6+DwSh7KZjpDgbNonCotA@mail.gmail.com>
From: Subham Pal <subhampal789@gmail.com>
Date: Thu, 1 Oct 2026 10:09:45 +0530
X-Gm-Features: AclHuK-y1tLB80ZNINzXQ6UtPI8XoZSzzsSAP0Y8v4QLKDC9gVJNA8sSucY42gE
Message-ID: <CAHeizqEqOx_bTJdNaUYGc1Mc_dcWbY6ybJNmo9uKMcyBPVLS1g@mail.gmail.com>
Subject: Re: [PATCH net 0/2] netfilter: nf_conntrack_h323: fixes for NAT
 bypass and ASN.1 decode
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: fw@strlen.de, phil@nwl.cc, kaber@trash.net, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	stable@vger.kernel.org, Subham Pal <subhampal789@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi Pablo,

Just following up to check if there are any remaining questions or queries,
regarding the multi-vendor testbed I described, or if the series is
ready to be applied.

Thanks,
Subham Pal
