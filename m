Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB2A1DC985
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 14:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761660708; cv=none; b=ZiaFzJHNnUumXxZ0UPXBfB3h0FqlsPUEoCxUqFKKm6nz7Fbah0aukHwBvEBkYtCtyhVycNfwiXZd+Uc0iabo2ZpksFZnhV0Gx+h1J1+Im55uVViGtyNHk3LfYlEEpTCqgG4B4Xxv2tkzgYOSOhSL1rMSLIMd1MChy7c8DR1aMjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761660708; c=relaxed/simple;
	bh=RpO25up/KZUeriBPVu2viG30JBliwCGjQkZsDMaGAWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n45yD+QDnLGsruSdZTOu+G72n+pKFXW97Bd79sznN0wb2XhXfcyxSDKJzL9XXoiNrj5JVJBgG6hdVhiU4frGjtJIi0N1R1qV8+ZSv0Av6hUj0K3sxu8TitxQ+PNSvYf7T5RatJQYadpWQjHf0ONugaeiqMCa3ojxR2C2sBShbkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E4D3A61A31; Tue, 28 Oct 2025 15:11:37 +0100 (CET)
Date: Tue, 28 Oct 2025 15:11:32 +0100
From: Florian Westphal <fw@strlen.de>
To: Andrii Melnychenko <a.melnychenko@vyos.io>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/1] tests: shell: Updated nat_ftp tests
Message-ID: <aQDPFAv24A0uuOgk@strlen.de>
References: <20251027113907.451391-1-a.melnychenko@vyos.io>
 <aP_By5SYOFlM9LmZ@strlen.de>
 <CANhDHd_fLKccgO8Prw=r8D_S8nGNeUaXfOqBPn=jj7ww3W7jYg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANhDHd_fLKccgO8Prw=r8D_S8nGNeUaXfOqBPn=jj7ww3W7jYg@mail.gmail.com>

Andrii Melnychenko <a.melnychenko@vyos.io> wrote:
> It could be a tricky one - for example, an SNAT-only case requires
> connecting directly to the FTP server.
> A DNAT-only case would require checking the client's IP in the PCAP file.
> So the "test function" may look like this:
> ```
> test_case( ip_and_port, client_ip_to_check)
> {
> ...
> ip netns exec $C curl --no-progress-meter -P - --connect-timeout 5
> ftp://${ip_and_port}/$(basename $INFILE) -o $OUTFILE
> ...
> tcpdump -nnr ${PCAP} src ${client_ip_to_check} and dst ${ip_sr} 2>&1
> |grep -q FTP
> }
> ```
> If something like this ok, then I can do it:

Above looks good to me.

> 
> I'm not sure, maybe the idea is to make sure that the data is
> "flushed" to the PCAP file?
> I can remove it.

Thanks!
