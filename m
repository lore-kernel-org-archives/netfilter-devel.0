Return-Path: <SRS0=+9KY=7U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62B4CC433DF
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jun 2020 05:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBB012067B
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jun 2020 05:09:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=openfortress.nl header.i=rick@openfortress.nl header.b="egAVkYyd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgFGFJQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Jun 2020 01:09:16 -0400
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:56431 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725998AbgFGFJQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jun 2020 01:09:16 -0400
Received: from popmini.vanrein.org ([IPv6:2001:980:93a5:1::7])
        by smtp-cloud7.xs4all.net with ESMTP
        id hnYXjEb5PNp2zhnYYjPX4m; Sun, 07 Jun 2020 07:09:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=openfortress.nl; 
 i=rick@openfortress.nl; q=dns/txt; s=fame; t=1591506552; 
 h=message-id : date : from : mime-version : to : subject 
 : content-type : content-transfer-encoding : date : from 
 : subject; 
 bh=+3s/chQXJMjBf9ntrRCG+2InpiF5rySTXlyVFgFC8m8=; 
 b=egAVkYydDYPewLofaNCow9DopjlUlKJqTkHOYx01amUWJeimUHMLH+9X
 R/eqySW2Zqz61FlX8iBnVAShr9MCfx9Y4wl4Tk2dLlKqzmxxZSSQlOr5R5
 KjAo5eWidN8OiTxDomDou2bnPTYBNjInIQ6aQf8TRhgiHZWd588EO0UZ8=
Received: by fame.vanrein.org (Postfix, from userid 1006)
        id 95DE13CE2D; Sun,  7 Jun 2020 05:09:12 +0000 (UTC)
Received: from airhead.fritz.box (phantom.vanrein.org [83.161.146.46])
        by fame.vanrein.org (Postfix) with ESMTPA id 738073CE28;
        Sun,  7 Jun 2020 05:09:06 +0000 (UTC)
Message-ID: <5EDC7662.1070002@openfortress.nl>
Date:   Sun, 07 Jun 2020 07:08:50 +0200
From:   Rick van Rein <rick@openfortress.nl>
User-Agent: Postbox 3.0.11 (Macintosh/20140602)
MIME-Version: 1.0
To:     netfilter-devel@vger.kernel.org
Subject: Expressive limitation: (daddr,dport) <--> (daddr',dport')
X-Enigmail-Version: 1.2.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Bogosity: Unsure, tests=bogofilter, spamicity=0.520000, version=1.2.4
X-CMAE-Envelope: MS4wfNYvmrGuyICK42ufhcio2pYtGMraXLherZKqdgPkhW+OC5HmReR5cBxiiNzqavpuEOJ06O1JuW0IEIYoV1LEzPVBDD20wcxXUwoAJEqPrMvl2ekHWdFY
 8JzEZHOh4JgCiM40xZkohChIO42TSOJCwagRK06DUYfQFhc6kup2/9fXJhMo9ejDFZt13NjYelx/QyD+0KC+woAyvXukkUWoULw=
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

I seem to be running into an expressive limitation of nft while trying
to do stateless translation.  I prefer statelessness because it it is
clearer for bidirectionality / peering, and saves lookup times.

After nat64, I have a small set of IPv6 addresses and I would like to
map their (daddr,dport) or better even (daddr,proto,dport) tuples to
outgoing (daddr',dport').  Effectively, port forwarding for IPv6.

Individual rules work, like this one side of a bidir portmap:

nft add rule ip6 raw prerouting \
   ip6 daddr $PREFIX::64:75 \
   tcp dport 8080 \
   ip6 daddr set $PREFIX::100:20 \
   tcp dport set 80 \
   notrack

I have problems doing this with the map construct, presumably because it
does not atomically replace (daddr,dport) by (daddr',dport') but instead
does two assignments with intermediate alterede state.  This is bound to
work in many cases, but it can give undesired crossover behaviours
[namely between incoming IPs if they map to the same daddr' while coming
from the same dport]:

nft add rule ip6 raw prerouting \
   ip6 daddr set \
      ip6 daddr . tcp dport \
         map { $PREFIX::64:75 . 8080 : $PREFIX::100:20 } \
   tcp dport set \
      ip6 daddr . tcp dport \
         map { $PREFIX::100:20 . 8080 : 80 } \
   notrack

So now I am wondering,

 0. Is there a way to use maps as atomic setter for (daddr,dport)?
 1. Can I reach back to the original value of a just-modified value?
 2. Is there a variable, or stack, to prepare with the old value?

Without this, I need to work around an expressive limitation,

 * Fan out from a few IPv6 to many first to minimise rule clashes
 * Make separate maps and rules and maps for each of the IPv6 addresses

Both sound to me like a lack of expressiveness, or that I missed how.

Thanks!
 -Rick
