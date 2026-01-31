Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5703635B151
	for <netfilter-devel@vger.kernel.org>; Sat, 31 Jan 2026 17:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769881186; cv=none; b=SPmvclVFxdd3tD80+IjLHJEARlFMn2WJlthnZ0XSFlYJN22yI6Nwv4TnmQVAqXae3IQ16pWMr/73OYrpaFEQBh9FiAcEcI73mPhwuvA1UC+qLRTJEhn/rotiq79rKgoUZAjGP4kjFLZ9p855KaS4+NPrELj+PYlyt3BHF/uvykE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769881186; c=relaxed/simple;
	bh=/yY3tg+/ZjV4/uXkNlvEa9FFKJUe7l2JuKESq2P14S0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=MJtepATFBuOKHdel+vwV2gKhe3kDbYaPwkDo2tSoJEPowYsjapw89JtIbQd8jlPrfqVVmFaC/sExuf193b/YCeVcikXV68al2zCI96v7YSfK3FkiVFQ57ny2XV0WSsxX58PCKYvR5HJZ3D2YZiwC63ms/ktP8nzxG6Q6Tf2NjwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 8355010038AF19; Sat, 31 Jan 2026 18:33:45 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 830DB1108EE4A2;
	Sat, 31 Jan 2026 18:33:45 +0100 (CET)
Date: Sat, 31 Jan 2026 18:33:45 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Ingyu Jang <ingyujang25@korea.ac.kr>
cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, 
    phil@nwl.cc
Subject: Re: [Question] Dead code in xt_register_matches/targets()?
In-Reply-To: <20260131145516.3289625-1-ingyujang25@korea.ac.kr>
Message-ID: <o4n85p54-s836-5qo6-881n-45o8so7p4q89@vanv.qr>
References: <20260131145516.3289625-1-ingyujang25@korea.ac.kr>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Saturday 2026-01-31 15:55, Ingyu Jang wrote:

>I noticed that in net/netfilter/x_tables.c, the functions
>xt_register_match() and xt_register_target() always return 0.

See commit 7926dbfa4bc14e27f4e18a6184a031a1c1e077dc
and the state prior.

