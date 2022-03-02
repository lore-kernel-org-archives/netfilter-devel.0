Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48CEAC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Mar 2022 15:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243384AbiCBPME (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 10:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234428AbiCBPMD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 10:12:03 -0500
X-Greylist: delayed 972 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 02 Mar 2022 07:11:19 PST
Received: from mxout70.expurgate.net (mxout70.expurgate.net [194.37.255.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6119077AA3
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2022 07:11:19 -0800 (PST)
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <fe@dev.tdt.de>)
        id 1nPQNc-0004Yc-7R; Wed, 02 Mar 2022 15:55:04 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <fe@dev.tdt.de>)
        id 1nPQNa-0004WM-B1; Wed, 02 Mar 2022 15:55:02 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id A0055240049;
        Wed,  2 Mar 2022 15:55:01 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 49706240040;
        Wed,  2 Mar 2022 15:55:01 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 9807520B92;
        Wed,  2 Mar 2022 15:55:00 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 02 Mar 2022 15:55:00 +0100
From:   Florian Eckert <fe@dev.tdt.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [PATCH ipset] Fix IPv6 sets nftables translation
In-Reply-To: <20220228190217.2256371-1-pablo@netfilter.org>
References: <20220228190217.2256371-1-pablo@netfilter.org>
Message-ID: <08d032b3a2629bedeb82e93031470dff@dev.tdt.de>
X-Sender: fe@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.17
X-purgate-type: clean
X-purgate-ID: 151534::1646232903-00005EE4-836758CD/0/0
X-purgate: clean
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thanks Pablo for the fix.

Works as expecected:

root@st-dev-07 /tmp/run/mwan3/iptables-log #
cat ipset-mwan3_set_connected_ipv6.dump && ipset-translate restore < 
ipset-mwan3_set_connected_ipv6.dump

-! create mwan3_connected_ipv6 hash:net family inet6
flush mwan3_connected_ipv6
-! add mwan3_connected_ipv6 fe80::/64
-! add mwan3_connected_ipv6 fe80::/64
add table inet global
add set inet global mwan3_connected_ipv6 { type ipv6_addr; flags 
interval; }
flush set inet global mwan3_connected_ipv6
add element inet global mwan3_connected_ipv6 { fe80::/64 }
add element inet global mwan3_connected_ipv6 { fe80::/64 }


On 2022-02-28 20:02, Pablo Neira Ayuso wrote:
> The parser assumes the set is an IPv4 ipset because IPSET_OPT_FAMILY is
> not set.
> 
>  # ipset-translate restore < ./ipset-mwan3_set_connected_ipv6.dump
>  add table inet global
>  add set inet global mwan3_connected_v6 { type ipv6_addr; flags 
> interval; }
>  flush set inet global mwan3_connected_v6
>  ipset v7.15: Error in line 4: Syntax error: '64' is out of range 0-32
> 
> Remove ipset_xlate_type_get(), call ipset_xlate_set_get() instead to
> obtain the set type and family.
> 
> Reported-by: Florian Eckert <fe@dev.tdt.de>
> Fixes: 325af556cd3a ("add ipset to nftables translation 
> infrastructure")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Tested-by: Florian Eckert <fe@dev.tdt.de>
> ---
>  lib/ipset.c             | 24 ++++++++++--------------
>  tests/xlate/xlate.t     |  2 ++
>  tests/xlate/xlate.t.nft |  2 ++
>  3 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/lib/ipset.c b/lib/ipset.c
> index 73e67db88e0d..50f86aee045b 100644
> --- a/lib/ipset.c
> +++ b/lib/ipset.c
> @@ -949,18 +949,6 @@ ipset_xlate_set_get(struct ipset *ipset, const 
> char *name)
>  	return NULL;
>  }
> 
> -static const struct ipset_type *ipset_xlate_type_get(struct ipset 
> *ipset,
> -						     const char *name)
> -{
> -	const struct ipset_xlate_set *set;
> -
> -	set = ipset_xlate_set_get(ipset, name);
> -	if (!set)
> -		return NULL;
> -
> -	return set->type;
> -}
> -
>  static int
>  ipset_parser(struct ipset *ipset, int oargc, char *oargv[])
>  {
> @@ -1282,8 +1270,16 @@ ipset_parser(struct ipset *ipset, int oargc,
> char *oargv[])
>  		if (!ipset->xlate) {
>  			type = ipset_type_get(session, cmd);
>  		} else {
> -			type = ipset_xlate_type_get(ipset, arg0);
> -			ipset_session_data_set(session, IPSET_OPT_TYPE, type);
> +			const struct ipset_xlate_set *xlate_set;
> +
> +			xlate_set = ipset_xlate_set_get(ipset, arg0);
> +			if (xlate_set) {
> +				ipset_session_data_set(session, IPSET_OPT_TYPE,
> +						       xlate_set->type);
> +				ipset_session_data_set(session, IPSET_OPT_FAMILY,
> +						       &xlate_set->family);
> +				type = xlate_set->type;
> +			}
>  		}
>  		if (type == NULL)
>  			return ipset->standard_error(ipset, p);
> diff --git a/tests/xlate/xlate.t b/tests/xlate/xlate.t
> index b1e7d288e2a9..f09cb202bb6c 100644
> --- a/tests/xlate/xlate.t
> +++ b/tests/xlate/xlate.t
> @@ -53,3 +53,5 @@ create bp1 bitmap:port range 1-1024
>  add bp1 22
>  create bim1 bitmap:ip,mac range 1.1.1.0/24
>  add bim1 1.1.1.1,aa:bb:cc:dd:ee:ff
> +create hn6 hash:net family inet6
> +add hn6 fe80::/64
> diff --git a/tests/xlate/xlate.t.nft b/tests/xlate/xlate.t.nft
> index 96eba3b0175e..0152a3081125 100644
> --- a/tests/xlate/xlate.t.nft
> +++ b/tests/xlate/xlate.t.nft
> @@ -54,3 +54,5 @@ add set inet global bp1 { type inet_service; }
>  add element inet global bp1 { 22 }
>  add set inet global bim1 { type ipv4_addr . ether_addr; }
>  add element inet global bim1 { 1.1.1.1 . aa:bb:cc:dd:ee:ff }
> +add set inet global hn6 { type ipv6_addr; flags interval; }
> +add element inet global hn6 { fe80::/64 }
