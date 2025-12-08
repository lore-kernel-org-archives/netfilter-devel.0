Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EB723B61E
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Dec 2025 15:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765207162; cv=none; b=Ff5mVpF6xqR+MWWjsy5QWu22yyA//hl1Nv1L90XdCrDPiTEcexeGmm3iFoJaQVLRD+dakb4av4gx7qNRjZmyXX8PcKoBEJbFqEsMIt8TjSevqLxkbqeH9YJ2neaht8ld9OBY5za0g/61JL38hbLDCYJucXC7QIPDjjwOshU5JVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765207162; c=relaxed/simple;
	bh=rrdDEXaQDKdd78sDlmC/cXdeBqqxfvjBLemaYxqI3Bk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PMBsZZ2rCrQnPIDUzhekFAPMZ6PBZhwf76gBDUS6XYhLw1ow4RbGS5WEoyNGsY0GecubnfVSn32EwLKUEFaM3I53gST9X3XL5FcPwVwGf+cmsNFMtC+82FytUKU5Vo1Py4PbB6tnLJFi8lbVBYQA5hv9u+8okymBNSOrobssbno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gh012QR3; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gh012QR3"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ee13dc0c52so38536221cf.2
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Dec 2025 07:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765207159; x=1765811959; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rrdDEXaQDKdd78sDlmC/cXdeBqqxfvjBLemaYxqI3Bk=;
        b=Gh012QR3LLxP9MBxljOT06kPFpJ6QPKsKTTTOYqPt5jIiVvpbmSczekyzWQ60xuk4r
         Eydwe+1y+tyHx+js+WooP67FRBY9tbw+jp6fS5bMb4PdDMS1iZ5U91T9mZfungD7rG+Y
         JE4SbPaq1fcwLbAPGk3ghiaui6XPifERcx2oVnPVRlYpfRYmuFhTpLZ3nz/R++77iTKD
         osGRvATukIIzrhUypya4Gr1tDZvglKEReiW2iHJq/zF2sYsqOrKqkKuvEuZDGgpGEsd9
         dNBIg50/yaLk8qrxNUwUwp8BetTQbus3XkUCn7L0Cy0qrxZVvyQqYUTtfzkAqOBPvFCv
         2Shg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765207159; x=1765811959;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rrdDEXaQDKdd78sDlmC/cXdeBqqxfvjBLemaYxqI3Bk=;
        b=CQkLE4h1oDrO3MEJTS5fY1E5V7g3PyMkX/ztv8SXQyYhByx0RS6qCVVqwD3aUPCsrO
         AvfYRicWiBhHgjsDrOWhM8SJYJdRwnsF0ldqYwhXhETac37o9QenOYO6KjXu6Ry1JyWc
         KgCrZKdi2nVaYg9ov2/rtY/iIvmKvBspXiH5k5QIbkZBs78G84xLejLm7WL7tQAl59rG
         STWPDqoMWY2fj45L34tAlW/tv98eJmO1WRTx7tTeMD0RQX29e8APbzUU1HqCLWvTZOVo
         OjLOS3iniEtWzAFyo3RohLbwx4ZxKmz8UlliT9aDaCYDnFy0aBgukjQSfuHDKmHIkuvo
         ck/A==
X-Forwarded-Encrypted: i=1; AJvYcCWQCWA3iw5iTUHMQ34eVCYsXHS66BMaHn0bRBAubKuNryMG2KN5mhit89y5Slfy1b5cH0eYiWq5Sflk7S+vTDs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgeLO1CyEIofOltkGiy4Y+vru0lE3/qrtcCP+DSjpUYM2BFJ6K
	/V0lVAzWtwpMRYVAAPR/lfzPOnaS+xBCZ2ODYlFpRJ6weqmC/ET5AYo5gSjiGsqVwrphOBm/qdA
	PAImezobwO+/RzTdfvld9R8IFz9irXC+MAgiBcFsM
X-Gm-Gg: ASbGncvLYRMdCJ0UFhLxu776V2sXGj4/9xA2Gy58x78p/DX321ILW7CLD+2uwq0MWHl
	r+Z3kIviIP4d7wCCKmTZAkQsYv3o3IEPiW1LuAPk9+PlqSUKpkmUolBjD1CMoWZA0PtQhTFt5H3
	G7gVqoBuL7Ln6uI5+t8K0sxYR9XeQQPS+3I62uTNM3SDHEd4as5scpa31VxQajQEcu2i6vo+kza
	CJPKp+3i0w6rBBTW18WAWu1hhN1P/K2WqSGvSwnpwvn9g/dh4oZweOkm7UA//KbTPVBz6c=
X-Google-Smtp-Source: AGHT+IHe4WA98gFHxYr762BxNDmBlFmorn5sO8OdaJZMzpm8W64y38FR/DVOgYQKTkY94qsrhOPfdLdCYtvZCKgy2Gw=
X-Received: by 2002:ac8:58cc:0:b0:4ee:4128:bec1 with SMTP id
 d75a77b69052e-4f03fde874amr116057811cf.1.1765207159131; Mon, 08 Dec 2025
 07:19:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251207010942.1672972-1-kuba@kernel.org> <20251207010942.1672972-3-kuba@kernel.org>
In-Reply-To: <20251207010942.1672972-3-kuba@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 8 Dec 2025 07:19:08 -0800
X-Gm-Features: AQt7F2rVVCpqYBSftNjsko_J_IzumACZhYPrp0Ab4JflsbmYv8jDi6XDutiOzLo
Message-ID: <CANn89iKku9guhTVbnc_zGSMBtZm+r+dD03APob1q8LuijFLvcQ@mail.gmail.com>
Subject: Re: [PATCH net 2/4] inet: frags: add inet_frag_queue_flush()
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com, 
	andrew+netdev@lunn.ch, horms@kernel.org, pablo@netfilter.org, fw@strlen.de, 
	netfilter-devel@vger.kernel.org, willemdebruijn.kernel@gmail.com, 
	kuniyu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 6, 2025 at 5:10=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> Instead of exporting inet_frag_rbtree_purge() which requires that
> caller takes care of memory accounting, add a new helper. We will
> need to call it from a few places in the next patch.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Eric Dumazet <edumazet@google.com>
