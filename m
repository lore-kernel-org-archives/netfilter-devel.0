Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D22886EB4E
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2024 11:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710415080; cv=none; b=kITE8r/f0LwlIVPWDra8hPBU8LhBi5cCv/67VPoR6mNlTnUNcn/8d6PEidUXANCw7MSw3G21A1jKAKPzTapOi0DpUbstxmWItqC2WPF2P/odCR5raUwwnew+s5l3hCjUVj6rJB+2r1M4uXVTOHi9yxH1cdP2o8D0AqInJOJnh04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710415080; c=relaxed/simple;
	bh=b8fBw34yEJkArGwbv3xg6wAfXIdQ8rw2k47uo6fu1iw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NRf0zrGorANJz5NUnLhq95l1qOvgdOQLNNAtlZ1hRcwsXIEaMpZgFBa9nxJXkMHHKvZrTlEWJZZpr4BmSSmHi0yM/r4yuDHAvyEk6xUfsLQar6ZONkGNGrSifiRXJzTbEC7pd6cfyui9JRlP0bYkhZDyhP1YKFsIZ8hAZwxhv9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 14 Mar 2024 12:17:51 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sven Auhagen <sven.auhagen@voleatech.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Flowtable race condition error
Message-ID: <ZfLc33WgQPKdv2vG@calendula>
References: <x6s4ukl7gfgkcap6b56o6wv6oqanyjx4u7fj5ldnjqna7yp6lu@2pxdntq2pe5f>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <x6s4ukl7gfgkcap6b56o6wv6oqanyjx4u7fj5ldnjqna7yp6lu@2pxdntq2pe5f>

Hi Sven,

On Tue, Mar 12, 2024 at 05:29:45PM +0100, Sven Auhagen wrote:
> Hi,
> 
> I have a race condition problem in the flowtable and could
> use some hint where to start debugging.
> 
> Every now and then a TCP FIN is closing the flowtable with a call
> to flow_offload_teardown.
> 
> Right after another packet from the reply direction is readding
> the connection to the flowtable just before the FIN is actually
> transitioning the state from ESTABLISHED to FIN WAIT.
> Now the FIN WAIT connection is OFFLOADED.

Are you restricting your ruleset to only offload new connections?

Or is it conntrack creating a fresh connection that being offloaded
for this terminating TCP traffic what you are observing?

> This by itself should work itself out at gc time but
> the state is now deleted right away.
>
> Any idea why the state is deleted right away?

It might be conntrack which is killing the connection, it would be
good to have a nf_ct_kill_reason(). Last time we talk, NAT can also
kill the conntrack in masquerade scenarios.

> Here is the output of the state messages:
> 
>     [NEW] tcp      6 120 SYN_SENT src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 [UNREPLIED] src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 mark=92274785
>  [UPDATE] tcp      6 60 SYN_RECV src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 mark=92274785
>  [UPDATE] tcp      6 432000 ESTABLISHED src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 [OFFLOAD] mark=92274785
>  [UPDATE] tcp      6 86400 FIN_WAIT src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 [OFFLOAD] mark=92274785
> [DESTROY] tcp      6 FIN_WAIT src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 packets=10 bytes=1415 src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 packets=11 bytes=6343 [ASSURED] mark=92274785 delta-time=0

Is there a [NEW] event after this [DESTROY] in FIN_WAIT state to pick
the terminating connection from the middle?

b6f27d322a0a ("netfilter: nf_flow_table: tear down TCP flows if RST or
FIN was seen") to let conntrack close the connection gracefully,
otherwise flowtable becomes stateless and already finished connections
remain in place which affects features such as connlimit.

The intention in that patch is to remove the entry from the flowtable
then hand over back the conntrack to the connection tracking system
following slow path.
