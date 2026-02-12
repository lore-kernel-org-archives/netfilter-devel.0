Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D06E12CDBE
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2026 17:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770916848; cv=none; b=kx6b2PIXHTwce9p4FdJEphsmLU6CmxUg0kSRzCV+uAFQOADFLeja0ntEDpGykNubdYAYkRC+k7X9Uncu7MyOuVO4xUE3hSsHGU/cT3gwePTvJ6Ne6TzKlChnO81T5Zti2t6TfMn4SfJzZfkQt4NSwAgk+XYZz+WVrcXlJjI09d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770916848; c=relaxed/simple;
	bh=gFqvlZvZ8RE8lGvxeMx6t0nD2F/oJb2J0eaBjMpi2dw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c9HUH3SBktjb5QNwIOu8tYb5Ne/GQ5zb1kgNcyBIhfJWAGOXkgJQ/reTqVPlF3GI+CEYszn3JSKqQzXszu/9lo53Dwvqpb1rzntmsXI+LlKRKtsTwL3DXFojlOGoM3ZbKzFL3htvfYIqOzVG60SND7/zXpNQEgXWB5EOPEgUPLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 66D966063D; Thu, 12 Feb 2026 18:20:37 +0100 (CET)
Date: Thu, 12 Feb 2026 18:20:37 +0100
From: Florian Westphal <fw@strlen.de>
To: Alan Ross <alan@sleuthco.ai>
Cc: Jan Engelhardt <ej@inai.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] libxtables: refuse to run under file capabilities
Message-ID: <aY4L5azyFoRua6iM@strlen.de>
References: <CAKgz23F8EKsc2vhVAPyuZgUNA7Zohm0zS6-So+jPJTvCiNikig@mail.gmail.com>
 <aY3aAChfNI3LWvfO@strlen.de>
 <qq4or008-331o-628q-rr32-409p846r02o9@vanv.qr>
 <CAKgz23HD3UDEubpDfVK2dumYfTr+ODOyKmbfDunVeoPPjX2x3A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgz23HD3UDEubpDfVK2dumYfTr+ODOyKmbfDunVeoPPjX2x3A@mail.gmail.com>

Alan Ross <alan@sleuthco.ai> wrote:
>  Good feedback. If the binary is built with NO_SHARED_LIBS (static, no
> dlopen()), then the env vars
>   never reach plugin loading, so the setcap risk is mostly gone and
> it's okay to allow it.

Not sure sure.  Yes, the dlopen() risk is gone.

But I'm not convinced its safe to setcap this; are we sure there is no
bug in there that could allow to redirect control flow?

CAP_NET_ADMIN is quite powerful, I don't think we should sanction
setcap-installations in any way, so I prefer the strict version.
