Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D745733A
	for <netfilter-devel@vger.kernel.org>; Sun,  6 Oct 2024 14:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728225902; cv=none; b=S2W3c+S3jOVxMns9alQL3ojLBC7GuQsZejuYFUUsImCFlaePb5qBeHVLfTWlnXbOd3UsMLdeUf6OvXCarELLi5FEFMB9y1PEndVCst+/06urJXL7FOmghoc/fK36fkdVHB64d6ZA59fn9Kt+UX8p7PcfTNobllPetZe1DaIQC/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728225902; c=relaxed/simple;
	bh=+SiHnkbivDM10zUrQ5KbxvsTNdEofGFXbrAGSWnNnlg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gxXgO07DQUOGgemxD+Vc4Lmhtgw2IeUTMdY2ab3NgXrF+vIulvNrHNB6uHOJb3hK3iL5msPekCyypuKO0BAQAWqfVdEJmQ5UG7T3vKggu/tafBRsW4Yt+NknN92EbDaVbULIn6rqYrTY1IibXRO9pBSRfnfAU7tWbftV5PKuSNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=acWlaA88; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="acWlaA88"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3a3525ba6aaso10805445ab.2
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Oct 2024 07:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728225900; x=1728830700; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+SiHnkbivDM10zUrQ5KbxvsTNdEofGFXbrAGSWnNnlg=;
        b=acWlaA88cr2RxGWwZNC48nzibqVzJDvUWShhnzYPhBzHbn9Lnp/bUWx7XWWI3HIW05
         wHBjbQyzLJiz/arjjQGAAKxdQ1Z5lI9c1LrPeaJ3EkfKFekeOluOCl2WvL2dfqoxNu9f
         89zl2guWQCUTHucziHuooKtkoCUoW/WkrUkUokI+jQfQcC8tzhKaWA0GxiG/roSvAs6/
         FIPJFqcXOFezY1ivZyWtexZ4X1PvjEh++MYr01azq0gLkG8zcIDH11dXIyJRmOybcpln
         IHhYpfasQwmqpTlxW9fkDLahNC6swhectfMdlmTMtLNqjrOcsnm5d73DXO5rWaUj4Uni
         SZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728225900; x=1728830700;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+SiHnkbivDM10zUrQ5KbxvsTNdEofGFXbrAGSWnNnlg=;
        b=XARikBWGSZUZ1yb9MAnCJUKp+qiUYHdmGcleAGk8gkdZr9GCSPJoGIlXX3pb3OFqXO
         KR+CxYdQ0CCYUmEF1v0wlFa01I9xd5RSY9hnAe3KCxvH3zhCUwy/F3sFMe2YFX6FcF/s
         RH4MjD7P6/xPaNUuv9gqKNQpjmWQJXbpesFSXkTnSq/l7uKT6oKx7Rdq9l2yt+mzmF3b
         /tBxrYXEZbD/qFzFbtU8yNWHVKxhCwYZLLJmURxkKKLJoz1RcGd6du+O+LWToUSmDmRs
         Z0VQp/3Mn9cU5eHMO4NoLaOUqpEfB9FQ97eEl5E7g+CJybYtyWW5p/GhYR2oh1gaI1FV
         PoUA==
X-Gm-Message-State: AOJu0YxhSdTxogBjiHVlKGhGNzvvfvyKrBkUtu6KuVpUNMISc58vZ6u4
	ROAipv51A7WdbZkWtF+rVRxiMWcqmPrXq9DOsmdUcKBwat93MW2nZvFq8Qhh/k6fFoxgZVBwdG0
	fLU/Cv4/ZLl/9ByoZKnF4bQcoqbfB9Jpe
X-Google-Smtp-Source: AGHT+IF8P73NSqaaDeYP/H0rfX4wzFnjv/KXKikUmb7JaV6V4wtwiC/Vro5YZyO6lka3Io3oqCZJGSjEHEO2uRuY04A=
X-Received: by 2002:a05:6e02:148c:b0:3a0:4db0:ddbf with SMTP id
 e9e14a558f8ab-3a37599c6eemr74237815ab.8.1728225900326; Sun, 06 Oct 2024
 07:45:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240912185832.11962-1-pablo@netfilter.org> <CABhP=tY2ceRAiZd3UCN3LqU8ZSO1G1W236XW+2rC6QhpeA9dsw@mail.gmail.com>
 <CABhP=taUnE6nxQ1ZPradgk7iNt3M_LCcFoM251OhpEJsasCoSw@mail.gmail.com>
 <Zus9trdyfiTNk2NI@calendula> <CABhP=tbVrpr1MuYSubw4LKUNP=_PFap3CN9bc3M_mzo6yxeqpw@mail.gmail.com>
 <ZuwSwAqKgCB2a51-@calendula>
In-Reply-To: <ZuwSwAqKgCB2a51-@calendula>
From: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Date: Sun, 6 Oct 2024 16:44:23 +0200
Message-ID: <CABhP=tbA+m+xnDp8kQUMZE61zNwLekdnzP_5HJB7gaPzvC1OFg@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: reroute reinjected packets
 from postrouting
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

>
> It could be different scenario. I was expecting consistency in UDP packet
> distribution is a requirement, but I understood goal at this stage is
> to ensure packets are not dropped while dealing with clash resolution.
>
> I have applied Florian's patch to nf.git, thanks.

Is there a workaround I can apply in the meantime? kernels fixes take
a long time to be on users' distros and I have continuous reports
about this problem.

I was thinking that I can track the tuples in userspace and hold the
duplicate for some time, but I'm not sure this will completely solve
the problem and I want to consider this as a last resort.
Is there any feature in nftables that can help? any ideas/suggestions
I can explore?
