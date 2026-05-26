Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1012F33710F
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 23:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779837712; cv=pass; b=Xr2fv+8Pf/2azypSW2j86C7Uvpii1x0sSbIC1tos2q3I8E/h8w2cA+oNfzxsATLEiJ92HDZwCA+jxJXchhbgWw7Ae3dYPBRe49KRDcJmJNKMGsC1m/+hKpYXKHLrY1UKAq6QPYJtym/WMzBXlHxalhb1Pyra66umg/H17ymj1i8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779837712; c=relaxed/simple;
	bh=u5AZ6lDvJHN6hkOMWJlEHdIYy+BPs1w8b0bOdZZRyJY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J8P1loUVUomiiqG9jxUxwmMUebwmX8mlQo+8Wpdy0jft0r43JcylwcnNbckyPyjoJFck8OCFktOuizbYdXtThk41HbgyFc4aVq2TynN5Q1N8nv3tM9JIwgnVvn2FjUsLWDOX4WWGLoZnoITs+NEORCwa+iygIRfRq/nriaBScMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZoF8Uarq; arc=pass smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZoF8Uarq"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-69498319ee7so5777097eaf.1
        for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 16:21:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779837710; cv=none;
        d=google.com; s=arc-20240605;
        b=e9KkzgVH0Xn+OAGlCb48s0bhsZkqwQfGKu5v7G4K1dTEgL83OJ/5VUOciH/q7U/orW
         fwORSyp/oob5zr5Meue+MkLgZfrqz+jH05CMrIDFgB/o6BG2GsYGWduGPIrXfLxp1KHl
         k6eqvJW3C3eUr/jSCLLKRqsUfCbn0H43e9rnQ1Dh63UGsGwb3O/quLK+ngrQdcdsSCrb
         9tZzyztqIKDPRqP6bvly4KbkTkHLkcsE5bPqimX2AdBRuepDwySVPSpJLdYlgOH2c9J5
         akNV5xmcpRsF4ffY+JSk/iar+PUNrX/Oc0LKevDxYC3ruVh+Gu11lAGCWkBb2xF4kt+X
         EC4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=HujuVBuKdWWEfICM8n6u8a8X3rF3iweG2fpAlmRVj68=;
        fh=fbI5nI3F7+TyRRRzcNFXMgosvYrvPGWZHFA9ACsL/cw=;
        b=Zr0u0meCrAfhLNDNCwtWeIRJAp7h19xnag4dMi+IOZIVwFCr6ubagLZiWujgFxnJj/
         Lb3q4BKLDrR1xKL6AjtTmSqcwckH2Y2jF/9HV8jsvDpORcIvKqFL95TxjS2zqrcUnl6s
         cqu+4kWVQTVezRBIluume9EJEyo/tRxbifW+G+2erh/01H6PUAVu19acbPxrzzAuQ7qa
         VGdsVYDxJRVXeSkwWjZdyJbL5m82XIiMd9ZmI1N3cwIkQzYWL8lP5mAmzeeVwhrvpyux
         HK+wQnjUtR0QO8msw5asjDTbtzmaXVH/Jpznrdb6th0beLeG1UaYSuNzXm7eKjEiA4qO
         wpCg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779837710; x=1780442510; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HujuVBuKdWWEfICM8n6u8a8X3rF3iweG2fpAlmRVj68=;
        b=ZoF8Uarq/TldyaYIzCoGeNZ4a27AC5yVtMW2qA6Tq9NzzWaOekALVchygvW560Li57
         VEI7YHopZ1NPwR5c4jDdIWBBGBy5szAPuY2g8Sebgwsu6Srwp+6KIZMbFR26UksalAqR
         /Ar4cOnt3DJDonqFEM5D8vyKYvVSvGsfoInObizwy3IygcHiBMTU9RUkLaauWzZGhZN4
         sJ8H7IfBEpqPZyeaRUURQi+O8KCm0ESpIrzqou+SbZh7vqjIF77HWQzXdCYKNcE2p5ja
         XdTYZPCEWLbvOKLLf6BiiK24XjBh+QgJlYovwsMDMFUdvrOkh/ahAXlltSyXVJPE7efq
         phmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779837710; x=1780442510;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HujuVBuKdWWEfICM8n6u8a8X3rF3iweG2fpAlmRVj68=;
        b=QW96eellRsltpurRHCIy8NmeU8EAQgkMHW/hovxCykCQhgO2ImbdYNvPKKlrrIwmFO
         FjrOiz94qfEqNp6fi5jueEb4UDgJX79V8N8zV50i+NVRrLe2c0RFxDaJ1YMJ+VmYf+FA
         oWrTXJXdfRbQMZFmaCQkWk++4zXTQKFscDTJ5JCbdr/UWIpRAPf8Cpkut6HrSmF5kOm6
         Cv+zUE0uzTQgO6ppE/eR9DG68/ZJvuY32vdCFAvo+9Fv/GcP1u9pGAmKNBlayDcsLtPD
         BkBM6HWeO6Oby2qA7j12jLBN7kQlrQTWWwrtKmJiqUnf1PRO2d5UGCFKFY6pEcdXalb7
         8D3A==
X-Forwarded-Encrypted: i=1; AFNElJ/oeXIkhmWB9QboaWNzNL/l3372RvJPYF0rJCwRvYHM+M+hmqHgz8ZbtkvOYKgTl/3Iyy/MU88QE3Dc8bJ1IC8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCvlaH6URE9oHLVNvev9Dl3CixvMC+MJkbTJMtQnW3qHZLYJ81
	XkDh6lDreYFtsb2QWUswT9cIG+mXpBJUfRR76iQJzjX1Xs57H1BB4jrGleIPGAK32cEfZrx3Bbd
	TPNP7FwVEnT+8289yWOjBZ97CVVGq0DE=
X-Gm-Gg: Acq92OH3gD5bUX18/ybhtANelQPfJnMaL+jQgzG9HzHKpekV85N5QZnp8xMLhm5sVBg
	4mMj/FWqnjJxHxFjspjOY40gTpSCzT2gR78iMK88Tdp8HiKpNg9b0ye2oAvBIXANYHPJi2UvpsJ
	xg8aaiJ1/2q/Cp+sujMYBJkfzvCANsKYgaAn+dtah2Bb2ojyZa44fXO0mBJMntILLg1+p1rVKxR
	QVgDE9WWPANR45NKsAF6oeWfxz0D9jy9CKCj/lo3ywixFReMRBtgKbdSjRFEwXvk2Cunr+PbIF8
	cFtAUwzFP/VtCbogpAQxtikEE6A=
X-Received: by 2002:a4a:e903:0:b0:694:9e2f:cfac with SMTP id
 006d021491bc7-69d7fcb51b6mr8951696eaf.9.1779837709977; Tue, 26 May 2026
 16:21:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260525201116.407338-2-kacper.kokot.44@gmail.com> <202605261807.YY0PWuhX-lkp@intel.com>
In-Reply-To: <202605261807.YY0PWuhX-lkp@intel.com>
From: Kacper Kokot <kacper.kokot.44@gmail.com>
Date: Wed, 27 May 2026 00:21:38 +0100
X-Gm-Features: AVHnY4IeURuAw-7kug8a-6xqNpmP-8aoIQEcxEzrITr5eMpT52Lzw3oZg7lhaRo
Message-ID: <CAG-Fur7edB8_4iLnP4QWh+K96bGFBgYyfdoy8H7zvqa8NYdyow@mail.gmail.com>
Subject: Re: [PATCH] netfilter: TCPMSS: fix dropped packets when MSS option is unaligned
To: kernel test robot <lkp@intel.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> AFAICS, these issues are not present in real environments as MSS option
> is placed at the beginning of the options block making it aligned by
> default usually.

I agree, I haven't observed it in any real environment and wouldn't expect to.
I found it by reading the code and had to craft a SYN to reproduce. That said
the spec permits unaligned options and the kernel shouldn't silently drop legal
packets just because nobody sends them today. I can note in the v2 commit
message that this is a theoretical fix.

> > I wonder, if we are touching this code, we could use the opportunity
> > to make it use get_unaligned_be16() instead.
>
> gcc and clang convert x[0] << 8 | x[1] (etc) to the appropriate single
> instruction (and maybe byteswap) on cpu that support misaligned accesses.
> So there is little to gain from doing it any other way.

Happy to go with whichever you prefer for v2.

> and, of course, the code works fine because 0x1 != 0 is 1.

Ha - accidentally correct. I'll add the parens in v2 tomorrow.

Also the reproducer I sent with v1 was clunky. Here's a better
one with some results below:

  #!/usr/bin/env python3
  import argparse
  from scapy.all import *

  parser = argparse.ArgumentParser()
  parser.add_argument("target_ip")
  parser.add_argument("target_port", type=int)
  args = parser.parse_args()

  def gen_mss_syn_options(nops=0):
      return nops * [("NOP", None)] + [("MSS", 1460)]

  def syn_check(opts):
      sport = RandShort()
      ip = IP(dst=args.target_ip)
      syn = TCP(sport=sport, dport=args.target_port, flags="S",
seq=1000, options=opts)
      synack = sr1(ip/syn, timeout=1, verbose=False)
      send(ip/TCP(sport=sport, dport=args.target_port, flags="R",
seq=syn.seq+1),
           verbose=False)
      return not not (synack and synack.haslayer(TCP) and
synack[TCP].flags == 0x12)

  for i in range(7):
      n = 5
      ok = sum(syn_check(gen_mss_syn_options(i)) for _ in range(n))
      print(f"{i} nops + mss, {ok}/{n} probes responded")

Before:

  0 nops + mss, 5/5 probes responded
  1 nops + mss, 0/5 probes responded
  2 nops + mss, 5/5 probes responded
  3 nops + mss, 0/5 probes responded
  4 nops + mss, 5/5 probes responded
  5 nops + mss, 0/5 probes responded
  6 nops + mss, 5/5 probes responded

After:

  0 nops + mss, 5/5 probes responded
  1 nops + mss, 5/5 probes responded
  2 nops + mss, 5/5 probes responded
  3 nops + mss, 5/5 probes responded
  4 nops + mss, 5/5 probes responded
  5 nops + mss, 5/5 probes responded
  6 nops + mss, 5/5 probes responded
