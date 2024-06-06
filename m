Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A96E2A1D8;
	Thu,  6 Jun 2024 14:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717684107; cv=none; b=Mcn7G5IhDxflEm1tcFSm+6kSFca+ALfvLGzzlzGM1tMmE8QE8Z5zUHEiqYLfQK1Sgu1aw//mttSY90FSik9OJ25WSRnnLdk9ugyZl3b1OJMSdGI/HyXDTp8I4uD8OddSBpkYXzPQrRSPH4lYgEKdnJS7rKox1cb2w6qKVJhj88M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717684107; c=relaxed/simple;
	bh=hQBzhNObWU8aRXHk0bfsSKO8Qrhp01azpV/J00FvZQY=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=tx6MPcEKEtc5jYpbLs71UjOusLSph/lXTUj5+kFcTv9WLBk9HIMXkx7CFrSBHT5BaPH9Q1EO4oPeGK9YB9m8pNg38bjF7F5dl2yhZL7QAvwQaaEaGBEgfqBSECWHRkw61b+bS815sSxysklScrXQFNDi0jvy7cqapEc1l7AXXxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a3SKh3J0; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a3SKh3J0"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6ad8344825cso3718206d6.0;
        Thu, 06 Jun 2024 07:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717684105; x=1718288905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2zfB3MoLrV5D7vjDIplljlPhLNJrctBwaNyhRn/7mkE=;
        b=a3SKh3J0XkfPi4W2Xbyi1M1F3c5g8LBGN9Ap9Ue0o5ZzqgGbEZ/LQOtMJnBD3a88K+
         9CvfItYuYZpaDW92b2ZNtBxEqdomPn1gC1UNbhbOEqmhpB/3mtJjuNQ5wNnUE0Dy0iiI
         bYaiNnlepsReCf8BXv/IDqEKOul1nZgbR+Ly9JRWxCfunqQrfGiXGWgJp9+Y7hlUxC0N
         vRY5GTnPrRS9X6x7BTcicaRCB0LktqYUaGNjTNt8rPozTBjr939im0fDrEBb1fbzkCI5
         YDHGojzYsGk86TAkxO1rrBnUSFZsZCbodH6oHcimscpmyvUYwnK09LlpBV13zUlx3rcg
         3YCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717684105; x=1718288905;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2zfB3MoLrV5D7vjDIplljlPhLNJrctBwaNyhRn/7mkE=;
        b=qKWmTwVewehbnMk/yNIUdQLlAAaL+2C0q9n9VuGViNkUdTdebPK+Ey+Gf0Tr872RNj
         tbYuI77V36aXDPS3xy+2mUZPPm4guF+fQtKsbsAKirH6HSUMSasqrz8Cf/YhYqw8h2dO
         GkBzxPeCLFd+zmHXxRunKnuAOJExHs4P5nb4jr8cSo4xzgCzE7A2w3AdPWeXfWocDRQl
         XTqtSoNktUsAQZj9/qlTFeSjZN0Ib2mnNQgmRTXyK0ZsEICd3S3fRwf0dfvhn2ayW8NS
         TKLiiVCC/Px5rNWWU4AOxFnJCwNA5n+/57rSTp4b9ucwXFLfIHhZcIVinxw8b26N7rJX
         Nkwg==
X-Forwarded-Encrypted: i=1; AJvYcCVwT8QorwL3pGQFQbA+Hiz0NiUoKMTfEMHRjRjccai49iTrO92jG12xVTwzrnUWPZUw+SlJ6OehzIqeXUIEN+9Zm8H1wP86oMBvJGl2blYxEZ99QMwlNL3V+iAC2SuSDWnHz1AB0rF0
X-Gm-Message-State: AOJu0YyAepXSW6q07mr+tT97ycnWJQdiJGmeIQAmyWySsXPZ1T8ULg8f
	dTsnybaxI7AS08vs8CNga/+MJyCIdYB3yQQ7xDTnL6Ia6ybuDaQy
X-Google-Smtp-Source: AGHT+IEXjo2vdWuwKlB+RtehkJG3gyQ6cMFReM6S8gAFWkAZEAVLG91FarcqvdqseJhCRbxDpzxs9Q==
X-Received: by 2002:a0c:f20a:0:b0:6af:c6bc:bdb5 with SMTP id 6a1803df08f44-6b030a96fbemr61872486d6.44.1717684105030;
        Thu, 06 Jun 2024 07:28:25 -0700 (PDT)
Received: from localhost (112.49.199.35.bc.googleusercontent.com. [35.199.49.112])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b04f6bbd06sm6817856d6.48.2024.06.06.07.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jun 2024 07:28:24 -0700 (PDT)
Date: Thu, 06 Jun 2024 10:28:24 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Florian Westphal <fw@strlen.de>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, 
 Christoph Paasch <cpaasch@apple.com>, 
 Netfilter <netfilter-devel@vger.kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, 
 netdev@vger.kernel.org, 
 daniel@iogearbox.net, 
 willemb@google.com
Message-ID: <6661c788553a4_37c46c294fc@willemb.c.googlers.com.notmuch>
In-Reply-To: <20240606141516.GB9890@breakpoint.cc>
References: <20240604120311.27300-1-fw@strlen.de>
 <FF8A506F-6F0F-440E-9F52-B27D05731B77@apple.com>
 <20240605181450.GA7176@breakpoint.cc>
 <ZmCwlbF8BvLGNgRM@calendula>
 <20240605190833.GB7176@breakpoint.cc>
 <20240606092620.GC4688@breakpoint.cc>
 <20240606130457.GA9890@breakpoint.cc>
 <6661c313cf1fe_37b6f32942e@willemb.c.googlers.com.notmuch>
 <20240606141516.GB9890@breakpoint.cc>
Subject: Re: [PATCH nf] netfilter: nf_reject: init skb->dev for reset packet
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Florian Westphal wrote:
> Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> > Florian Westphal wrote:
> > > Florian Westphal <fw@strlen.de> wrote:
> > > > ... doesn't solve the nft_hash.c issue (which calls _symmetric version, and
> > > > that uses flow_key definiton that isn't exported outside flow_dissector.o.
> > > 
> > > and here is the diff that would pass net for _symmetric, not too
> > > horrible I think.
> > > 
> > > With that and the copypaste of skb_get_hash into nf_trace infra
> > > netfilter can still pass skbs to the flow dissector with NULL skb->sk,dev
> > > but the WARN would no longer trigger as struct net is non-null.
> > 
> > Thanks for coding this up Florian. This overall looks good to me.
> 
> Thanks for reviewing.
> 
> > One suggested change is to introduce a three underscore variant (yes
> > really) ___skb_get_hash_symmetric that takes the optional net, and
> > leave the existing callers of the two underscore version as is.
> 
> Okay, that reduces the code churn.
> 
> > The copypaste probably belongs with the other flow dissector wrappers
> > in sk_buff.h.
> 
> skb_get_hash(skb);
> __skb_get_hash_symmetric(skb);
> ____skb_get_hash_symmetric(net, skb);
> 
> I named the copypasta as nf_skb_get_hash. If placed in sk_buff.h:
> net_get_hash_net()?
> skb_get_hash()?

Still passing an skb too, so skb_get_hash_net()?
 
> And if either of that exists, maybe then use
> skb_get_hash_symmetric_net(net, skb)

If symmetric is equally good for nft, that would be preferable, as it
avoids the extra function. But I suppose it aliases the two flow
directions, which may be exactly what you don't want?

> or similar?
> 
> (There is no skb_get_hash_symmetric, no idea why it
>  uses __prefix).

Perhaps because it is more closely analogous to __skb_get_hash, than
to skb_get_hash.

