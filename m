Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C49222129C
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Apr 2025 11:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744369515; cv=none; b=ZZW+mcN327sCwgWa2vqUNhvZwZcD5iO/PtAXsAjlteExMVQSRXavGNsquMb693qGniKpxjv2BIlpQZBwyNtFPo3/b0gN7+ob0BR37lTrhCVHLy+UuZJ0UD1kndulD6LhZ27fbdaU+wEx7re5LuG2H4NibgpPo8in3femVLw6hys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744369515; c=relaxed/simple;
	bh=VllVQ0vvNUafpDYq2DDfoIp6nt9EmInvdgRLaY0fkNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RxP1nx29gfjGAf/Q49i5g2Y396m0rQfaKm/Dv5fQSgJTO0Dj4HOI25UDLUZ+Der+tVyJxsybb8xPrc6o5CPzzxDAq93GYi3mzkWcnDkD0F5Wqaum6yQ14JMhoKhU0WFp6AGctji6+i7qLNHz9IndJOXkVssg/zFMwIzN3WFLLTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Rjo0HTFs; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GaAkQ+k4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Rjo0HTFs";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GaAkQ+k4"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 38E5D6062F; Fri, 11 Apr 2025 13:05:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744369510;
	bh=oU52L7hAz3145AFdYJ6S3tTWGqmQqOP2MwtYPpwVplc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rjo0HTFsBwH7hcD7yWWyfDAQSluVLZhe0ZZWEkUV1TDdnG+L8DAUFvXKi5+O7nhPF
	 rdGjAXyMy50ACaoowxmVi9n05cyE1BXvculI3APmU2LQsQMysEUgfAyRq64C0g7PDg
	 AWlAbIvfLecvCUkXT99nBEIUIfC1HZrqSFasqUJJGJxDn+hbgMHJrE2f+bucQmYT/y
	 rJyQwTrDCxRR9wDIUF00FVIV6WzprMZtGELlyBuH0wSudLLFGE411aJZzGzMZaKG6S
	 UrvhQymiLi5ZFO67JjHarRlSwhqGtq1TNl3oXVBcYzjYVcqLlTvoc1+diPVK5NT3Qm
	 wLA9DnEb7l8tA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D7B846062F;
	Fri, 11 Apr 2025 13:05:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744369507;
	bh=oU52L7hAz3145AFdYJ6S3tTWGqmQqOP2MwtYPpwVplc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GaAkQ+k4nTp+ZixsgjRxyiXwIN8YbhgWC4l6nkTJBB8HiGvQRCEN6SB2QYdVUw15H
	 bEiSqewepGU5LDCWQmz6CCkxujkbRu/Cw4e3i29lTUBiK5ZY4EKOjjuouyvva5RPzb
	 QZ1tFaYMLanCvQ2GTuIxSu9MRE6shlo22akJN2RwpJg4r9CqTHCvX0wN8I7UQxBx+O
	 NZjv6UP9MmewMo8wEgkYJMsw5kc9A77WwfOyIG+B686yg1E402y50+jtTzfef0GRpG
	 y80v8MuHxDQRUAO53FkjLduWOR5+LFU1iQsKODLYxG6bsL5njfre0IGgw3GotybTmq
	 uthZKEZ4E9bxg==
Date: Fri, 11 Apr 2025 13:05:04 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Braden Bassingthwaite <bbassingthwaite@digitalocean.com>,
	kadlec@netfilter.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, ncardwell@google.com, maximmi@nvidia.com
Subject: Re: SYNPROXY affecting initial BBR throughput
Message-ID: <Z_j3YPsT-EwAWjcT@calendula>
References: <CAFejGzLnjCKfhx2FnjWnnCnO1x1nH1mKnia41a_7OtrqbFbRLg@mail.gmail.com>
 <20250411101240.GB26507@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250411101240.GB26507@breakpoint.cc>

On Fri, Apr 11, 2025 at 12:12:40PM +0200, Florian Westphal wrote:
> Braden Bassingthwaite <bbassingthwaite@digitalocean.com> wrote:
> > I am using SYNPROXY with XDP and have discovered an issue with the current
> > SYNPROXY implementation. When used in conjunction with BBR (TCP Congestion
> > Control), connections over WANs have drastically reduced bandwidth (< 1
> > Mbps) for the first 10s of a connection, and will accelerate to their
> > expected bandwidth of ~ 500 Mbps.
> > 
> > I believe this is because SYNPROXY will internally send a SYN and SYN/ACK
> > after the 3HS is completed. This causes the initial RTT of the connection
> > to be artificially low < 50 microseconds when it should be > 100ms in our
> > experiments.
> > 
> > BBR uses a RTT sliding window of 10s and during that window, it will
> > leverage the minRTT. For our WAN connections, the artificially low RTT
> > affects the window size and drastically reduces the available bandwidth for
> > that period for these connections.
> > 
> > Ideally SYNPROXY would somehow signal to the TCP stack that it should
> > ignore this SYN->SYN/ACK RTT since it's not a valid measurement, and would
> > rely on subsequent RTTs.
> 
> SYNPROXY is designed as a middlebox, both sender and responder are
> considered to be on a different physical host, so its not possible to
> signal that initial rtt measurment should be discarded.

Rough idea: In nftables, it is possible to define a synproxy object.
Would it work to have a sidecar userspace program to refresh the
missing rtt measurement between synproxy router and backend server?
I am assuming one synproxy object to represent each backend server.

> If you are already using BPF, did you consider
> https://lore.kernel.org/all/20240115205514.68364-1-kuniyu@amazon.com/
> 
> instead of SYNPROXY?
> 
> (or just use normal tcp stacks syncookie mode, i don't see why you
>  have to do upfront xdp cookies if its all on the same host ...).
