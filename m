Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4111822DF9E
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Oct 2025 12:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760100426; cv=none; b=GiFp6WCcI7lkKShl4fkgCgPRP57pCK5MXkXM+jLqGRMfPaMTfO/lqfSaCBgfhSbi+WvR4rhZyDSnYeIVQ8aSD4kT34ZHn1YVWTfRhmqoCoBjTE5icwFaFINwUst+COFtIGgG8rxSaTyq2XcgE5E6fajm0V4EhNR6yEFn39a7cPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760100426; c=relaxed/simple;
	bh=qkK8I1YguBnVQS/8CTTVCeBe9tV+wQUrB+MQpCwNN/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YYetdZ39RKp8Sxer+hLd8Zj3bedjbnqA7PGjtfl8dg9kN9mnLyp5SKUI3FkYmxpM5t9hFHp/eS8ie7Caxw67l86RJHnekzj1JothiF0lu3VNV/7nyKmMYr82t1HOFw+t8uL+5yRB7vfIQriEdK72cgQYYHWecXwLqMyS7XSupkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4AC1C61830; Fri, 10 Oct 2025 14:46:56 +0200 (CEST)
Date: Fri, 10 Oct 2025 14:46:56 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nft] tests: shell: add packetpath test for meta ibrhwdr
Message-ID: <aOkAQFrmZzKs_2X2@strlen.de>
References: <20251009162439.4232-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251009162439.4232-1-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> The test checks that the packets are processed by the bridge device and
> not forwarded.

OK, I think it would make sense to also check that we can do something
useful with the packet.

> +
> +ip -net "$ns1" link set veth0 up
> +ip -net "$ns2" link set veth0 up
> +ip -net "$ns3" link set veth1 up
> +ip -net "$ns2" link set veth1 up
> +ip -net "$ns2" link set br0 up
> +
> +ip -net "$ns1" addr add 10.1.1.10/24 dev veth0
> +ip -net "$ns3" addr add 10.1.1.20/24 dev veth1
> +
> +ip netns exec "$ns2" $NFT -f /dev/stdin <<"EOF"
> +table bridge nat {
> +	chain PREROUTING {
> +		type filter hook prerouting priority 0; policy accept;
> +		ether daddr de:ad:00:00:be:ef meta pkttype set host ether daddr set meta ibrhwdr

While this indeed is enough to check the bridge 'redirect to input'
maybe it would make sense to also check that we can do something useful
with it?

The bridge has no ip address, so I don't really see the point why anyone
would redirect the packet locally to begin with.

> +table bridge donotprocess {
> +	chain FORWARD {
> +		type filter hook forward priority 0; policy accept;
> +		ip protocol icmp ether saddr da:d3:00:01:02:03 counter
> +	}
> +}
> +EOF
> +
> +ip netns exec "$ns1" ping -c 1 10.1.1.20 || true
> +
> +set +e
> +
> +ip netns exec "$ns2" $NFT list table bridge process | grep 'counter packets 0'
> +if [ $? -eq 0 ]
> +then
> +	exit 1

I think it would be nice to display WHERE its failing so that someone
looking at testout.log doesn't have to re-run with added "set -x" or "echo
failed at".

To give some ideas (this isn't fleshed out):

diff --git a/tests/shell/testcases/packetpath/bridge_pass_up b/tests/shell/testcases/packetpath/bridge_pass_up
--- a/tests/shell/testcases/packetpath/bridge_pass_up
+++ b/tests/shell/testcases/packetpath/bridge_pass_up
@@ -38,14 +38,18 @@ ip -net "$ns3" link set veth1 up
 ip -net "$ns2" link set veth1 up
 ip -net "$ns2" link set br0 up
 
+ip netns exec "$ns2" sysctl -q net.ipv4.ip_forward=1
+
 ip -net "$ns1" addr add 10.1.1.10/24 dev veth0
 ip -net "$ns3" addr add 10.1.1.20/24 dev veth1
+ip -net "$ns2" addr add 10.1.1.1/24 dev br0
 
 ip netns exec "$ns2" $NFT -f /dev/stdin <<"EOF"
 table bridge nat {
 	chain PREROUTING {
 		type filter hook prerouting priority 0; policy accept;
-		ether daddr de:ad:00:00:be:ef meta pkttype set host ether daddr set meta ibrhwdr
+		ether daddr de:ad:00:00:be:ef meta pkttype set host ether daddr set meta ibrhwdr meta mark set 1
 	}
 }
 
@@ -62,9 +66,19 @@ table bridge donotprocess {
 		ip protocol icmp ether saddr da:d3:00:01:02:03 counter
 	}
 }
+
+table ip process {
+	chain FORWARD {
+		type filter hook forward priority 0; policy accept;
+		ip protocol icmp mark 1 counter
+	}
+
+}
 EOF

ALTERNATIVELY one could check INPUT instead (no fwd sysctl)
by also doing 'ip daddr set 10.1.1.1' in bridge or ip prerouting
and then checking if the packet made it to the ip input hook.

I only ever saw 3 cases of this 'bridge hijacking' implemented
via meta ibrhwdr:

1. Push packets up to mangle them via NAT.  In most cases
people did this with br_netfilter + iptables, but it would be nice
to make sure we have a working alternative to that thing.

2. Push packet to local host/application, e.g. for TPROXY intercept.
3. Push packet to local host for forwarding/policy routing.

I think that 'it arrived in ip input or forwarding'
would be good because then the above (tproxy, nat, etc. should "just work").

But if you think checking bridge input is enough, thats fine.
