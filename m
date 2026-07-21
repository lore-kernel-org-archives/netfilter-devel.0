Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81D8435ED0
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2026 07:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784620601; cv=none; b=g9VuXE5DmVp7lTiVSWplph8o2e7eeELEPaYAKd+0W4J2Daqt6AeDpiz/ZPrs6fioOumaJj5XOKAGsb9j6OVFwO60RkKua/7hM9opl3ZJ9afug7eQWoaxiVIt7epABLVFBsgazX7kctFNadLc0pQgA2B+MTHPFdOxYIML4DDDtu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784620601; c=relaxed/simple;
	bh=4pFYVUCPuxq1geQWky1ftwxksK5oK1Z6LKV8vILdWT0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M43BpzKE/kmueRsMH8y5cSRTagfz/G8iAKJgDybhQ673ADGlTVYIITNJ3Omf8NNymrf3ED6k7x4jDrbi9oCbsho5IJSOzDsK0buyFRNifoZ+SiE+fTVzR+q90fgWt0TS0Jr+Ov6HC7WKJj8OEt7I7l7tKaRWe14tQgSsL3wp36I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eRAiZzWW; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eRAiZzWW"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47c2b362ee2so9631621f8f.1
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2026 00:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784620598; x=1785225398; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4pFYVUCPuxq1geQWky1ftwxksK5oK1Z6LKV8vILdWT0=;
        b=eRAiZzWWzEs89WUPrpH85HYbbKqZyibHd4FlDvS02D5rl7PLFHvDwYfqpf97HWF9Dk
         4OC/jF6jQ9vlxHgynsTHOkhG1bxLEI2xUpXnRrDztLNITG4irdWnzv3x0eATOUg19eF8
         14KgoTyG3WnrZLBJ9VzgkdZ7FjfVfEZ3j9YJTwgk0pnpdpxC+gYbYzQl5VMA46WNsNeM
         qhRKkRPoZHvL8vfJ7rKW+cLfZSjhBJMfdBOUHEsS++8KRwxRPU41uWC/O4VQGFEinz9Q
         UpCIrkJeve3vWxFsZ7ciWlQe1k7qzCEvkt9HYIeAD0RTD5We4JA6xgyoNfz1e6sRYRNB
         dHvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784620598; x=1785225398;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4pFYVUCPuxq1geQWky1ftwxksK5oK1Z6LKV8vILdWT0=;
        b=tJI8tU6t9koRPiebU6YXM9jgpwYP879cIAa4mwfN7FnJ25og9WoAEedx7sHjL+Gxja
         RAwTbo8uxO7KfSUxoGiBu4piV1NT/3N4jsNozaG3QLcF20CCL/ETh2RgPtypVeiv8NrV
         WXcoGGNSfXoLQtiTaJfKn9rESNGmr4rDfgZ0OxPrNrE/DbL/0YynBzPkp3BHWHoA8TWS
         j5tHPChH62rCdhUObxOYLiFgQoQTHQJoByYflEEWM0jfM3FeSpFG/ZKPslGfH4ll2qJd
         Ahm56CCHnsEYmbjazJd7yu61duiTecdhQr+VTzHxNTNgNbHVtTgFiEQLjbncs3ds2rGo
         Ylng==
X-Gm-Message-State: AOJu0YzQxB9l566Ak0alM7rXhjQr036Pq6vavZ8XzNyhbxRgnIUjoCX3
	b2v/OMwwugq5WOiN7uADQGEvrKJnVc30lS/aiWjcWMzv0z0ILT9tcyDX
X-Gm-Gg: AfdE7cldGNIlJZRqX1Dr15I9O6I+WbHqVKZvT21yREjLq3hfncRrbiwWQtQ9tQOkni5
	2lTr/vPwKZ/CUhPUGpElfENl3jib5L7+kcl6iD3rNQGV1Joo2/VdrnCOF4olxDZR2WrW6vDv6jW
	yTxiNliqxCWQQ8jFnXdjKmUUHxWUh1kfAbfPnMrZvW0wnedFKUzJMjWsz8uXp17DmnM1zfvdTH7
	wUuIFZ8JoTG1bU6IzCa3ZvEH9vg87/+QUHVC5I3447YWeWZQ77O/fPtnhurPEBrSSL+Qrbc78Nw
	Ha1AG98uT71SKE/Fuc4KVxOYkDMQqEYUIJi5QD/Hr6Wsj3NTcjn3N9ptFd+4dN++g8twepEDM2e
	KOp2GZrjOzV0HPWM/sNydpYyz1kTywhBUzgmu+6kPOKDTWqJ+DXkpneKmblnRslvAC89K+grHUq
	Aoxj0Ha/2Nv4Wnuzyj5OeLWqhchVh559NfZxSNGs6GrSC0mJAPtiPulgdEkquB78BmQYg=
X-Received: by 2002:a05:600c:4693:b0:495:3f26:97fb with SMTP id 5b1f17b1804b1-4954a3e20edmr186560825e9.3.1784620597745;
        Tue, 21 Jul 2026 00:56:37 -0700 (PDT)
Received: from DESKTOP-VQ38ID8.localdomain ([85.153.228.203])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4956536870esm52321965e9.3.2026.07.21.00.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 00:56:37 -0700 (PDT)
From: Talha Berk Arslan <talha.anything.info@gmail.com>
To: greg@kroah.com
Cc: netfilter-devel@vger.kernel.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc
Subject: Re: [SECURITY] net/netfilter/xt_hashlimit: Uninitialized rateinfo.burst read via shared table mode confusion (CWE-457)
Date: Tue, 21 Jul 2026 10:56:33 +0300
Message-ID: <20260721075633.408-1-talha.anything.info@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Jul 21, 2026 at 10:44:17AM +0200, Greg KH wrote:
> For some reason you sent this only to me, which is a bit rude to
> everyone else on the mailing list. I'll be glad to respond if you
> resend it to everyone.

Sorry about that, this is my first time submitting to a kernel mailing
list and I am still learning the etiquette. I will make sure to always
reply to all going forward.

The [PATCH] itself was already sent to netfilter-devel at 07:46 UTC
today via git send-email (Message-ID:
<20260721074629.668-1-talha.anything.info@gmail.com>).

Thanks for your patience.

Talha Berk Arslan
Artfical Security Intelligence
