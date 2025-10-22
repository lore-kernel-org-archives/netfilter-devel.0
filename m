Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E8284A35
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Oct 2025 14:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761142559; cv=none; b=FtEmbwHGGXj1pVh8apNS6jvZuH1P+gO7q/Y2YeDPwBqNf9gLBEhEUXgX2iNAoxuPqBJsS09LoAwifYXChHbSI7hGn4ShHEsf719ZzRTvxncrkk+QCy0kPjMXHsOiGG+d/cgDfYzVfBF0cJ/+5ySX6NCOrhAs8LTjzV37JZM/scs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761142559; c=relaxed/simple;
	bh=NpcP+HFhhb+8iR3CtYmODN0wKAFtn4iUdPCm2JRhyDk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nkn2bEgNc5srP4V0Ub1vicbK/Y44d5X7E3oNKCLTJi/tOiK3EBjj8AwtXkDYE0hNWYxv5YAy0/7CZ0aQ9WHBVFYmOOLdpSUyVVzk9qjrMzbLEejDJLnxCeuzCXWw9LcTm7AspuQM4u4hWwirV+0Nao48EvWe0PtUnMuH20VValY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4Ng4++yG; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4Ng4++yG"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-426ff694c1fso1900122f8f.2
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Oct 2025 07:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761142556; x=1761747356; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NpcP+HFhhb+8iR3CtYmODN0wKAFtn4iUdPCm2JRhyDk=;
        b=4Ng4++yGtfpYOS0HzfgEWGVbyepMV89ochYtbTzBAJHw8MU5s+qmh1SICd7QBfziGW
         +U6381c0rLTHTUVw736XHi/NDcJclwPknKpu+uTecrcSHwi6Z1pfy/savec7PV3zE5TT
         yFiLiMh4TjB8FVmO3QmhBAzePTiZETBxYasH9RuNwV4Dppw8tltpHnzs6KIw4Zkg+Fo4
         1STw6jt4RYBvVFNgl9p7vLDq2rmMpba6AOz+2odu7fUJ0YGH1HnAsLimqWQKmEM0tJjg
         bYHEDuBtEqbpYsy32xWsp2Eg9Qs+l0dTiTKTtDJ7f2nFZxUk/C7ujvoCVL5iH8ty2NXu
         rynA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761142556; x=1761747356;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NpcP+HFhhb+8iR3CtYmODN0wKAFtn4iUdPCm2JRhyDk=;
        b=jwTmCwQR67N32jIJb4rtePDuWX6ycAgCDbYtpIGkLu7iNQDLGXUFLvX6/n/4/0p3Gk
         yc3A2IL6AiQzsjv37Pbav6fXIRljX5FA4U7IBnXIsvLoTDIVS5Xrwih1ekBA82dnadFN
         fVgmmPLHvtAtyujZKUCRvBQKBd0VyIc0Dn46ZsV/wBN/shJCbef4F17TVdyTJBO298bq
         lUBVTtMz1yQ8doiSVYQrVCtkHXXfXsT13DN9LtMXQjsmotuLJdThBm/eZ/PRlioh6fX5
         HxNv+kRQpuiV3OrRlhe/qPnsRvgkCXSV8nvZNlhaibSUS/9kKlMdfRm7uBQyM3Amb5jC
         343Q==
X-Forwarded-Encrypted: i=1; AJvYcCURge1pDuPL83HzrjmOKVNb/eBhhzGlrjlxZuSDcBGTroIpHpF66yLoAA/IyYwYCYFs/ee8lW3qql16pCEKXjw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLdV4Ogdugo6VfO7bM4vKqu61tPLzoPGdGFm4WpWju+M2XTMVV
	QJVuLeuuXZNSmj5+v9D+RtVGDHv0smO5T0unjzmc9zvOKRs2/SwvZEJzZD5SlYQ/TDpYyo/m+nI
	3MREPng0mo7DfAkYRIss42lz2LdlqtwuXF+Lfxm/raIMNgzhBLITkzXjw
X-Gm-Gg: ASbGncum3/6LzZrV4hS5GEksMjFhjh88qkSV+RbhupANLRShhyDtZWTic41ZflqROGF
	GB16MSpRKmTF3MZoLjt+wj0Q8LN+88Gh2aLQMqgBeRA1O45Y43PMB+/8uLF7i3uSpvb6lP+JEdF
	0bKsubraORPR7z4GFH4qdInl9yISn1PBsP7c44h3IAfqo6gUUAoTEwDlhdG6rfgfGs0FDZ89zoG
	+PBGn3jEJWbZSUk/oN+F9kY+0edHcR+Ncy+taFWZHdvHDgNAQEcsikDYEw=
X-Google-Smtp-Source: AGHT+IE2M4QvSYORPAZ0AG6gKu0tWu6fS8GuSJIu/Xux3DWqkokD22aP7DIRoeO7nbzMogzE/3Haxn7OYVD33vYN0aM=
X-Received: by 2002:a5d:5c89:0:b0:425:6866:6a9e with SMTP id
 ffacd0b85a97d-42704ca6ba1mr13757790f8f.0.1761142556105; Wed, 22 Oct 2025
 07:15:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251020200805.298670-1-aojea@google.com> <aPah2y2pdhIjwHBU@strlen.de>
 <CAAdXToT14bjkvCrP=tG4V4XJhhyGMfuJz+FdfTO+xJ10Z-RezA@mail.gmail.com>
 <aPay1RM9jdkEnPbM@strlen.de> <CAAdXToQs8wPYyf=GEnNnmGXVTHQM0bkDfHGqVbLhber04AyM_w@mail.gmail.com>
 <aPdkVOTuUElaFKZZ@strlen.de> <CAAdXToRzRoCX4Cvwifq9Yr7U663o4YLCh1VC=_yhAYqAUZsvUA@mail.gmail.com>
 <aPd6Ch7h6wdJa-eE@strlen.de> <CAAdXToQ+DuBsPGQUgSCk2=f_b2222iTD4-rT=0gVuaYWT7A2HQ@mail.gmail.com>
 <aPi_VdZpVjWujZ29@strlen.de>
In-Reply-To: <aPi_VdZpVjWujZ29@strlen.de>
From: Antonio Ojea <aojea@google.com>
Date: Wed, 22 Oct 2025 16:15:44 +0200
X-Gm-Features: AS18NWCCvSrs0UBK6okmKQzeBgal63xMz4NrCbAHXrJs9mkwmmaQh-aAx7tWJmE
Message-ID: <CAAdXToSGfYK0BKW=sBD4ZP5Odm8Xp3fRWBa4Qtdgrh++429n2w@mail.gmail.com>
Subject: Re: [PATCH] selftests: nft_queue: conntrack expiration requeue
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Eric Dumazet <edumazet@google.com>, 
	netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

>
> I'd propose to extend the label allocation to when a 'ct lablel'
> rule is added rather than just 'ct label set'.
>

+1 , thanks, selfishly, that will save me the need to add the "unused"
ct label set rule, since I only set via netlink.
