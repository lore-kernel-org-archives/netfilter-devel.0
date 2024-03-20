Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2022B6A8DD
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 18:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710958144; cv=none; b=tTjCRXgsyHZDvVxaKadpfGYWczQa1h7Y3PVon5wQ2d3Qbd3IzPWIrLs+ZnR84Bw/OuF9ANmGR2RF9xInkN8m855HL+3t/q3oUMx4S8xAnRa5Glgn2JY98TYIbTyOKMYLJQO9yIZfsn/wincPQKmFu0XIYD2RvaYoWIBzHCkS5mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710958144; c=relaxed/simple;
	bh=8k7Y2Bz2bYYJKwCtNkcQPfAmn8Q73Fz7mfY+Qhqnjh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D04ZY34miO8hqaPcTbikwzrrelzl1drM+xI96yx8esqQBOXArJGWVSzX1WncaOqYj3qW7TEZlTKIlPzqtO9Crt4MIG9jeXodAruNIOni3m4aQTcMsgzM9UU1mmZ4L/IvHhgTnIK+FL+JGqCchofQbh53BLzKCi05r2pqn+ammFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Wed, 20 Mar 2024 19:08:58 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v3] src: do not merge a set with a erroneous one
Message-ID: <ZfsmOkUyrPfd3Sk4@calendula>
References: <20240112121930.11363-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240112121930.11363-1-fw@strlen.de>

On Fri, Jan 12, 2024 at 01:19:26PM +0100, Florian Westphal wrote:
> The included sample causes a crash because we attempt to
> range-merge a prefix expression with a symbolic expression.

For the record, I have applied this, thanks!
