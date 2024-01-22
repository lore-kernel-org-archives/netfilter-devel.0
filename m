Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A64F60DE9
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jan 2024 18:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705946917; cv=none; b=RX4UoKzMXM306pUpwrR5SIjkPyXfGuwhtqBTRafpUBqvuACBEes1iopC52B4Q0CaU2NjQaz04Ymjhq4G63DuKIpunOZAdsGa6sUd9pDXmqbzozAf5ubWs4+gxKhHa25VxcgJc5E8SQOXwRsYcjXUKZXHKvBwOwdM6sBfvQ1Tfiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705946917; c=relaxed/simple;
	bh=YYTDWwEdRcFqDo1x3L3RM6iYrfjwPNPX/k6h0YApg+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fTUwu/5RpRPfP60HgByZPvcs4Ev5YZB5xtiQG+pOBLaHIoqOKkECGjTvcl3+MDndyLiXsss4f/BJgA+xiLKAkMZCjLgDZp0ayP1bBCEYkivSIx5co7lqAgMfLV3OZ19XueJpOvYcql0T9oilc09WDhNPz7mZc6J+tPec3GSrahM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=47076 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rRyid-003lPb-12; Mon, 22 Jan 2024 19:08:25 +0100
Date: Mon, 22 Jan 2024 19:08:22 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: yiche@redhat.com
Cc: netfilter-devel@vger.kernel.org, fw@netfilter.org
Subject: Re: [PATCH] tests: shell: add test to cover ct offload by using nft
 flowtables To cover kernel patch ("netfilter: nf_tables: set transport
 offset from mac header for netdev/egress").
Message-ID: <Za6vFpJZCHVw1LrV@calendula>
References: <20240122162640.6374-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240122162640.6374-1-yiche@redhat.com>
X-Spam-Score: 0.6 (/)
X-Spam-Report: SpamASsassin versoin 3.4.6 on ganesha.gnumonks.org summary:
 Content analysis details:   (0.6 points, 5.0 required)
 
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
 -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  1.0 HEADER_FROM_DIFFERENT_DOMAINS From and EnvelopeFrom 2nd level
                             mail domains are different
  2.5 SARE_RAND_2            No description available.

Hi,

This test reports:

I: [OK]         1/1 testcases/packetpath/flowtables

or did you see any issue on your end?

Thanks!

On Tue, Jan 23, 2024 at 12:26:40AM +0800, yiche@redhat.com wrote:
> From: Yi Chen <yiche@redhat.com>
> 
> Signed-off-by: Yi Chen <yiche@redhat.com>
> ---
>  tests/shell/testcases/packetpath/flowtables | 96 +++++++++++++++++++++
>  1 file changed, 96 insertions(+)
>  create mode 100755 tests/shell/testcases/packetpath/flowtables
> 
> diff --git a/tests/shell/testcases/packetpath/flowtables b/tests/shell/testcases/packetpath/flowtables
> new file mode 100755
> index 00000000..852a05c6
> --- /dev/null
> +++ b/tests/shell/testcases/packetpath/flowtables
> @@ -0,0 +1,96 @@
> +#! /bin/bash -x
> +
> +# NFT_TEST_SKIP(NFT_TEST_SKIP_slow)
> +
> +rnd=$(mktemp -u XXXXXXXX)
> +R="flowtable-router-$rnd"
> +C="flowtable-client-$rnd"
> +S="flowtbale-server-$rnd"
> +
> +cleanup()
> +{
> +	for i in $R $C $S;do
> +		kill $(ip netns pid $i) 2>/dev/null
> +		ip netns del $i
> +	done
> +}
> +
> +trap cleanup EXIT
> +
> +ip netns add $R
> +ip netns add $S
> +ip netns add $C
> +
> +ip link add s_r netns $S type veth peer name r_s netns $R
> +ip netns exec $S ip link set s_r up
> +ip netns exec $R ip link set r_s up
> +ip link add c_r netns $C type veth peer name r_c netns $R
> +ip netns exec $R ip link set r_c up
> +ip netns exec $C ip link set c_r up
> +
> +ip netns exec $S ip -6 addr add 2001:db8:ffff:22::1/64 dev s_r
> +ip netns exec $C ip -6 addr add 2001:db8:ffff:21::2/64 dev c_r
> +ip netns exec $R ip -6 addr add 2001:db8:ffff:22::fffe/64 dev r_s
> +ip netns exec $R ip -6 addr add 2001:db8:ffff:21::fffe/64 dev r_c
> +ip netns exec $R sysctl -w net.ipv6.conf.all.forwarding=1
> +ip netns exec $C ip route add 2001:db8:ffff:22::/64 via 2001:db8:ffff:21::fffe dev c_r
> +ip netns exec $S ip route add 2001:db8:ffff:21::/64 via 2001:db8:ffff:22::fffe dev s_r
> +ip netns exec $S ethtool -K s_r tso off
> +ip netns exec $C ethtool -K c_r tso off
> +
> +sleep 3
> +ip netns exec $C ping -6 2001:db8:ffff:22::1 -c1 || exit 1
> +
> +ip netns exec $R nft -f - <<EOF
> +table ip6 filter {
> +        flowtable f1 {
> +                hook ingress priority -100
> +                devices = { r_c, r_s }
> +        }
> +
> +        chain forward {
> +                type filter hook forward priority filter; policy accept;
> +                ip6 nexthdr tcp ct state established,related counter packets 0 bytes 0 flow add @f1 counter packets 0 bytes 0
> +                ip6 nexthdr tcp ct state invalid counter packets 0 bytes 0 drop
> +                tcp flags fin,rst counter packets 0 bytes 0 accept
> +                meta l4proto tcp meta length < 100 counter packets 0 bytes 0 accept
> +                ip6 nexthdr tcp counter packets 0 bytes 0 log drop
> +        }
> +}
> +EOF
> +
> +if [ ! -r /proc/net/nf_conntrack ]
> +then
> +	echo "E: nf_conntrack unreadable, skipping" >&2	
> +	exit 77
> +fi
> +
> +ip netns exec $R nft list ruleset
> +ip netns exec $R sysctl -w net.netfilter.nf_flowtable_tcp_timeout=5 || {
> +	echo "E: set net.netfilter.nf_flowtable_tcp_timeout fail, skipping" >&2
> +        exit 77
> +}
> +ip netns exec $R sysctl -w net.netfilter.nf_conntrack_tcp_timeout_established=86400 || {
> +        echo "E: set net.netfilter.nf_conntrack_tcp_timeout_established fail, skipping" >&2
> +        exit 77
> +
> +}
> +
> +# A trick to control the timing to send a packet
> +ip netns exec $S socat TCP6-LISTEN:10001 GOPEN:pipefile,ignoreeof &
> +sleep 1
> +ip netns exec $C socat -b 2048 PIPE:pipefile TCP:[2001:db8:ffff:22::1]:10001 &
> +sleep 1
> +ip netns exec $R grep 'OFFLOAD' /proc/net/nf_conntrack   || { echo "check [OFFLOAD] tag (failed)"; exit 1; }
> +ip netns exec $R cat /proc/net/nf_conntrack
> +sleep 6
> +ip netns exec $R grep 'OFFLOAD' /proc/net/nf_conntrack   && { echo "CT OFFLOAD timeout, fail back to classical path (failed)"; exit 1; }
> +ip netns exec $R grep '8639[0-9]' /proc/net/nf_conntrack || { echo "check nf_conntrack_tcp_timeout_established (failed)"; exit 1; }
> +ip netns exec $C echo "send sth" >> pipefile
> +ip netns exec $R grep 'OFFLOAD' /proc/net/nf_conntrack   || { echo "traffic seen, back to OFFLOAD path (failed)"; exit 1; }
> +ip netns exec $C sleep 3
> +ip netns exec $C echo "send sth" >> pipefile
> +ip netns exec $C sleep 3
> +ip netns exec $R grep 'OFFLOAD' /proc/net/nf_conntrack   || { echo "Traffic seen in 5s (nf_flowtable_tcp_timeout), so stay in OFFLOAD (failed)"; exit 1; }
> +
> +exit 0
> -- 
> 2.43.0
> 
> 
