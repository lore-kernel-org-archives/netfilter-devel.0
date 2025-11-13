Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BCE320CAC
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 20:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763067398; cv=none; b=jVcAA9c8h0WMXSRiHJxb3Hl1mwYFbybhhaKhje6AE7cpHdYxBVQ2CSLdbjOk4MoV7mDrhn7HEMm4BERuLZemzg0BsEzV60OLX6xy2v/1RR4vbMOzElWappjXLqrIYIyqdI1yujyaamhtU88Nrf732E3aAZpTg/ZvBQ9SgEIShIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763067398; c=relaxed/simple;
	bh=xcx51CpZDC2fkjH4LJIQFa9yOLzN8e25KFGSYzDpG1k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=stUsqAkPyEg7Um46jiGe38CzgEfxKvnOfAfLJwXd/jVadD+GzFvbOWCiteNZlw+yCbw4+r63AyY/66SU40wrPlMWFVFHLUib8HkhGzzJBUEE6iRVH1S9I8P8Ufh26Cv7oBvtHm9ndW3uN1rcsWhUncifHH5O8pZoNgt5zuV3ihQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PWNof0G7; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PWNof0G7"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-5dfc2a9b79fso229592137.0
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 12:56:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763067396; x=1763672196; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fE6wkTka36l+WuIbH6rtyhnrc4czYANuD5KWow4y1eY=;
        b=PWNof0G7520PnJBc9SLS9M4LZwwtleoViibd/qNGRIjkF88VkCpTkp0aF/G0EhRIBG
         jCpUEKpeZVJ5/oUlS0tnkBtRxYEXHeH9mu4WCXv6Y4Zm2sBsw3ieCRXxv8E4LdCwrAwZ
         ky4YP0nSxw36pN3CoKpA+Pl93jz0PlSkHQjQhPa7nR0MqAzO+JdaNDGvDeiFb9rq/anV
         3j12fp0IWezn1a9bD9SYBSros2to+Hq8JqrKZMBaGX6LyU2W+eDi+pOhOoUvyhTDXyPQ
         8WF+tyEc4ffkvrNLM6UXlCOs1kVJXffKRmQ6Tmd5ndfVtgcgpzNIy+/ldb/rR1r5fpao
         6/yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763067396; x=1763672196;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fE6wkTka36l+WuIbH6rtyhnrc4czYANuD5KWow4y1eY=;
        b=HMj31PiMyjhljcFb4XUSD9FPWoimdXBWyYZsPNwpnMQu/e68Wq8stpfRXByCafZSvt
         Ok3vVNnqdXqRUbshzmhKtkIa16QZbGwtKG2rcjQH8olZLu4bAQb3zbHSKF6NCk8eJvlR
         0EZaJRtjBnujx5ItDpUIydWmrD7lvsiHESHZhgyYqbWa18k8kShXmlRBD9WeVjV6rzp2
         7YxRIWYgdrKaPljRtYXjocMp/CGow3XdbPXE04a5oqXTl/VtW6uY7ja/8a+sl1xbGi6x
         PmPqnLavx9AgtoiKc7QpBVBcqsmkYw8YFaeaAS76bTmleP5RtVXGAG1zchhDlxToI6bz
         v7mA==
X-Forwarded-Encrypted: i=1; AJvYcCWlp52LgrhrlWnX7PxzbTpeZwr0Yjeia0YoyCErEAOl74UvTd9xffvCQqs9pgI46T8eOOg09pZbVcj/6f8YkF0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz38spmhfuXBZxAmXxfcjz21WBM+gMJ4JWd5Ru2PTnqhsONcjZX
	s2pREZjIZ8Rn01sjI3uuC8VXWIiqEJicnXjh1BBteYStKE5aWsJcyRlIlP3ZpLzlg+pk346Bqnf
	NDjklWUvQ6DQbUcE04nXSBt3EMssdJ2Y=
X-Gm-Gg: ASbGncvMGvJSNtrByP1wWMFp9b1H0tbkYUVTqwjF3JtWMt4H+YWkXqiKTnuZ0y8H3hV
	+7sfyaKi+SHwuH4bVPBMUDXSJfxNYZ1z4dnwT5CPRwAL7eJ871QRHatNpW8/yFGm1RL9Z+fnqse
	Hh/gQKxp/nortY1wclDbpfWCUxRcT7eZADgYVzBLHqKWa76zdSHdBY18nDHkgPTJIyuytKTYiIO
	qBcsT+jUPWv5qMkPr8eAOkr0wjuyAMHxmwWib72JlfQ7nJO3EAHQnIf6rJXfHwhce5/r9kT65GU
	8e+yhpHM/4Vr
X-Google-Smtp-Source: AGHT+IEuYuAEqPYTSWSN+h426W33ZgMvr8eWHUjqHTxueXAXxSuhXsQmmawhbdxIne3/JUPA9fdkujcoOKj+toV5PfU=
X-Received: by 2002:a05:6102:5808:b0:5dd:b288:e780 with SMTP id
 ada2fe7eead31-5dfc533e040mr691137137.0.1763067396190; Thu, 13 Nov 2025
 12:56:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113092606.91406-1-scott_mitchell@apple.com>
 <CANn89iJAH0-6FiK-wnA=WUS8ddyQ-q2e7vfK=7-Yrqgi_HrXAQ@mail.gmail.com> <20251113194029.5d4cf9d7@pumpkin>
In-Reply-To: <20251113194029.5d4cf9d7@pumpkin>
From: Scott Mitchell <scott.k.mitch1@gmail.com>
Date: Thu, 13 Nov 2025 12:56:25 -0800
X-Gm-Features: AWmQ_bm47bkPDEkq2SO3eRLRbarp-giqb4Vz8j4DJ-oKOw0iNgI_m1DRXDEzE84
Message-ID: <CAFn2buD7QWb42nVaG8yMhEA6+6VtTndk61E+_tZvydLm0Gs3qg@mail.gmail.com>
Subject: Re: [PATCH v2] netfilter: nfnetlink_queue: optimize verdict lookup
 with hash table
To: David Laight <david.laight.linux@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>, pablo@netfilter.org, kadlec@netfilter.org, 
	fw@strlen.de, phil@nwl.cc, davem@davemloft.net, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Scott Mitchell <scott_mitchell@apple.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 11:40=E2=80=AFAM David Laight
<david.laight.linux@gmail.com> wrote:
>
> On Thu, 13 Nov 2025 02:25:24 -0800
> Eric Dumazet <edumazet@google.com> wrote:
>
> > On Thu, Nov 13, 2025 at 1:26=E2=80=AFAM Scott Mitchell <scott.k.mitch1@=
gmail.com> wrote:
> ....
> > I do not think this is an efficient hash function.
> >
> > queue->id_sequence is monotonically increasing (controlled by the
> > kernel : __nfqnl_enqueue_packet(), not user space).
>
> If id_sequence is allocated by the kernel, is there any requirement
> that the values be sequential rather than just unique?

I will defer to maintainers for the authoritative answer, but
NFQNL_MSG_VERDICT_BATCH API semantics rely on sequential IDs
(nfqnl_recv_verdict_batch applies same verdict to all IDs <=3D max id).
New options could be added to opt-in to different ID generation
behavior (e.g. user acknowledging NFQNL_MSG_VERDICT_BATCH isn't used),
but not clear this would always be beneficial as "unique for all
packets" depends on size of map relative to number of un-verdicted
packets. Packets can be verdicted out-of-order which would require
additional tracking/searching to get "next unused ID".

>
> If they don't need to be sequential then the kernel can pick an 'id' valu=
e
> such that 'id & mask' is unique for all 'live' id values.
> Then the hash becomes 'perfect' and degenerates into a simple array looku=
p.
> Just needs a bit of housekeeping...
>
>         David
