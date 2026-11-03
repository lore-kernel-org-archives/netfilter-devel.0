Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793739512;
	b=1AuRFe53CiDy3p1+U6+OyToqEdkdclnspLmAhApU4/ZWZZxbzniVSVRNA2U0EouZfxcG
	 iHkLUS1gKvRt6hMucSQ/MPhT29iOBaSAkK4Gwv0O6pPlSFD79oQWiM/6cgH7w4Dn6f91b
	 XJ2HUBlGeVS7Fp6arZiDn/lLF4WLr09xlSfQz8CMsLULHQGy9y1Z2lc47OKcC4A5KJtZF
	 RurA9NR/Lzy/Z035TEnfesZiWUcaZKvJWgGfzChINB1OVvHC9s+h0WBntZnFXjwc9o8BA
	 nACdTjQn8qMMvP+mVY3wbE22NsXpk9D77BB/NxPBuQt1nmfjC3Tq2mJ3+vJLsYmnxlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793739512;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=KngdHVXO0VCOyarkWM7TMXQG9nL1S1U8Z7KtwUElp3Q=;
	b=Up/0gwP0kNNBOfj19ISFASDim3XHwwgv5/mMPA7+wsN21U97iQeL7vOvikvbGtY3vPuL
	 BQWHmiW9htWGAk40FxLx1chtx8pZwac17pX5lmR3kP+9o6k1N+AKmpl6Mu+BQ4rob/Y59
	 IslQ2BXZ8fkwls5W8wKPfmFs4CXFho7hg4yctvKffHSUBVQRpMEIFzRSBXs+YI28qlFHz
	 hi6tTrzzfnQ5oeoh5yVewMIitYlDx+4taRJ2Tw6iDB7G+LlEqUVdBejAhixxlfSTpy3ux
	 IctQE/PwPJe0T2d0OjiZKUJJrak1EbJumJLcjxhJ83LBJTce5pVwCT42KbsnasS3S8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=iIakarlG;
	arc=none smtp.remote-ip=79.135.106.101
Received: from mail-106101.protonmail.ch (mail-106101.protonmail.ch [79.135.106.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6033A606A31B
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 20:58:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6033A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=iIakarlG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1793739509; x=1793998709;
	bh=KngdHVXO0VCOyarkWM7TMXQG9nL1S1U8Z7KtwUElp3Q=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=iIakarlGguvKPgNRv2DvuwqP9RptmudZgsH4Ti6FK2XpJKfPfchs0WCziRE3mryrC
	 ZTaDlPkc8Pkn2QMGc95goI9yOEnEWGcgSlIfD5nbtMLeQm26tDM1NSNvVNRDX7e+dp
	 EgayX2JCx/O4H+xM3X4vdf8GMw0G4YzP4J0Ciyg0bcFx7HZB4AUHb1/HuKlDYcv5t2
	 e0PGyae48Kn0l1urrlpRLQNzM8MxYlE5sJuZZjUP0DQZ2+ILdJ4+wYgK6+u8Ryk4Ip
	 UiGlB9OYb35ORd+v0+5gR2bEThjVAM9GuM//8ldiFEun5RNQitXNZoRG53U83VrMh1
	 e06TQzzFNBO5A==
Date: Tue, 03 Nov 2026 20:58:25 +0000
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From: xelra <xelra@protonmail.com>
Cc: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>
Subject: [nft] 1.1.7: limit rate without burst breaks later tokens
Message-ID: <VPAY0CnKhCaOKYE6oo_AU7sR5MaGIGzyPkXi00RlaucbyN78KYBqK73XfyJ-yyXQENIvvXeFJq_fNrYbJuW8LcqZvZyf4J3kr66jvsojxCU=@protonmail.com>
Feedback-ID: 2140365:user:proton
X-Pm-Message-ID: 5de4b507ecda4ff90aa05aeea8409cf237c02bd2
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

nftables 1.1.7 fails to parse a rule with a "limit rate" that has no
"burst", followed by "reject with tcp reset" and anything after it:

  $ cat repro.nft
  table inet t {
    chain c {
      tcp dport 1 limit rate 5/second reject with tcp reset comment "x"
    }
  }
  $ nft -c -f repro.nft
  repro.nft:3:59-59: Error: syntax error, unexpected junk

Column 59 is the "c" of "comment", which the error lists among the
tokens it expected.

Without the comment, the next statement fails instead, at "lo" in
"iif lo accept", even when it's on the next line. The rule parses fine
with an explicit "burst 5 packets", without the limit, or with an icmpx
reject instead of the tcp reset.

JUNK for a plain word means the scanner is in SCANSTATE_RATE there,
the only exclusive start condition. My guess from reading
scanner_pop_start_cond(): without a burst, bison's lookahead after the
rate is scanned while SCANSTATE_RATE is active and pushes its own
scope, so the rate and limit pops are deferred via flex_state_pop. The
push/pop pairs of TCP and CMD_RESET in "reject with tcp reset" then use
up that count, and the scanner falls back into SCANSTATE_RATE.

1.1.6 parses all of the above. Bisecting points to 9d105581b5f1
("scanner: Introduce SCANSTATE_RATE"), and current master
(07be13393b00) fails the same way. The fix already in 1.1.7, "scanner:
Accept all statements' first words in all scopes", doesn't cover this
case.

Workaround: an explicit burst, or the limit on a jump and the reject in
its own chain.

