Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.174
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792622339;
	b=hrMl6mhmnVHzVxt1eahe6qerMk6h8IVq/ryFdL9t9wuuHTCOWNn4CZVUpSPz1btfnEUf
	 Lxq2yL5L61+GmOxbnlx1mnMSNfmVmbqOU/gLyjNhvjN4H8q9llcNWwwmGRGChJlGH5D+p
	 sCEulPj/+Tx0D9v6xa/dYsvz8YLIgzGlq7zd/nmuz3IDIMdWXrDS/cSg+shPj4utQEyOI
	 ITr+i6hoK9ozTLeHDC5qljO+PeGuOEt6YymOe6I9jlK26MoRyqUGddRKfz9PI8gU2aYcO
	 JxJ8TfwyQBnnjR3ZvOdO+filx6b25vPjMtzlCufPJAtP7edIvbNhDujv/cu+EpzwPqw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792622339;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=SmC5QDaZtY/tUHrpKqljZ15wNyGf+4dy53b3mfaEpts=;
	b=PfcyEo4rinf/3U/QSTd4pFbZylnHD5cKapE8tfDiqgT+J1vzUvfhE6l2j/T+4lWwL6I/
	 o1zUkvSu6aPTOTpYgY5gTjk7FKbJbzk40cv5uTnaKXz1RRnt3Nvr72cMj0DXzw3U/WH0Q
	 0mSIxFYisZ71ZwoXFd18QMJRE03QO2c5Mc8I/ZozD7ZXLTAhXjEfDyGlzbfOfvwpDdrCV
	 YsGkvOu/4VlxOV6XlLn6qa6roe7ZtAH8poasSbUm8B37HJXnoudVSyA+XWRPG3GUsr9XV
	 gQ8L3voj8Fc6bHDorKzm0G+lR19LNDxkD0GOJ2doVqoUD5oL6KotPCiJXWEs7aQHZ6w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=ipZhChH6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.174
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD56606A31D
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 22:38:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DAD56606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=ipZhChH6
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8ac8a2ac52bso4055967b3.0
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 15:38:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792622338; cv=none;
        d=google.com; s=arc-20260327;
        b=Ibsqbuap4piJW08HVfPzLFqOGq2s6vHcnFeydewgAlDpG6EmxwoxrHQh58bAN94e+y
         piDNxsi346dS3rTYnS4k8vJY0/CqSFEaqMOO9jKDWPupouJTEGY02w2kYUbQo6negNri
         QxaNi98l8iE5Nl+jublOtNM3unLOrQi26KZUsrwMlfMK3LcWQIXIPNN2YnR1iwXfmxbx
         5jnTPrILZA9c3OYSV4N+HATUYIykUxuyWVk6myXhcz1pZpgJNQ1rhpQ1S7Q9VIbL3VFz
         ILjMpxg7+WdQMmNraBkWx3wFyrW2FN9nt2eAxIBfNLjqkVN/Oo8Zg7ZaypBQe5+S9D7/
         Bhew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=SmC5QDaZtY/tUHrpKqljZ15wNyGf+4dy53b3mfaEpts=;
        fh=uVUDoKkNpB83kVLigihf/miKfM7HcQcYj7ldrmD2CSY=;
        b=CUMe4eah9Eyg3GYkl8GauRFMyG/xFHpObdbEhawKkmbXul8qEjvOChemIvp+FHURXw
         YVw1mozA/bzNytnOcoYrcVTr0XGMva4XTkzxueBdxgGKVEzvMBXbOgQAGS89tiEZ/YQk
         zeuRKdgY3uhihhIMKvFHpSeURbyRIQT1DKo8d58d6KlDXqXOYEbS/p1o15tVwpgmCgJM
         9zqzcv2lGQ8YrLpxUwN2SCiS/x9qidRVWhiVjFwbbMg8mRsvyEINuI1P2U1VFH1e8TRu
         uz7nl1ZQCFYz8Q3YXQI0C4PWxM7dtH6SL1C/IK+W2npMNu+C86lj6vsieb5DFJG3CN1C
         h6Gg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792622338; x=1793227138; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SmC5QDaZtY/tUHrpKqljZ15wNyGf+4dy53b3mfaEpts=;
        b=ipZhChH63S3JydgLIQpA2i/1Q+0ZwZU9Kk8gbIBur/B7FjOkuH++WKK5WXDnZJhdhB
         dZH7Kn9WD7hxV6WFIlwjPzhw2vlptHIn0nwyVrTf+EzK4a79NRbmc7yTPUPZPdxQkufV
         mryx3cKnr2UnkfFCrfDm5Hgkp6Dz1oBrmUTnuVw5yfzopboKEr8cxdBn4o3YIs+UNOwV
         Hd0V9MjwMZ2j3fEmTwzQG/a0B6qudXcNmnnrHEuTNBXMdI5XkR5Ytl/nmPbhNi24j31Z
         v9mbeHEfwePAzfphL32krwpVyk2P9vwxCKTUWhsJGnD0llOAXPz92ok3uJ3ShxfYlofZ
         WocQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792622338; x=1793227138;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SmC5QDaZtY/tUHrpKqljZ15wNyGf+4dy53b3mfaEpts=;
        b=EIsS7abizVAWi10e/ISGBMl0u0Bdd7TjMlpLZVaVEBSLFOeY9RjDd4qMh0qYaU+aH6
         q1Mr5rmdaZE5ptTi8Ia1yrlWvaNxBQUMHsKPQoAeD8TLge2t/IJJ6L4hk7dyXdOY//7A
         m+FOZI12c3medYfvLO3yDEWHjuNjkh+icmHMh8ZCwTgu5+b8ltf7/+NivJO8OhslxUCh
         crsjRo4rPiTZnRDuuHlo9IvjDk/9XjYcSabwOYyOQ/oiaHKr7LiJtKnmse0yrXUfrYaZ
         Ed4a/XY8DCmrYdQyXviM3u5xtNzWFnUWDuWnpUR8X5zxowzf5nl5RHhoWZpKyt2a7rJl
         qcZQ==
X-Gm-Message-State: AFq9FYLiUDu73g2RzazAuBET3w+LA2dkl/AHTSF2hYa7IbA5A4BA1ylF
	Ax8can4ACgE0uhtwau+f6VUsIVM/NPzObtdn20nnND96WsdHle8jPfKMH1n4hNRtnNrpH1O6Iuk
	w3p+WUjMAyZxXxnXE0p33N8yyF/P/CK9ILAmnzvJo
X-Gm-Gg: AYBFou2RFsTUivL9aetdo0t319QmB7TB3SUiSiNXXfmn9bx6KOfC0ifPp52g7Q6HbDo
	PegeqX9ZF6J1ZjGIp8wwNcr8tqBHNGrpmJ9HGJNzj6oYbPaM0T4rKZ6etcP78Mxgr/pm1Eapn7t
	ekAf+NY8NNrq0ROJjaf3QyWmnPgpZ5PDomUOwtyoqUlUR7NU7lRBPWIaXHOFtwk62wWuFJOGph+
	SO1f3xByBe3uHgnN7O5wcfGVzdtE/JQNmlUgQYu6lwNy61kZv1lw69ANdoFKwGrSYUVfFMX7lrD
	5uOAzI1qPCZAGSsY2765EPnUxY2yN9oagetvdEPf77wR5e6lBb0mGzBCYeuYkHF2NSIiF/9NqO8
	DX5QsZGUqqAgPA7M8rvhjzE7HrwGEyL1wrbN52i5ql+ki4O721018tSOp11QPuRNWBllWiPmqaY
	EPjPjDaTNK1AlELu70TyaJCaT00HQRafYy230Cqhm4xWKww+chZapdNLktmgu29m/voCWsdHtnM
	6lm7EW+hbjf/oO1c7KAsYP2b1ehx0kKs5hjYGW0ah4k4FMkWhUG3ZHy+SivdseGvYhSUMGR+bF6
	oDd6XacSMLY3UCuTeh3jZQhk9n4VDGyjGNRnToFELwdENc/rHl3yh2uO8+QmVCC0NdeAwh8=
X-Received: by 2002:a05:690c:dd6:b0:89c:41f9:b8bd with SMTP id
 00721157ae682-8b145717273mr4834527b3.20.1792622337820; Wed, 21 Oct 2026
 15:38:57 -0700 (PDT)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261004171628.3544978-1-julius@bairaktaris.de>
 <20261004171628.3544978-2-julius@bairaktaris.de> <atQii0cO-HJb5TQ7@chamomile>
In-Reply-To: <atQii0cO-HJb5TQ7@chamomile>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Wed, 21 Oct 2026 22:38:21 +0000
X-Gm-Features: AclHuK9eNtJ1Y6ncuQtLuxl6DPZP2RAM-Lbg7K0P7AME9akQS7QgqY9EuzG32NA
Message-ID: <CAC1t37L_0ayne1Hj5Eg6xkfgWvu3uVU-sw7rdjgs7J4Ov=v1EQ@mail.gmail.com>
Subject: Re: [PATCH nf-next v2 1/4] netfilter: conntrack: pick up a TCP flow
 whose SYN was never answered
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de, 
	coreteam@netfilter.org, netdev@vger.kernel.org, geldot@protonmail.com, 
	shuah@kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The series was written to offload LAN to LAN with the default send_redirects=1.
With two subnets on one link this doesnt work currently.

Would something like what act_ct does for UDP be acceptable? The ruleset
opts a connection out of TCP tracking, and the flowtable offloads it
in the one direction it sees.

Or is this all too "hacky" and should be dropped?

Julius
