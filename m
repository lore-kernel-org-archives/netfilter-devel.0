Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2735B48383F;
	Wed,  5 Aug 2026 16:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785948125; cv=none; b=pYKvTrqU8Mw8HiT5+Y0zoy5BdvyLYQ3NmJ5jEeHuzAloC9F6BvYL4hGLNV1cgpDejyVHaxQXEhcKZtSKxUKzPV0gMCg0Gz5rbFjkyhTYMrzSZq4iYsdLTRr74+I+eVifE+DOLkhmzG6DYso4Oz9UtvyeVSWz8RtyKaWWhiIav9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785948125; c=relaxed/simple;
	bh=andGwbNDy/vJXChc5XE51DsLyyGduy20Vng835rro/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXuvV1Ue3m3Ay1QzgaG9kXb0xsq4Q/ZCrZUEUW1t1nQKT2Chkl6ghtrTnWxtu3JzqQw8OZYPV6ClfJwO78FkcsIaZuU2A9uG/Uhn9bBqkpbReeBb+Qc4xostyutLvpfB938IbWsl8DpCK5RfEhatdnZLHQksuZFLx8vgx0zCaw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K339JCOu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K339JCOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831081F00A3A;
	Wed,  5 Aug 2026 16:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785948123;
	bh=kr1QodyluVIX2VsN4MiPujwwIHFFnztNbU2xdWcrkM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K339JCOuI19I/GXwgk+YBehWUylRIKOcWaoI64cLusEw1RDIgs2PzFputIXVsxCSF
	 /pkhzaquTk8Fj0wudTqqLEc2OsFXIX1KL7wf2NNQYE3j0ALLSajwAvap8JwXYFFgYy
	 M8h6aMYT/jA6NfRWCXzQMSiX7TmQ8fAiX9yDrR+Ld/ol3CDSuGbgPXXJQn1RASsjRQ
	 l6d3r5T/vMacL0YyvasrPFnPaHywV9HhNEOzXcvFFFGni/nm+65fHO0j8Fp/z4QJnt
	 Zc+ZfdCkbCtt5yTohc3yeo1hclU5UC684aNKRHMDFHq0DgphaOztaEdbmZ66vR94Gp
	 d98w0aZR3Nqcw==
From: Sasha Levin <sashal@kernel.org>
To: Fahad Alharbi <fahad@codepure.com>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	security@kernel.org,
	security@ubuntu.com,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Greg KH <gregkh@linuxfoundation.org>
Subject: Re: nft_set_pipapo: UAF and double free from a stranded GC batch in the 5.15.y / 6.1.y / 6.6.y backports of 9df95785d3d8
Date: Wed,  5 Aug 2026 12:41:53 -0400
Message-ID: <20260805164000.stable-0007@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026080436-dyslexic-willfully-fb2e@gregkh>
References: <2026080436-dyslexic-willfully-fb2e@gregkh>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, Aug 04, 2026 at 08:01:12AM +0200, Greg KH wrote:
>> Missing commits:
>>
>>   8b8a2417558c ("netfilter: nft_set_pipapo: prepare destroy function for
>>                  on-demand clone")
>>   532aec7e878b ("netfilter: nft_set_pipapo: remove dirty flag")
>
> That is because they do not cleanly apply there.  Can you provide
> working backports for that tree, and any other older tree that you think
> needs it, so we can queue them up?

Backports of those two commits would only cover 6.6.y, so they do not
close the report on their own. The per-tree picture is:

- 6.6.y: yes, it needs both. Its dependency chain pulled in the middle of
  the 2024 on-demand-clone series but skipped 8b8a2417558c immediately
  before it and 532aec7e878b immediately after.

- 6.1.y and 5.15.y: they never took the on-demand-clone series at all, so
  those two commits do not apply there even in principle. They need a
  structurally different, stable-only fix: make pipapo_gc_queue()
  unconditional so the batch that pipapo_gc_scan() already allocated and
  put on priv->gc_head cannot be stranded by the early returns sitting
  between the two calls.

-- 
Thanks,
Sasha
