Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569BC346A08;
	Wed,  5 Aug 2026 07:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785916497; cv=none; b=cpRNsapdRN15/CzMA0LUhifJvtQN5HywczD89JoCy7705Qt+6uZvWoQADLCEV2BpiD8DhmJFfT3OAToxOpYCb1b4EcG8Mq+2i09QbdkwbriPg9HkTPgT0ir+jfTO4bwrj+KAjpgd9irQE+D+woJoUenqI+NQTaPv3MnS6vTsoHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785916497; c=relaxed/simple;
	bh=ztqjl2VKqqZcC14N6ZqMSQKSZq3tND6243n8qDNTEyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K73YEwZ7Wp955pq7ONRAs1uVB41ccw9lSz8hBHAHq5gmjYtIBU46GQ9Q4DSf8mMCRHf5y1dwBmU02v/7+DRRYu2o1iupIOgI9ieZAUbDQv1XgyX57pbAJgsfC5xIElzFc5t6ylCq4GNh9YtD9RnJstXNAabrHSM+WRJZoAFQcw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=i8/TpTPi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="i8/TpTPi"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id CA7A760191;
	Wed,  5 Aug 2026 09:54:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785916490;
	bh=Er2zS5UkHfHOubMZBQiKBoNpLnX86mYzJTCX2onIuk0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i8/TpTPi0DuJi7SbeUWwcRBwyVxpYE9XAvqXX1FKozsFHgbLNmPdQYxkykhvgkXED
	 +5y9py1H1PiYZk1NFEg4xGoew+4IgA91WgG/wgY5YFLSsbws8GM9kaAzt7PyOncHCc
	 VzENF4abrARRb+aRCIzTGQ398mmWvUk0huX3VQ3aqQlubhfdtHPdW9gIN3h2ZO/Gm3
	 EicA4Pc+URPhVQQDnfBqN/6HMXecJ/UofiGiVtlnfmn2cJHRPJuO6EVCc6QN3IhcIE
	 xXTDv0zFrfWZrd/GYJU2J0vbUDh2WCZKvO627dE0N4ODjojdJSL+Cfvngk4dEO1lU/
	 6oLOus/YlZ/6A==
Date: Wed, 5 Aug 2026 09:54:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH net-next 9/9] netfilter: conntrack: tcp: use UNACK
 timeout for non-closing RST packets
Message-ID: <anLsR4y_VcrFFYL2@chamomile>
References: <20260731153402.851224-10-pablo@netfilter.org>
 <20260805001908.3985938-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260805001908.3985938-1-kuba@kernel.org>

On Tue, Aug 04, 2026 at 05:19:07PM -0700, Jakub Kicinski wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> netfilter: conntrack: tcp: use UNACK timeout for non-closing RST packets
> 
> This changes the timeout selection in nf_conntrack_tcp_packet() so that an
> RST which leaves the entry in TCP_CONNTRACK_ESTABLISHED (the non-exact
> sequence case from be0502a3f2e9) gets timeouts[TCP_CONNTRACK_UNACK] instead
> of timeouts[TCP_CONNTRACK_CLOSE].  RSTs that conntrack accepts as closing
> the flow are meant to keep using timeouts[new_state].
> 
> A few questions below.
> 
> >     Use the UNACK timeout for RST packets that leave the conntrack entry in
> >     TCP_CONNTRACK_ESTABLISHED.  Exact-match RSTs and accepted RST packet
> >     trains still fall through to timeouts[new_state], which preserves the
> >     CLOSE timeout when conntrack accepts the RST as closing the flow.
> 
> [Severity: Low]
> Should this carry a Fixes: tag?
 
No, and it is intentional.

We do not want updates on the conntrack state machine to automatically
end up in -stable.

Do we have to write this in the cover letter from this time on?

> [...] The changelog describes a user-visible
> failure (an ESTABLISHED entry expiring after 10 seconds while both TCP
> endpoints stay established), and it names be0502a3f2e9 in prose only, so
> stable tooling has nothing machine-readable to key on.
>
> There is also a wording tension: be0502a3f2e9's own changelog presented the
> CLOSE timeout for non-exact RSTs as intentional ("With patch, timeout is
> lowered like CLOSE, but connection stays in ESTABLISHED state" / "If no
> challenge ACK is received, the connection will time out after CLOSE
> seconds").  Either adding
> 
>     Fixes: be0502a3f2e94211 ("netfilter: conntrack: tcp: only close if RST matches exact sequence")
> 
> or rewording this as a deliberate policy refinement rather than a bug fix
> would make the two consistent.
> 
> [Severity: Low]
> Is there a test that observes this change?

No, it is just a timeout update in conntrack, there is nothing the
packetdrill test can do about this.

> The only in-tree artifact covering the inexact in-window RST path,
> tools/testing/selftests/net/netfilter/packetdrill/conntrack_rst_invalid.pkt,
> checks only the state string:
> 
>     // in-window but not exact match
>     +0.0 < R	42:42(0)	win 0
>     +0 `conntrack -f $NFCT_IP_VERSION -L -p tcp --dport 8080 2>/dev/null |grep -q ESTABLISHED`
> 
> The timeout is now the sole observable difference for that scenario, and it
> is never inspected.
> 
> On top of that, the segment labelled "in-window but not exact match" has seq
> before seen[!dir].td_maxack (the peer had acked 3001), so
> nf_conntrack_tcp_packet() rejects it at the "invalid rst" check and never
> reaches the patched timeout selection.  The test's own counter assertion
> agrees:
> 
>     // Expect four invalid RSTs
>     +0 `$xtables -v -S INPUT  | grep INVALID | grep -q -- "-c 4 "`
> 
> So the suite passes identically with and without this change.

Yes, that is expected.

> > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> > index ceeed3d7fe520..723e946a78f40 100644
> > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > @@ -1281,8 +1281,9 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
> >  	if (ct->proto.tcp.retrans >= tn->tcp_max_retrans &&
> >  	    timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
> >  		timeout = timeouts[TCP_CONNTRACK_RETRANS];
> > -	else if (unlikely(index == TCP_RST_SET))
> > -		timeout = timeouts[TCP_CONNTRACK_CLOSE];
> > +	else if (unlikely(index == TCP_RST_SET &&
> > +			  new_state == TCP_CONNTRACK_ESTABLISHED))
> > +		timeout = timeouts[TCP_CONNTRACK_UNACK];
> 
> [Severity: Medium]
> Can this new branch lengthen an entry's lifetime rather than shorten it?

Yes, it is indeed extending the timeout rather intentionally.

> Every sibling branch in this chain only assigns when the replacement is
> smaller, for example the RETRANS branch just above and the UNACK branch just
> below:
> 
>     if (ct->proto.tcp.retrans >= tn->tcp_max_retrans &&
>         timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
>         timeout = timeouts[TCP_CONNTRACK_RETRANS];
>     ...
>     else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
>          IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&
>          timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
>         timeout = timeouts[TCP_CONNTRACK_UNACK];
> 
> The new branch has no such guard.  Since this branch is only reachable via
> "new_state = old_state;" in case TCP_CONNTRACK_CLOSE, new_state is
> ESTABLISHED here, so the effective comparison is timeouts[UNACK] against
> timeouts[ESTABLISHED].
> 
> With the defaults in tcp_timeouts (ESTABLISHED 5 DAYS, UNACK 5 MINS) this is
> always a lowering.

Yes, and it is intentional, this is lowering the timeout indeed.

Actually, it is lowering it in a less "aggressive" way, instead of
using CLOSE timeout it uses the UNACK timeout (5 MINS) to avoid

> But both values are independently tunable with no cross-validation:
> 
>     net/netfilter/nf_conntrack_standalone.c:
>     [NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_ESTABLISHED] = {
>         .procname	= "nf_conntrack_tcp_timeout_established",
>         .maxlen		= sizeof(unsigned int),
>         .mode		= 0644,
>         .proc_handler	= proc_dointvec_jiffies,
>     },
> 
> and tcp_timeout_nlattr_to_obj() copies CTA_TIMEOUT_TCP_* verbatim.  So an
> administrator lowering nf_conntrack_tcp_timeout_established (120 s is a
> common hardening/NAT-appliance setting) inverts the relation.
> 
> __nf_ct_refresh_acct() then writes the expiry absolutely rather than
> clamping it:
> 
>     net/netfilter/nf_conntrack_core.c:__nf_ct_refresh_acct() {
>         ...
>         if (nf_ct_is_confirmed(ct))
>             extra_jiffies += nfct_time_stamp;
> 
>         if (READ_ONCE(ct->timeout) != extra_jiffies)
>             WRITE_ONCE(ct->timeout, extra_jiffies);
>         ...
>     }
> 
> In that configuration, an in-window RST whose sequence does not match
> td_maxack pushes the entry past the configured ESTABLISHED policy, and a
> periodic stream of such RSTs can renew it indefinitely, holding entries
> against nf_conntrack_max.  Would the usual form keep the intent while
> avoiding this?
> 
>     timeout = min(timeouts[new_state], timeouts[TCP_CONNTRACK_UNACK]);
> 
> or the matching guard:
> 
>     else if (unlikely(index == TCP_RST_SET &&
>                       new_state == TCP_CONNTRACK_ESTABLISHED) &&
>              timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
> 
> >  	else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
> >  		 IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&
> >  		 timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
> 
> [Severity: Low]
> For an RST that conntrack does accept as closing the flow, is the CLOSE
> timeout really preserved?

No, and it is intentional. We are changing to the UNACK timeout which
is less aggresive.

> Previously such packets took the unconditional
> timeouts[TCP_CONNTRACK_CLOSE] assignment; now they fall through into the
> DATA_UNACKNOWLEDGED and last_win == 0 branches:
> 
>     else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
>          IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&
>          timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
>         timeout = timeouts[TCP_CONNTRACK_UNACK];
>     else if (ct->proto.tcp.last_win == 0 &&
>          timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
>         timeout = timeouts[TCP_CONNTRACK_RETRANS];
> 
> Those fire precisely when nf_conntrack_tcp_timeout_close is raised above
> nf_conntrack_tcp_timeout_unacknowledged or the retrans timeout, and both
> preconditions are reachable for a closing RST: IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED
> is commonly set on a flow that carried data, and ct->proto.tcp.last_win is
> sticky since it is only refreshed for ACK-only segments.
> 
> This also diverges from the other closing path in the same file, which does
> not cap:
> 
>     nf_conntrack_tcp_set_closing() {
>         ...
>         timeout = timeouts[TCP_CONNTRACK_CLOSE];
>         WRITE_ONCE(ct->timeout, timeout + nfct_time_stamp);
>         ...
>     }
> 
> Given that, is the changelog sentence "Exact-match RSTs and accepted RST
> packet trains still fall through to timeouts[new_state], which preserves the
> CLOSE timeout when conntrack accepts the RST as closing the flow" accurate
> for non-default close timeouts?  Restoring an explicit CLOSE assignment for
> new_state == TCP_CONNTRACK_CLOSE, or adjusting the wording, would resolve
> it.

Not sure what wording adjustment need to be done here.
