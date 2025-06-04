Received: from mail.cock.li (mail.cock.li [37.120.193.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCA181741
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Jun 2025 15:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.193.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749051975; cv=none; b=oiJr5suP1+PGsfr0O91H6xS+TekfWkrIqxrh+G162qJlMxdCWGl0tFPCiB7Z7gdm6hEdtIbJBp1WhDlC8qsDNKt6p+9n4SB1LoqtileoPN2lAS6cI+DYY6K2VFXQomeLYGLoKlI32EyFvtwo+oUAiYotxaovoEqCW376TTMPEKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749051975; c=relaxed/simple;
	bh=MhnelzJJ0L4d6RkLRlzDdpuOIbsgHuFNN8w1iOkdTYY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=edCXJqzF7yMidPtI/iSxtrFNg2denZjGiJWnpOJtFm+wMVDkXOEifmyZYggkDFJ0uu35kA+W2ocbQzKdXZKdtqnhoOTJ9MdTl4bedlSIvaol1sG9h/n/VJ7yEaWM/Fx8oglLMgEN0IzXGpXNTwmF4LXHTsjHCM1YmzkLG5hxqFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cock.li; spf=pass smtp.mailfrom=cock.li; dkim=pass (2048-bit key) header.d=cock.li header.i=@cock.li header.b=Iww6wXQC; arc=none smtp.client-ip=37.120.193.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cock.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cock.li
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cock.li header.i=@cock.li header.b="Iww6wXQC"
Date: Wed, 4 Jun 2025 15:46:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cock.li; s=mail;
	t=1749051969; bh=MhnelzJJ0L4d6RkLRlzDdpuOIbsgHuFNN8w1iOkdTYY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Iww6wXQCueWtfQCO8Gxysednf7zYTekhT+D6JH0rXghClN8N3pAe0+bMvy2LDye9X
	 Tn7zw3lcI7kFL3NkZTKyl58H09ziQ4lE+Mli6FcuTB5e9ncmGV/ufd6MFTL4368Cs0
	 KmcAg5YnjbDb5Ov/khC78v+a9yt+rCYVpMbgRprFO0XKO4m+IE40yXcr7wGJY1QYrL
	 z1YKJaNmOcf53lehqR7B3iuc7UOFygJq9D0r4+tZazy2HiMZcOqcNOw2f1okr9QKnT
	 ouAILGRLEX+Q99dRG2ZaOtGmC4IhaDe8sO0LtmqWLhCz7H4RtLm6v17pmcIWCt4jwF
	 Cq4T9AYboVg9g==
From: Folsk Pratima <folsk0pratima@cock.li>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Document anonymous chain creation
Message-ID: <20250604154604.0af22103@folsk0pratima.cock.li>
In-Reply-To: <aEBPo-EAZA0_OSD7@orbyte.nwl.cc>
References: <20250604102915.4691ca8e@folsk0pratima.cock.li>
	<aEBPo-EAZA0_OSD7@orbyte.nwl.cc>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.48; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/9AkpDmBV=aABZqFKUVi9Hg8"

--MP_/9AkpDmBV=aABZqFKUVi9Hg8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, 4 Jun 2025 15:52:35 +0200
Phil Sutter <phil@nwl.cc> wrote:
>Did you try requesting a user account?
Frankly, I do not know how.

>you could add the missing documentation to nft man page and submit a
>patch
See the attachment.

--MP_/9AkpDmBV=aABZqFKUVi9Hg8
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-document-anonymous-chain-creation.patch

diff --git a/doc/nft.txt b/doc/nft.txt
index c1bb4997..1be2fbac 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -397,7 +397,8 @@ CHAINS
 Chains are containers for rules. They exist in two kinds, base chains and
 regular chains. A base chain is an entry point for packets from the networking
 stack, a regular chain may be used as jump target and is used for better rule
-organization.
+organization. Regular chains can be anonymous, see *VERDICT STATEMENT* examples
+for details.
 
 [horizontal]
 *add*:: Add a new chain in the specified table. When a hook and priority value
diff --git a/doc/statements.txt b/doc/statements.txt
index 74af1d1a..384fda51 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -42,6 +42,9 @@ resumes with the next base chain hook, not the rule following the queue verdict.
 
 filter input iif eth0 ip saddr 192.168.0.0/24 jump from_lan
 filter input iif eth0 drop
+
+# jump and goto statements support anonymous chain creation
+filter input iif "eth0" jump { ip saddr 192.168.0.0/24 drop ; udp dport domain drop ; }
 -------------------
 
 PAYLOAD STATEMENT

--MP_/9AkpDmBV=aABZqFKUVi9Hg8--
