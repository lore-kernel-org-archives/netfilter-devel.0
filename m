Received: from mail.cock.li (mail.cock.li [37.120.193.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F4C19DF8D
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Jun 2025 17:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.193.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749058337; cv=none; b=Yrei+NNcBGNhdrRRGMp+wSG5KCi3y8dMyDOYM3H0vAs1LFe5sBOyMCsKCDK695HlCyfFZuk1y0JxRt2hCwE8Fw4TrM5iWuOZK3/DgusmBtp5j/VRfR8S/9a5F+gw7UzE2b/URTO9nfSCDctoIkuufU04uAANdpt/M3SGCZJu2BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749058337; c=relaxed/simple;
	bh=TrrfbpUT98F1WkpPk3sGHFMtOQvCraacyBZYiXPU6WA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QTk2IuOcD6iw2WLpDgY9vnyQU77CiuHgeNBDIziKSPw2k+mlrcfdNeCE46FueykkQGCZ8WVVb1K8G7dShFwPhROEcjjFK6HzfM6494Ro2oEuLGJaxr/h+VssSQ/Mcfk0QbPx6DC0e5NR7HeZ7BolgotPZBliKn048hpFDBWhOQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cock.li; spf=pass smtp.mailfrom=cock.li; dkim=pass (2048-bit key) header.d=cock.li header.i=@cock.li header.b=h6Eb8dQx; arc=none smtp.client-ip=37.120.193.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cock.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cock.li
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cock.li header.i=@cock.li header.b="h6Eb8dQx"
Date: Wed, 4 Jun 2025 17:32:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cock.li; s=mail;
	t=1749058330; bh=TrrfbpUT98F1WkpPk3sGHFMtOQvCraacyBZYiXPU6WA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=h6Eb8dQxKOZD8ELfGOOEJuGqMpfsbOZAnsYV/ibbfo4p4GTrVtJer1OjKmK9RnvUZ
	 zlLMdGdLHV5/nrUbHuYsrD471ZqJ/JOPPfHXc4Cn5g/Z/0L5npl36DDofSpphIBN84
	 3nWtSPtL4FtbRNh6Ak1tvw15hdmdIPGXBxQ7xVSlQ5ewDtZx3p0MJEolwoKBQZiyKE
	 1AK+PEIWktUdjpDhBChfdUzFdiazZ0w0Y3cGXD01piWbOnDx3iZuuuCKVN3tRdEevQ
	 Yxx97qDuvvuvkdQRSaTrX8pr0CMQHNfKBp5Omu7BCKyMxziXGYXjEDIu90HwPMHsKk
	 Nv/ftywcwoIXg==
From: Folsk Pratima <folsk0pratima@cock.li>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Document anonymous chain creation
Message-ID: <20250604173206.75523a86@folsk0pratima.cock.li>
In-Reply-To: <aEB5i1l8C8-TK3vJ@orbyte.nwl.cc>
References: <20250604102915.4691ca8e@folsk0pratima.cock.li>
	<aEBPo-EAZA0_OSD7@orbyte.nwl.cc>
	<20250604154604.0af22103@folsk0pratima.cock.li>
	<aEB5i1l8C8-TK3vJ@orbyte.nwl.cc>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.48; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/fWmvsxaLVUxSc6Kf7f0pveX"

--MP_/fWmvsxaLVUxSc6Kf7f0pveX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, 4 Jun 2025 18:51:23 +0200
Phil Sutter <phil@nwl.cc> wrote:
> Thanks! I think we need to update the synopsis as well. What do you
> think of my extra (attached) to yours?
Good. See the attachment for a bit of style improvement. Removed
the quotes I put around eth0 to look uniform with the previous
examples. Also did not like how 'Note that' sounds, as if anonymous
chains are something unimportant or accidental.

--MP_/fWmvsxaLVUxSc6Kf7f0pveX
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0003-document-anonymous-chain-creation-improve-style.patch

diff --git a/doc/statements.txt b/doc/statements.txt
index ac8b15ec..0b8c4ccb 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -39,10 +39,10 @@ resumes with the next base chain hook, not the rule following the queue verdict.
  call stack, meaning that after the new chain evaluation will continue at the last
  chain instead of the one containing the goto statement.
 
-Note that an alternative to specifying the name of an existing, regular chain
-in 'CHAIN' is to specify an anonymous chain ad-hoc. Like with anonymous sets,
-it can't be referenced from another rule and will be removed along with the
-rule containing it.
+An alternative to specifying the name of an existing, regular chain in 'CHAIN'
+is to specify an anonymous chain ad-hoc. Like with anonymous sets, it can't be
+referenced from another rule and will be removed along with the rule containing
+it.
 
 .Using verdict statements
 -------------------
@@ -53,7 +53,7 @@ filter input iif eth0 ip saddr 192.168.0.0/24 jump from_lan
 filter input iif eth0 drop
 
 # jump and goto statements support anonymous chain creation
-filter input iif "eth0" jump { ip saddr 192.168.0.0/24 drop ; udp dport domain drop ; }
+filter input iif eth0 jump { ip saddr 192.168.0.0/24 drop ; udp dport domain drop ; }
 -------------------
 
 PAYLOAD STATEMENT

--MP_/fWmvsxaLVUxSc6Kf7f0pveX--
