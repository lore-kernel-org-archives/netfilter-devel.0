Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3B52BE641
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2026 15:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777561625; cv=none; b=ZQJ3SSVsjfRSnHpe6FIZrGz9iazamirxrPJGnMhM5bXzSToHBGcV79PHOEA+MMAFMPzFI2/4eoMqcBtouPCT/H/9wWpu4MDPSiWSnGGeaiC4eoAB2xXUZrlwEgoIonhXGbkd5ZRdBN7bsi135JwzFviI6rTuqdI6ymBs/WO/Tic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777561625; c=relaxed/simple;
	bh=EgXtzJ9taU6w0pKQx7hLlq4gtQilNvY3OtR4l2G1J4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RVA6XXrb2x5UvFFM21pZQV3DeCZTLOZG/LfXU73AAcHX5vSkXcH1yyHU6QLg1ICSXF6uUR40e+QfMWh0xBruGrfNuOGJ/BXijV8axyHoUYkKU6rQ+sR4J/ujim3KBnWE3ljQLre810GaenItyBHXIRxKcu7dgP8Yvg5ZfjXSJ8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lgYB/yM6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lgYB/yM6"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3625F6017F;
	Thu, 30 Apr 2026 17:07:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777561621;
	bh=b8Jv8wp2dwsh6B5N+5B7L/KgcZhuIjwvskLnvzfi4Yo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lgYB/yM6Li3x2KvaCxE7RpR+iiVuwBFWpwY0NHvOITLOx5h5HbOalZ6FLYvm85hxU
	 EgP+79jH4MM+dtUWMTcf/2GR4mcJGN7NvI44UfcKRH87li727U6RxbQ/+DBmox2eZR
	 K4eX99+q8WIurrK35bCWLq3vfbaIsriJGvSO5U6zTp3hXlZqmdY6sYi8wjGpBDxLRc
	 7xzIlmSac+8nNYE4+/+G9FWWrtZLGW3XnzSdXiao9oA+gDUBjvli65zwd9QRYdEfdu
	 44Mbzw0lfb8fQNMQumHEBpgeJrnQl+TFU7DCB6uWBgmbEgO9z6qTqmJCI/EWsuCTj9
	 kx3Qs15H5pFfw==
Date: Thu, 30 Apr 2026 17:06:58 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, phil@nwl.cc,
	fw@strlen.de
Subject: Re: [PATCH 3/3 nf v5] netfilter: xtables: fix L4 header parsing for
 non-first fragments
Message-ID: <afNwEgYpHBARCaI3@chamomile>
References: <20260428102548.6750-1-fmancera@suse.de>
 <20260428102548.6750-3-fmancera@suse.de>
 <afLx347nrAJLqsyf@chamomile>
 <236f1674-6ed2-4822-b313-3835c5895af7@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <236f1674-6ed2-4822-b313-3835c5895af7@suse.de>

On Thu, Apr 30, 2026 at 04:53:14PM +0200, Fernando Fernandez Mancera wrote:
> On 4/30/26 8:08 AM, Pablo Neira Ayuso wrote:
> > Hi Fernando,
> > 
> > On Tue, Apr 28, 2026 at 12:25:48PM +0200, Fernando Fernandez Mancera wrote:
> > > Multiple targets and matches relies on L4 header to operate. For
> > > fragmented packets, every fragment carries the transport protocol
> > > identifier, but only the first fragment contains the L4 header.
> > > 
> > > As the 'raw' table can be configured to run at priority -450 (before
> > > defragmentation at -400), the target/match can be reached before
> > > reassembly. In this case, non-first fragments have their payload
> > > incorrectly parsed as a TCP/UDP header. This would be of course a
> > > misconfiguration scenario. In most of the cases this just lead to a
> > > unreliable behavior for fragmented traffic.
> > > 
> > > Add a fragment check to ensure target/match only evaluates unfragmented
> > > packets or the first fragment in the stream.
> > 
> > One more little issue here: There seems to be an issue in
> > xt_hashlimit, hashlimit_init_dst() drops packets via hotdrop if it
> > returns -1.
> 
> Hi Pablo, I do not follow here. I think a hotdrop is the right thing to do.
> 
> xt_hashlimit creates the hash and later checks whether we are over the limit
> or not. The verdict is set based on that and the INVERT flag.. I don't think
> we should match or not match packets that we cannot parse correctly, we
> should just drop them.
> 
> This is the current behavior for example when protoff < 0 (because no L4
> header is found).
> 
> What do you think?

Your reasoning makes sense.

Currently if protoff < 0, the packet is dropped, therefore, fragments
are already being dropped.

Let's stick to this approach, thanks for explaining. I will take this
series as is then.
