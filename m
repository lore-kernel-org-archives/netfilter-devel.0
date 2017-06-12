From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2] tests: shell: Add test for ambguity while setting the
 value
Date: Mon, 12 Jun 2017 11:22:07 +0200
Message-ID: <20170612092207.GA3997@salvia>
References: <1497024060-6142-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:56853 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751925AbdFLJWL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Jun 2017 05:22:11 -0400
Content-Disposition: inline
In-Reply-To: <1497024060-6142-1-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 09, 2017 at 09:31:00PM +0530, Shyam Saini wrote:
> diff --git a/tests/shell/testcases/sets/0023unknown_value_to_use_0 b/tests/shell/testcases/sets/0023unknown_value_to_use_0
> new file mode 100755
> index 0000000..ee9be68
> --- /dev/null
> +++ b/tests/shell/testcases/sets/0023unknown_value_to_use_0
> @@ -0,0 +1,33 @@
> +#!/bin/bash
> +
> +	# This test checks bug identified and fixed in the commit Id "986dea8".
> +	# i.e, If in a statement there are  multiple src data then it would be totally ambiguous to decide which value to set.
> +        
> +	# Before this commit 986dea8, nft returns 134 which indicates the bug but after this commit it returns 1.
> +	# We don't add this test in python testsuite, because there we can't detect 134 != 1 (returns code stating failure) 	
> +
> +declare -a rules=(
> +"tcp dport set {1, 2, 3}" "udp dport set {1, 2, 3}"
> +"meta pkttype set {unicast, multicast, broadcast}"
> +"meta mark set {0xffff, 0xcc}"
> +"ct mark set {0x11333, 0x11}" "ct zone set {123, 127}"
> +"ct label set {123, 127}" 
> +"ct event set {new, related, destroy, label}"
> +"ether daddr set {01:00:5e:00:01:01, 01:00:5e:00:02:02}"
> +"ip saddr set {192.19.1.2, 191.1.22.1}"
> +)
> +
> +$NFT add table t
> +$NFT add chain t c
> +
> +for (( i = 0 ; i < ${#rules[@]} ; i++ ))
> +do
> +	$NFT add rule t c ${rules[$i]}
> +	ret=$?
> +	if [ $ret -ne 1 ];
> +	then
> +		echo "E: failed test: returned $ret instead of 1" >&2
> +		exit 1
> +	fi
> +done

Better use tests/py/ for this?
