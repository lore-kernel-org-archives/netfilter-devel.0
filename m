Return-Path: <SRS0=2ZCu=4N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7383AC35DF9
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 08:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE26A218AC
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 08:07:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="Viu8v4Fi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbgBYIHO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Feb 2020 03:07:14 -0500
Received: from smtp-out.kfki.hu ([148.6.0.46]:35645 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729600AbgBYIHO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 03:07:14 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id A257B3C800FB;
        Tue, 25 Feb 2020 09:07:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1582618029; x=1584432430; bh=Gqp51dGD+2
        DM8sKmdnpeIhwkNt/Z4KBqGrakGoOkiNs=; b=Viu8v4FiVKXHo7KtciJbQK4nOy
        i5S6T1E7FtwauhBbhgmSz1lcOZQOW4UKx7PTF6A+q40zITFneSn96mOT8ZTaffD5
        hakny9aclT9Scpzb2a/Rb1WT0KdwoOr82x3Dmm+1vggQaYI39Y3ry1q3G+XDRFwe
        GQQw8pk3okS9WZeRY=
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 25 Feb 2020 09:07:09 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp1.kfki.hu (Postfix) with ESMTP id 5340E3C800F8;
        Tue, 25 Feb 2020 09:07:09 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 2A037206C9; Tue, 25 Feb 2020 09:07:09 +0100 (CET)
Date:   Tue, 25 Feb 2020 09:07:09 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Stefano Brivio <sbrivio@redhat.com>
cc:     netfilter-devel@vger.kernel.org, Mithil Mhatre <mmhatre@redhat.com>
Subject: Re: [PATCH] ipset: Update byte and packet counters regardless of
 whether they match
In-Reply-To: <f4b0ae68661c865c3083d2fa896e9a112057a82f.1582566351.git.sbrivio@redhat.com>
Message-ID: <alpine.DEB.2.20.2002250857120.26348@blackhole.kfki.hu>
References: <f4b0ae68661c865c3083d2fa896e9a112057a82f.1582566351.git.sbrivio@redhat.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stefano MithilMithil,

On Mon, 24 Feb 2020, Stefano Brivio wrote:

> In ip_set_match_extensions(), for sets with counters, we take care of 
> updating counters themselves by calling ip_set_update_counter(), and of 
> checking if the given comparison and values match, by calling 
> ip_set_match_counter() if needed.
> 
> However, if a given comparison on counters doesn't match the configured 
> values, that doesn't mean the set entry itself isn't matching.
> 
> This fix restores the behaviour we had before commit 4750005a85f7 
> ("netfilter: ipset: Fix "don't update counters" mode when counters used 
> at the matching"), without reintroducing the issue fixed there: back 
> then, mtype_data_match() first updated counters in any case, and then 
> took care of matching on counters.
> 
> Now, if the IPSET_FLAG_SKIP_COUNTER_UPDATE flag is set,
> ip_set_update_counter() will anyway skip counter updates if desired.
> 
> The issue observed is illustrated by this reproducer:
> 
>   ipset create c hash:ip counters
>   ipset add c 192.0.2.1
>   iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP
> 
> if we now send packets from 192.0.2.1, bytes and packets counters
> for the entry as shown by 'ipset list' are always zero, and, no
> matter how many bytes we send, the rule will never match, because
> counters themselves are not updated.

Sorry, but I disagree. ipset behaves the same as iptables itself: the 
counters are increased when the whole rule matches and that includes the 
counter comparison as well. I think it's less counter-intuitive that one 
can create never matching rules than to explain that "counter matching is 
a non-match for the point of view of 'when the rule matches, update the 
counter'".

What's really missing is a decrement-counters flag: that way one could 
store different "quotas" for the elements in a set.

Best regards,
Jozsef
 
> Reported-by: Mithil Mhatre <mmhatre@redhat.com>
> Fixes: 4750005a85f7 ("netfilter: ipset: Fix "don't update counters" mode when counters used at the matching")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
>  net/netfilter/ipset/ip_set_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index 69c107f9ba8d..b140e38d9333 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -649,13 +649,14 @@ ip_set_match_extensions(struct ip_set *set, const struct ip_set_ext *ext,
>  	if (SET_WITH_COUNTER(set)) {
>  		struct ip_set_counter *counter = ext_counter(data, set);
>  
> +		ip_set_update_counter(counter, ext, flags);
> +
>  		if (flags & IPSET_FLAG_MATCH_COUNTERS &&
>  		    !(ip_set_match_counter(ip_set_get_packets(counter),
>  				mext->packets, mext->packets_op) &&
>  		      ip_set_match_counter(ip_set_get_bytes(counter),
>  				mext->bytes, mext->bytes_op)))
>  			return false;
> -		ip_set_update_counter(counter, ext, flags);
>  	}
>  	if (SET_WITH_SKBINFO(set))
>  		ip_set_get_skbinfo(ext_skbinfo(data, set),
> -- 
> 2.25.0
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
