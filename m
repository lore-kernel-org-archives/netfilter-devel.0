Received: from mail.ptr1337.dev (mail.ptr1337.dev [202.61.224.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51673D8135;
	Tue, 14 Apr 2026 15:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.61.224.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776181210; cv=none; b=gEpzTYWjdjZqAnyfXTgfe6L4unacXjhjAi5Sn0WQ+HUXk9WTtYQ4P/fXfl3eBMozQ2KfONcLOLo697l1kbJxsNTxu4c88xPblthU640zWVOpzEs2U1j3pzD1W2dPBGSjQpm45R9pIRMKsfSK/NdBm2gn5VXGHMJJbjY6NVsPw98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776181210; c=relaxed/simple;
	bh=/hbq9f62sy3zTymZ/tCBjj9yBX6FjRzT54Jp86YE5Eg=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=H6uCUy6l5hv67WyOVwctig9mfckXwxqiVjJtCdzENA0MmchRLg4yQMiXawFn9pfGf7MqvKXcZ6wDqCiGb1cSqdmEgEy8+rqBRG1huCL288hq+aXSZ2DVmxJgJM7PS3lBFWj8JuAy2iFqCpqg3zlbBy+VEt6I6LmafrfxapPUeyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cachyos.org; spf=pass smtp.mailfrom=cachyos.org; dkim=pass (2048-bit key) header.d=cachyos.org header.i=@cachyos.org header.b=N8DG4Rra; arc=none smtp.client-ip=202.61.224.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cachyos.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cachyos.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cachyos.org header.i=@cachyos.org header.b="N8DG4Rra"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 64A0528601B;
	Tue, 14 Apr 2026 17:39:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cachyos.org; s=dkim;
	t=1776181206; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=TRkUVuOQeq5Z5SjZhRD6qZFJgCtwbDEy/Asrr2F24NA=;
	b=N8DG4Rra4KLwOyKjeHa+N8iEQYdRlSKj88SKiopR37J/JDfRZtyzFNNDIeADwcch505Xy8
	YSkqXZ+wIuGDmsHnsYuXzbuPYi6dYmv6kzI+0ByILJd5aD2wKKN/RqxgSVjeuHuLbSsups
	CFwXntF75VWv1dsYJMwdr7RdfS4ZATCJgIiMthF5LMGV+ISVVfzxGcZu4rKQpXXeoxYrZT
	/wGKLdLpqAaxOWbZnle3hAk7QtnMDUsL9EzNi9oWlIajDQ8jqy0QrooOD4J40oLsmmtYx7
	AV4zSYlpt/dun2f9rDKasT0jynylvaiSd6hKEV53/75HZsaqcJ0NxkrrPZAFiQ==
Content-Type: multipart/mixed; boundary="------------vQ8liQkI7bMgytpMGm0FanKR"
Message-ID: <aeb848aa-404a-40fb-bd41-329644623b1d@cachyos.org>
Date: Tue, 14 Apr 2026 15:39:00 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: The "clockevents: Prevent timer interrupt starvation" patch
 causes lockups
To: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>,
 Thomas Gleixner <tglx@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Calvin Owens <calvin@wbinvd.org>, Peter Zijlstra <peterz@infradead.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>, Ingo Molnar <mingo@kernel.org>,
 John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
 linux-pm@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20260407083219.478203185@kernel.org>
 <20260407083247.562657657@kernel.org>
 <68d1e9ac-2780-4be3-8ee3-0788062dd3a4@gmail.com>
From: Eric Naim <dnaim@cachyos.org>
In-Reply-To: <68d1e9ac-2780-4be3-8ee3-0788062dd3a4@gmail.com>
X-Last-TLS-Session-Version: TLSv1.3

This is a multi-part message in MIME format.
--------------vQ8liQkI7bMgytpMGm0FanKR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/14/26 5:20 AM, Hanabishi wrote:
> 
> Hello.
> 
> Sorry, but this patch as of 7.0 introduced *severe* periodic lockups on my
> Ryzen 7700X machine.
> I see such messages in the log:
> 
> clocksource: Long readout interval, skipping watchdog check: cs_nsec:
> 2897344852 wd_nsec: 2897356996
> 
> Reverting d6e152d905bdb1f32f9d99775e2f453350399a6a for mainline fixes the
> issue for me.
> 

Hi maintainers,

several users from CachyOS has reported this regression as well. We landed on
the same bisection. One of the users that could reproduce this reliably
reproduced this just by watching a YouTube video in a browser, and observed
freezes and stutters when interacting with the system.

I had an LLM generate a fix (patch attached), and it fixed the regression for
that user. Full disclosure: it is written completely by AI, and I am also not
familiar with this subsystem. I just hope that this patch can be helpful in
fixing the regression.

Please don't hesitate to tell me off if utilizing AI in this way is not
helpful, so I can keep this in mind for future contributions.


-- 
Regards,
  Eric
--------------vQ8liQkI7bMgytpMGm0FanKR
Content-Type: text/x-patch; charset=UTF-8; name="ai.patch"
Content-Disposition: attachment; filename="ai.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2tlcm5lbC90aW1lL2Nsb2NrZXZlbnRzLmMgYi9rZXJuZWwvdGltZS9j
bG9ja2V2ZW50cy5jCmluZGV4IDM4NTcwOTk4YTE5Yi4uMzdiMTAwNDU1NzJlIDEwMDY0NAot
LS0gYS9rZXJuZWwvdGltZS9jbG9ja2V2ZW50cy5jCisrKyBiL2tlcm5lbC90aW1lL2Nsb2Nr
ZXZlbnRzLmMKQEAgLTMzMiw4ICszMzIsMTAgQEAgaW50IGNsb2NrZXZlbnRzX3Byb2dyYW1f
ZXZlbnQoc3RydWN0IGNsb2NrX2V2ZW50X2RldmljZSAqZGV2LCBrdGltZV90IGV4cGlyZXMs
CiAJaWYgKGRlbHRhID4gKGludDY0X3QpZGV2LT5taW5fZGVsdGFfbnMpIHsKIAkJZGVsdGEg
PSBtaW4oZGVsdGEsIChpbnQ2NF90KSBkZXYtPm1heF9kZWx0YV9ucyk7CiAJCWNsYyA9ICgo
dW5zaWduZWQgbG9uZyBsb25nKSBkZWx0YSAqIGRldi0+bXVsdCkgPj4gZGV2LT5zaGlmdDsK
LQkJaWYgKCFkZXYtPnNldF9uZXh0X2V2ZW50KCh1bnNpZ25lZCBsb25nKSBjbGMsIGRldikp
CisJCWlmICghZGV2LT5zZXRfbmV4dF9ldmVudCgodW5zaWduZWQgbG9uZykgY2xjLCBkZXYp
KSB7CisJCQlkZXYtPm5leHRfZXZlbnRfZm9yY2VkID0gMDsKIAkJCXJldHVybiAwOworCQl9
CiAJfQogCiAJaWYgKGRldi0+bmV4dF9ldmVudF9mb3JjZWQpCmRpZmYgLS1naXQgYS9rZXJu
ZWwvdGltZS90aWNrLW9uZXNob3QuYyBiL2tlcm5lbC90aW1lL3RpY2stb25lc2hvdC5jCmlu
ZGV4IDc0NzI1OTdmMzIyNS4uYmY0MTE0NzJkNGY3IDEwMDY0NAotLS0gYS9rZXJuZWwvdGlt
ZS90aWNrLW9uZXNob3QuYworKysgYi9rZXJuZWwvdGltZS90aWNrLW9uZXNob3QuYwpAQCAt
MzQsNiArMzQsNyBAQCBpbnQgdGlja19wcm9ncmFtX2V2ZW50KGt0aW1lX3QgZXhwaXJlcywg
aW50IGZvcmNlKQogCQkgKi8KIAkJY2xvY2tldmVudHNfc3dpdGNoX3N0YXRlKGRldiwgQ0xP
Q0tfRVZUX1NUQVRFX09ORVNIT1RfU1RPUFBFRCk7CiAJCWRldi0+bmV4dF9ldmVudCA9IEtU
SU1FX01BWDsKKwkJZGV2LT5uZXh0X2V2ZW50X2ZvcmNlZCA9IDA7CiAJCXJldHVybiAwOwog
CX0KIApAQCAtNDMsNiArNDQsNyBAQCBpbnQgdGlja19wcm9ncmFtX2V2ZW50KGt0aW1lX3Qg
ZXhwaXJlcywgaW50IGZvcmNlKQogCQkgKiBiZWZvcmUgdXNpbmcgaXQuCiAJCSAqLwogCQlj
bG9ja2V2ZW50c19zd2l0Y2hfc3RhdGUoZGV2LCBDTE9DS19FVlRfU1RBVEVfT05FU0hPVCk7
CisJCWRldi0+bmV4dF9ldmVudF9mb3JjZWQgPSAwOwogCX0KIAogCXJldHVybiBjbG9ja2V2
ZW50c19wcm9ncmFtX2V2ZW50KGRldiwgZXhwaXJlcywgZm9yY2UpOwo=

--------------vQ8liQkI7bMgytpMGm0FanKR--
