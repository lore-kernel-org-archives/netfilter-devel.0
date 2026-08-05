Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EC0360ECF;
	Wed,  5 Aug 2026 00:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785889150; cv=none; b=cRRsF7V66adHilVwekO4ifMikmqqppuyDiwJGadgtfx6VSxUM0pglNnVopvGuuZdLbEVxbk1clfjLNeqs80myacucJ9U6v9+6PKvGWq0k7X+B+FelH4zEwVDeGS3jxMdI8O1vHwHLJkm4zpRkV2w+4vvj6GKr9i1lEWd5T5kCJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785889150; c=relaxed/simple;
	bh=EOvmf++v2273tqKXMyBZXJDCxChTwbTgMGkiL6l16ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aj1Q+clCKsYsmt1b0TImpwovxeP8opcpF+Yt25bfeVLbAofH7aqPjPZ05qvfcIirWCVICsSM1D5IVpQ4Ap4LB74hFUtYNvM30b5hiRuwGMTxA0Cs9j33OQOnE3CTcRhtm68LtbK+GTlFcFbRODJ39HJas2uwvvVeqqyISpigFhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VkPSYTiV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VkPSYTiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05401F00A3A;
	Wed,  5 Aug 2026 00:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785889149;
	bh=2Rz3sso58TKbpy+4UEb41C1sF/WgqRYzR7UBDWjF9EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VkPSYTiVGVisBO34csTTbQUyiSEMsNN0eQ91gEc60I4nc+crUfxqTTdg58X7WpyOr
	 E89+mJmr7ganS5e87fEkuDPncASHXLCPQwJKI15A4xusRAwagYoLrUL7aHfuZoP38Z
	 FmzsHMOdV3GW4VNSaJrksvk4auaD03UkVUAI5io5mvh1dDMAVwlBYNW5MeoqEfoujW
	 u28tZ4dgTdlTHE2driNjsl4EHuuqiIMbOghAFyS1n3qq2EIU/dCciqF9CfJMY9l5rL
	 XrKPTK5At2RJXsyLH2jX88Xw6ijnsK/j6f+BVeJFdqMg7RH0vhqJsHxvikVYL8sdMG
	 D4rlfa1G8Wdsg==
From: Jakub Kicinski <kuba@kernel.org>
To: pablo@netfilter.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: Re: [PATCH net-next 9/9] netfilter: conntrack: tcp: use UNACK timeout for non-closing RST packets
Date: Tue,  4 Aug 2026 17:19:07 -0700
Message-ID: <20260805001908.3985938-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731153402.851224-10-pablo@netfilter.org>
References: <20260731153402.851224-10-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
netfilter: conntrack: tcp: use UNACK timeout for non-closing RST packets

This changes the timeout selection in nf_conntrack_tcp_packet() so that an
RST which leaves the entry in TCP_CONNTRACK_ESTABLISHED (the non-exact
sequence case from be0502a3f2e9) gets timeouts[TCP_CONNTRACK_UNACK] instead
of timeouts[TCP_CONNTRACK_CLOSE].  RSTs that conntrack accepts as closing
the flow are meant to keep using timeouts[new_state].

A few questions below.

>     Use the UNACK timeout for RST packets that leave the conntrack entry in
>     TCP_CONNTRACK_ESTABLISHED.  Exact-match RSTs and accepted RST packet
>     trains still fall through to timeouts[new_state], which preserves the
>     CLOSE timeout when conntrack accepts the RST as closing the flow.

[Severity: Low]
Should this carry a Fixes: tag?  The changelog describes a user-visible
failure (an ESTABLISHED entry expiring after 10 seconds while both TCP
endpoints stay established), and it names be0502a3f2e9 in prose only, so
stable tooling has nothing machine-readable to key on.

There is also a wording tension: be0502a3f2e9's own changelog presented the
CLOSE timeout for non-exact RSTs as intentional ("With patch, timeout is
lowered like CLOSE, but connection stays in ESTABLISHED state" / "If no
challenge ACK is received, the connection will time out after CLOSE
seconds").  Either adding

    Fixes: be0502a3f2e94211 ("netfilter: conntrack: tcp: only close if RST matches exact sequence")

or rewording this as a deliberate policy refinement rather than a bug fix
would make the two consistent.

[Severity: Low]
Is there a test that observes this change?  The only in-tree artifact
covering the inexact in-window RST path,
tools/testing/selftests/net/netfilter/packetdrill/conntrack_rst_invalid.pkt,
checks only the state string:

    // in-window but not exact match
    +0.0 < R	42:42(0)	win 0
    +0 `conntrack -f $NFCT_IP_VERSION -L -p tcp --dport 8080 2>/dev/null |grep -q ESTABLISHED`

The timeout is now the sole observable difference for that scenario, and it
is never inspected.

On top of that, the segment labelled "in-window but not exact match" has seq
before seen[!dir].td_maxack (the peer had acked 3001), so
nf_conntrack_tcp_packet() rejects it at the "invalid rst" check and never
reaches the patched timeout selection.  The test's own counter assertion
agrees:

    // Expect four invalid RSTs
    +0 `$xtables -v -S INPUT  | grep INVALID | grep -q -- "-c 4 "`

So the suite passes identically with and without this change.

> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index ceeed3d7fe520..723e946a78f40 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -1281,8 +1281,9 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
>  	if (ct->proto.tcp.retrans >= tn->tcp_max_retrans &&
>  	    timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
>  		timeout = timeouts[TCP_CONNTRACK_RETRANS];
> -	else if (unlikely(index == TCP_RST_SET))
> -		timeout = timeouts[TCP_CONNTRACK_CLOSE];
> +	else if (unlikely(index == TCP_RST_SET &&
> +			  new_state == TCP_CONNTRACK_ESTABLISHED))
> +		timeout = timeouts[TCP_CONNTRACK_UNACK];

[Severity: Medium]
Can this new branch lengthen an entry's lifetime rather than shorten it?
Every sibling branch in this chain only assigns when the replacement is
smaller, for example the RETRANS branch just above and the UNACK branch just
below:

    if (ct->proto.tcp.retrans >= tn->tcp_max_retrans &&
        timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
        timeout = timeouts[TCP_CONNTRACK_RETRANS];
    ...
    else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
         IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&
         timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
        timeout = timeouts[TCP_CONNTRACK_UNACK];

The new branch has no such guard.  Since this branch is only reachable via
"new_state = old_state;" in case TCP_CONNTRACK_CLOSE, new_state is
ESTABLISHED here, so the effective comparison is timeouts[UNACK] against
timeouts[ESTABLISHED].

With the defaults in tcp_timeouts (ESTABLISHED 5 DAYS, UNACK 5 MINS) this is
always a lowering.  But both values are independently tunable with no
cross-validation:

    net/netfilter/nf_conntrack_standalone.c:
    [NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_ESTABLISHED] = {
        .procname	= "nf_conntrack_tcp_timeout_established",
        .maxlen		= sizeof(unsigned int),
        .mode		= 0644,
        .proc_handler	= proc_dointvec_jiffies,
    },

and tcp_timeout_nlattr_to_obj() copies CTA_TIMEOUT_TCP_* verbatim.  So an
administrator lowering nf_conntrack_tcp_timeout_established (120 s is a
common hardening/NAT-appliance setting) inverts the relation.

__nf_ct_refresh_acct() then writes the expiry absolutely rather than
clamping it:

    net/netfilter/nf_conntrack_core.c:__nf_ct_refresh_acct() {
        ...
        if (nf_ct_is_confirmed(ct))
            extra_jiffies += nfct_time_stamp;

        if (READ_ONCE(ct->timeout) != extra_jiffies)
            WRITE_ONCE(ct->timeout, extra_jiffies);
        ...
    }

In that configuration, an in-window RST whose sequence does not match
td_maxack pushes the entry past the configured ESTABLISHED policy, and a
periodic stream of such RSTs can renew it indefinitely, holding entries
against nf_conntrack_max.  Would the usual form keep the intent while
avoiding this?

    timeout = min(timeouts[new_state], timeouts[TCP_CONNTRACK_UNACK]);

or the matching guard:

    else if (unlikely(index == TCP_RST_SET &&
                      new_state == TCP_CONNTRACK_ESTABLISHED) &&
             timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])

>  	else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
>  		 IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&
>  		 timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])

[Severity: Low]
For an RST that conntrack does accept as closing the flow, is the CLOSE
timeout really preserved?  Previously such packets took the unconditional
timeouts[TCP_CONNTRACK_CLOSE] assignment; now they fall through into the
DATA_UNACKNOWLEDGED and last_win == 0 branches:

    else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
         IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&
         timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
        timeout = timeouts[TCP_CONNTRACK_UNACK];
    else if (ct->proto.tcp.last_win == 0 &&
         timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
        timeout = timeouts[TCP_CONNTRACK_RETRANS];

Those fire precisely when nf_conntrack_tcp_timeout_close is raised above
nf_conntrack_tcp_timeout_unacknowledged or the retrans timeout, and both
preconditions are reachable for a closing RST: IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED
is commonly set on a flow that carried data, and ct->proto.tcp.last_win is
sticky since it is only refreshed for ACK-only segments.

This also diverges from the other closing path in the same file, which does
not cap:

    nf_conntrack_tcp_set_closing() {
        ...
        timeout = timeouts[TCP_CONNTRACK_CLOSE];
        WRITE_ONCE(ct->timeout, timeout + nfct_time_stamp);
        ...
    }

Given that, is the changelog sentence "Exact-match RSTs and accepted RST
packet trains still fall through to timeouts[new_state], which preserves the
CLOSE timeout when conntrack accepts the RST as closing the flow" accurate
for non-default close timeouts?  Restoring an explicit CLOSE assignment for
new_state == TCP_CONNTRACK_CLOSE, or adjusting the wording, would resolve
it.
