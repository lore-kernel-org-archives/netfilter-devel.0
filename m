Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795382251;
	b=VgSjj+0bbtMOY4pX6p7OgsmMDrOXS7DZwOVRHzJQluJI1RIkg7+jqnEdlDcQ0gUV5MVX
	 MoBo2T8rqyeeVf0y1sWgJmN1nERRR80efTkIU77PPgpRiD4a8QEmF29CnB51yoZuqLYnC
	 3ZrUWr1OukMYQ6RJAIKU5/yWVVwuq3EiswpurFVwplY3y8gtj5USJW409LvvGNLjoQCsT
	 6oa8bdky00sWRo31pd05QbrhbOdvBfzh3DKa2HRHPUIaIsvJ7WdiTJirS2pMAEeg/fIbh
	 uup8xDoeOg9ev7crvcQV1XHpcD7PD2CTyFEodupz1C7Qj7MFfATwr7UWmZ2/DggAtxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795382251;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=dF78nh4kCBdhP6WNS4FBpyXwSTV7Ima7F2JADUKPcnU=;
	b=0ma8OwHTXqZhUsbldCL27dg2PQn+mkJZwXpmD0rHYXuMXJfCZISUFSbwQphuxba2UgQe
	 4GHWK2quUeUw6c5Jwe/8kYP374crmoMIYvcnxYaGx+x74mGvAcQdmhmrIuLC4ebAkRD0Z
	 7gM9QOAIbNsizvVQCh0r1thT19s6mb9/hMGPjqHy/IfEuF+yepDRyHhMqbZ47QU5w9Wtn
	 TfQ3UkUcKlZ+oBbsfGKdlwgmnZRD36cRslQ/Z5CeZEDBEC3QL1AnwFWf2773HDkK1EOOu
	 gfoTzqFBd2IGb6cb2Q0+OsUR4iOXd9WsjWe2GsZG45cHGLJaEI8CAkFCfGjnTi043EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U6lSbeRK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E44D606A332;
	Sun, 22 Nov 2026 21:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U6lSbeRK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C7C1F000D0;
	Sun, 22 Nov 2026 21:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795382250;
	bh=dF78nh4kCBdhP6WNS4FBpyXwSTV7Ima7F2JADUKPcnU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=U6lSbeRKGEbCNsg5IIuTjloDnVBqIhQRbAZoiPzEk+/tJN1vm8yTST6GVhjdGJzPG
	 iZ+6eVvALd1zGjTUYB3ZdERVNWpxFNnms/XXkLZACJnw8Kmc2trgaUTJpCxaxvQfs9
	 350sgGwklJmB6O4mANrJp0kfUbOqIP0fj61iTtfjpJ88Fyr04TIXaIuj3nOxBgImqE
	 dlPhdOc8MBhCa7jZAQu8v0hK48Q6D6JCws92qxAq6FlM4Fdkf6GRt8mqBxv9BAWG0d
	 ZvbOxn81DTwCaukJ/HP3qV80rY34zE++zhkWOCpwDswBPiVfVnikJCOXHtOEakzjtR
	 FPGdACkIpU9PA==
Subject: Re: [PATCH net 4/4] selftests: netfilter: check the GRE timeout after
 flowtable teardown
From: netdev-bot+sashiko@kernel.org
To: florian.fainelli@broadcom.com
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, shuah@kernel.org, toshiaki.makita1@gmail.com,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, linux-kselftest@vger.kernel.org
Date: Sun, 22 Nov 2026 21:17:29 +0000
Message-ID: <179538224965.3135.5112190126089308317@kernel.org>
In-Reply-To: <20261118201250.2075007-5-florian.fainelli@broadcom.com>
References: <20261118201250.2075007-5-florian.fainelli@broadcom.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In nft_flowtable_gre.sh the test treats `nft delete table inet
  filter` as tearing down the offloaded GRE flow before the command…
- [Low] The timeout check in nft_flowtable_gre.sh (lines 127-135) fails
  only when the restored timeout is greater than…

--

selftests: netfilter: check the GRE timeout after flowtable teardown

This adds a selftest that offloads a GRE flow through a flowtable in a
router namespace and then deletes the flowtable. It checks that the
conntrack entry timeout goes back to the GRE stream timeout instead of
the one-day offload timeout. The GRE and PPTP options are also added to
the selftest config.

> diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable_gre.sh b/tools/testing/selftests/net/netfilter/nft_flowtable_gre.sh
> new file mode 100755
> index 0000000000000..5efad6908b3fc
> --- /dev/null
> +++ b/tools/testing/selftests/net/netfilter/nft_flowtable_gre.sh
> @@ -0,0 +1,137 @@

[ ... ]

> +# The entry has the timeout of an offloaded flow: remove the flowtable, which
> +# tears down its flows. Nothing else refreshes the conntrack entry.
> +if ! ip netns exec "$nsr1" nft delete table inet filter; then
> +	echo "FAIL: could not remove the flowtable"
> +	exit 1
> +fi
> +
> +if gre_entry_offloaded; then
> +	echo "FAIL: the GRE entry is still marked as offloaded"
> +	ret=1
> +fi
> +
> +timeout=$(gre_entry_timeout)

[Severity: Medium]
Is the flowtable teardown guaranteed to be finished by the time nft delete
table returns?

In net/netfilter/nf_tables_api.c, flowtable destruction seems to be
deferred to a workqueue:

nf_tables_commit_release()
    schedule_work(&nft_net->destroy_work);

The work item also waits for an RCU grace period before it frees the
flowtable:

nf_tables_trans_destroy_work()
    synchronize_rcu();
    nft_commit_release()
        nf_tables_flowtable_destroy()
            nf_flow_table_free()
                ... flow_offload_teardown()

IPS_OFFLOAD_BIT is cleared and the GRE timeout restored only in
flow_offload_teardown():

net/netfilter/nf_flow_table_core.c:flow_offload_teardown() {
	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
	if (!test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
		flow_offload_fixup_ct(flow);
}

If conntrack -L runs before the deferred work completes,
gre_entry_offloaded() would still see OFFLOAD and print "still marked as
offloaded".

gre_entry_timeout() would also return nothing. While the entry is
offloaded, ctnetlink_dump_info() in nf_conntrack_netlink.c does not dump
the timeout:

	if (!test_bit(IPS_OFFLOAD_BIT, &ct->status) &&
	    (ctnetlink_dump_timeout(skb, ct, false) < 0 ||

In that case the test also prints the misleading "no conntrack entry for
the GRE flow" message, even though the entry exists.

Can this make the test fail at random on a fixed kernel? That seems most
likely on loaded or virtualized CI, where synchronize_rcu() can be slow.
Would polling with busywait or slowwait from lib.sh, until OFFLOAD clears
and a timeout is printed, avoid the race?

The comment above ("remove the flowtable, which tears down its flows") and
the commit message both describe the teardown as synchronous.

> +max=$(ip netns exec "$nsr1" sysctl -n net.netfilter.nf_conntrack_gre_timeout_stream 2>/dev/null)
> +[ -z "$max" ] && max=180
> +
> +if [ -z "$timeout" ]; then
> +	echo "FAIL: no conntrack entry for the GRE flow"
> +	ret=1
> +elif [ "$timeout" -gt "$max" ]; then

[Severity: Low]
This isn't a bug, but only an upper bound is checked here, so any timeout
from 0 to 180 is reported as PASS. The check does catch the 86399 regression
the commit targets.

The "ct state established" rule requires IPS_SEEN_REPLY, and the flow has
not expired. So flow_offload_fixup_ct() should pick
tn->timeouts[GRE_CT_REPLIED] without subtracting NF_FLOW_TIMEOUT, giving
about 179-180 seconds.

The following broken fixups would all still pass this check:

- one that picks GRE_CT_UNREPLIED (30s)
- one that wrongly subtracts NF_FLOW_TIMEOUT (about 150s)
- one that clamps the timeout to 0

Would a lower bound, such as max minus a small slack, better match the
"restored to the GRE timeout" behaviour described in the header comment?

> +	echo "FAIL: the GRE entry timeout is $timeout seconds after teardown, expected at most $max"
> +	ret=1
> +else
> +	echo "PASS: the GRE entry timeout was restored to $timeout seconds"
> +fi

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261118201250.2075007-1-florian.fainelli%40broadcom.com
