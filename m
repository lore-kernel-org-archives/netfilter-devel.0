Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8739197525;
	Fri,  7 Jun 2024 14:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717769646; cv=none; b=j/OLNWHAcBUl+77Hn1h7OsngXiQInqdadD93YJBlEK/IPVAFtgZ0NUh4qPDj4qq+hgjyZd93nqKr9YHOiDGeK7AMQxl2txW3O3avKxj/GCP20PQJbNcX5bpGm2ePdEqeHRRSm1F1M4/mxiB00SxKPK7IbL5qFNM+UnscKtgekNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717769646; c=relaxed/simple;
	bh=+KKJVGG/e/qe2wZl2RWC8qtO/WdXDPCzwNxd+ZD+vpw=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=eSS/+jeW+MHgdofEj8T6ULC/kMswNEL3y9EASvp8raeAlzlXGGX7PLlNQ1uiTPC/NSasXri7QcJeHERC0eC+2ENP6yETQ0ecRUpABk4DHvstD4eizt7MorDi3lg/4gauNJNAcua3RKNZJfQYBYwYTFFyCwKSvYXp7Og/7tHTAVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GTrY5sEJ; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GTrY5sEJ"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4401a1ee681so10612701cf.1;
        Fri, 07 Jun 2024 07:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717769644; x=1718374444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+KKJVGG/e/qe2wZl2RWC8qtO/WdXDPCzwNxd+ZD+vpw=;
        b=GTrY5sEJSvX3HPMcEixPVCyhkUG39E333AcwhqJg9MeVvAfvKWVdop2cawIhcMQHBg
         kiVyt/PHVC5CvSdvowabpZ9nTAZJKT/Pz4h9h1T/RslWsckhZf9682hedINdCI7SL/yX
         JdjjZrl+/7v/KOTMiKj5vuoYpsCg4tAQqBwnZotXA/GV7/l/tUUnzeOh7wjHlm+Qx+lo
         Fh6Vu10yR+Mpe3/49Tw4v6lTOukNXEJYjCTPOAVk83t/cxiI14jURgYR4fQTaWNgoIdy
         so8+aaonui74r1i5ScBXta5LAwJ87FpDiREpDsntUC10/aBcAaGXeOKqrgHidQEogB55
         EAHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717769644; x=1718374444;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+KKJVGG/e/qe2wZl2RWC8qtO/WdXDPCzwNxd+ZD+vpw=;
        b=uINwbr8Yzm0JMHi+9bNBbv12AByvHP8sJyklQaFXKEhdWYfGmt7qNKLh+u+obvPmYH
         78+JMHk1WX6aSzh+pMGMRjKZm2vF9Ltg1NwRziXFqcFiIJiOu7Y4MBiIa5Sd1h2CnTeo
         +IVSQfsrST8TtLfRIR79/0YJ9X6swOccwZw5O/e0sZ2xeIgvDkSBbh6WGtXLzK1LTzN0
         Mep5bLNWtxwq0euPqqqQkas7tYTxBgkU+jUvQsNbybOy9smmj2Z1vwba6xsyAcjXrHKM
         9JnwcxipPFkTtVKQ1VLSbmAZ+bHBg9sAhdKyCA2uEaeZQKLN4ShVayzr9q5iFdUOtdHW
         z5og==
X-Forwarded-Encrypted: i=1; AJvYcCXkHvqzUi5vPz4tSBFXZWBElStV55Lmb0BHBKT/RepEessAGL5kO3ic25eaUDRJK+B0yHYwOpPTMckcgsqN6uuGV8dio9K8bjU/b1LSS1Ya
X-Gm-Message-State: AOJu0YxFbHuhdVPh2PhO7u/07MWLrAxdLrbTlXSb5XyuB8IVwDVbZ/sn
	4Cj0wG6j3D8ZJJWeo0MDn15BCzstQZtZGhM0XFyLQ/IIDDFstlPn
X-Google-Smtp-Source: AGHT+IEHfi6IFbiHLAUN035D5OezHeUrhkcmq8K3bt4e5N4twFthJfeUYZhO2Npb2xeeMaZ0q5oKPQ==
X-Received: by 2002:a05:622a:30c:b0:440:2972:abb9 with SMTP id d75a77b69052e-44041c4d811mr30429011cf.20.1717769643460;
        Fri, 07 Jun 2024 07:14:03 -0700 (PDT)
Received: from localhost (56.148.86.34.bc.googleusercontent.com. [34.86.148.56])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-44038b38bd1sm12415981cf.69.2024.06.07.07.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jun 2024 07:14:03 -0700 (PDT)
Date: Fri, 07 Jun 2024 10:14:02 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Eric Dumazet <edumazet@google.com>, 
 Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, 
 Paolo Abeni <pabeni@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 netfilter-devel@vger.kernel.org, 
 pablo@netfilter.org, 
 willemb@google.com
Message-ID: <666315aadaceb_2f27b294d8@willemb.c.googlers.com.notmuch>
In-Reply-To: <CANn89iJuSxe5fD7O_J0ZKXEQsyv64X1JH6un5eMZDmL43mJ+3g@mail.gmail.com>
References: <20240607083205.3000-1-fw@strlen.de>
 <20240607083205.3000-3-fw@strlen.de>
 <CANn89iJuSxe5fD7O_J0ZKXEQsyv64X1JH6un5eMZDmL43mJ+3g@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: add and use
 __skb_get_hash_symmetric_net
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Eric Dumazet wrote:
> On Fri, Jun 7, 2024 at 10:36=E2=80=AFAM Florian Westphal <fw@strlen.de>=
 wrote:
> >
> > Similar to previous patch: apply same logic for
> > __skb_get_hash_symmetric and let callers pass the netns to the dissec=
tor
> > core.
> >
> > Existing function is turned into a wrapper to avoid adjusting all
> > callers, nft_hash.c uses new function.
> >
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> =

> Reviewed-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>

