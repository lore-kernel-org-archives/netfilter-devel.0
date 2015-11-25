From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH -next] netfilter: nf_ct_sctp: validate vtag for new
 conntrack entries
Date: Wed, 25 Nov 2015 20:42:34 +0100
Message-ID: <20151125194234.GA12460@salvia>
References: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1448478477.git.marcelo.leitner@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>, mkubecek@suse.cz
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39252 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbbKYTmm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 14:42:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0AF11129253
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 20:42:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EBA7CDA803
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 20:42:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F0A54DA732
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 20:42:38 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1448478477.git.marcelo.leitner@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 25, 2015 at 05:13:01PM -0200, Marcelo Ricardo Leitner wrote:
> Commit d7ee35190427 ("netfilter: nf_ct_sctp: minimal multihoming
> support") allowed creating conntrack entries based on the heartbeat
> exchange, so that we can track secondary paths too.
> 
> This patch adds a vtag verification to that. That is, in order to allow
> a HEARTBEAT or a HEARTBEAT_ACK through, the tuple (src port, dst port,
> vtag) must be already known.
> 
> As it's possible that peer A initiated the connection but peer B ends up
> being the first one to send a heartbeat, there is a cross-direction
> check for matching the registered conntrack directions with the
> heartbeat one.
> 
> Note that this vtag verification is only possible on peers or routers
> that will see all paths in use by a given association. When used, it
> will only allow secondary paths if the primary one is already there.
> That is, it's usually only useable at the peers themselves, and thus it
> defaults to off, controlled via sysctl
> net.netfilter.nf_conntrack_sctp_validate_vtag.
> 
> As we can't really track associations but just their paths, it's
> possible to have multiple hits of the 3-tuple to actually reflect
> multiple associations, just as it's also possible to have different
> vtags for a given pair of ports.
> 
> When a heartbeat comes by, it will allow it if the vtag is one of the
> two (or n) in use, no matter which association it really belongs to.
> Yet, if there is a lingering conntrack entry from a previous association
> built from heartbeats for that 5-tuple (saddr, daddr, sport, dport,
> sctp), like from a fast port reuse, it will reject packets with the new
> vtag. This is actually a result of the normal conntrack entry
> verification and is not a result of this patch or d7ee35190427.
> 
> SCTP has this particularity that peer addresses are negotiated during
> initial handshake _and_ also via ASCONF chunks (RFC 5061). ASCONF chunks
> must be authenticated, for security reasons, and as conntrack actually
> sits in the middle even when used at the peers, it cannot validate the
> authentication and thus it cannot trust ASCONF chunks, so we cannot
> track IP addresses and thus we can't rebuild the association itself.
> 
> It is necessary that the path that initiated the association to continue
> up as it's the only one that gets hashed and we cannot promote secondary
> paths, due to the above. Once the primary path is down, secondary paths
> using those vtags that expires won't be able to re-activate.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  Documentation/networking/nf_conntrack-sysctl.txt |   9 +
>  include/linux/netfilter/nf_conntrack_sctp.h      |  17 ++
>  net/netfilter/nf_conntrack_proto_sctp.c          | 251 ++++++++++++++++++++++-
>  3 files changed, 276 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/networking/nf_conntrack-sysctl.txt b/Documentation/networking/nf_conntrack-sysctl.txt
> index f55599c62c9d61335005202146fdad75c8c133b9..9113fa12fee9548a99e5ea6b5241a4e882ffbfd0 100644
> --- a/Documentation/networking/nf_conntrack-sysctl.txt
> +++ b/Documentation/networking/nf_conntrack-sysctl.txt
> @@ -175,3 +175,12 @@ nf_conntrack_udp_timeout_stream2 - INTEGER (seconds)
>  
>  	This extended timeout will be used in case there is an UDP stream
>  	detected.
> +
> +nf_conntrack_sctp_validate_vtag - BOOLEAN
> +	0 - disabled (default)
> +	not 0 - enabled
> +
> +	Enable VTAG validation for conntrack entries created from
> +	HEARTBEATs. That is, in order to allow such new entry, that vtag
> +	must already be known for that port pair, no matter which
> +	addresses are used. Most useful in end peers.

Any specific reason ...

not to have this enable by default?
to have a sysctl switch to enable/disable this?

Thanks.
