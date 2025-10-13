Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF7425783C
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Oct 2025 19:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760384609; cv=none; b=t1JQ5CliAZaX3KGhY/r3c+kU+LQiP0T91I2OI8ap2wO27F+8dcDrF08/DoarA/7pIL1CkKH82R1BCZSKVQDIJrqJ6EoUVBKyXA3COCHTinNUptsEpvWrPVt9YtcM/QDs378dNwtkB3X8Vcm3m3xd9rbx5uuxBYSnmea6+mKsJmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760384609; c=relaxed/simple;
	bh=fg7yx5CYqHqq21jm9cvr8lA0yG5/CN3ZiIyZTY4yUoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DdoQH5IMJdwJmHZpW2eSyqzh5lwMzL8I0XOZm8jRjGXKxBmrLO3tGBI4zAjMfetP8QNNWuvfDsYLVbuLRs4W6qudzA4xdeI5dvrqSnIr4Eiu/BmXFXN1WcdGjTaiAPcmFHFlxc4zkuIoJia0SLG12NpujtWGMqSWUqcnP0g9sVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BF3A26042E; Mon, 13 Oct 2025 21:43:24 +0200 (CEST)
Date: Mon, 13 Oct 2025 21:43:24 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: georg@syscid.com, netfilter-devel@vger.kernel.org,
	Georg Pfuetzenreuter <mail@georg-pfuetzenreuter.net>
Subject: Re: [nftables PATCH] doc: fix tcpdump example
Message-ID: <aO1WXJP5tQQ_Rbty@strlen.de>
References: <20251013171730.1447005-2-georg@syscid.com>
 <7600f08e-bedf-4f92-99b8-751f4a096243@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7600f08e-bedf-4f92-99b8-751f4a096243@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> > The expression needs to be enclosed in a single string and combined with
> > a logical AND to have the desired effect.
> Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Applied, thanks everyone.
