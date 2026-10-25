Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792937239;
	b=DzDvrdfqSz00c8FbK2Saptyt6QhoQoT7tYoFF9BE9LpaDCaUoc3upolZ116Gh2SdssZm
	 FjGJut+knKUVHmclZndPgum2ahmewDCWApnu25PuyYGKV4EzgifudRDB1zHaNAfye9RNW
	 kxBVcs4+4NCqzcS5oTVB3hAaPLreisYsjrMGWNbZF+8rHhzRCpRCc1ngCVPYNPw51DI5d
	 69yVCtKNY+zmThwUxgiuC+6bjEcMUmEMK0DUCxc+x4wykaLmynlUqxQkRMKyibEsYCBDF
	 c6gX0pAbnlnVpoq8UFCdisuwRjUq8EZxrfgMgBdVPKiTSCPa5ogJ5GL3wOlrvM2Hvbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792937239;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/WofT0yh3KpmHARnSgrS9AsbIBrE6V8uNY4po8M3XK0=;
	b=LcG00qp8exAdDO6C7CD2JrK/zmb1RVc+2BVIiJeQ8TejU/1aFFFN2opjsa7Rp2tJxURU
	 VlRje6lT36rd8iW88BskeD/2IEroo2JMRnZsvrCn0egk9nO7pq0XWEko8infCvXgs8bVb
	 4+58RHn+jM3G/1NkaEihp1UbW/KY2HXtvG+CjKQ3nu46U+2DZxcQuIvtfhafn83nW9LJC
	 SzcAvlKbfrbsxsVGwU8bGGY7xochLyVzSQl0hMB7QE36pmEadybVj38glRDewZKLjkwbx
	 3reZ+tUa23bZOdOBzqhf2uH8TSj0rUUIhSlr3XdWjHuvR+hOUX6SOsbhLGJEEZwBfMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oqeADfQV;
	arc=none smtp.remote-ip=209.85.216.48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EB5606A31A
	for <netfilter-devel@vger.kernel.org>; Sun, 25 Oct 2026 14:07:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87EB5606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oqeADfQV
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so1360532a91.2
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Oct 2026 07:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792937239; x=1793542039; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/WofT0yh3KpmHARnSgrS9AsbIBrE6V8uNY4po8M3XK0=;
        b=oqeADfQV64ONsHXyegylGm2pBiC9f1WfKiwdma+Qh6bk/8LF8EUBep9hjXbRXwUhXI
         md9BJk/WWbsdXUibnsyyggsFwTBOSuGquKwk1Aed5mBJ3FKGhmW2XOcCz0a4KNTtopOs
         atERMRjzhZxrLPhNWjaEl8UaI6IOIA14/333ftk1ZGml90HC5Y1oo66n2iPuacrpj/mE
         Px1wuvQa6HIHkEO1uWnNSbQb/JDwQIhKu/x7dwdnsf1M8LtJF9rioMlUWyPu58Xmcodn
         YRrD1ef8FxrDFpPePRxsTICuMZ56buZBQWmJNmSHjSVwQSlx4ofuSnDVTbxGk8+NHjnk
         4/yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792937239; x=1793542039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/WofT0yh3KpmHARnSgrS9AsbIBrE6V8uNY4po8M3XK0=;
        b=FmzrNyY/w7ZTKras0Hh+G7/uwwgveHuZxCeJduB2UcHdyU4p09PmlliNhKUhrbFmKj
         7aAcRW+juM+lheKloun1iZnn4Ce31QQZRjGEeyztZywv9m16ub9ghdtwUG592B/DbIoD
         cDMAn0HR1qAyGxC6J3zHsc3QqYT0SSyae3f03Yljy4sDc3jGprIRHIgcjI5U/pgQ6dv1
         oYMvc+/0vJFo7b4Vt+sNJjk11V8LTrt/VQdbrBiQawOqEJsNGuhgHycbqpV+eA1FP1FR
         qzYxbiXXok1r0Wew999ezcKFQXWA+oxiehBC+Qt7toePinnnTeExGcuNlmNZFjZ0sFXA
         5hwg==
X-Forwarded-Encrypted: i=1; AKwUvBwnqZEj2ALBGLf4Ygff+SkryFPJiBZNE0zT9C/mOiwKgmwci9miQZwObLs1Xuj9Bth/gtpMtkYk6B0HjwCkA/A=@vger.kernel.org
X-Gm-Message-State: AFq9FYJFEjPQFPDrE06pppvjw55h3dlaZHQlqSyFa7Qt7AdSjWULrLfF
	5stf2p4rS93Yo9fgbR4ElF3W6+Lbqw9vTy4M8t7KXeta/2mfl+rAlwfB
X-Gm-Gg: AYBFou0oyidxQ5RVB37vhlIGjs12d+ya3x2b/AHWB5dna916urYnBdcjL/6kMK/3PuA
	JYZGRXO1FEpd+EzffZLssTIyRMYZSdow32npFCvyZ2WrzVYpcCrEjZjW4imPIZurCadTibQQ0Ia
	PwU9mcIXTievQ4ppq/OVAasKgJzv2CHFLe41JC65speCTo7vCqIjruaM38wypH/8mEVbuRN1F8b
	RBhN8z6v6yLKtaiLmO2T41Vb1/cONp5t6ponuJQIFjqwfUZ1OHKqdRGpHFasN7tIhrefg7694lG
	wB8kUbf9qI4vBqZp9nSQ4DsG2gOOye1ubiJia9uutIKhxi/8YmEceek55wI8Fc9XyPkB4VkY+sR
	hg7Hzamemzus1peROhlKdU+Ja0QPJYVHS2h+Luymb5qjkGDfH6sbTTbhhG3kG/jwT9+UqdhK3lt
	0AmX8NvU40HGN/f3hI+3EQTgJ5irUzmj2GKyE2w2as6TR7v5JE71wIxNz3W5OcgWaF+K+NXi60G
	xH+U7iFAkpvlY1CXmOecQaitMTDvAw5z320vvQUAffhf9sK9VEsUshNb3esCvrOLIxubyv4/8pN
	0w==
X-Received: by 2002:a17:90b:3c41:b0:3ac:a203:e0a1 with SMTP id 98e67ed59e1d1-3adead03898mr3797971a91.37.1792937238796;
        Sun, 25 Oct 2026 07:07:18 -0700 (PDT)
Received: from gmail.com ([240e:469:849:35a9:20c:29ff:feb3:e631])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebaddd45sm3776443a91.2.2026.10.25.07.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 07:07:17 -0700 (PDT)
From: Xue Boyang <fuchen.dust@gmail.com>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Xue Boyang <fuchen.dust@gmail.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Phil Sutter" <phil@nwl.cc>
Subject: Re: [PATCH nf] netfilter: ipset: fix double free on kernel-side delete during resize
Date: Sun, 25 Oct 2026 09:07:06 -0500
Message-ID: <20261025090609.v2reply.4093.fuchen.dust@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <8b1c4c41-d371-1901-0f85-f3d0a1dfd033@blackhole.kfki.hu>
References: <20261012163353.4093-1-fuchen.dust@gmail.com> <8b1c4c41-d371-1901-0f85-f3d0a1dfd033@blackhole.kfki.hu>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jozsef,

thanks for looking at the patch!

> Thank you for your patch! Could you address the issues sashiko raised at
> https://sashiko.dev/#/patchset/20261012163353.4093-1-fuchen.dust%40gmail.com
> about it?

Sure - v2 follows right after this mail, quoting the findings and what I
did about each of them:

> Can a memory allocation failure bypass the backlog cleanup block and leak
> the deferred operations? [Medium]

The exact path claimed cannot: every early exit is taken before the table
is marked resizing, so the backlog is still empty there. The leak is real
one retry later though: on -EAGAIN the cleanup path jumps to the retry
before draining the backlog, and an early failure of the next attempt
(its own allocation failures are again before the mark) strands it - and
with the deferred delete being the only record of the delete, the
elements would stay in the set while the packet path believes them
deleted. v2 drains the backlog on all failure exits, replaying it
against the original table.

> Does the backlog replay ordering during resize incorrectly resurrect
> deleted elements? [High]

Yes, it does - the list_add() prepend of deferred deletes predates this
patch. Since the fix now relies on the backlog order, v2 queues the
deferred deletes with list_add_tail() as well, so the whole backlog
replays in arrival order, on the failure paths too.

> Does this skip clear_bit(i, n->used) and leave the element fully active
> in the original table? If a subsequent ADD for the same element occurs
> before the resize completes, will mtype_add() incorrectly see the
> element as still existing, return -IPSET_ERR_EXIST, and fail to queue
> its own operation to the backlog? [High]

Exactly, and fixed the other way around: clearing the used bit is not an
option, the extension of an element the resize copy loop has not reached
yet would never be freed (the old table is destroyed with
ext_destroy=false to protect the extensions shared with the copied
elements). v2 defers the kernel-side add of an element still present in
the current table instead, so the replay applies the del and the add in
arrival order and the add is no longer lost.

The remaining Medium concern (leak of the extensions of elements which
expired during the resize) is preexisting and not touched by v2 - I can
look at it separately. The five dismissed concerns look like false
positives to me, e.g. the lockless orig->ad walk after the table swap is
serialized by the synchronize_rcu().

Also included in v2: the deferred delete now reports -ENOMEM when its
backlog entry cannot be allocated, instead of returning success.

v2 was tested with the same reproducer as v1 (no double free in repeated
runs) plus a new ordering regression test: packet-path del-then-add
pairs race continuous resizes and the set membership is checked right
after a resize completes, with the traffic source frozen so nothing can
paper over the outcome. On v1 the element deleted and re-added during
the window comes out missing (the lost add); an instrumented v1 kernel
confirmed a single ~80ms resize window deferring 253 packet-path
deletes and dropping the corresponding adds with -EEXIST, replaying the
deletes in LIFO order. On v2 the element is present in every sampled
resize across repeated runs.

Best regards,
Xue Boyang
