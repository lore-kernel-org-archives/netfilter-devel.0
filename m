Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49977273816;
	Wed,  4 Feb 2026 02:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770170979; cv=none; b=iU4kI3aUCcD/QnoXejDQYfCnpksPQusWfswcbNnKSgd3k1qM899QTBdskU0z27SINfxrPLx5P4DOZTKa4z69zOArszAbGgJui5PH/aKmn3QfQO0NCeqEeFMaD3fRNfOuooHdlnyX2ExfBCpCG6LGD6NOI59AcK5DefQHkgb20kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770170979; c=relaxed/simple;
	bh=XUyfb4wzf0dEgS+vltqrSUB4mrfJutQj0qg/Ca7kbYc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s/d+F/75kR86aVQww9tXQMmN/05v/FmYfRGfoBi/nYz45so6kLi8rcTv17lMhMa/guR34HwatNeYBbaMwMXPaZbIDMBh3pgt4ib12tvwJFei8xrqm/OdQjeCUiE5biA5jBaLdIn6LnrvJseAh5QqmVvrUeDEjyWyp+Pokj+vpzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fk7r6+gE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fk7r6+gE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55656C116D0;
	Wed,  4 Feb 2026 02:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770170978;
	bh=XUyfb4wzf0dEgS+vltqrSUB4mrfJutQj0qg/Ca7kbYc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fk7r6+gEy7jVZ4EdqJYIy8OrETdUz6WJUYbVRlrN/PqXqMfKutwByH9aECOV/wp6A
	 mq5ObCK2U6P8fDWef/uZnPxEB3aCgPNy8COOZCsTxe6NZeasu7wTbrtZLPvWiMkNdK
	 BivszxGCOjJX3aRRjysiJiwJgukjTIL8cNhcl9Mp73YXlBEoJov1H9sfiwOqhCnkUH
	 likURp5XsC4Bt5i4azZcta1wFSh06hnOgPVE+P81nXLJbpIdtpf8x5E7H87WZk23fq
	 a4ifoX0tH0DTDxG22oflY3jmHZ2OG0prlN07DOtOB28NN1M9FZUGFWwLnZBw1hvvmU
	 fHL61ir6ugGBQ==
Date: Tue, 3 Feb 2026 18:09:37 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: anders.grahn@gmail.com, Pablo Neira Ayuso <pablo@netfilter.org>, Phil
 Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3] netfilter: nft_counter: Fix reset of counters on
 32bit archs
Message-ID: <20260203180937.25219489@kernel.org>
In-Reply-To: <aYH-Mr0Hy7EfivBt@strlen.de>
References: <20260203134831.1205444-1-anders.grahn@gmail.com>
	<aYH-Mr0Hy7EfivBt@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 3 Feb 2026 14:54:58 +0100 Florian Westphal wrote:
> I will apply this in the next days unless there is a NACK from
> netdev maintainers.

My $0.02 is that it'd be great to add a comment advising against the
use of the new helper, because normally stats shouldn't go backwards.
But I guess is equally obvious as it is hard to explain succinctly.
So ack from me.
