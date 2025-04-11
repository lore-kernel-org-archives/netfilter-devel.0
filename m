Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82740278E44
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Apr 2025 10:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744366364; cv=none; b=OwIHAgRal2qHFQ5PON91LqqA5tAUhjgEfiV2MKcQF6W3IX0nGik057CPiDUbJfojRVGPLtzcv9MyOtq5CCWOS30AWNhw3EEd+xgGw4yfCah5X6gX+SavFKLpT/9Coac3j8NFT2Fqi19bo0PwjnwFSOIQKbHUckiIglUwlsil/tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744366364; c=relaxed/simple;
	bh=uUSx2kppVumYDYj2KM7k7jWxGiBaSXFLFHOaJocSYtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=trHHqpx+HAEEZCkpGGNmefkCA/zclkfPWskNa39ihtwUvjbxcWDIhGEICGc/sZxm3dmDYMsTBkCLbD4+VKtE+RZo0pW2GFTg+39n85sjrja12F05hoEsV+QH4oqrcA+Pf4PBI9yOHgxMGNPqwgsJLVIZVjuAaiaDeboWA4Ex3pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u3BNI-0007C2-3P; Fri, 11 Apr 2025 12:12:40 +0200
Date: Fri, 11 Apr 2025 12:12:40 +0200
From: Florian Westphal <fw@strlen.de>
To: Braden Bassingthwaite <bbassingthwaite@digitalocean.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	ncardwell@google.com, maximmi@nvidia.com
Subject: Re: SYNPROXY affecting initial BBR throughput
Message-ID: <20250411101240.GB26507@breakpoint.cc>
References: <CAFejGzLnjCKfhx2FnjWnnCnO1x1nH1mKnia41a_7OtrqbFbRLg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFejGzLnjCKfhx2FnjWnnCnO1x1nH1mKnia41a_7OtrqbFbRLg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Braden Bassingthwaite <bbassingthwaite@digitalocean.com> wrote:
> I am using SYNPROXY with XDP and have discovered an issue with the current
> SYNPROXY implementation. When used in conjunction with BBR (TCP Congestion
> Control), connections over WANs have drastically reduced bandwidth (< 1
> Mbps) for the first 10s of a connection, and will accelerate to their
> expected bandwidth of ~ 500 Mbps.
> 
> I believe this is because SYNPROXY will internally send a SYN and SYN/ACK
> after the 3HS is completed. This causes the initial RTT of the connection
> to be artificially low < 50 microseconds when it should be > 100ms in our
> experiments.
> 
> BBR uses a RTT sliding window of 10s and during that window, it will
> leverage the minRTT. For our WAN connections, the artificially low RTT
> affects the window size and drastically reduces the available bandwidth for
> that period for these connections.
> 
> Ideally SYNPROXY would somehow signal to the TCP stack that it should
> ignore this SYN->SYN/ACK RTT since it's not a valid measurement, and would
> rely on subsequent RTTs.

SYNPROXY is designed as a middlebox, both sender and responder are
considered to be on a different physical host, so its not possible to
signal that initial rtt measurment should be discarded.

If you are already using BPF, did you consider
https://lore.kernel.org/all/20240115205514.68364-1-kuniyu@amazon.com/

instead of SYNPROXY?

(or just use normal tcp stacks syncookie mode, i don't see why you
 have to do upfront xdp cookies if its all on the same host ...).
