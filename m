Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF08317578
	for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2024 16:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709396829; cv=none; b=dQ+Bmgi8V21nS36ZbVOuaiwoOiKk35j3kfU1cavecAwBG4ZhYxAoEQBmFcTTmiaa/+lJjq+b48IFb/Kd/PmfORd/8GVRJrOC+mGm7M1VU8eUKPfJZ4dEib2AofWfSqBlQcu11BWDfGMo/GbD1tD7Bl3i7qlTxBY1v+hC72lyKBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709396829; c=relaxed/simple;
	bh=yIemghmUcjvAROwf/XYTNwNRaU5Q/WPOtN616b8Ib5Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ScEMw8Yira+T38v2gHOxhrgnha8kgvelgUwPUQeSUMyC+Tak7LRM/Xyx0s5wyE+SWd/5mZaVnHsv7qWbiAgXDPm3Xqo9ouu3HkdC+0I+JsMsVN2GwPCAdtkxmCVoEPb4Fwh0BO+OUHncg43xl0iHWFdZgHTuImHnDGeg3FtgHkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dnCrpkZQ; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dnCrpkZQ"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3652762edcfso12020775ab.2
        for <netfilter-devel@vger.kernel.org>; Sat, 02 Mar 2024 08:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709396827; x=1710001627; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yIemghmUcjvAROwf/XYTNwNRaU5Q/WPOtN616b8Ib5Y=;
        b=dnCrpkZQy3bKoOMOsGOtjwoHm+FYMkaJapGaYudBxmFrBF4bAZeX06uEJ7m8ch5wJZ
         J8xCZF7icZPDP0feHNEUm1WGeH6nDYIcq6KVhRvG+oUhXEnUexj8x4eu55Xj5wH9mK40
         93k2h30zLJecYsKN8+JkXXY9N1XhBlkpW9ps6/35k3nF6SrbMbblJuiORCGfiD5i9hoe
         wWvmp0jyMmUoUzXjT/bVF9RDOw2XCjd1SG5B6FWdhkmtDcXa3mTL/j/rPS3NeQVcR1/O
         VPNUVBeS4noNeznfTX9AdYNDOMozWXRzYIsZSPJe43jhoVjaVXY+p06izvLbZl7IMgj7
         3egw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709396827; x=1710001627;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yIemghmUcjvAROwf/XYTNwNRaU5Q/WPOtN616b8Ib5Y=;
        b=iJRs/IytxPqUJYyyLFOdNq8WmCMXb+I7vMrsrcn/y6MyhJNpnjK7gJ0x9gMAPgjnLU
         ohT35L5sO90u2DyPPSQdUyrvRkRS094diMnwx2nptvWAMYrQkXrDyYuVQEbdiu1+xwrL
         lEpzzzG5RgCYkPji3IiHdF++FOEAV/SuwgF4Vr+vAza+TkcdMo18nW2UDdHY5ybLKHpT
         u/QxWhDG0aReZdQj9xYXt1vZikerOcoEPJ6T53PbvY/7xcKNZb0dHed0Mey+jZ7DgrXf
         ZblGm4LdOYhQFaCZrMJFhznKSTmJr2NpxG3ej4svR/Bmy0aOLCJXoBbSFfn4UgdPyXLT
         C9kg==
X-Gm-Message-State: AOJu0YxGCEjQzbymzA01l0ViDXjHRldaQUOYXF40eQvvoKAK8R5g/5K3
	CsT2/OH2H0HRs7OwZCTu6uK17Xq29TEX/1LL/dWpzMv90ca979G2Z42zoW/H/DOGhePCVLoLmww
	lxdTfQ9AABfmWK5K+z3ZpGs+vRjnQ83JI
X-Google-Smtp-Source: AGHT+IERMCZRlByuXt/y9SUaf2jWB4JfD5Xb3bRXL7N4fopKd9YS0FpIxppX0gYmJPVghPkiQy1dFVg9pFSucXi/6/k=
X-Received: by 2002:a05:6e02:1747:b0:365:3a69:1e1a with SMTP id
 y7-20020a056e02174700b003653a691e1amr5520252ill.0.1709396826800; Sat, 02 Mar
 2024 08:27:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240301170731.21657-1-donald.yandt@gmail.com>
 <20240301170731.21657-2-donald.yandt@gmail.com> <ZeL3WvMhrir_Lz-s@calendula>
In-Reply-To: <ZeL3WvMhrir_Lz-s@calendula>
From: Donald Yandt <donald.yandt@gmail.com>
Date: Sat, 2 Mar 2024 11:26:55 -0500
Message-ID: <CADm=fgnL6x38+f3ULsrtSRmf5LQxOSc0+K3hu37rg=Phc1tHZg@mail.gmail.com>
Subject: Re: [PATCH conntrack-tools 1/3] conntrackd: prevent memory loss if
 reallocation fails
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 2, 2024 at 4:54=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
>
> Could you declare void *ptr at the top of the function? Following old
> style variable declarations?
>
> Thanks.
>

I moved the variable declaration to the top of the function in v2 as sugges=
ted.

Thanks!
