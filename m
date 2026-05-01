Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001472367DF
	for <netfilter-devel@vger.kernel.org>; Fri,  1 May 2026 20:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777668070; cv=none; b=Pe7S5RCHYfBREe82wPAmps8G09Zj1hfp1UzW/63ousZx9yQmsoN5hksF/TW/yefjhXpLq5D5h2Pvcz9LlyI6AhR4h1cbPw4J1YQmDMelXc+Ej8tvtFlb1S1foNmZ60ssKzqHbC81TeFx2kJStELpJ+Gujti7858jVmAqIWkmffU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777668070; c=relaxed/simple;
	bh=VAGwlkfOhO8vq5+QQLvGj7XDBS7ATS4VX2eI2mgwUus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sfAGsgMSGnyS+Ag2BL84B2MX2c6y80Sz1StDi+4ns9potvBkIPXEsoqJ1BOgDcErckcw4ezXClmPYP/ugaTgUI69uYoQeM0EJvB3qFNaUp5ktUUzlRkLM9+qWZmEltErtgoIO4quWsbjA23/DpOf62R6+CTlLHBGzi6yUue8ZAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qEi8ltVY; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qEi8ltVY"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-44a5174670eso610578f8f.1
        for <netfilter-devel@vger.kernel.org>; Fri, 01 May 2026 13:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777668067; x=1778272867; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VAGwlkfOhO8vq5+QQLvGj7XDBS7ATS4VX2eI2mgwUus=;
        b=qEi8ltVY5FPEkzaV0Cs9mYwRsvjaa8SVo60MZY0QFhFnG6FzppCD07Ig8oFLUFCBbH
         puGD2nsRT7C5GnHb//5Az6G1obFAXi/gAlcuPX8h9ntj0DNsW1CZeuKAALjO/Hhvac9t
         FmBk6RXdOlM0X+r/1iwngpC8pEKFe3FcIgyaoOwCO1ZGBj1EEZ9zl+Hz4AKfVdVllvM5
         qpXddun6F14obLU40djU92xYXpovRtbDpeaj2SYRk/FcztH1pkcPdosmgEDdi+YQ5mWx
         hHx/qpD1IQIGBBInApPHgk5mPsFY6kuiyqmAWxbbfBETeq3dCSihVsbftqa28pXx+Y1/
         a6KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777668067; x=1778272867;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VAGwlkfOhO8vq5+QQLvGj7XDBS7ATS4VX2eI2mgwUus=;
        b=p6NbchbjypRWDF1Ph5dJ3DAytqwjgcz2rNvpforA7FyimC3YFoiF+ehNsJwgrFs4uT
         7O3Y/NIi/LopeFmQS9cuF3ucxySL6nVmT3EUyGrvqpNgORKTmHJzNSQIDQxRRGTRr3Cy
         HgqbFYK0FRZpYZQjz4zxRN+KOpRAN+xWg68HRR4U4L0M2rFO1Y5jZ8RDohtiXrYI+Swr
         OJpRB8kHXu2Ltr55jFZrpvGM4ONGhTp7mKQrR1t+YPshv2hIX/R0npAj6ZrC56ybe+v6
         W6dvyRADrNyW+Xba8QXz2FRYJh9qy23PMyeOfRC3IQ711vnDAapWCFzCCIMvMmMQrKO5
         D3Yw==
X-Forwarded-Encrypted: i=1; AFNElJ9nX3lMraLXrp503kyTqfUKhOOoTJRzehTvGNfB9eNTzdSOS11R+/VCFjUVkRtDuryhr0HWiI2bR9nuypatgMI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXcY6Xu2qp5XUNELZBciO3HqXMc4sxdEYtLt/Ca/PiI5Alk2fW
	XZU6qEUqz960Jn2sxsh/vzACQD23qTjlG+DdLkkwQag2LdC8EB055RQ=
X-Gm-Gg: AeBDiev12+GGukCi4YbhM6PYq8dhgOSM22rw2Yh7+V5cv6W8iEbK6Q8/o76X67n5lIt
	FvZWupIB4mK617ptKCFb3YQ7MNw/4rBXyus8DMPENBFwNKCGLYtqUVxxzPK0sJB/sYRdrZyb1Ub
	7twBLswCNfypsF9e+wJkg8G1h69TAXy4MhmbANeXMVWz8s+XiguQyvXDzO0kpX7CYqgsvtIIxdD
	JmLCWNCNc52GE4Akz681umautjPet3qvdtauAZejpsQKZEWisMUHQpP8SPvDRjFmuTVVOUyBsNq
	syTJEHoqeEuJ9lEb2Frv7O5iJxcclvQGMul4syUmASmi5Be9GGVOWS2F/ivZ/Bu00ruLtRON1YB
	+zQcYY7DfMv4tKLw4cq6Brqk64+yiSXCgrfbeKljC7zREpyQAXDqasxEI6cgRiT0p8MUYOUQrzt
	KX0kXNNfoJvOo=
X-Received: by 2002:a05:6000:2383:b0:43d:c95c:4259 with SMTP id ffacd0b85a97d-44bb5b4e054mr1421092f8f.30.1777668067195;
        Fri, 01 May 2026 13:41:07 -0700 (PDT)
Received: from debian ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a986aa3a5sm7882383f8f.26.2026.05.01.13.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 13:41:06 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
 netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] netfilter: ip_tables: guard
 ipt_unregister_table_pre_exit against NULL ops
Date: Fri, 01 May 2026 20:41:05 -0000
Message-ID: <177766806589.1898033.5646188235412407059@gmail.com>
In-Reply-To: <afPUr2oksLlaMcOj@strlen.de>
References: <20260429175613.1459342-1-tristmd@gmail.com>
 <177750472539.3004201.15967003942391945312@talencesecurity.com>
 <177750474339.3016150.13196470704394042910@talencesecurity.com>
 <afNYqx41pBCyDnjR@strlen.de>
 <177758578919.118018.11758358602621428742@gmail.com>
 <afPUr2oksLlaMcOj@strlen.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 1 May 2026 Florian Westphal wrote:
> If we have races between a thread calling ipt_register_table
> and the netns cleanup path there is nothing we could ever do to
> fix it: we are tearing down a live network namespace.
> Something else must be going on.

I agree, this one is unusual. I tried multiple PoC approaches
without success -- all I have is the syzkaller crash I shared,
no reliable reproducer. Syzkaller itself could not minimize it
either.

That said, the crash is real -- KASAN shows ops=NULL in
pre_exit during cleanup_net -- so something is reaching that
path. The V2 guard handles it regardless of the root cause:
if ops is NULL in pre_exit, we should not pass it to
nf_unregister_net_hooks.

I will share any PoC/repro if I get one.

Thanks,
Tristan
