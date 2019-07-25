Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B739AC7618B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 10:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97124206B8
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 10:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387683AbfGYKkj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 06:40:39 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:53276 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387602AbfGYKki (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 06:40:38 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hqbAq-0001vy-07; Thu, 25 Jul 2019 12:40:36 +0200
Date:   Thu, 25 Jul 2019 12:40:35 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Adel Belhouane <bugs.a.b@free.fr>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables]: restore legacy behaviour of iptables-restore
 when rules start with -4/-6
Message-ID: <20190725104035.GP22661@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Adel Belhouane <bugs.a.b@free.fr>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <f056f1bb-2a73-5042-740c-f2a16958deb0@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f056f1bb-2a73-5042-740c-f2a16958deb0@free.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Adel,

On Wed, Jul 24, 2019 at 10:13:02PM +0200, Adel Belhouane wrote:
> Legacy implementation of iptables-restore / ip6tables-restore allowed
> to insert a -4 or -6 option at start of a rule line to ignore it if not
> matching the command's protocol. This allowed to mix specific ipv4 and ipv6
> rules in a single file, as still described in iptables 1.8.3's man page in
> options -4 and -6.

Thanks for catching this. Seems like at some point the intention was to
have a common 'xtables' command and pass -4/-6 parameters to toggle
between iptables and ip6tables operation. Pablo, is this still relevant,
or can we just get rid of it altogether?

> Example with the file /tmp/rules:
> 
> *filter
> :INPUT ACCEPT [0:0]
> :FORWARD ACCEPT [0:0]
> :OUTPUT ACCEPT [0:0]
> -4 -A INPUT -p icmp -j ACCEPT
> -6 -A INPUT -p ipv6-icmp -j ACCEPT
> COMMIT

Would you mind creating a testcase in iptables/tests/shell? I guess
testcases/ipt-restore is suitable, please have a look at
0003-restore-ordering_0 in that directory for an illustration of how we
usually check results of *-restore calls.

[...]
> It doesn't attempt to fix all minor anomalies, but just to fix the regression.
> For example the line below should throw an error according to the man page
> (and does in the legacy version), but doesn't in the nft version:
> 
> % iptables -6 -A INPUT -p tcp -j ACCEPT

On my testing VM this rule ends up in table ip filter, so this seems to
not even work as intended.

> Signed-off-by: Adel Belhouane <bugs.a.b@free.fr>

Acked-by: Phil Sutter <phil@nwl.cc>
