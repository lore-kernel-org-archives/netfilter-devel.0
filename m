Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5341332AAA0;
	Mon,  8 Jun 2026 11:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780919924; cv=none; b=lzxactqogGht+8sRTRqK0lzTnEYOSMICSA8BZInmyITSnZQSCCxnPyd6yAeKkK697ME6ISgZ3iTvH6jxsRDOCFUjAOZeydedKn9HAGtd5xW8rg4tUkoGiJmK60QceIs10fo7y51uldrRIrksQKQF/YYtE7+7wEIbhj5NALKmkyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780919924; c=relaxed/simple;
	bh=02GfgsWj0zdga+jHPzVRb34KmbV/p+t9O0OVqsIRqCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jDRbtEju+A9+RLl+dC3MZ2HIZstp2uTTaTnocMj3uScPM1+vVz/eWw1p59rmr+CCZAs37nvHFtwtsL8Jo+cpcu2s6WCGO9i/ubO278VPlwSq4rIqOUQIZ/Zcj1Dp20MLK1y76CB82ls3o0WuFbCvYYpzuN8I2d74tEEiPssqnBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=W9xPvfGP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="W9xPvfGP"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id DFB2E601A4;
	Mon,  8 Jun 2026 13:58:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780919920;
	bh=IoB+Ot18cd6gKVtQ6gpjAMIec1tM54RSVRw+IZ0W9cQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W9xPvfGPSrVGPCEkcSbXbtBfrQUGC2W5udHeN6hTsMk0MTmjuxNcuCokvqT1Z/x/h
	 wrgyoro1unUH0nhnLkn0l4xJ0ak8ECR6CTu+FjhEb+Zt6nsDVbwc6Oz/ptz1RhE51P
	 Wc5ZLkX+LcC+1isS6yckdt7Jnu+6sMwhUNHMH4+AyHgXQB0KLvb8DkgyE2skX4IK8z
	 mVSRYjgZEwIHwMwgyy7A2jKdpfwdNSASDJvzGGjsqOEd/VEVf5K/qUDQZpg9CpwEeO
	 XdjEqCOXRo+6dUyDWKZjCJCxr2JF7U2YMX+CIzVb7mrB396jvybe4frX09lMzZYOQZ
	 RmCsk+LXo/x3Q==
Date: Mon, 8 Jun 2026 13:58:37 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, fw@strlen.de,
	horms@kernel.org
Subject: Re: [PATCH net-next 00/15] Netfilter/IPVS updates for net-next
Message-ID: <aiaubSEfDp_JQk_p@chamomile>
References: <20260607094954.48892-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260607094954.48892-1-pablo@netfilter.org>

Hi,

I'm replying to Sashiko.dev comments here:

* [PATCH net-next 06/15] netfilter: synproxy: fix unaligned memory access in timestamp adjustment

Refers to pre-existing issue. I think this comment is not correct?

* [PATCH net-next 07/15] netfilter: synproxy: protect nf_ct_seqadj_init() with conntrack lock

Refers to pre-existing issue. But I think it is not correct, reopened
connections in TIME_WAIT are killed by TCP protocol tracker, so they
start in a clean state.

It also suggests check for NULL in seqadj = nfct_seqadj(ct); this is
related to a bug in the ct extension generation ID which is addressed
by this batch. Anyway, Florian and me agreed that adding this NULL
check for safety is good to go, and I have a patch fot this.

* [PATCH net-next 08/15] netfilter: cttimeout: detach dataplane timeout policy and repurpose refcount

Wrong comment by AI. 

> Does removing this assignment cause nftables ct timeout rules to silently fail
> if a timeout extension is already present?

The ct timeout is only applied to a new conntrack that unconfirmed,
this override semantics does not make sense to me.

* [PATCH net-next 11/15] netfilter: nf_conntrack_helper: add refcounting from datapath

Refer to pre-existing issue. Yes, ->destroy() is missing here and in
ctnetlink, I will post a patch to address this. This also refer to
ctnetlink_change_helper().

* [PATCH net-next 13/15] netfilter: conntrack: call nf_ct_gre_keymap_destroy() if master helper is pptp

No other helper support the .destroy callback. AI assumes other
helpers support this callback.

* [PATCH net-next 14/15] netfilter: flowtable: avoid num_encaps underflow on bridge VLAN untag

Refers to pre-existing issue. Yes, this function nft_dev_path_info()
can be made more robust when failing to build a fast path. I have a
follow up patch for this.

There is another issue with the IPVS patch that adds the conn_max
documentation (incorrect format), Julian Anastasov is ready to send a
follow up patch address it.

Let me know, thanks.

On Sun, Jun 07, 2026 at 11:49:39AM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> The following patchset contains Netfilter/IPVS updates for net-next,
> this contains updates to address sashiko reports in IPVS and Netfilter
> on possible pre-existing issues. This also includes a series to add
> refcount for ct helper and timeout to deal with a corner case scenario
> with unconfirmed conntracks flying to nfqueue.
> 
> 1) Add a conn_max sysctl to IPVS to limit the maximum number of
>    connections, from Julian Anastasov.
> 
> 2) Use get_unaligned_be16() to access TCP MSS in nfnetlink_osf,
>    from Fernando Fernandez Mancera.
> 
> 3) Use {READ,WRITE}_ONCE to access helper flags from nfnetlink_helper.
> 
> Several patches for the synproxy infrastructure, from Fernando
> Fernandez Mancera:
> 
> 4) Drop packet if TCP timestamp adjustment fails.
> 
> 5) Continue parsing of TCP timestamp to deal with possible duplicates.
> 
> 6) Use {get,put}_unaligned_be32() to acess the TCP timestamp.
> 
> 7) Hold ct->lock to initialize nf_ct_seqadj_init().
> 
> Updates for the ct timeout infrastructure, to deal with a corner case
> for unconfirmed conntracks flying to nfqueue:
> 
> 8) Add a refcount to track ct timeout policy use by ct extension,
>    release the timeout until the last ct extension drops the refcnt
>    on it.
> 
> Similar update for the ct helper infrastructure:
> 
> 9) Dynamic allocation of ct helpers, as a preparation for adding
>    refcount to track ct extension use.
> 
> 10) Move destroy_sibling_or_exp() to nf_conntrack_proto_gre, so
>     pptp conntrack helper module removal does not make this code
>     unreachable via the helper->destroy callback. This is another
>     dependency for the new refcount coming in this series.
> 
> 11) Add a refcount to track use of it from the ct extension, then
>     ct helper and timeout is reachable to the connection until
>     it goes away.
> 
> 12) Remove the genid infrastructure in ct extensions. The primary
>     goal was to detect that a ct extension such as ct timeout and
>     ct helper went stale for unconfirmed conntrack, either because
>     object or module was removed. This deactivates all ct extensions
>     though for this unconfirmed conntrack.
> 
> 13) Call nf_ct_gre_keymap_destroy() if this is a master conntrack
>     with a pptp helper only.
> 
> sashiko.dev reports one more relevant issue when unsetting the helper
> via ctnetlink that I will address in a follow up patch.
> 
> Then, two more assorted updates:
> 
> 14) Avoid a unlikely underflow in bridge VLAN untag, only possible
>     if buggy bridge VLAN filtering is buggy, remove WARN_ON_ONCE
>     while at it. From David Carlier.
> 
> 15) Use get_unaligned_be32() in nf_conntrack_tcp to access sack
>     extension, from Rosen Penev.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-06-07
> 
> Thanks.
> 
> ----------------------------------------------------------------
> 
> The following changes since commit bfa3d89cc15c09f7d1581c834a5ed725189ec19f:
> 
>   Merge tag 'batadv-next-pullrequest-20260603' of https://git.open-mesh.org/batadv (2026-06-04 19:14:35 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-26-06-07
> 
> for you to fetch changes up to d3bf9eae486490832bd08fd62ab0ac601f346bd4:
> 
>   netfilter: nf_conntrack: use get_unaligned_be32() in tcp_sack() (2026-06-07 11:13:47 +0200)
> 
> ----------------------------------------------------------------
> netfilter pull request 26-06-07
> 
> ----------------------------------------------------------------
> David Carlier (1):
>       netfilter: flowtable: avoid num_encaps underflow on bridge VLAN untag
> 
> Fernando Fernandez Mancera (5):
>       netfilter: nfnetlink_osf: fix mss parsing on big-endian architectures
>       netfilter: synproxy: drop packets if timestamp adjustment fails
>       netfilter: synproxy: adjust duplicate timestamp options
>       netfilter: synproxy: fix unaligned memory access in timestamp adjustment
>       netfilter: synproxy: protect nf_ct_seqadj_init() with conntrack lock
> 
> Julian Anastasov (1):
>       ipvs: add conn_max sysctl to limit connections
> 
> Pablo Neira Ayuso (7):
>       netfilter: nfnetlink_cthelper: use {READ,WRITE}_ONCE for accessing helper flags
>       netfilter: cttimeout: detach dataplane timeout policy and repurpose refcount
>       netfilter: nf_conntrack_helper: dynamically allocate struct nf_conntrack_helper
>       netfilter: nf_conntrack_pptp: move GRE specific cleanup to GRE tracker
>       netfilter: nf_conntrack_helper: add refcounting from datapath
>       netfilter: conntrack: revert ct extension genid infrastructure
>       netfilter: conntrack: call nf_ct_gre_keymap_destroy() if master helper is pptp
> 
> Rosen Penev (1):
>       netfilter: nf_conntrack: use get_unaligned_be32() in tcp_sack()
> 
>  Documentation/networking/ipvs-sysctl.rst       |  35 +++++++
>  include/net/ip_vs.h                            |  22 +++++
>  include/net/netfilter/ipv4/nf_conntrack_ipv4.h |   4 +
>  include/net/netfilter/nf_conntrack_extend.h    |  12 ---
>  include/net/netfilter/nf_conntrack_helper.h    |  42 ++++++---
>  include/net/netfilter/nf_conntrack_timeout.h   |  27 +++++-
>  net/ipv4/netfilter/nf_nat_snmp_basic_main.c    |  27 +++---
>  net/netfilter/ipvs/ip_vs_conn.c                |  10 +-
>  net/netfilter/ipvs/ip_vs_ctl.c                 |  53 +++++++++++
>  net/netfilter/nf_conntrack_amanda.c            |  39 +++-----
>  net/netfilter/nf_conntrack_core.c              |  92 +++++-------------
>  net/netfilter/nf_conntrack_extend.c            |  32 +------
>  net/netfilter/nf_conntrack_ftp.c               |   5 +-
>  net/netfilter/nf_conntrack_h323_main.c         | 107 +++++++++------------
>  net/netfilter/nf_conntrack_helper.c            | 125 +++++++++++++++++--------
>  net/netfilter/nf_conntrack_irc.c               |   5 +-
>  net/netfilter/nf_conntrack_netbios_ns.c        |  20 ++--
>  net/netfilter/nf_conntrack_netlink.c           |  28 ++++--
>  net/netfilter/nf_conntrack_ovs.c               |   9 +-
>  net/netfilter/nf_conntrack_pptp.c              |  83 +++-------------
>  net/netfilter/nf_conntrack_proto.c             |  15 ++-
>  net/netfilter/nf_conntrack_proto_gre.c         |  61 ++++++++++++
>  net/netfilter/nf_conntrack_proto_tcp.c         |  10 +-
>  net/netfilter/nf_conntrack_sane.c              |   5 +-
>  net/netfilter/nf_conntrack_seqadj.c            |   2 +
>  net/netfilter/nf_conntrack_sip.c               |   5 +-
>  net/netfilter/nf_conntrack_snmp.c              |  21 ++---
>  net/netfilter/nf_conntrack_tftp.c              |   5 +-
>  net/netfilter/nf_conntrack_timeout.c           |  27 +++++-
>  net/netfilter/nf_flow_table_path.c             |   3 +-
>  net/netfilter/nf_synproxy_core.c               |  40 ++++----
>  net/netfilter/nfnetlink_cthelper.c             |  79 ++++++++--------
>  net/netfilter/nfnetlink_cttimeout.c            | 112 ++++++++++------------
>  net/netfilter/nfnetlink_osf.c                  |   6 +-
>  net/netfilter/nft_ct.c                         |  10 +-
>  net/netfilter/xt_CT.c                          |   3 -
>  36 files changed, 653 insertions(+), 528 deletions(-)
> 
