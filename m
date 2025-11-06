Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C6B3081C8
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Nov 2025 08:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762418419; cv=none; b=T16c5YbIdozZQJl5jCxkKsszPt7eu0tmyttAEbx6Rsp9FlRUQBwrNG5FvNNsLqTGUkLFO7B9j0bzNNIVMpMJqEMBl7vpw43howtBOdCjQTKopVkdbq8zT7XXiqKauXykhKHnRSGeNm+v2MZOg/KXjdirL5hSLDBMklzm7aeTA3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762418419; c=relaxed/simple;
	bh=iAZuzfINYde94ZgcXgwlTjZaeFZ2nZLQd9xdvRSlLY0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=e6PqyBxl2TnBsdKXKoESa1Z8XaKlhfYs6OIPa9jgYBBCURW3pY78zS2Mt11w5EgtGVPP7qxOUdHkDwK92FoYE9Cl835uqoQQHlYo93XLfsLayLldQjsILYzz50p1bILPtGmkr+cnjr3L7XIWBjiXJ28FG/1GVcKOGPlFvrJL/YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iDUS3uPK; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iDUS3uPK"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8804a4235edso8606546d6.1
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Nov 2025 00:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762418416; x=1763023216; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iAZuzfINYde94ZgcXgwlTjZaeFZ2nZLQd9xdvRSlLY0=;
        b=iDUS3uPKE+Ne/RdXK4B9FTNVcdhEgaGOK4HQF9UHOqEUXvFYFu4bW1wod3oFfhXnD2
         pS3jXI8v6pf4xwcWhcOcxQus8Hcl2Wd3KCvHOPiOat3T1v9GNadC7L/gfKWyoxubvWxP
         aT4QygSpnMLsEtrZ6Rprr3ohDDkDZXB06FwKHnDy0j8e6xejNAmOdPLlrW9G4/8GDENn
         1wWeGgaAZZlz07dMLKDJ7yhmAz7+9cLkWKbFEea/vAOxnWGb3ceEdP8g+Rm9Q3qOPneI
         2+ahbvS5+GvY2dgx/HBrPRsmxjZ18XvK2XbY1jBFYigUuyaNngCAapY4sCsnO6mYTL+9
         GfIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762418416; x=1763023216;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iAZuzfINYde94ZgcXgwlTjZaeFZ2nZLQd9xdvRSlLY0=;
        b=m2AffscA7oEDJmgHG5hDZAqhIh0mVYlHJpHsVmtPOS8XrEFPKKND+bFqun4raJi7Ql
         cuCPnplmo5kdaiQ6cWTRSBUoP90OPFAMgfzcb1U+vrNcOvwv7MoXEIYrUSi3QTsQR60D
         ZlgoglUTXUC3GgZ8armHBIDZ4YIiOPLY/0/eA/MGdez47DkHGkFIZNoOfSazGVbn4oAA
         0+R8mbbOki6xmPkWuwAEjztOnmR7UgxbhmaVSkMG/4B3KKqmlmxh4+ZnwoL9w9fNZuZi
         e2w3W4yR9xz3pIIyiIxtf4skayV790Te5fiL3NqdxKogvqhmUAmO5gRpzRJt7LoKcZ0M
         e80w==
X-Forwarded-Encrypted: i=1; AJvYcCXSzrDmspJjwb6kclmXwzkgl7BVjU247/WeYbPn00RkohqNSdneiD3UeM0YEUPpEg8BEvO6Q3UvIme0jowzwy4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNPwpYYWaWl5g3sqSeBrbh/lI0evHaptow0O9vnj/X5etv95/g
	n3h6lzO03UjJ+q+p5WvnpwVX2tDM+r/qS3aVzorf2cmdk7+84qyfUvDWUmUL6DRQbGcsx+X0H4C
	US4o2xWhu9KrwUCRxB/LvQl+/qM5aFEM=
X-Gm-Gg: ASbGnctZv+uw70pH9EiPVI1U6ijAjzXNe+vu6NmZFVgza3YE8cz/i+7b61AdVtU3loA
	ZYfr52TK+NQDZZOZoTuerdY4MGVz72bWiPLQjl5kXGRRnI/pUarRb0weRYXwZn0ybfuz3f6zuym
	g03hlEVfbzZSI/hscZZ3jj3qQJf+87i3a2+5hJjytWyCt2zoif1Nd5Iae3cNKuG/dghI8DUFwfV
	wOlqxj/pNCgnBJWXKukje07gl+oDnw8o5C9mniVHvUxfSU/Al239ZCVXdVBK1sd2UeDK+ZQ1Nuw
	9xeEIhyE682iAm2xCZJIq0WAD+gwAnAAgB7pLfuOLhtPZ7avovY=
X-Google-Smtp-Source: AGHT+IFaZ2YCWSsVQy7GEkIeKNWnyS2pw4TQFpvSA8Q68LeQgMW+S6Zb4nK8nJHyX5rUxZyk4JgYmwHv7nr++Zn/8cg=
X-Received: by 2002:a05:6214:4a83:b0:880:8843:1f91 with SMTP id
 6a1803df08f44-880884324c3mr8222206d6.22.1762418416590; Thu, 06 Nov 2025
 00:40:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251029003044.548224-1-knecht.alexandre@gmail.com>
 <20251029224530.1962783-1-knecht.alexandre@gmail.com> <20251029224530.1962783-2-knecht.alexandre@gmail.com>
 <aQNBcGLaZTV8iRB1@strlen.de> <aQNNY-Flo9jFcay3@strlen.de> <CAHAB8WyByEKOKGropjHYFvz=yprJ4B=nS6kV6xyVLm0PWMWbYQ@mail.gmail.com>
 <aQdRjC4HJmjMStrI@strlen.de> <aQng6Holl8xN04dd@orbyte.nwl.cc>
In-Reply-To: <aQng6Holl8xN04dd@orbyte.nwl.cc>
From: Alexandre Knecht <knecht.alexandre@gmail.com>
Date: Thu, 6 Nov 2025 09:40:05 +0100
X-Gm-Features: AWmQ_bk5tB9b62j9InASe3AfHIugl-6ose3coj49tB15kyLIv3WiXOrGSs6ie6Q
Message-ID: <CAHAB8Wz_u36szA87su+jZ5punJLfJucjW6rp3YBN5jF9koK+xw@mail.gmail.com>
Subject: Re: [nft PATCH v2] parser_json: support handle for rule positioning
 in JSON add rule
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>, 
	Alexandre Knecht <knecht.alexandre@gmail.com>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

Thanks for your precious feedback, I submitted the new patch with the
requested test cases. Hope it will suit you !

Link: https://patchwork.ozlabs.org/project/netfilter-devel/patch/20251106083551.137310-1-knecht.alexandre@gmail.com/

Enjoy the rest of your day !
