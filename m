From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Overlapping IP networks no longer allowed?
Date: Wed, 14 Feb 2018 19:22:49 +0100
Message-ID: <20180214182249.nnccha2bg5j4htrv@salvia>
References: <CAPWNY8W5euS6+LrEppdKp81k-Uz48w2WZP8kzu5=cVyhObnVMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36478 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161778AbeBNSXK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 13:23:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E923A190F6F
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 19:23:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E35A8DA787
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 19:22:52 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAPWNY8W5euS6+LrEppdKp81k-Uz48w2WZP8kzu5=cVyhObnVMg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 14, 2018 at 07:02:32PM +0200, Mantas Mikulėnas wrote:
> Hello,
> 
> As of nftables 0.8.1, it seems I can no longer write anonymous sets
> which contain overlapping networks (CIDR masks).
> 
> For example, I want to write the following ruleset:
> 
> #!/usr/bin/nft -f
> define users = { 10.0.0.0/8, 193.219.181.192/26 }
> define admins = { 10.123.0.0/24, 31.220.42.129 }
> define allowed = { $users, $admins }
> table inet filter {
>         chain foobar {
>                 ip saddr $allowed accept
>         }
> }
> 
> results in an error message:
> 
>     Error: interval overlaps with previous one
> 
> I noticed a few nftables.git commits related to disabling auto-merge
> for interval sets... but mine don't have the 'interval' flag, and
> there doesn't seem to be any way to specify 'auto-merge' for anonymous
> sets, either.

I would like not to enable this by default since typo in rulesets
could go through unnoticed.

So the two alternatives I see are:

1) add per-table configuration options, this would allow us to
   enable auto-merge explicitly for all anonymous sets. This is also
   required if we want to allow user to select "policy memory;" for
   anonymous sets. Only problem with this approach is that this needs
   a kernel patch, so it will take a while to restore the behaviour you
   want since we need a new NFTA_TABLE_USERDATA attribute to store user
   preferences on this.

2) We add a -m option that we can combine with -f for this, which
   globally enables auto-merge for every set, including anonymous and
   named sets.

Let me know.
