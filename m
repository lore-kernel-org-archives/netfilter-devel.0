Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADCC215F40;
	Fri, 10 Jan 2025 16:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736526431; cv=none; b=tC35jUwJT2N1/rAzkRRfRKpneJtUxLp6VA62KTekhr912iHdM8flVNdxXKJfJqs6t8FqpqI57Ex3ORT0A4lijghJlCR+Y92dI1AhrcGpNTm02DTA9DlvdAUgf5BGMBZ85k+ypJjVsI+h6rsEaglO8DpN6uiXxx/RY9/XQ/mD0CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736526431; c=relaxed/simple;
	bh=ZiPhK5vgQpBvD7RpAFAKT0G97/ZliQjaX7Mkza0GpvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pVCbWIoG5DgQe8fL0SPbJK7BPO9lpxIYyZTdrw2PIGShJBaSSQ405BIqqcUbFJmSSXADvBXO1CLfWBvETZGW9FvXSJyduJzkVieGB4S2EqyoLEywNrI63xWCcuw282HK2HXICxlYsPTPax6FJN3eCqbYRpY+OXrFS4In9SnNgmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PAyKE8cx; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PAyKE8cx"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-385e87b25f0so2209316f8f.0;
        Fri, 10 Jan 2025 08:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736526428; x=1737131228; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yMB9xkNsYE8QzdTKwQ47u8LlJ7axgUiYXav5hpZiRQc=;
        b=PAyKE8cx1WSgZxy674kDENp94mKZVPC8yqXQNfp9eVEPsnIsDmGsHWUOTaHmmb1XKw
         /fA2HCyXaMdWvSkrKaUHnNAazvG51gE8VihUau3munNdQfm6f4bUoNedDXmCKzDu+Ujp
         giHHEVolSeFc6zCev4L8U6NVqiNmPsfjd3pJi4XgNzTgwhAcQl2v2LNCGgwwGMhay1dL
         M9fOBSTrKstrpRhN5oofz5x/Imgm9t/eerU8kA9bsrc20JSRTAZic1cNwlYl6i4AfTk+
         5HnLjqot0nLPW+vP/nPdvM9+6YtUCVsZt+VOtEofZ+VWrYKcHQs/DA/vqSMVoG8dNb7K
         wBMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736526428; x=1737131228;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yMB9xkNsYE8QzdTKwQ47u8LlJ7axgUiYXav5hpZiRQc=;
        b=AHp/SPZDDDjIapqpYk4mvBvtKDNZBpgpOqFqeINLxL8yLoX06pRAgNJEn87gOsTMdd
         Kx7DRthMoj0E97HXAmXunHSrXqR6yeJvlRgHGJQKVFTNMB6KCRvvvh9sx5dPwITPG28K
         Gbwb2ZDLP2+yvH6rddOiYVPmHJpxB8h/9pyeTGdIfHhReFyOiDdoaXuKw3C0iaI8bv/I
         0xEcCaeUCGsYQiz1bTOr+vraF0VAYypEpM30Mi0R+v3rCqPbJKVuKK7tCzrtxWXjzJPp
         6pXY8KXadKognzrFFHY8uNMS2kMjgJYKsYaVkggFHQEqqxeWecUVzNaJOa6FelTkc0PB
         eP2A==
X-Forwarded-Encrypted: i=1; AJvYcCVLEfji+y72/o7RRAvYDsEgWa7Js/bIRc4UI7R04itOHOY6dmaCIhZhFaeQrvkNokxoSw/nwRmrEWdx3t6IJpa7XQCXuFY=@vger.kernel.org, AJvYcCVwE5GlU0QYxcXnWlE4z3NmtMWHInA4LFIkjCMPiQ6OiykColmjHq0OpsFWKX03X0qnfRtW7zZWKpM+6xyq0X7u@vger.kernel.org, AJvYcCXAQ9xnPyzA2OyliyKTixz0HBVYwod7vsgyLUMi6RXGnvn4q1NHnaUGXAlMf+5khJJZwDLwc1Vb@vger.kernel.org
X-Gm-Message-State: AOJu0YzfLn4B4HWyrJqsryh1CT0hV47nj0eDtjYeTXkUrTK6KpCiheKC
	8Hnum1V1PT0mjVs2/9XZiXTY428VA4o+ICDLJrswam2zVg6rXh9O
X-Gm-Gg: ASbGnculIYNZE5t6etyM3IQnJb3L8nv6VKh0Bew4fvKPs3E6vy0+LV01mTifCyUq6eO
	8JIIbFdCO70Vr7yL8HSCwgOmV/LFpQEAlCVsLv7b6QsrhOBQ+CoZ+A5wVBZjnfnsNmF1aHg3aRJ
	h3Gfsmgugl4XSqv8fU2t+107tWJgx5UyHC2d/wr61z88bFN6p2hoGkgmVPaqwfrmMk8Y0L1MWDS
	AtoBHdmrO0sYt5Vg6AggKSj4HPozOJkJW5JEgqkRS4ZF1fx4PqEBtvS/Q==
X-Google-Smtp-Source: AGHT+IF9lDcXaSKtJXeoW63ZHOlYb6k96KiJt/bfhAjm6GMGd4/IkxLEroQXqdZ6WTXM45XqSm5BoQ==
X-Received: by 2002:a05:6000:4712:b0:38a:8b34:76b0 with SMTP id ffacd0b85a97d-38a8b3476c0mr6444299f8f.27.1736526427760;
        Fri, 10 Jan 2025 08:27:07 -0800 (PST)
Received: from localhost ([2a00:79e1:abd:a201:48ff:95d2:7dab:ae81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e37d090sm4876192f8f.2.2025.01.10.08.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 08:27:07 -0800 (PST)
Date: Fri, 10 Jan 2025 17:27:01 +0100
From: =?iso-8859-1?Q?G=FCnther?= Noack <gnoack3000@gmail.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	=?iso-8859-1?Q?G=FCnther?= Noack <gnoack@google.com>,
	willemdebruijn.kernel@gmail.com,
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, yusongping@huawei.com,
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Subject: Re: [RFC PATCH v3 01/19] landlock: Support socket access-control
Message-ID: <20250110.8ae6c145948f@gnoack.org>
References: <ea026af8-bc29-709c-7e04-e145d01fd825@huawei-partners.com>
 <Z0DDQKACIRRDRZRE@google.com>
 <36ac2fde-1344-9055-42e2-db849abf02e0@huawei-partners.com>
 <20241127.oophah4Ueboo@digikod.net>
 <eafd855d-2681-8dfd-a2be-9c02fc07050d@huawei-partners.com>
 <20241128.um9voo5Woo3I@digikod.net>
 <af72be74-50c7-d251-5df3-a2c63c73296a@huawei-partners.com>
 <f6b255c9-5a88-fedd-5d25-dd7d09ddc989@huawei-partners.com>
 <20250110.2893966a7649@gnoack.org>
 <3cdf6001-4ad4-6edc-e436-41a1eaf773f3@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3cdf6001-4ad4-6edc-e436-41a1eaf773f3@huawei-partners.com>

On Fri, Jan 10, 2025 at 04:02:42PM +0300, Mikhail Ivanov wrote:
> Correct, but we also agreed to use bitmasks for "family" field as well:
> 
> https://lore.kernel.org/all/af72be74-50c7-d251-5df3-a2c63c73296a@huawei-partners.com/

OK


> On 1/10/2025 2:12 PM, Günther Noack wrote:
> > I do not understand why this convenience feature in the UAPI layer
> > requires a change to the data structures that Landlock uses
> > internally?  As far as I can tell, struct landlock_socket_attr is only
> > used in syscalls.c and converted to other data structures already.  I
> > would have imagined that we'd "unroll" the specified bitmasks into the
> > possible combinations in the add_rule_socket() function and then call
> > landlock_append_socket_rule() multiple times with each of these?
> 
> I thought about unrolling bitmask into multiple entries in rbtree, and
> came up with following possible issue:
> 
> Imagine that a user creates a rule that allows to create sockets of all
> possible families and types (with protocol=0 for example):
> {
> 	.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
> 	.families = INT64_MAX, /* 64 set bits */
> 	.types = INT16_MAX, /* 16 set bits */
> 	.protocol = 0,
> },
> 
> This will add 64 x 16 = 1024 entries to the rbtree. Currently, the
> struct landlock_rule, which is used to store rules, weighs 40B. So, it
> will be 40kB by a single rule. Even if we allow rules with only
> "existing" families and types, it will be 46 x 7 = 322 entries and ~12kB
> by a single rule.
> 
> I understand that this may be degenerate case and most common rule will
> result in less then 8 (or 4) entries in rbtree, but I think API should
> be as intuitive as possible. User can expect to see the same
> memory usage regardless of the content of the rule.
> 
> I'm not really sure if this case is really an issue, so I'd be glad
> to hear your opinion on it.

I think there are two separate questions here:

(a) I think it is OK that it is *possible* to allocate 40kB of kernel
    memory.  At least, this is already possible today by calling
    landlock_add_rule() repeatedly.

    I assume that the GFP_KERNEL_ACCOUNT flag is limiting the
    potential damage to the caller here?  That flag was added in the
    Landlock v19 patch set [1] ("Account objects to kmemcg.").

(b) I agree it might be counterintuitive when a single
    landlock_add_rule() call allocates more space than expected.

Mickaël, since it is already possible today (but harder), I assume
that you have thought about this problem before -- is it a problem
when users allocate more kernel memory through Landlock than they
expected?


Naive proposal:

If this is an issue, how about we set a low limit to the number of
families and the number of types that can be used in a single
landlock_add_rule() invocation?  (It tends to be easier to start with
a restrictive API and open it up later than the other way around.)

For instance,

* In the families field, at most 2 bits may be set.
* In the types field, at most 2 bits may be set.

In my understanding, the main use case of the bit vectors is that
there is a short way to say "all IPv4+v6 stream+dgram sockets", but we
do not know scenarios where much more than that is needed?  With that,
we would still keep people from accidentally allocating larger amounts
of memory, while permitting the main use case.

Having independent limits for the family and type fields is a bit
easier to understand and document than imposing a limit on the
multiplication result.

> > That being said, I am not a big fan of red-black trees for such simple
> > integer lookups either, and I also think there should be something
> > better if we make more use of the properties of the input ranges. The
> > question is though whether you want to couple that to this socket type
> > patch set, or rather do it in a follow up?  (So far we have been doing
> > fine with the red black trees, and we are already contemplating the
> > possibility of changing these internal structures in [2].  We have
> > also used RB trees for the "port" rules with a similar reasoning,
> > IIRC.)
> 
> I think it'll be better to have a separate series for [2] if the socket
> restriction can be implemented without rbtree refactoring.

Sounds good to me. 👍

–Günther

[1] https://lore.kernel.org/all/20200707180955.53024-2-mic@digikod.net/
