Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF6035CBBB
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 14:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768832339; cv=none; b=GYKdiQxl3a3SxqLvmeuQGnUw4hxSzDpH4UVyMx2DkZiQ7qlESgFe3WqN1yEARhBklk/s9gzj+dkN36hRkkg5rP1b1xGB0WRvgpeA8l8iRyva3u5BK4HoYeKE2QjJQbn7IzRYQA9LhScZ9GMXPDkRbr3ivfgN73j/36oN5Ps9oTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768832339; c=relaxed/simple;
	bh=dvOKvtysSH7Y+ujQxgNgMT6sMrKUY/CqAcibbW5Fe3g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=c2Oa54ROqXZk2MG6MMFJmkIBGGMuH0livC8WL5q79ebd4nWUGJYoD3dRqljhNPP0ljyMIeF2dJfq4g6OicO42hwLF9vFykTr4ZXreGwAo/O7oUmgrWqoXrJ3s6uHeD8mtFSDBtNLSbnnQD1QA33cehmZX8koQ3d4wPBlz+q7FrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WPe8ih9C; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WPe8ih9C"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-88a2e3bd3cdso43715316d6.0
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 06:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768832337; x=1769437137; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dvOKvtysSH7Y+ujQxgNgMT6sMrKUY/CqAcibbW5Fe3g=;
        b=WPe8ih9CWj34Pj1ahSBph8A/lGRiutxbhr0LgHaErT4aP4wZAD+o77am32kB0o+PJ6
         EbXnC+qzqV0xw08RHmqLAzYZ6GXQiLkmATdaLO4BeNmLXnPe+nTMflXj70ithAAuzzwO
         d83F0K7ScEpGtb5KXAudToQqFaSKoDGhf3MvjVDG8Mg4Wk5Q57ozS2/89xTANSPSw+aD
         YqRa+/L8OR+iaDQ95vB2yYOnB/VkB3sDDV3adn9Ug0pNhtC6kPo2uS6SiyokTwNbvsv4
         q/OpquM4WMFlBvnyTMdqIFxUxxiQH+LG1lmF2queAcKOMwc8jYNW5RCBPUoFiVv7NpBi
         jkaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768832337; x=1769437137;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dvOKvtysSH7Y+ujQxgNgMT6sMrKUY/CqAcibbW5Fe3g=;
        b=TL3JbjHVedu+NQovOWeRB1qeeY4wh68WNf+yjkFRKDqIQMw/ce1ccVMLJQ6IG7yn1p
         UCO13IlLK1q60irpkAlREL1VEpAVwY92ZEKGLa6fSsbzQBIgf0iZ2RVxueMUTSlQzcV3
         Ptx2iHGzHEnxc0Z/T3g+S/ua1jrIEKXML8ntVfAjCkQkqbnEamKzghMOBxsBcXylSV5Z
         64UvqF4sHwxVWCTXe9ej3u3mc8kR4dTSK5qR0dQhWajjZyH1PG+/6wht17bxIvI27lUF
         Wg1gf7coqBh3xhUiT5ZOGR/ymJ7WdK5wv3DYjVTXGVvsqZwGVxXQ56/XdWxPmlfr91NQ
         9sJw==
X-Forwarded-Encrypted: i=1; AJvYcCXR9w+b2yYFI63L1dpz2uKw8caIs2LAY0tUAIqNFuxDpFJTWvdWhkzuLxs+uKS/8C/N8oFveodQ7T+RhphmlzE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo9fa5nhsY6ZYon/A7rP8JHzxnsmxc5NS97PAGIYxVYGSx6fiE
	KDxiL7XTUuUKvvCx9mHiDz/QctY0FkMnui7iME7sITF09kDBc3WACCgTijIjhDOlCvdQ7cP5xOA
	+MwlgQz3bOHf9mh+USYCo2uuLxR++sos=
X-Gm-Gg: AZuq6aJLdkee8fRngduNlxDgm+60eltJ9cbyHwyp2jlSXjq7quJxVuWp31i/DZfHDJ0
	IqFHzzYgIDRhz1mwsJQ+6catelohSiF6s1ZqMIlKLgbIhw6/rPoHqAhAHvSoxUKybafFcFSKlEy
	3RGP3tK6UG+yqvS8vlamOQoyV419w6Uq36PxGKeSvo/1LUTUR64nvMxUhodKzjpoAyPZd+NHwJE
	kybRGHimHfCzn2qQzTKTeCyTSNSoHYwm1qYPXN5RKp+UdgHBTAkmX1GooNan6sTlUZFZzW28OLk
	O4Y/Jfi47B1Y/vC4y8ILkGOduMr+0OngEXdNkVg=
X-Received: by 2002:a05:6214:268e:b0:88a:300f:29b7 with SMTP id
 6a1803df08f44-8939827306amr209115236d6.30.1768832336671; Mon, 19 Jan 2026
 06:18:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113203041.419595-1-knecht.alexandre@gmail.com>
 <aRcnt9F7N5WiV-zi@orbyte.nwl.cc> <aRcwa_ZsBrvKFEci@strlen.de>
 <aWe16oO_R-GwM_Af@orbyte.nwl.cc> <CAHAB8WzKr9rehUKWSZAPWZq_3QnLGbh2Py88WXpV9sE3_V3MZw@mail.gmail.com>
 <aWoxZQc-h93Y_xyN@orbyte.nwl.cc>
In-Reply-To: <aWoxZQc-h93Y_xyN@orbyte.nwl.cc>
From: Alexandre Knecht <knecht.alexandre@gmail.com>
Date: Mon, 19 Jan 2026 15:18:45 +0100
X-Gm-Features: AZwV_QiKS9-WR1ydJvzCbJz4dcL6wGGLNhSS1IJjThM9XaipOmUSbrYsQDLzZWc
Message-ID: <CAHAB8Wzx_pRsZ+Ep2eES51oDiifcWVDjL_VXcq0DvH_HmXgQeQ@mail.gmail.com>
Subject: Re: [PATCH nf-next v4] parser_json: support handle for rule
 positioning without breaking other objects
To: Phil Sutter <phil@nwl.cc>, Alexandre Knecht <knecht.alexandre@gmail.com>, 
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for such kind words. Indeed, I wanted to post it, back in
november, sadly, I prepared the patch a few days after your reply, and
learned that my grandmother passed away, and so it got out of my mind.

I didn't want to handover it since I had everything prepared for
submission, I took the time yesterday evening to rebase and verify it
was still good, and ensure I followed all your suggestions.

Hope this time it will be fine, I submitted a new series.

Le ven. 16 janv. 2026 =C3=A0 13:39, Phil Sutter <phil@nwl.cc> a =C3=A9crit =
:
>
> Hi Alexandre,
>
> On Thu, Jan 15, 2026 at 09:23:22PM +0100, Alexandre Knecht wrote:
> > I'm deeply sorry for the delay, had a loss in my family, plus a
> > truckload of tasks to achieve at the end of year at work, I have the
> > patch nearly ready, need to review and retest it and I should push it
> > this weekend during my spare time.
>
> My condolences. Just take your time, there are more important things in
> life than software (hardware e.g. ;). I merely wanted to check with you
> that next steps are clear. If you wish, I can also take over from here
> on but you sound like you don't want to hand it over yet. :)
>
> Cheers, Phil
