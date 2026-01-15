Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036C052F88
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Jan 2026 14:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768487570; cv=pass; b=oiemujO04n3QSQhpIxmMc7/PjlZ3u7kbixq59bvB7t61P9wTLxjSXXevVOnOOuxiC/3Z+YUFRyH1JcV6VilomzC5RxaITza3NP40qJtsKCXSWn1hEdr1zZ2cuHEdnU9vqV8ZThJSRjOEDZHJeKZGa7rvRJjhz7aBA10n1OQpK/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768487570; c=relaxed/simple;
	bh=pnKBieAsBBN1nRjdO+ZKu8Q1lebF47x2O3DUXxtYCFE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R/Vu9SB7Y34KXMbqEJT/0qoiAS2w7f5EtZtPdaGaMj1fk+7o1w9xnB7p+cRuQtQx/6um9JWE9u7QCWW27zlgSxK1jpVdbop/nstcwvfjdgsgGzqIKeVdgc7NmCUwCIo654yFFj7gnXdNGYYm4qqVo/kVe4CwMRB6FgWh23MttXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=AFIA3KkJ; arc=pass smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="AFIA3KkJ"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a07fac8aa1so7094825ad.1
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jan 2026 06:32:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768487568; cv=none;
        d=google.com; s=arc-20240605;
        b=Cr+JexMEvbZ3J5XHn+RDLDjG86H/Oi34Lo3xn5Qv/tbxxmgsv4ybM6weyDbINTLjMs
         yLW0tY0O3B7XYM458SdDaR5A6E3b41n4qa/a4hnsWxl3bEb/O40LsWMQinmwrhZgdPeF
         HtwH/Hs72MTxSK9Surrk/MUFAoo20zd9IVw/NVjln4VAkAPhXo65VwRd6yqv5zwXxHCz
         lG7hgYjBgkXGkdu+gJqOzaZUoPAKixKPNEClUjUP/LMOOLzbKpAVVg1JHbKa0VSRQRfV
         UNykZQ7XqPk0U/nuO58MFZs4S4nz2LcnnXI3DFUuSYYOx4jo1exBTshqGe5puIfhDS0h
         mqVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pnKBieAsBBN1nRjdO+ZKu8Q1lebF47x2O3DUXxtYCFE=;
        fh=I5VHvE0DSX6aWl8mCVFHgIy5SNp1hfDx1PnR+92jDdw=;
        b=SaXUWsUIEXGmyQzVNi7CwcUNId4PvDAkGjuLzS5FHz8ucyYsvanhRZpR3ucvlDCwB9
         ls9QoF2ocTIKBoLPS2LmSMIAxFNgB5mvPrUQ2Ze0dknUggZTEgQ+W/EEVanqSBkCLKGv
         SW2BDKnPpu2KvOIMDCEArhaAsK6a00gBbhAZLw1X50hZxPjATYy1swRGwB2lSbUQrnI4
         OKB6L5hv52OxXfUWvj1h6cLB4Pgd2BCMonwwbqMhpRS3WCqKPqajxDm5LbqQ31jrIHmM
         a5dmLlagcauRT3dVjO2g4GZqPUCjOcBbIteUeXbbHs+alF+yPRX7Wb5b16t2ehjGjeuo
         Zb0A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1768487568; x=1769092368; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pnKBieAsBBN1nRjdO+ZKu8Q1lebF47x2O3DUXxtYCFE=;
        b=AFIA3KkJjoSwuuMC/gScuUH4HPfFsB61fL4mlP+dZrb4EIfqsjMAUw6ssPH+h12YWe
         CbvgreRiA2RhSsY7r/dkGrBE7zNJeT5Qt4xL//WT2tjPPHvvNUfwVgrj4agj2E1GwfSD
         QAGEK1bzbrxom9UIzhm7r9WxKfkZaz/qdFCBuotNLDilj/ZIFmTxG1rLcRzxvSvbiER/
         stgUpEMQRdpIk6htFq1agLyGaPkU1SAzYFOljc0Ek0ixIqbgpIhCXYY7ObKYS4UCq/IQ
         Fdi5wjXSauL6F/l7D9qWm8Z4S5po0bWbs5WrTClr6Q0ZmQpkfrIEXefNP7eS2nrERr+W
         8ypw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768487568; x=1769092368;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pnKBieAsBBN1nRjdO+ZKu8Q1lebF47x2O3DUXxtYCFE=;
        b=TwL87a6cdc/wi96TpwCw6BjXsIKbPyESVDhIYuBpx/yFEx3cv5BMMdwodBMDykibLq
         zAVr9YVaG65j+f1NPuCCSABEwl4qNMYuHqFKIMiQb14ENXg3T+lpxBt0Uxomxm8d6rcf
         dnxNfLgKaGx25XOFTn/7zP74D6gZNDMTs3h/0sGXV0TdoHxycWAgudXSFY7bacwopV1r
         tA7B7oeN0ojWCBITAkXKfNcoP7ezbKmAqmZlQBeUebSX3RONDPyu1SSoLZ9fWbSqSU4g
         9HIgCyPSyTYjGmbRlqhxp6eSJCxpUR7DHRzrtbOqhqtTEutgVUyg+JwyIdFdQIRO/iv9
         27ag==
X-Forwarded-Encrypted: i=1; AJvYcCX3vVZiRNK2TdrWXqYh1PFGkZDzwU5IXhYykzhnfEUnw9GAWeFmndVzEoBA7GtHWCe428nZuqfHpFeCgUP/IzY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7P0JcuXYZqaVBPYSBVLQTJCILmaVTjB38d3C7UB3O+hCL9+g1
	5kKiqombVlE/dZq7NIQAzo2sRrBiA9cbiY+V3jUBwvDILxpmXf6BB5ANre1Rwk4z6KdmeXjzf5r
	N6W3x+di5YsdpO7thuGkzbadQ54spaB1yCdW/XAxT
X-Gm-Gg: AY/fxX55xHpU5KV9nFGMXdbEfWJ5M+eGsRXixXfCjmEp5KeGBesHB6GyV1fyp5Lpx3I
	sGzhGf3NKiQxG8V2nANWX3ua0mMF3SKSGrFrShrbPtBWhQuepPCzoCWK4pc1q9BcVzt7IgggKjr
	zuPT1aHqe8iFAUfnxACacbtR1aBAr2xTemScw+EPwScWA/HcTIqykJ6IaiwJ5Q4EDtyBojSx0jz
	awdtTZ3w+6AQEJBlTc2k3YKmfpyq40uw+IbQPXQ1G34DRSl7EOF+qH/ZvNHkx87uv3MTA2OjLIG
	Jgg=
X-Received: by 2002:a17:902:d50f:b0:295:5972:4363 with SMTP id
 d9443c01a7336-2a599cd28e2mr57322295ad.0.1768487568175; Thu, 15 Jan 2026
 06:32:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260111163947.811248-1-jhs@mojatatu.com> <d42f0c80-e289-4e0f-8608-10580d315fd9@redhat.com>
In-Reply-To: <d42f0c80-e289-4e0f-8608-10580d315fd9@redhat.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Thu, 15 Jan 2026 09:32:37 -0500
X-Gm-Features: AZwV_QipabjBhZ4WpV9rzlhYCiOdxNRQmYEEEVl7HpRiSmMSb8kUxTzzzVTbiRo
Message-ID: <CAM0EoMkFMURPj3+gNOaqO60D4deeht2F3EZWZbmShjO+B4wJBA@mail.gmail.com>
Subject: Re: [PATCH net 0/6] net/sched: Fix packet loops in mirred and netem
To: Paolo Abeni <pabeni@redhat.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	horms@kernel.org, andrew+netdev@lunn.ch, netdev@vger.kernel.org, 
	xiyou.wangcong@gmail.com, jiri@resnulli.us, victor@mojatatu.com, 
	dcaratti@redhat.com, lariel@nvidia.com, daniel@iogearbox.net, 
	pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	zyc199902@zohomail.cn, lrGerlinde@mailfence.com, jschung2@proton.me
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 5:23=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On 1/11/26 5:39 PM, Jamal Hadi Salim wrote:
> > We introduce a 2-bit global skb->ttl counter.Patch #1 describes how we =
puti
> > together those bits. Patches #2 and patch #5 use these bits.
> > I added Fixes tags to patch #1 in case it is useful for backporting.
> > Patch #3 and #4 revert William's earlier netem commits. Patch #6 introd=
uces
> > tdc test cases.
>
> Generally speaking I think that a more self-encapsulated solution should
> be preferable.
>

I dont see a way to do that with mirred. I am more than happy if
someone else solves that issue or gives me an idea how to.

> I [mis?]understand that your main concern with Cong's series is the
> possible parent qlen corruption in case of duplication and the last
> iteration of such series includes a self-test for that, is there
> anything missing there?

i dont read the list when I am busy, but I will read emails when Cced
to me. I had not seen Cong's patches before yesterday.

But to answer your question, I presented a much simpler fix and more
importantly after looking at Cong's post i notice it changes a 20 year
old approach (which returned things to the root qdisc). William had
already pointed this to him. The simple change i posted doesn't
require that.
In any case if Stephen or you or Jakub want to push that change go
ahead - we'll wait to see what the bots find.

I am more interested in the mirred one because the current approach
has both loops and false positive(example claiming a loop when there
is none).

> The new sk_buff field looks a bit controversial. Adding such field
> opens/implies using it for other/all loop detection; a 2 bits counter
> will not be enough for that, and the struct sk_buff will increase for
> typical build otherwise.

My logic is: two bits is better than zero bits. More bits the better.
I am not sure i see sharing across the stack - and if we do hit that
situation, something will drop and we can debug.
At the moment I know of these two bugs - which are trivial to fix as
shown. I don't think it's fair to ask me to fix all potential (and
hypotheical) loops; i can fix them if someone shows an example setup.

> FTR I don't think that sk_buff the size increase for minimal config is
> very relevant, as most/all of the binary layout optimization and not
> thought for such build.

It is not really. Nobody turns off options that are ifdef just to say
"i need to save 1B".

cheers,
jamal
