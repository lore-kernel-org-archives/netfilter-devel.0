Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA065C6FA82
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Sep 2022 14:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbiIWOMf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Sep 2022 10:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232240AbiIWOMa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Sep 2022 10:12:30 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BAAF5952
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Sep 2022 07:12:28 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1objPn-0002aE-8m; Fri, 23 Sep 2022 16:12:27 +0200
Date:   Fri, 23 Sep 2022 16:12:27 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables-nft] tests: extend native delinearize script
Message-ID: <Yy2+y1z7p/FhpRGN@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20220923121725.875-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923121725.875-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 23, 2022 at 02:17:25PM +0200, Florian Westphal wrote:
[...]
> diff --git a/iptables/tests/shell/testcases/nft-only/0010-native-delinearize_0 b/iptables/tests/shell/testcases/nft-only/0010-native-delinearize_0
> index cca36fd88d6c..7859e76c9dd5 100755
> --- a/iptables/tests/shell/testcases/nft-only/0010-native-delinearize_0
> +++ b/iptables/tests/shell/testcases/nft-only/0010-native-delinearize_0
> @@ -5,22 +5,5 @@ nft -v >/dev/null || exit 0
>  
>  set -e
>  
> -nft -f - <<EOF
> -table ip filter {
> -	chain FORWARD {
> -		type filter hook forward priority filter;
> -		limit rate 10/day counter
> -		udp dport 42 counter
> -	}
> -}
> -EOF
> -
> -EXPECT="*filter
> -:INPUT ACCEPT [0:0]
> -:FORWARD ACCEPT [0:0]
> -:OUTPUT ACCEPT [0:0]
> --A FORWARD -m limit --limit 10/day
> --A FORWARD -p udp -m udp --dport 42
> -COMMIT"
> -
> -diff -u -Z <(echo -e "$EXPECT") <($XT_MULTI iptables-save | grep -v '^#')
> +unshare -n bash -c "nft -f $(dirname $0)/0010-nft-native.txt;
> +  diff -u -Z $(dirname $0)/0010-iptables-nft-save.txt <($XT_MULTI iptables-save | grep -v '^#')"

run-test.sh calls unshare already. Apart from that:

Acked-by: Phil Sutter <phil@nwl.cc>
