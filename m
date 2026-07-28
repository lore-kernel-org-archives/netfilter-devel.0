Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10783C585C
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 09:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785230229; cv=none; b=V9Usql1wnRXB/BZSaD+nMHbfTHLJF0iR8ylxYHe0NjMTIRrj+N9T9ZklVLTEekYgBrFv8RiF7j6C3D2U39HecvRhwU++fRW3ReC1x79tTu1CqWt0Z7svc06J74gzGv5EzF7Nl7DWvhWPOe58duIjZrWsyWoBKDeVzmHgtQeuGUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785230229; c=relaxed/simple;
	bh=C08foeYeu1USjy0uINAtn1uK+aFj8uT9oKAb/Jugw28=;
	h=MIME-Version:Date:From:To:Message-Id:Subject:Content-Type; b=lJFS2vZ9pSqYCKa1UlSgpSWZvCwpSoaWsAF2Co1oVwXck2eovIsFxxvTdgB8zFBQpAnMtKF0r1CmYlcH0feEuukrvBMYGhlBUi99JTtJPlXNeuoCNuttkmIRK0s+wLe+uMDVdSr8ytW+yy8dv0sfW7295MrcMZulfv95wsKCUNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=adamtulinius.dk; spf=pass smtp.mailfrom=adamtulinius.dk; dkim=pass (1024-bit key) header.d=adamtulinius.dk header.i=@adamtulinius.dk header.b=iHzhlZcA; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=bDIfAClQ; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=adamtulinius.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=adamtulinius.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=adamtulinius.dk header.i=@adamtulinius.dk header.b="iHzhlZcA";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bDIfAClQ"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 083F2EC0255
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 05:17:04 -0400 (EDT)
Received: from phl-imap-09 ([10.202.2.99])
  by phl-compute-02.internal (MEProxy); Tue, 28 Jul 2026 05:17:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=adamtulinius.dk;
	 h=cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=mesmtp; t=1785230224; x=1785316624;
	 bh=lK9JurJG2u1Nc7CoYvqtYIVZaocTRDUGXEvBP4TqAWg=; b=iHzhlZcANcHZ
	0Lweq9GgXbEObAjAccxQGVZP3YYqb73ne/2Iyc7xRR50LW909Px3kZ0q5jaZzoCf
	PP7+bKJvsi/eGN4AjkLcly7ANpsb4fJ1sCK78wKBUiva1SPoW70k6j6Ix6X0VYWL
	3YjXJnJ1gdig3+bQ5OWLuNkqJG0T4Qc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1785230224; x=1785316624; bh=lK9JurJG2u1Nc7CoYvqtYIVZaocTRDUGXEv
	BP4TqAWg=; b=bDIfAClQgEFEXFJyPOatsWYujpHW6JQrnP9VyfXmjHbNurVLygk
	zpqvpU5w9FqI3CMrEh5H5PNgEhxDTxQRmCkO7j8AKI/xjjrteAqbC6W64R3+yTxM
	qUA4ehbdqb5B0FFbuZxuyY8v/GPJETkaaUQ/k20cfR7sedwCtVREgHUc1EInHJeE
	VLeRWwrcn3+gSQb3zPF162HVAv2t+GgmzFwH6+J+0N4JsqQVsNVWJ+yi4akdZ3DM
	THiFTvO2JGz2iuWEOP1m/VL/BPIuf1hwFuwwqpkjEz0XJSax/dTRZkommiWxOeZf
	LCtLz1OKMA6ECPkiJLUzYdnanmUMkwd8fVQ==
X-ME-Sender: <xms:j3NoamM61Zx5O6I8_MEOGC71c2o92uKHJKmpFKF_SK2bgdjXqJgyrg>
    <xme:j3NoavyhEeJcBVqAdNeIWMETOZ9FKbGVZ5s00gISwZMsnBqkjCwShkZkj_eO1U5S4
    YIIDjjVo3fOzvBxMtK6BuHpY-AVJYnP_mBgIVtAny_8qmmhTAM>
X-ME-Proxy-Cause: dmFkZTGtDUUI/CXNPXyJUndU6EpWm1Zx3CXl5L5fFIYtr4ySZSdiqCOSUJLa9953ipIrEh
    k7dhIhA9/UUv5QDyNbX8/wbp1VFBHotQO1csfIjQ7x9zViBprhkCTx6Fshusnj6dw2J3oT
    uwKWxUfJVSazLbUkeXsdWUBpzXbgKb9zAowftDw0AQTcDG/q/i2yCqAq6G4GAmbhy9VOyp
    v356qyOZeoLhUEVOgIg3M1jAJSNwnaAUa1GQKgO1TK13myT0W2r9WWi4CpZSiSoZjvPwJx
    U3MSnJdS3tupAKEgPz0E/t2QOVm3hK9XcyLYW/EiipcjydhcljNVH4kPIj1jcha7DhvfGO
    vTI8V8GMZ7VWByqB04Ob/vID2tzyBkmGVDFrEzEKnxb7P5y7Fvqowtgo9kZ0x8ZlNsS/Vj
    dC5R5oqC8SFDP7yIxGnSRC/r/QQKRFTk3xl+U6kcg6OC30IWEoehZF338GJ9RUI1v+fVUj
    RS55KGSriTaoHijJKk/j1Y/0kPuz+TLsionHulZxhUkQ+X0StIfzp4Ch4M6XZNZGd9AbM1
    8meFDyJNowm25u1LoC9OWSxTUOVV2RMfhVStZ52IP8OVBXoozfBqLDfhXkEYRvRoFjSnGP
    7Lvq8aGg5sL4f1dfBdnk6K7u//Ki+psD1xgF6Vvxxf1vpAjy5cZ3+nNN1uXQ
X-ME-Proxy: <xmx:j3Noas9JNF1IgPqdJh4RtCKVHLuHZtmFNWYnotUuyZojJjbEJqAwiQ>
    <xmx:j3Noakro3J7bkRhVET9IWKetRzeSUpW7H_kNQXIakhF9TIxptdtORg>
    <xmx:j3Noau5YHg5xmaYSfTICtskp1iSbGPjmeWJ3f3i9HGsj3-w6Lrb7vA>
    <xmx:j3NoakOe5GfNrHtjfy6ZIo6YG4c9Kge8RNuDTPbylBcyESvS06JGtA>
    <xmx:kHNoarTdMyP0j5YT7KkMH_rmaqziry3ieIwM12mslED0PYoP8RRWp7gR>
Feedback-ID: i42d0403b:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id C3AE23020073; Tue, 28 Jul 2026 05:17:03 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AzxTnGRmNQD-
Date: Tue, 28 Jul 2026 11:16:40 +0200
From: "Adam Tulinius" <mail@adamtulinius.dk>
To: netfilter-devel@vger.kernel.org
Message-Id: <589d243b-3d88-4138-9786-1bbb4347e79d@app.fastmail.com>
Subject: nftables: regression/bug in interval set lookup in 6.18.14, still present in
 7.1.5
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi there

Sorry to post here, I tried creating this bug report on bugzilla, but it seems down :(

I believe I have found a regression in kernel 6.18.14/6.18.15 w.r.t. interval set lookups, that still affects kernel 7.1.5. Sometimes the lookup will fail during table re-creation, and nftables will behave as if the element was missing, even if it isn't.

We found this while deploying kernel 6.18.35 to our kubernetes environment, where we started noticing connection refused rates of about 0.05%. Further testing revealed that this happens when we reload our nftables rules (every 20s), and bisecting through kernel versions tells me that 6.18.13 is the last good kernel. I haven't been able to test on 6.18.14, but as far as I understand 6.18.15 was released shortly after, and I know 6.18.15 is affected.

To reproduce I did this:

Ran a fast responding web server on port 127.0.0.1:3000 .

Loaded these rules in a loop (e.g. `while $(sleep 0.1); do sudo nft -f bar.nft ; done`):

delete table nft_rbtree_repro
create table nft_rbtree_repro

table nft_rbtree_repro {
        set local_ips {
                type ipv4_addr
                flags interval
                elements = {
                        127.0.0.1,
                }
        }

        chain egress-fw {
                ip daddr @local_ips accept
                meta nftrace set 1 mark set 0x00007ff8
        }

        chain output {
                type filter hook output priority filter; policy accept;

                tcp dport 3000 jump egress-fw
                tcp dport 3000 meta mark 0x00007ff8 meta nftrace set 1 reject
        }
}

Ran some requests: `echo "GET http://127.0.0.1:3000" | vegeta attack -rate=1000/s -duration=20s -insecure -keepalive=false | vegeta report`.

On kernel 6.18.13 no connections will fail, on 6.18.15 about 3-10 will fail during the 20 seconds, and kernel 7.1.5 shows the same affected behaviour.

Please let me know if I can provide more information or testing.

Thanks in advance.

Best regards
Adam Tulinius
