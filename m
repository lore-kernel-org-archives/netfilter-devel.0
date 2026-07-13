Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05AA3655C7
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 03:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783912228; cv=pass; b=jw2TrwJjrSy446JaJEcivHy2VpgdiPowE2qMd32dA8kNP3c1tYWgNBVV3eCzHcg05aMmB9+Rvv7yHM514apQsN00gXuCAjnswF8orSJw4qGFPJ5MfwhRrLUPR7fWU9/h96JjPlv97mfVTUMoYD3c5qqZIDVyvzWIJCBeLvKtN+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783912228; c=relaxed/simple;
	bh=snbQm3CdmGNBpMwSTg0euodzn2P+zqYJrnjlEEblrKw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sajyXotJVV3ZtDsWoTAOMwiNl7h4XPe8jHUsQI1cx6LNEIspoqmfhmO6qDZsFz2DXzICrpzlaUjGxW+8jzlSq/kxgV8qQVTPo3su0R3aPk6cIQ5ExuxoTstvbDcPusLoD9tlt9BeHBK6oGpbeJx1LdGdvDMOAMz27HW7CwAoNMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qQIOpN3h; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qQIOpN3h"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-69a50189d25so4708601a12.3
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 20:10:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783912225; cv=none;
        d=google.com; s=arc-20260327;
        b=SX6bpvt3etVMy2W6vwhrujFTzGGTrDZg+xys58jZRUjjzJp81r0m2xnlu6aXjTlrvf
         ZhVr/W9OFqLjfRTn9ltRGGPOZpQox0BpKPmOqLATnpcUk1FuDGn5p2p1sw5oYzodzArz
         l1+LNZCx4SLADWNaRWxeNKuh8vMgsaNs02Bsxkfw/FnfV0kPGhm/UfAAsiuF8GqcWHmA
         lHWT6q9KjXNGwTED9IYmD7QBotyL2kpD0OduxsZErcViOGsPlS4fqqKipndo1/vt0mpR
         PQm8JyS6gjC7PyDl4SnYv7VkmWwiXjxjQTExf1QeZM3g8ZhI23viFCwQQiteN8EpBJYP
         FZUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=snbQm3CdmGNBpMwSTg0euodzn2P+zqYJrnjlEEblrKw=;
        fh=TWb9iQlzIAoQ6VbUrTxzk/buq/rAGcuI0UrpKJMToIE=;
        b=hbQS9TG9oMRvn0AGiFacmsilFtz1OL1GfV6jvxhWuBNwcRnBic8fTUjmcy7jZ6zamg
         +24vjHy0gCTq+FJp3XmwLM4eOMhh29LAERQMKh2JI7S9rOJl/rJzduacnoY/W+M2jjU8
         XDopW+KfMdYILsyify+CcUj06n2eKEMNDUYq3EW9f6dwVzevmG/noo56NoOXfx4iILmz
         qTsVKp8DJcsKuMBZjyMNtEyw/ZtJR1qbPTlPPfXOXDdUF4Bjdf/voQI8MyMeIV0qftKE
         oPmKrgk98cJURjo6RtZYCBU6VDQGrn58GZL65/pNP5838IhlCNMp9pqDKWJy/1pRCeVq
         mCeA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783912225; x=1784517025; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=snbQm3CdmGNBpMwSTg0euodzn2P+zqYJrnjlEEblrKw=;
        b=qQIOpN3hm5ph5vr/p5B+kRdd32XXu1Xwez28v/pNX9vcDcrjZMToco8LwN+LdLZtBY
         dc/PZzutHteVy7zQFvn/nzrGERhw5z379vmPXH2hKg80L8CA3Vy+EOklI37dPkgZLS7b
         bH9uKixehRsxaGsehRQD6VA81/dP/hk5aWqvzFihww9/fmkYcLdoFHdFFChI4siIK0tf
         m2txI1brnKgO1BFhhNfLft0fx/Nu7JrTNVldeRer+Bo9oXgTGzJzn99q1RcNUgn10Utz
         RmJCPkherz84rn1Ffm9wlI6OE9oB50FQuVUAzzPP1Svce2xj4Eji2bSYjGGOp/sSJV3V
         h3DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783912225; x=1784517025;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=snbQm3CdmGNBpMwSTg0euodzn2P+zqYJrnjlEEblrKw=;
        b=BpGyNANzv0v7qsTCU+ggal/AnYp87jyjMraM335yaKNqI5ITc7bN2Gf42q27FlQkUb
         4wDScHQDGwM5tXAsQcip7SL/tKkgiCK9daiS5a0io87cwJncujvwBhsDKl2tXVL9W059
         ByhgejyJEu6cUrzXGyDqQ5OWxwjBFKwcG0kpDh/gTkOSLGkcjTx0gX+Tlc2rwuP3XK6n
         GOxyXYbk19ufh6S6kHg7hsfPnN0eJOLF+nHw1iWsGmry3kWbCH15BFSQDOXgItGMV58Q
         AU+Gbb+1IOaXO/zFPiqSUXZ8fSfWKZFJWoX6Fpfss/DzWUCEs/4o3slVekZOtboiPvSG
         Xegg==
X-Forwarded-Encrypted: i=1; AHgh+RodcvCBKBe9Cmg7zu1DFT4nmt7Zns2QHJqKDhD/GLU4FPYtiCpXjex/TMsmPKA2lGGYS96p7gpecjrRfp3d/8o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzspMwS9cA1Q1r28cfXyTf45YGFHP/mlhGglxd2qP6a6k5Yw9nN
	kxR1btJxh+ziYPTB2Ok9gKwBO5tBlpD5hD4sfagtzBYKP6vBVNzNCyp8pcGJ7qgZtKbzned0Uwb
	5lST3sJ/YWiXFtlmLLhqvkG20jPHSy64=
X-Gm-Gg: AfdE7cn0Tt/TSts2fD6LJAQZIOD9OwOfvnVASjWX49joF0OBw7ZhJgZUkuTg7/Etnzg
	lUC0Abw+zpvmUyirQK8nROwibt37s7d/rxE/9O77p0Jufoza03s5i+ZdVEwtPzwfj7MOUl41/Q5
	bLFpSsBg1ItN/CGqCpYx//htCOqLEEa+UNkNtUHvq5U2Svcq4QIPZ5WJue5F5njVXqqXlZMffVf
	+KoTM+C8YgoYYCC9sdb+aXqo132/vyGQwmnUn8wpHGVcAlrmvi6sFN4EiyGFh1F5Hr6nPI=
X-Received: by 2002:a17:906:c149:b0:c12:9b2d:67de with SMTP id
 a640c23a62f3a-c161f388078mr261421866b.61.1783912225130; Sun, 12 Jul 2026
 20:10:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260709063012.33160-1-running910@gmail.com> <ak9_wZz054a6JMb5@orbyte.nwl.cc>
In-Reply-To: <ak9_wZz054a6JMb5@orbyte.nwl.cc>
From: Zhixing Chen <running910@gmail.com>
Date: Mon, 13 Jul 2026 11:10:13 +0800
X-Gm-Features: AUfX_mwxGXvwgTE6oy5EXU__Jfy1OQZvXPr-yq7oHlr7ByZwFljnkmdYU_NfKlc
Message-ID: <CAMyuFdWjGnoQvE4owtnwANTiaxbq=dtvFri9+vQbPhTEL2aWgA@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: ip6tables: set hotdrop for malformed
 extension header matches
To: Phil Sutter <phil@nwl.cc>
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Phil,

Thanks a lot for the review.

> There is another candidate for hotdrop in there, e.g. the "Packet
> smaller than it's length field" check in line 76. Or is this a
> legitimate non-match?

This should already be covered in the current nf/net tree by the previous
IPv6 extension header hotdrop fix, but I will double-check the base before
sending v2.

> Given the many common blocks, maybe introduce a 'hotdrop' goto label to
> jump to instead of break/return?

That makes sense to me for the repeated hbh error paths. I will look at
the flow again and use a hotdrop label where it keeps the code clearer.

> I think the 'srh->segments_left > srh->first_segment' case is also a
> candidate:

I will revisit this one and check it against RFC8200/RFC8754. My current
understanding is that this looks more like malformed input than a normal
rule mismatch, so I will account for it in v2 if the check fits cleanly.

Thanks,
Zhixing
