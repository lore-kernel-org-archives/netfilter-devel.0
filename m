Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226FB2882BC;
	Thu, 22 May 2025 13:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747922017; cv=none; b=FcCSsH8pdK8Slm9bBjLVy3K7IMl4Y/VFnL4nRqKNsBK9tUm+Yu1PsvbNiZ1GtB2vYo3DpTV/QRFN2whVkPQaGLFdHU0N9DiRE2xsHSdqN7u2GjbYUhnelO0gCENVZk7s5nLwVthwx+uLD90bITup2X5UOBMQm591HUtKyfr4CzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747922017; c=relaxed/simple;
	bh=Sa/Gpq4MDNOi2J3fwC+rO1gFlrYFv2SlfwaB39iQP08=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oBTVaTOdZX7AMWNRmCsuaswgPSnAljD0THd+x+OLtrlQwFiXS3yTzdR7LHIdtiFTALEqvK9YY+efod0w+CItji74nCoJv3gV7Vgvh85k18Ws6d8qbNdymkPYAcw5/6qWNwkWJPVl4Ifow0jAiMDCZug2bUNeQxFAyo70wfTb1Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QODs/v5P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QODs/v5P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5552DC4CEEB;
	Thu, 22 May 2025 13:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747922016;
	bh=Sa/Gpq4MDNOi2J3fwC+rO1gFlrYFv2SlfwaB39iQP08=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QODs/v5P1zGJQh7drAiLaZZuUTWJQqseEnQ+N5Xq4oAJU1zkekElCGd6lxkvLHlDG
	 7iEb6zIWWDNyAK4ejDFl8TbfwUVjNOUNhpcMRJaYJ3kpR2eUGa6AfxsinHuiAtnvNN
	 E7phopTcD9SxY50QxRQYOFdhNXAlbKCdS/E2xz0z1rNF0ZbkFZ5BbGmNP6aeJ2DlDl
	 LMjmwOfT9j1Y4kZCEaoM9/d8tWey+JzA9ZX3vZXRFMtnGTzWAxYNYTpuE8L2GkIrB3
	 +yVnp3woRPGPAsyzZVfPZdr59DLmSXDfZE8o2gM/pbvLea6/0h01DND5HVWiccrL6k
	 Wc1yef8U8eEFg==
Date: Thu, 22 May 2025 06:53:35 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso
 <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>,
 "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: nft_queues.sh failures
Message-ID: <20250522065335.1cc26362@kernel.org>
In-Reply-To: <584524ef-9fd7-4326-9f1b-693ca62c5692@redhat.com>
References: <584524ef-9fd7-4326-9f1b-693ca62c5692@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 22 May 2025 12:09:01 +0200 Paolo Abeni wrote:
> Recently the nipa CI infra went through some tuning, and the mentioned
> self-test now often fails.
> 
> As I could not find any applied or pending relevant change, I have a
> vague suspect that the timeout applied to the server command now
> triggers due to different timing. Could you please have a look?

Oh, I was just staring at:
https://lore.kernel.org/all/20250522031835.4395-1-shiming.cheng@mediatek.com/
do you think it's not that?

I'll hide both that patch and Florian's fix from the queue for now, 
for a test.
