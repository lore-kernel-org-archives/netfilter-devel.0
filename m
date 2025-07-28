Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15976239E70
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Jul 2025 23:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753746493; cv=none; b=P2ghl2v93hDSjimrRxGXmaoa1dG1k+lANKPNwaI/t4De92gUSRvv1yqxx1/Ysf/NxFcrzv+/Qc4vcyXbh1eLQInmQM0yeWThs5GiNSaQc5jsQ+fwmkH2nB3I9XRNz3icw/66S2/3ehkySQ2bM51NJETphwhW3yXOal74iiM4zd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753746493; c=relaxed/simple;
	bh=wCbAx24pADUWG9Bg5h29iehyH8d5hPSkf+PYsaiJJCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KMeIerrOiNcpf2O0/FbeamtpgwLH/CsyrWtnkdYM6ZXUTjYS/016mduS7YstKI1ZdR8JQJNf9kFfYpmtwSXQeUfzBOD6SMZASHJnPkGY3UD0LsbWA86BMNy5xkanX3asgk41WjRsng5JDB1fxy5ilPVVN0xBdF2b70mcYRQdkxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dpeCjUv6; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WVx2xxmj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dpeCjUv6";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WVx2xxmj"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 84DF3602F2; Tue, 29 Jul 2025 01:48:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753746489;
	bh=p1iUmHRzNyRRalh1YRCXFV/wHMU0+3zLO8gZkmDXsKU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dpeCjUv6MHfe8FqlXu/kfczlAUKzdWufSN/ruEekv7Q3SR4Q8z7pAYpE+0Aj7W+Gy
	 lmdGEr8Hy/+FXGWAtdWi7fxyZ7P0hdmCYZEZMk/7irYMCoR4z+jZpq2vEVK9LTqXKG
	 DYoLjHMriylEkG81oSnWHdKaSJKizm+pkRUZ8zPt8ekW/U+rAkJ4E6KqZS4DD2qAAY
	 HPAErnbAKHhwy5SyzBR7X/MGLB+wu4ZNmacbXkAPX9zHn3SCRvrK90US8CVukE9wmH
	 Y1ldZAGZ+FOhUIYMu/ik7qp79m4QaOkWwDsN4VMkt4HzEpf4boQbpuUEqcqSi8dy8y
	 1TbeXzHMWSwPw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E96EA602ED;
	Tue, 29 Jul 2025 01:48:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753746487;
	bh=p1iUmHRzNyRRalh1YRCXFV/wHMU0+3zLO8gZkmDXsKU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WVx2xxmjDNoJl+/D+4ogDP5w+SAty0wkC3QwDiT1CraeBalVPKBgQWeNfPtNJnd8+
	 Vtq2ZnXpwgpUyayA6ij6jQsP4vC9bY1obCQHq9ImSNh9SNs6YiE6GjPPkCDMQp5Ydk
	 BD1kIojhsMu8U/MmAdWJq4Qcv0b/aDfpzcXTYkv++jLjb/HG8npMjeTxx6ipdNqv87
	 nm1NfYaKShhTnvh6K/hhXMOKOj3W584UyEkfvSr5U6t6MZGQUcDlnvgxkhBn4ChATJ
	 CkbXl5rM2myTyOzWq4P7UoeivVief7Oi3EbwXXRySVtH3PjgRQGugwdZUXSOor6RCA
	 ybiWArw6SXy2A==
Date: Tue, 29 Jul 2025 01:48:02 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Shaun Brady <brady.1345@gmail.com>
Cc: netfilter-devel@vger.kernel.org, ppwaskie@kernel.org, fw@strlen.de
Subject: Re: [PATCH v6 2/2] Add test for nft_max_table_jumps_netns sysctl
Message-ID: <aIgMMnl-2WMQlFH-@calendula>
References: <20250728040315.1014454-1-brady.1345@gmail.com>
 <20250728040315.1014454-2-brady.1345@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250728040315.1014454-2-brady.1345@gmail.com>

On Mon, Jul 28, 2025 at 12:03:15AM -0400, Shaun Brady wrote:
> Introduce test for recently added jump limit functionality.  Tests
> sysctl behavior with regard to netns, as well as calling user_ns.

Would you rework this to a more elaborated torture test that exercises
both commit and abort path?

It would be great to have something similar to
nftables/tests/shell/testcases/transactions/30s-stress
but to exercise loop detection.

Thanks.

> Signed-off-by: Shaun Brady <brady.1345@gmail.com>
> ---
>  .../testing/selftests/net/netfilter/Makefile  |   1 +
>  .../netfilter/nft_max_table_jumps_netns.sh    | 227 ++++++++++++++++++
>  2 files changed, 228 insertions(+)
>  create mode 100755 tools/testing/selftests/net/netfilter/nft_max_table_jumps_netns.sh
> 
> diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
> index a98ed892f55f..62193e0cd8ec 100644
> --- a/tools/testing/selftests/net/netfilter/Makefile
> +++ b/tools/testing/selftests/net/netfilter/Makefile
> @@ -26,6 +26,7 @@ TEST_PROGS += nft_conntrack_helper.sh
>  TEST_PROGS += nft_fib.sh
>  TEST_PROGS += nft_flowtable.sh
>  TEST_PROGS += nft_interface_stress.sh
> +TEST_PROGS += nft_max_table_jumps_netns.sh
>  TEST_PROGS += nft_meta.sh
>  TEST_PROGS += nft_nat.sh
>  TEST_PROGS += nft_nat_zones.sh
> diff --git a/tools/testing/selftests/net/netfilter/nft_max_table_jumps_netns.sh b/tools/testing/selftests/net/netfilter/nft_max_table_jumps_netns.sh
> new file mode 100755
> index 000000000000..9dedd45f4fd2
> --- /dev/null
> +++ b/tools/testing/selftests/net/netfilter/nft_max_table_jumps_netns.sh
> @@ -0,0 +1,227 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# A test script for nf_max_table_jumps_netns limit sysctl
> +#
> +source lib.sh
> +
> +DEFAULT_SYSCTL=65536
> +
> +user_owned_netns="a_user_owned_netns"
> +
> +cleanup() {
> +        ip netns del $user_owned_netns 2>/dev/null || true
> +}
> +
> +trap cleanup EXIT
> +
> +init_net_value=$(sysctl -n net.netfilter.nf_max_table_jumps_netns)
> +
> +# Check that init ns inits to default value
> +if [ "$init_net_value" -ne "$DEFAULT_SYSCTL" ];then
> +	echo "Fail: Does not init default value"
> +	exit 1
> +fi
> +
> +# Set to extremely small, demonstrate CAN exceed value
> +sysctl -w net.netfilter.nf_max_table_jumps_netns=32 2>&1 >/dev/null
> +new_value=$(sysctl -n net.netfilter.nf_max_table_jumps_netns)
> +if [ "$new_value" -ne "32" ];then
> +	echo "Fail: Set value not respected"
> +	exit 1
> +fi
> +
> +nft -f - <<EOF
> +table inet loop-test {
> +	chain test0 {
> +		type filter hook input priority filter; policy accept;
> +		jump test1
> +		jump test1
> +	}
> +
> +	chain test1 {
> +		jump test2
> +		jump test2
> +	}
> +
> +	chain test2 {
> +		jump test3
> +		tcp dport 8080 drop
> +		tcp dport 8080 drop
> +	}
> +
> +	chain test3 {
> +		jump test4
> +	}
> +
> +	chain test4 {
> +		jump test5
> +	}
> +
> +	chain test5 {
> +		jump test6
> +	}
> +
> +	chain test6 {
> +		jump test7
> +	}
> +
> +	chain test7 {
> +		jump test8
> +	}
> +
> +	chain test8 {
> +		jump test9
> +	}
> +
> +	chain test9 {
> +		jump test10
> +	}
> +
> +	chain test10 {
> +		jump test11
> +	}
> +
> +	chain test11 {
> +		jump test12
> +	}
> +
> +	chain test12 {
> +		jump test13
> +	}
> +
> +	chain test13 {
> +		jump test14
> +	}
> +
> +	chain test14 {
> +		jump test15
> +		jump test15
> +	}
> +
> +	chain test15 {
> +	}
> +}
> +EOF
> +
> +if [ $? -ne 0 ];then
> +	echo "Fail: limit not exceeded when expected"
> +	exit 1
> +fi
> +
> +nft flush ruleset
> +
> +# reset to default
> +sysctl -w net.netfilter.nf_max_table_jumps_netns=$DEFAULT_SYSCTL 2>&1 >/dev/null
> +
> +# Make init_user_ns owned netns, can change value, limit is applied
> +ip netns add $user_owned_netns
> +ip netns exec $user_owned_netns sysctl -qw net.netfilter.nf_max_table_jumps_netns=32 2>&1
> +if [ $? -ne 0 ];then
> +	echo "Fail: Can't change value in init_user_ns owned namespace"
> +	exit 1
> +fi
> +
> +ip netns exec $user_owned_netns \
> +nft -f - 2>&1 <<EOF
> +table inet loop-test {
> +	chain test0 {
> +		type filter hook input priority filter; policy accept;
> +		jump test1
> +		jump test1
> +	}
> +
> +	chain test1 {
> +		jump test2
> +		jump test2
> +	}
> +
> +	chain test2 {
> +		jump test3
> +		tcp dport 8080 drop
> +		tcp dport 8080 drop
> +	}
> +
> +	chain test3 {
> +		jump test4
> +	}
> +
> +	chain test4 {
> +		jump test5
> +	}
> +
> +	chain test5 {
> +		jump test6
> +	}
> +
> +	chain test6 {
> +		jump test7
> +	}
> +
> +	chain test7 {
> +		jump test8
> +	}
> +
> +	chain test8 {
> +		jump test9
> +	}
> +
> +	chain test9 {
> +		jump test10
> +	}
> +
> +	chain test10 {
> +		jump test11
> +	}
> +
> +	chain test11 {
> +		jump test12
> +	}
> +
> +	chain test12 {
> +		jump test13
> +	}
> +
> +	chain test13 {
> +		jump test14
> +	}
> +
> +	chain test14 {
> +		jump test15
> +		jump test15
> +	}
> +
> +	chain test15 {
> +	}
> +}
> +EOF
> +
> +if [ $? -eq 0 ];then
> +	echo "Fail: Limited incorrectly applied"
> +	exit 1
> +fi
> +ip netns del $user_owned_netns
> +
> +# Previously set value does not impact root namespace; check value from before
> +new_value=$(sysctl -n net.netfilter.nf_max_table_jumps_netns)
> +if [ "$new_value" -ne "$DEFAULT_SYSCTL" ];then
> +	echo "Fail: Non-init namespace altered init namespace"
> +	exit 1
> +fi
> +
> +# Make non-init_user_ns owned netns, can not change value
> +unshare -Un sysctl -w net.netfilter.nf_max_table_jumps_netns=1234 2>&1
> +if [ $? -ne 0 ];then
> +	echo "Fail: Error message incorrect when non-user-init"
> +	exit 1
> +fi
> +
> +# Double check user namespace can still see limit
> +new_value=(unshare -Un sysctl -n net.netfilter.nf_max_table_jumps_netns)
> +if [ "$new_value" -ne "$DEFAULT_SYSCTL" ];then
> +	echo "Fail: Unexpected failure when non-user-init"
> +	exit 1
> +fi
> +
> +
> +exit 0
> -- 
> 2.49.0
> 
