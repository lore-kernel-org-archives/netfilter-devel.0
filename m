Return-Path: <SRS0=fjj5=CH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF9AC433E6
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Aug 2020 11:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36A6021527
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Aug 2020 11:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgH2L0Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Aug 2020 07:26:24 -0400
Received: from correo.us.es ([193.147.175.20]:44782 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbgH2LXw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Aug 2020 07:23:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 15C09D1622
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2020 13:17:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 05D13DA73F
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2020 13:17:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EFAE6DA730; Sat, 29 Aug 2020 13:17:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF075DA722;
        Sat, 29 Aug 2020 13:17:23 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 29 Aug 2020 13:17:23 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C155F42EF4E0;
        Sat, 29 Aug 2020 13:17:23 +0200 (CEST)
Date:   Sat, 29 Aug 2020 13:17:23 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Balazs Scheidler <bazsi77@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables v2 1/5] socket: add support for "wildcard" key
Message-ID: <20200829111723.GA9645@salvia>
References: <20200829070405.23636-1-bazsi77@gmail.com>
 <20200829070405.23636-2-bazsi77@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200829070405.23636-2-bazsi77@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Aug 29, 2020 at 09:04:01AM +0200, Balazs Scheidler wrote:
> iptables had a "-m socket --transparent" which didn't match sockets that are
> bound to all addresses (e.g.  0.0.0.0 for ipv4, and ::0 for ipv6).  It was
> possible to override this behavior by using --nowildcard, in which case it
> did match zero bound sockets as well.
> 
> The issue is that nftables never included the wildcard check, so in effect
> it behaved like "iptables -m socket --transparent --nowildcard" with no
> means to exclude wildcarded listeners.
> 
> This is a problem as a user-space process that binds to 0.0.0.0:<port> that
> enables IP_TRANSPARENT would effectively intercept traffic going in _any_
> direction on the specific port, whereas in most cases, transparent proxies
> would only need this for one specific address.
> 
> The solution is to add "socket wildcard" key to the nft_socket module, which
> makes it possible to match on the wildcardness of a socket from
> one's ruleset.
> 
> This is how to use it:
> 
> table inet haproxy {
> 	chain prerouting {
>         	type filter hook prerouting priority -150; policy accept;
> 		socket transparent 1 socket wildcard 0 mark set 0x00000001
> 	}
> }
> 
> This patch effectively depends on its counterpart in the kernel.

Applied, thanks.
