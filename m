Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAF83EDE6B
	for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 23:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778627159; cv=pass; b=d8v7p73QMVX1S2bMVNrOGrK6eIhJ1VhyyQClV5twTrr5DFPiXUi9AlGpD+hPB7y3qS91gKz46k3dcjlXNTRuwMRCk4X49yd2pmC32PkwBykd3BbuKYNygySLbzUMj7UDup+FzKRlONcJAVOllc0a7yUYj33Tla70IFU7VrjnWC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778627159; c=relaxed/simple;
	bh=RhzImYsmOKKHk6qrADsWWn7xKpqZhsUfQxb019Di648=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n/tiWLnk1aAwASrJqetedpmYL5U/9Gq8/prK3F+AqdmIe+X/s7jlxHgBErdeptewVxTRZVO7z8Cs4jR2fLTr2lMMijtWL+uExWLk3wknYU83EUnCNq/4zAFEzs5ztjApM2WmzyGgG31TdnbA1M7CaM6iikD/hdDb/k3jLj9HZfI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DjhTpofi; arc=pass smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DjhTpofi"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-65c1ba7eeb6so5926801d50.1
        for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 16:05:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778627157; cv=none;
        d=google.com; s=arc-20240605;
        b=RnZwb36k/KRNKNlfDXL9vYexSBSXyY7Ss1g2RliWM3Iqdzo+c8OrBJnIrrj0pn4caH
         R2ExwBMzlwtEj5fAt7oLtp+DesWqqMTZQMl/RPplAc93mAnVd7Ki4JBuSfYoX/2bnqCd
         /OMEQbpDnWwt2QeBpVxLOSULnNQvOUm/dm6f9S2hXyc2kJxyDtxtsDARMeuRxbtkfK23
         I3hD+lXquXDkjC3whxPX7aTZjplLULXcaButosS6gf9EgCriQLvy/dlZReWRSSrHQnty
         uxQKTFPSxSldiwQukejWc/SajtnYXfDYd9tXSwWx9N4TqDhiz2vzzZWHeRumCUI0vWCv
         B+Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W1cX5/tujz2IvokGuYBkLn/0gcvAXJBHFlLEw+M7GKk=;
        fh=8jzQJzTsrzpa2sKssVwLQkMKjYOXucE1Gc2QHZ0yK64=;
        b=W+PirjhhQxI4+caTq/OEGKGzfCNqdME/m2zCCT2hhV58LdIH05G6EU5KeanvgAqhhk
         224rJW8z+l2tkYVHtdSiWIncqdM7eKDZS8o1jVhi/6bJtT7OSjYcPnn1OsfyNGzpGBiK
         xwx4MTSXQcf87+l20WbU4QrKVOlO6CubqM1fwGz7sC3HR+Lrj21eBSU3ltYpcRry0Ip5
         oBP8VwC9CbfEwu4PO+aBpt7XQJ2GaufC0xlujxBVScMUBmUNblhZDi2aeGdRgzLBxxBa
         1CVxJUPafzLcJpMrM8sfPEMcLWZpjOE0XAn3NUxmcl9go15ndDC/qolOaRfpLfaIwOqT
         DzAw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778627157; x=1779231957; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W1cX5/tujz2IvokGuYBkLn/0gcvAXJBHFlLEw+M7GKk=;
        b=DjhTpofixFHRFuMnAdAeX1Tt+FOGGdbmhSShAAdLjnkUw8QEe4Nrk86l9SLfDI3ZxY
         Q8p2u1IZ3ESFKzQ8d/oGyiVBUNocDbCoHVm0DqRbDIZmUFSx9mkiNSlSWow5K31FBHw7
         ByhzZepgYFWCL2Ge3mDYHKdKQFouOhEwPhjYrvfI5U7y4v3LX2qP3D+GCRnAjmerMrco
         XL24KugvqqknpwuD//o7cy58rhgRVuJ1jMOy/PFsG7rsvKkiOqkhEN7WvLuc8vzvSwXC
         obwVY3jYdzM6pjgjL5ygzCWL+3r9+0wRqOeUiNPbPZZCnjItSrh7IrX3Ax+Qg7gIrvvF
         w8YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778627157; x=1779231957;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W1cX5/tujz2IvokGuYBkLn/0gcvAXJBHFlLEw+M7GKk=;
        b=iryKxuvCywgIa2pt/S7fTbbLZPCwsy5oR6nrTUJYhwOYYtocnhi5nXrlm5+OXIJJxW
         mlfK3ixkAl6Hsb5VYy6lom3QQvShgekfFAllcZPBVO+UiI2xTmZeSJwIwjebyqAmXeg8
         xMD/I1+U5PxksvALAMcPV5fVYE2Fm4rK1MkB1PQolDrp9oStZOu0s/hTN0NFHY7lnoTX
         5AfHohoMCx6ljX5O/JDAajskiJ8fwdAt+oM1S2oSiDIvrn5mVkAefy+7/J+EBzW7sSj7
         jba6KqoXBn34sb/gGuNmLxH16aLtAck58SL7svGZ70Bhl3pribTdXJ2qaYH7n+BtPLvU
         zqZA==
X-Forwarded-Encrypted: i=1; AFNElJ/OW/wt21TXUNbeVk1c6o6g2Zr831hhB7+dMOZY8HekA/hj8x4SKfAsv1953FWzP/lo7temZpSX9YWvQ+4PLNw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yye6bcAHBvZ4fYIb7YVRHVpQPqcTyOZDyWjw41vceWzkNwt21m4
	WBW2MdHLr19w7gNL1XxHA7caD1ZBJreyckKZRBYlHcHPmixL5RrNf1lsVF6L+4B3rCAFqDgCB6T
	myEmAynypur2/tMa9lO+H539CXpgA7II=
X-Gm-Gg: Acq92OEPeObE59i7Wds5hphA240QgKiEZOn4RrPFpqZRyP1cGWXCmRhC9lYhzG++bDy
	EZMyS24W9lbOQjQsPr3omrR5AtajzdM2+OC/cF/birAlZtORxU3Y5AjEQzfbK9s3N2pGfYiseim
	TD+dVkvZlndeQacAf1nzXGCOireIUrjkNlEwVrRtTBJGC2+2P7Q6lN/qBDfecajvrgfjmC+oCrC
	2V1oOleJOnpsvG2ekqEOy/IBN5sXZCdW85WG/Q4DKhXYOT4TDa2CEiq06Y2f8XYmcDgOrIbPeE5
	PtXRujXRgjeSsnLTiqPHutlB/+tS9lixNkKg
X-Received: by 2002:a05:690e:130b:b0:652:f6aa:f73c with SMTP id
 956f58d0204a3-65df830c830mr342312d50.62.1778627157080; Tue, 12 May 2026
 16:05:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1778614451.git.michael.bommarito@gmail.com> <agOrCj3YoMAxsxYf@chamomile>
In-Reply-To: <agOrCj3YoMAxsxYf@chamomile>
From: Michael Bommarito <michael.bommarito@gmail.com>
Date: Tue, 12 May 2026 19:05:45 -0400
X-Gm-Features: AVHnY4LLHxol5Z8Cuh4v98Ejrlk8HjLaj8LKu4bDeQhq9QSTqxdejNfNpCA0ivk
Message-ID: <CAJJ9bXxFHsLDfaEfDTMJajrVJ1GyGUCrNpYoRSdOnVm2AxocHA@mail.gmail.com>
Subject: Re: [PATCH net 0/2] ipv4: harden against ihl < 5 IP_HDRINCL packets
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org, 
	"David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Maciej Zenczykowski <maze@google.com>, Kees Cook <kees@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, "Gustavo A . R . Silva" <gustavoars@kernel.org>, 
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 12, 2026 at 6:34=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
> There are possibly more ways to mangle ihl in the kernel in 2026, not
> only NFQUEUE and nft_payload.

Yes, and there's a peer issue  in BEET IHL wrap I fixed in 017ccd82092e too=
.

In addition to a few other nft_* paths, my understanding is that tc,
NFQUEUE in userspace, eBPF, OVS, etc. will all be a problem unless we
guard in the IP stack itself.  But then if there are legitimate uses
of this path, we might cause regressions for people with complex rule
sets.  That's why Herbert suggested we should bring the issue here to
get feedback from the list broadly.

> Your patches LGTM, are you suggesting more patches?

I think the answer is yes either way, but either A) a smaller patch
set in IP that I can handle if we go that route or B) distributed
across people who know each of their systems better if we handle in
each subsystem.

Thanks,
Mike Bommarito
