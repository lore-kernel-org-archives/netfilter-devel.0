Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEA4F9D9
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2024 16:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732120570; cv=none; b=mI+qSmnsJuzj4dCsJWGiDjHbF61T7zoitCxq4qhUZoyq0tHJwIBMQ3/Ncfjd2SQUjJvmJiVSdm7L0hIsX48aDPMsPsMJO2je8FtC6hF9iGanbL6bImbK2vcAAgC8Ao6VYZtpkkWfIVg+oW0hul1YKj/NU09Io198G7MI2i9h65Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732120570; c=relaxed/simple;
	bh=+kMyp427WA5wwMs+bL3GBIsWSyp1A96N1b+KY41WA3I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YJZj8p2TTJOgFoP7zS3ppgS2/1cp2uq4OAUssQXOCpLpWp41Q9/v2KMUdo9jlmoit6qKaZzFeg7n7jWRxNGhU3nY1MSr+CAe/di809NH8/zwNX//snGA+pWFV7zDNQBEHZH9BLVdomifymPG92vjZty6VQdgtjuQjubgnWqUCw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lEP19mTw; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lEP19mTw"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5cfaa02c716so3009089a12.3
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2024 08:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732120566; x=1732725366; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+kMyp427WA5wwMs+bL3GBIsWSyp1A96N1b+KY41WA3I=;
        b=lEP19mTwhX40QJnI7oetvkVQToNMxsnXyb6yeUq9eBJXdBB2tc/k5JFXKDRf0u9rEM
         pUEHjiqM0PRw6WJzsSjudw+oQSMCItZcuSRLuukCRruCiETKXFJwdv5DiUSFgefGqFbZ
         Z67uFx3w0anDrrldk1mmqSwfkgKlWNRe7TpiNRIO1APtQo45nENrP/sDhv6eezH/OL2x
         4zxHjDPuY6jBctTKlQAJKJpCv3MeghbuawhsePU39dmshMWX5zPT2mWyKIqG+3/sLKvh
         IhGO9jJ8LhGDSJ1gzTBgm00MFHnPgR/2eVKX38pqfpxkoIAVRjVPLRq1pj9EcGMvQlVm
         yekQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732120566; x=1732725366;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+kMyp427WA5wwMs+bL3GBIsWSyp1A96N1b+KY41WA3I=;
        b=V/w45e2XKFjdVYyh04jARiHkMz1BqucGzBeALLGukB6qOhZCc+f8Xco0Enhufv3ALg
         13yhkvlpE1WVUaNLTUxdwtStgq4jP3jG/9eFOywtBjYGRYYECDro+3YZU2+MAsytNzTZ
         UL++m8/8FhH8e6toZvHDtSLmusRuddahhbO08IZ6fypo8N5Eos+Sbsc/fM6B7rf69L8t
         AvgpVbl3Pp/CFMkS7+O1ZMM4XN1G1t31BgjA/fnMB8OQng3bM5tmCYAk0+bOBTnX0jLF
         /6zUaWfUsB2Shikx2Dbndbo8IwF47l5TR3UVlquUQZkvJVQ0WTvX3Lc0leQeKJALv6Vx
         q1wg==
X-Gm-Message-State: AOJu0Yxbf/jKvB3vhWBU17sWgZlCw2C1Y7yFFygPVOldhhc/fY2Lbpw3
	e/d2Oiu4sqU62qoWM89IoVFQCRIOuMg2NJo4E2an6DNoGX08LAOdvcLqCwuTKkLxdtpAZHDJEsS
	PER4vyc8MZm5WrJvxMcoMMbc2ze3b2ZaF
X-Google-Smtp-Source: AGHT+IHbf2wPNNS1zviExyGdK5XPlEC250o2FW9o48jQKOZy0Pv9xnJPztaKZm8qojIOMbtoOTvjsO6ZEgZaegeneFw=
X-Received: by 2002:a17:907:7ea5:b0:a9a:14fc:44a2 with SMTP id
 a640c23a62f3a-aa4dd57c021mr261637766b.30.1732120566429; Wed, 20 Nov 2024
 08:36:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACSr4mSaw+M65HpZE+_Rotp=YuWugU9h0vokGyb-14pvoc+-Xw@mail.gmail.com>
 <Zz0TnJtCnKnEreKR@calendula>
In-Reply-To: <Zz0TnJtCnKnEreKR@calendula>
From: Jim Morrison <evyatark2@gmail.com>
Date: Wed, 20 Nov 2024 18:35:55 +0200
Message-ID: <CACSr4mTqwVL8HziF5q6aDpdV26NCtTsh_1fLEPqyg5iNXGiEMw@mail.gmail.com>
Subject: Re: DSA and netfilter interaction.
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Yes, but I am having a hard time understanding how it integrates into the DSA.

For example, let's take mediatek,mt7988-eth defined in
/drivers/net/ethernet/mediatek
/mtk_eth_soc.c
and let's say a sja1105s defined in
drivers/net/dsa/sja1105/sja1105_main.c is connected to it.

It looks like the sja1105s::cls_flower_add() will only be called as a
callback when a TC_SETUP_BLOCK is registered with the DSA subsystem.
When a TC_SETUP_FT arrives it will be dispatched to
mt7988-eth::ndo_setup_tc() but that driver will handle it for itself,
i.e. it will setup a callback that offloads incoming flows by
registering those flows in its memory.

But that is not how I expect the DSA to work. The whole point is to
let the switch do the offload itself, no?. Additionally, most eth
drivers don't even have an internal mechanism for HW offload so when a
TC_SETUP_FT comes to the DSA subsystem it will most likely be a no-op
even if the switch implements the cls_flower_*() functions.

Thank you in advance.

On Wed, 20 Nov 2024 at 00:39, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Hi,
>
> On Sat, Nov 16, 2024 at 11:11:22PM +0200, Jim Morrison wrote:
> > In net/dsa/user.c in the function dsa_user_setup_tc() when TC_SETUP_FT
> > command arrives, dsa_user_setup_ft_block() will be called which calls
> > ndo_setup_tc() for the conduit device.
> >
> > What is the rationale behind this design? Why isn't the corresponding
> > dsa_switch_ops::port_setup_tc() called?
> >
> > More specifically, what is the conduit driver expected to do when it
> > receives the TC_SETUP_FT from the DSA subsystem?
> >
> > It seems to me that the conduit's driver can't do much as it doesn't
> > even know for which switch port this ndo_setup_tc() was called.
>
> Did you have a look at the existing client code that is using this
> infrastructure from Netfilter?
