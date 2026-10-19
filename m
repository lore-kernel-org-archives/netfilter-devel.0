Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209AE45D911;
	Mon, 19 Oct 2026 04:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792385685; cv=none; b=gB2bUD75D6JCBEPmetqlnCEpDputW2Bvi5wPs12h69hb2iVzM7pgLEmGy5HKGF2Up/El7G1Mm6x69Gb5AuwTuRLCV+c0VSseeAAtyfbCTIM915bP/ZVB3/RPIiFUI2XPtMEDYY633gLyDb9m7n5QNWZGxY+kOsDJQrxlaEfM8yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792385685; c=relaxed/simple;
	bh=a4SL+doK9OH0FJaQ8HKI/dRfCbbnpJE78Vze5I7cMX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n6sH50c+caNQE3I4ng24sJFQTiKjTIW+AEJHzuk/0KZDJZTjyrY4WI/aFTavu7i85g3O6YDqDQoU6glnjlgQtYSWLg9Z8gv0dAxCoA+Mvqrb/twwtMDEwAO9OEKAwjfRD/TiiZ+6+2z0Rh8EvVrKwBWJ+dlYl0TIKw4RY/wndho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7561C60272; Mon, 19 Oct 2026 06:54:38 +0200 (CEST)
Date: Mon, 19 Oct 2026 06:54:38 +0200
From: Florian Westphal <fw@strlen.de>
To: Antonio Ojea <aojea@google.com>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@kernel.org, horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net-next 05/15] selftests: netfilter: nft_queue: check
 the scope of the hook drop flush
Message-ID: <atWijsi4OkrSCR-M@strlen.de>
References: <20261018005638.1776148-6-pablo@netfilter.org>
 <179237288374.3135.9473018103688224106@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <179237288374.3135.9473018103688224106@kernel.org>

netdev-bot+sashiko@kernel.org <netdev-bot+sashiko@kernel.org> wrote:
> - [Medium] The new test's failure does not reach the script's exit
>   status.
> - [Low] The 'keep' case cannot tell the two halves of nf_hook_cmp()
>   apart.
> - [Low] In hook_drop_case() the exit status of the command under test,
>   `ip netns exec "$ns1" nft "$@"` (line 932), is never checked, and the…
> - [Low] hook_drop_case() ignores the return value of `busywait
>   "$BUSYWAIT_TIMEOUT" hook_drop_all_queued "$packets"` (line 930).

I'll do a full quote here, despite not really responding: Antonio, if
you have to send a v2 for the nfnetlink_drop change, then please
consider sending a v2 for this one too. Otherwise I'm not sure its worth
following up with this one.

> selftests: netfilter: nft_queue: check the scope of the hook drop flush
> 
> This adds test_hook_drop_scope to nft_queue.sh. The test queues 20 UDP
> packets to the nf_queue helper, which holds the verdicts, and deletes a
> base chain while the packets wait. It then checks whether the packets
> were kept or dropped. It also adds a -H option to nf_queue that holds
> verdicts until SIGUSR1 is received.
> 
> > diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
> > index c8d1f2eb41339..a07652813a4b0 100755
> > --- a/tools/testing/selftests/net/netfilter/nft_queue.sh
> > +++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
> 
> [ ... ]
> 
> > +hook_drop_case()
> > +{
> 
> [ ... ]
> 
> > +	ip netns exec "$ns1" bash -c \
> > +		"for i in \$(seq $packets); do echo x > /dev/udp/127.0.0.1/12345; done"
> > +
> > +	busywait "$BUSYWAIT_TIMEOUT" hook_drop_all_queued "$packets"
> 
> [Severity: Low]
> What happens if this busywait times out? On timeout, loopy_wait() in
> lib.sh just returns 1. It does not abort the caller:
> 
> tools/testing/selftests/net/lib.sh:loopy_wait() {
>     ...
> 		if ((current_time - start_time > timeout_ms)); then
> 			echo -n "$out"
> 			return 1
> 		fi
>     ...
> }
> 
> The return value is ignored here. So the test still deletes the chain
> and classifies the result when fewer than 20 packets were queued, for
> example when some of the sends were lost before they reached the queue.
> 
> The drop classification further down only checks for zero:
> 
> 	elif [ "$queued" = "0" ] && [ "$delivered" = "0" ]; then
> 		result="drop"
> 
> Could the drop case then report PASS with only part of the batch queued,
> or with nothing queued at all? In the keep case the same situation
> would be reported as inconsistent.
> 
> > +
> > +	ip netns exec "$ns1" nft "$@"
> > +	queued=$(hook_drop_queued)
> 
> [Severity: Low]
> Should the exit status of this nft command be checked?
> 
> Suppose the deletion fails, or test_hook_drop_scope() passes the wrong
> arguments. Then no hook is unregistered and the 20 packets stay queued.
> SIGUSR1 releases them, the input counter reaches 20 and nf_queue prints
> "20 packets total". The keep case would report PASS even though no
> chain was deleted.
> 
> Other deletions in this file do check the result, for example in
> test_udp_gro_ct():
> 
> 	if ! ip netns exec "$nsrouter" nft delete table inet udpq; then
> 		echo "FAIL: Could not delete udpq table"
> 		ret=1
> 
> [ ... ]
> 
> > +test_hook_drop_scope()
> > +{
> > +	# the hook array of another hook point changes, queued packets stay
> > +	hook_drop_case keep "base chain removed at another hook point" \
> > +		delete chain ip6 unrelated prerouting
> 
> [Severity: Low]
> Does this keep case test the hook number check and the family check in
> nf_hook_cmp() separately? The queued packets are IPv4 (sent to
> 127.0.0.1) at NF_INET_LOCAL_OUT. The deleted chain differs from them in
> both family (ip6) and hook (prerouting):
> 
> net/netfilter/nfnetlink_queue.c:nf_hook_cmp() {
>     ...
> 	if (entry->state.hook != hooknum)
> 		return 0;
> 
> 	if (pf == NFPROTO_INET)
> 		return entry->state.pf == NFPROTO_IPV4 ||
> 		       entry->state.pf == NFPROTO_IPV6;
> 
> 	return entry->state.pf == pf;
> }
> 
> If nf_hook_cmp() compared only the hook number, or only the family, it
> would still keep the entries and this case would pass. The drop case
> matches on both fields, so it doesn't isolate either check.
> 
> Would it make sense to add a chain at the same hook in another family
> (for example ip6 output)? A chain at another hook in the same family
> (for example ip prerouting) would cover the other check.
> 
> The testing notes of the previous patch, "netfilter: nf_queue: limit the
> hook drop flush to the unregistered hook point", say that deleting an
> ip6 table with an output base chain does not drop the packets. That
> case isn't encoded in this test.
> 
> [ ... ]
> 
> > @@ -909,6 +1016,7 @@ test_queue_stress
> >  # should be last, adds vrf device in ns1 and changes routes
> >  test_icmp_vrf
> >  test_queue_removal
> > +test_hook_drop_scope
> >  
> >  # turns router into a bridge
> >  test_queue_bridge
> 
> [Severity: Medium]
> Does a failure in test_hook_drop_scope() reach the exit status of the
> script? hook_drop_case() records a failure only by setting the global
> ret=1.
> 
> test_queue_bridge runs afterwards and calls test_queue() twice.
> test_queue() does this:
> 
> tools/testing/selftests/net/netfilter/nft_queue.sh:test_queue() {
>     ...
> 	wait
> 	ret=$?
>     ...
> }
> 
> A bare wait returns 0, so ret is reset to 0 whenever the bridge tests
> pass. The script then reports success with exit $ret.
> 
> The FAIL line still goes to stderr, but kselftest runners decide pass
> or fail from the exit code. The same reset already affects the earlier
> tests in this sequence.
> 
> -- 
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261018005638.1776148-2-pablo%40netfilter.org
> 
