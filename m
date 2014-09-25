From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH nf] netfilter: conntrack: disable generic protocol
 tracking
Date: Thu, 25 Sep 2014 14:21:36 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1409251404060.14369@blackhole.kfki.hu>
References: <20140925113237.GC25548@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, dborkman@redhat.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:59177 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbaIYMVP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2014 08:21:15 -0400
In-Reply-To: <20140925113237.GC25548@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Thu, 25 Sep 2014, Florian Westphal wrote:

> Given following iptables ruleset:
> -P FORWARD DROP
> -A FORWARD -m sctp --dport 9 -j ACCEPT
> -A FORWARD -p tcp --dport 80 -j ACCEPT
> -A FORWARD -p tcp -m conntrack -m state ESTABLISHED,RELATED -j ACCEPT
> 
> One would assume that this allows SCTP on port 9 and TCP on port 80.
> Unfortunately, if the SCTP conntrack module is not loaded, this allows
> *all* SCTP communication to pass through, i.e. -p sctp -j ACCEPT,
> which we think is a security issue.
> 
> This is because on the first SCTP packet on port 9, we create a dummy
> "generic l4" conntrack entry without any port information (since
> conntrack doesn't know how to extract this information).
> 
> All subsequent packets that are unknown will then be in established
> state since they fallback to proto_generic and the tuple lookup will
> match the 'generic' entry.
> 
> Unfortunately, the only reasonable fix seems to be to completely
> disable generic protocol tracking, i.e. force all packets to be in
> invalid state.
> 
> Joint work with Daniel Borkmann.

That means the generic connection tracking is completely thrown out, which 
is totally backward incompatible and comes out of the blue for everyone 
who relies on it (for example runs OSPF).

I understand that this is the simplest way to handle the security issue, 
but I also believe the price is too high. Why don't we check in the sctp 
match that the conntrack module is loaded in? Something like

	if (nf_conntrack_loaded_in &&
	    !nf_conntrack_proto_sctp_loaded_in &&
	     request_module("nf_conntrack_proto_sctp") < 0)
		return false;

in match_packet() so that it won't match if conntrack there but sctp 
conntrack won't load.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
