Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C823FC6FA8F
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 15:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237300AbjH2Pig (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 11:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237314AbjH2PiV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 11:38:21 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC28193
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 08:38:18 -0700 (PDT)
Received: from [78.30.34.192] (port=36856 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qb0nF-00FGk4-BE; Tue, 29 Aug 2023 17:38:16 +0200
Date:   Tue, 29 Aug 2023 17:38:11 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 0/4] add operation cache for timestamp
Message-ID: <ZO4Q4xZGvg+E+j3P@calendula>
References: <20230825132942.2733840-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LNyHpERKoVFM5NGw"
Content-Disposition: inline
In-Reply-To: <20230825132942.2733840-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--LNyHpERKoVFM5NGw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Fri, Aug 25, 2023 at 03:24:16PM +0200, Thomas Haller wrote:
> Add a cache for "time(NULL)" and tm_gmtoff from localtime_r(time(NULL), &tm).
> The point is to ensure that one parse/output operation fetches the current time
> and GMT offset at most once.
> 
> Follow up to ([1])
> 
>   Subject:  Re: [nft PATCH 2/2] meta: use reentrant localtime_r()/gmtime_r() functions
>   Date:     Tue, 22 Aug 2023 17:15:14 +0200
> 
> [1] https://marc.info/?l=netfilter-devel&m=169271724629901&w=4

To extend what I said yesterday. It would be great if you could
validate that we have sufficient tests for time support.

Probably you can use this ruleset that I am attaching as reference and
think of a ruleset to cover this? I am attaching an example ruleset
which is basically a "timetable" using nftables sets/maps.

--LNyHpERKoVFM5NGw
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="schedules.nft"

table netdev filter {
	map ether_to_chain {
		typeof ether saddr : verdict
		elements = { 96:68:97:a7:e8:a7 comment "Device match" : jump fw_p0_dev0 }
	}

	map schedule_time {
		typeof meta time : verdict
		flags interval
		counter
		elements = { "2022-10-09 18:46:50" - "2022-10-09 19:16:50" comment "!Schedule OFFLINE override" : drop }
	}

	map schedule_day {
		typeof meta day . meta hour : verdict
		flags interval
		counter
		elements = { "Tuesday" . "06:00" - "07:00" : drop }
	}

	chain fw_p0_dev0 {
		meta time vmap @schedule_time
		meta day . meta hour vmap @schedule_day
	}

	chain my_devices_rules {
		ether saddr vmap @ether_to_chain
	}

	chain ingress {
		type filter hook ingress device eth0 priority filter; policy accept;
		jump my_devices_rules
	}
}

--LNyHpERKoVFM5NGw--
