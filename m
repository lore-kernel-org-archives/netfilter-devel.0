Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE562C029E
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 17:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761759800; cv=none; b=F0iIhgu4mZF1EJPT7rtL2fH7tOnqTa412W2STBo62sfMjzDT9th0u+qo36SkfZmq2WMGKcXHm5OcCsaymjbSrztlKeyNJXRfa4/ekyXqcHpBPqGVbJFz/2M4QugySyE28HTIAMW9B836CThz0uoHPl/i+zd88wSvzIjLGWHZ9KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761759800; c=relaxed/simple;
	bh=ZicaUqiYQPBqzes0gfe2Rbnlb0eu8ISzsux04/VORkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=skz7GXYqBto3l92wdJ1y28PBkihyfG+0vTZaJhR5Ar9M8pMn/94J/LbrflCaMN+yQu7d3Z2S6AKMRjCVuWqci/ZpnRbGemvSPAWcUO+HRz2xK0AlH6+EGG4RxpCX9oWE6w0eh7DFJAGflOS6Djll568foa4EYCLnJY4cHcEah9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aGmjkAzH; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aGmjkAzH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gkO0LoFpfbnM4XXBWF4eYMnVN9NZPlkGqN5Vr7h8s94=; b=aGmjkAzHgB8wFoWnUpXJYHSh9A
	rdj02nuHFU7YxR0HoVjCFvG9ZQau5ZoI0HNOIgg3xp2BrBTN4Gu7d/mweuoJM1Q31sxmA5SUjC0uT
	aJs8Ro49Dev+JVR671PzquJbdZSoXmmDSV6bQpJbMxlSlRajArEWyHqgnYdHrWvxCRZ1I+NcbXDH1
	tXIqhxIw0+CliHsl3qXAjCokI2pcmkyX3m2pSJoeqWLrlx7RhmjY6eK3eOSsbyHi/oXjKMOMLsdiY
	qv8Xfmv4UeZ32mgdfu2sMQEry5G34myRpE+T6XMu2U1ptvMtvFxa0DOEFN8A2m5e3UlsqzWkeIL9X
	XKBO5+JA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vEACS-000000001vM-0KdC;
	Wed, 29 Oct 2025 18:43:08 +0100
Date: Wed, 29 Oct 2025 18:43:07 +0100
From: Phil Sutter <phil@nwl.cc>
To: Andrii Melnychenko <a.melnychenko@vyos.io>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH v2 1/2] tests: shell: Refactored nat_ftp, added rulesets
 and testcase functions
Message-ID: <aQJSK78KSNL_fNwV@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Andrii Melnychenko <a.melnychenko@vyos.io>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20251028165607.1074310-1-a.melnychenko@vyos.io>
 <20251028165607.1074310-2-a.melnychenko@vyos.io>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251028165607.1074310-2-a.melnychenko@vyos.io>

Hi,

On Tue, Oct 28, 2025 at 05:56:06PM +0100, Andrii Melnychenko wrote:
> Refactored the setup of nft rulesets, now it is possible to set up an
> SNAT or DNAT-only ruleset for future tests.
> Presented the testcase function to test passive or active modes.
> 
> Signed-off-by: Andrii Melnychenko <a.melnychenko@vyos.io>
> ---
>  tests/shell/testcases/packetpath/nat_ftp | 86 +++++++++++++++---------
>  1 file changed, 53 insertions(+), 33 deletions(-)
> 
> diff --git a/tests/shell/testcases/packetpath/nat_ftp b/tests/shell/testcases/packetpath/nat_ftp
> index d0faf2ef..bc116f6e 100755
> --- a/tests/shell/testcases/packetpath/nat_ftp
> +++ b/tests/shell/testcases/packetpath/nat_ftp
> @@ -77,7 +77,7 @@ ip -net $S route add ${ip_rc}/64 via ${ip_rs} dev s_r
>  ip netns exec $C ping -q -6 ${ip_sr} -c1 > /dev/null
>  assert_pass "topo initialization"
>  
> -reload_ruleset()
> +reload_ruleset_base()
>  {
>  	ip netns exec $R conntrack -F 2> /dev/null
>  	ip netns exec $R $NFT -f - <<-EOF
> @@ -87,12 +87,6 @@ reload_ruleset()
>  			type "ftp" protocol tcp;
>  		}
>  
> -		chain PRE-dnat {
> -			type nat hook prerouting priority dstnat; policy accept;
> -			# Dnat the control connection, data connection will be automaticly NATed.
> -			ip6 daddr ${ip_rc} counter ip6 nexthdr tcp tcp dport 2121 counter dnat ip6 to [${ip_sr}]:21
> -		}
> -
>  		chain PRE-aftnat {
>  			type filter hook prerouting priority 350; policy drop;
>  			iifname r_c tcp dport 21 ct state new ct helper set "ftp-standard" counter accept
> @@ -111,14 +105,43 @@ reload_ruleset()
>  			ip6 nexthdr tcp ct state established counter accept
>  			ip6 nexthdr tcp ct state related     counter log accept
>  		}
> +	}
> +	EOF
> +	assert_pass "apply ftp helper base ruleset"
> +}
> +
> +load_dnat()
> +{
> +	ip netns exec $R $NFT -f - <<-EOF
> +	table ip6 ftp_helper_nat_test {
> +		chain PRE-dnat {
> +			type nat hook prerouting priority dstnat; policy accept;
> +			# Dnat the control connection, data connection will be automaticly NATed.
> +			ip6 daddr ${ip_rc} counter ip6 nexthdr tcp tcp dport 2121 counter dnat ip6 to [${ip_sr}]:21
> +		}
> +	}
> +	EOF
> +	assert_pass "apply ftp helper DNAT ruleset"
> +}
>  
> +load_snat()
> +{
> +	ip netns exec $R $NFT -f - <<-EOF
> +	table ip6 ftp_helper_nat_test {
>  		chain POST-srcnat {
>  			type nat hook postrouting priority srcnat; policy accept;
>  			ip6 daddr ${ip_sr} ip6 nexthdr tcp tcp dport 21 counter snat ip6 to [${ip_rs}]:16500
>  		}
>  	}
>  	EOF
> -	assert_pass "apply ftp helper ruleset"
> +	assert_pass "apply ftp helper SNAT ruleset"
> +}
> +
> +reload_ruleset()
> +{
> +	reload_ruleset_base
> +	load_dnat
> +	load_snat
>  }
>  
>  dd if=/dev/urandom of="$INFILE" bs=4096 count=1 2>/dev/null
> @@ -141,38 +164,35 @@ wait_local_port_listen $S 21 tcp
>  ip netns exec $S ss -6ltnp | grep -q '*:21'
>  assert_pass "start vsftpd server"
>  
> +test_case()
> +{
> +	tag=$1
> +	ftp_ip_and_port=$2
> +	client_ip_to_check=$3
> +	additional_curl_options=$4
> +
> +	ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/null &
> +	pid=$!
> +	sleep 0.5
> +	ip netns exec $C curl ${additional_curl_options} --no-progress-meter --connect-timeout 5 ftp://${ftp_ip_and_port}/$(basename $INFILE) -o $OUTFILE
> +	assert_pass "curl ftp "${tag}
> +
> +	cmp "$INFILE" "$OUTFILE"
> +	assert_pass "FTP "${tag}": The input and output files remain the same when traffic passes through NAT."
> +
> +	kill $pid; sync
> +	tcpdump -nnr ${PCAP} src ${client_ip_to_check} and dst ${ip_sr} 2>&1 |grep -q FTP
> +	assert_pass "assert FTP traffic NATed"
> +}
>  
>  # test passive mode
>  reload_ruleset
> -ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/null &
> -pid=$!
> -sleep 0.5
> -ip netns exec $C curl --no-progress-meter --connect-timeout 5 ftp://[${ip_rc}]:2121/$(basename $INFILE) -o $OUTFILE
> -assert_pass "curl ftp passive mode "
> -
> -cmp "$INFILE" "$OUTFILE"
> -assert_pass "FTP Passive mode: The input and output files remain the same when traffic passes through NAT."
> -
> -kill $pid; sync
> -tcpdump -nnr ${PCAP} src ${ip_rs} and dst ${ip_sr} 2>&1 |grep -q FTP
> -assert_pass "assert FTP traffic NATed"
> +test_case "Passive mode" [${ip_rc}]:2121 ${ip_rs}
                            ~~~~~~~~~~~~~~~
I think you should add double-quotes around this parameter to avoid
inadvertent shell globbing from taking place. Yes, it is a bug in the
old code already (if at all) but it's a good chance to fix it now.

Consequently the curl parameter dereferencing the variable should be
quoted as well.

>  # test active mode
>  reload_ruleset
> -
> -ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/null &
> -pid=$!
> -sleep 0.5
> -ip netns exec $C curl --no-progress-meter -P - --connect-timeout 5 ftp://[${ip_rc}]:2121/$(basename $INFILE) -o $OUTFILE
> -assert_pass "curl ftp active mode "
> -
> -cmp "$INFILE" "$OUTFILE"
> -assert_pass "FTP Active mode: in and output files remain the same when FTP traffic passes through NAT."
> -
> -kill $pid; sync
> -tcpdump -nnr ${PCAP} src ${ip_rs} and dst ${ip_sr} 2>&1 |grep -q FTP
> -assert_pass "assert FTP traffic NATed"
> +test_case "Active mode" [${ip_rc}]:2121 ${ip_rs} "-P -"
                           ~~~~~~~~~~~~~~~
Same here.

Cheers, Phil
