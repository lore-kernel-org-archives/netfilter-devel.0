Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2B95FDB0
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Mar 2024 16:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709571456; cv=none; b=Hhsgv/0z4BgaKXqXCxoeVuLbdm4zOfjhOlKyy24GFhK44NIsBw8HdHjSZfxxQnnLRoGF4N8xcILWi5J0ztfOwC4w5jRQ0W7+v79GDI5m/vdM5rj8+5O0hZQNSg9zP/l/Ah4FBxhi1vZqZzsKMNTT74tYMgpmGiGOWdOIsHGDSzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709571456; c=relaxed/simple;
	bh=uVQriWR+/+AxeAtbw6ieBV333od9t8KvGteq5gH754U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i6Z5x84A+VvNWxGIRYcb7EQK/Z+1Xs88hTWTczwKGAPfkojx7fHG4RXePewrifIUKF5WOxoWgJgW8vy+7m3yTm0mJXlt8cKNgXz8oeWR+Q+g4mF9HXQfwqOI6ooBHZ+DcWzpiCOJqIbh2g4wk7VXRUNWx2dfAZbZl3OnGxwBI7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KHTKYjvh; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KHTKYjvh"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7c83daf5dc3so69870439f.0
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Mar 2024 08:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709571454; x=1710176254; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uVQriWR+/+AxeAtbw6ieBV333od9t8KvGteq5gH754U=;
        b=KHTKYjvh/tfDMHyASTWg2KyhZVXIIK4PbgqSO+77nMzDiEe/MiPhWJmkeZUMGCoXFM
         m63Ni3bq+CfONXyQoAgSqyGj8qSP9g6T+0Kc1LrxsBOY4Om1RzTeQoxHFj/avjTEcn+5
         kWSIP9zbn45fQAFDUJ419FP5tfNgaeT+UJSyfhe07ksl3mS0jeu0qxiXcuoMzYHcnClY
         KnP0m+GW6dW9xD5KMISKooQ9iKCWLxFrZ7UqGo52s1KGyziy+gPoX0ijdXMbVHQ5rpy0
         pvR3J8qotsD3CkiQHUsQz5nuZ5e1zukeO+hWWEVlrRCGxcnMqKO+5M6kMd8i1Ax4oO3W
         O92Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709571454; x=1710176254;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uVQriWR+/+AxeAtbw6ieBV333od9t8KvGteq5gH754U=;
        b=HFrcE/0Q1tAq6wTA328cPDBcgdjklDvyGgjEjddeyyDTUp/LvISJFJKDPsO+mYpkQo
         h5PqwNT2y/LLtv3OVtNb/V/ZUjRGC4XQfENFWpfATSlFRzSiAxk/tzgI0pi2WX3HpB83
         9BmIQ/KpiCva6gZDxjRfbMddtkcGX/dRrBlieoUG5kJlH2KlwmITkh4o8eP0NaI6dGgC
         7UHpGNHx5mtZD2p+dvsvcDYE9YRFoiFfC6F6UMJb8UboU6Wzxp0V5h/YbfVtJtwAgCln
         /DVcp/CECyqzFrw98qrGKN2XZ5OLya67LIOWFl9+2brpQsfT1eiIpJqymLiQGzWjveA/
         jzHg==
X-Gm-Message-State: AOJu0YwBIA4oW6jQB8iDKdXsrevKnepoMoEDvfFkQy9WPgvynltTveU8
	6VRgnGhiE59K81mcBkggo0vVJ5XS/sPMFQYC+qtq9HWXS6iF8QYrR57mVT5T0rxMuSNpZ15hYmW
	e1meHM3IejmM8kO0tYGA912AbU9A=
X-Google-Smtp-Source: AGHT+IHsOdgn5PIUmSG5Fy485fYKUF/sSGlmTC2QVFZu+4+AEEymrIzFwHUwo/UnxpxL/aEwUsQBPT5o+HgnsE0SiDA=
X-Received: by 2002:a05:6e02:1a8c:b0:365:3e12:8bfb with SMTP id
 k12-20020a056e021a8c00b003653e128bfbmr12672981ilv.21.1709571454107; Mon, 04
 Mar 2024 08:57:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240302160802.7309-1-donald.yandt@gmail.com> <ZeXDYANYnRZJCcE8@calendula>
 <ZeXFgRt6HM30Mbng@calendula>
In-Reply-To: <ZeXFgRt6HM30Mbng@calendula>
From: Donald Yandt <donald.yandt@gmail.com>
Date: Mon, 4 Mar 2024 11:57:22 -0500
Message-ID: <CADm=fgk8mpBr=RgptyhuQt1+nKf5Tbpn2o8pQAmdJ9kOaF4LHg@mail.gmail.com>
Subject: Re: [PATCH conntrack-tools v2 0/3] fix potential memory loss and exit codes
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 4, 2024 at 7:58=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
>
> BTW, I skipped 2/3, I am not convinced this gives us much.
>

Hi Pablo,

Thank you, I greatly appreciate you accepting patches 1/3 and 3/3. In
regards to 2/3, since we're using max_elems in allocation calls that
take size_t as a parameter,
 such as in realloc(..., v->max_elems * v->size), and cur_elems as an
offset of allocated memory, we should utilize that type. In the event
that you concur,
it would also be necessary to modify the index type on line 83, which
was missed.

Donald
