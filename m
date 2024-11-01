Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FDB1D365A
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Nov 2024 20:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730491683; cv=none; b=WLGE/V1zCuY9ELf9j4EC8akpnajv4bdFXa1aqeuKXvhBiGruOgEN8/kerd5u7CBWEcbD2Z9Szwbjv7ZLxpsSybasH7fng4n/pkotmg6VfzNvfbTfkgDsIBRTWiV8iOW0sDplet5Sdw/8zmvUq0yUhKK/NUIdYusX8JZyq7fNIKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730491683; c=relaxed/simple;
	bh=VR4FqvBnEsvLRoY1zv77QJD3sXqgdL0CVS+r85of4XQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kk67HhPwLBqXok+Y/vgCt4q/ZyEY96cXJH3EmdJ2IhZVA4+d4ERWHBPFuYT987aZYYaq1HQwijmmHvAihnrz4XcZ7N6ZAwyq5upA0BPZEuqT4GK1Lqb3dz5peMQVneJRWZIAhjXDvrtAm3n68dTbAM6kmKMHzAkTyHh55xrQC7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=aNbVg/+9; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="aNbVg/+9"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-6e2e41bd08bso25549317b3.2
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Nov 2024 13:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1730491680; x=1731096480; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KY/aMgJuGmogtnd0GSRrc1tukgb1zmFjr08wvyiufLY=;
        b=aNbVg/+9dvSlvtqNVi7Hiw1gM3+Q9wSRc76zqsr/TawQ1oVtzbTx+cjuPGNl1U2dq9
         ImFVA2IhXHruBNRcJ/kLSy+UBnOwesKfxehkvGDxrsDIM7o0QBHrq+lDmsDqLKgmLYri
         FcfIdhhl1M5Ol0miBqOo6SVuAY1V0p8GYHPWZ07whHDHigiezCkfyjttRzRqrZahMfO2
         BqY6Sn4Rpc+LAE08n7zqUTJSg6HxyXy4IXiQqS0JceqaAiHHICQz6KykDVJrE+lT/xaw
         zKnKneCpT3tL7XpGH6giBkBuR37TjHq1SJSFkLy1146NlsdpkoI8F80Tp7WxYAMxewoS
         A2zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730491680; x=1731096480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KY/aMgJuGmogtnd0GSRrc1tukgb1zmFjr08wvyiufLY=;
        b=wjcrrZX+TIUVg89bQkkpK3YHw/QkaKRJ6yuZib1+2EsoGiUUFSuqJngOf9PsvOXIak
         BDnoHTgVQZJKI8zeNvjox6gj7KKi214jQBJ1Nc/Hp0f6e43t3KHxNv5kz7AeoULhSMjV
         KWMGVJJk2K8NrnszwoTAcRk3EQ3CIuilOMq/f9QKDDuiw4nSymGBoGSG4sCujg/kj7+T
         /o9qOjHt+ys2GTe8yR/QdS1w6XHPnykXcCzFn5rtFW6ycy6TLYZOp812PzUtUISXYYyF
         CWyT6x5jOWR04CaIo/M2120HMt6zS4nl+3bEFWWPtzIM5TNISJo0/xL/8mRx8YhhbkuX
         3SDw==
X-Forwarded-Encrypted: i=1; AJvYcCUrEunADOqKojmLVCa9mmw/ePbMwFgk0YPO7iONJrRwtJc+fEiBXvo89/YzVGSYGCMbNclH6MIyuOx+A6QqZxM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqQMpSjh0i1VhqGTI9cuKStgrV06S+v3FOIrNalmOpEaXX8ZvX
	KhG4y9oTg4GHcoyBZpZiz7EJhGBUOu/jafPVjjOLoQJ7weBfJcrjoknkMPoSSAB4VvTr9VyFP0p
	WSan48zDMGC+0HX9HK+gV12ig44V3eUpaGzkH
X-Google-Smtp-Source: AGHT+IG//dGUfdunoEVJTi2A3HFcZpQS3rbY71/a+8HLJ5+2w73tKA2dYpqIKVMycEq5/GJuDcSxOwoKk1zJgg9fpmE=
X-Received: by 2002:a05:690c:6287:b0:6ea:4b85:7a13 with SMTP id
 00721157ae682-6ea64a9f4a6mr53969797b3.3.1730491679847; Fri, 01 Nov 2024
 13:07:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <97463c75-2edd-47e0-b081-a235891bee6e.ref@schaufler-ca.com> <97463c75-2edd-47e0-b081-a235891bee6e@schaufler-ca.com>
In-Reply-To: <97463c75-2edd-47e0-b081-a235891bee6e@schaufler-ca.com>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 1 Nov 2024 16:07:49 -0400
Message-ID: <CAHC9VhTAijBwEtqi5cpdpo1MwSW4aLL+jy9ctwbU1XVcq4wEYg@mail.gmail.com>
Subject: Re: [PATCH lsm/dev] netfilter: Use correct length value in ctnetlink_secctx_size
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: LSM List <linux-security-module@vger.kernel.org>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 1, 2024 at 2:43=E2=80=AFPM Casey Schaufler <casey@schaufler-ca.=
com> wrote:
>
> Use the correct value for the context length returned by
> security_secid_to_secctx().
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> ---
>  net/netfilter/nf_conntrack_netlink.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Thanks Casey, I'm going to merge this into lsm/dev-staging for
testing, but additional comments, reviews, etc. are always welcome.

--=20
paul-moore.com
