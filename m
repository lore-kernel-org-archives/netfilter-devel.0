Return-Path: <SRS0=M6WU=7W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 053A9C433E2
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 10:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B54F9207F9
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 10:46:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=openfortress.nl header.i=rick@openfortress.nl header.b="X6SlcR26"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgFIKqt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Jun 2020 06:46:49 -0400
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:59741 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727995AbgFIKqt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jun 2020 06:46:49 -0400
Received: from popmini.vanrein.org ([IPv6:2001:980:93a5:1::7])
        by smtp-cloud7.xs4all.net with ESMTP
        id ibmEjSoXzNp2zibmFjk02O; Tue, 09 Jun 2020 12:46:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=openfortress.nl; 
 i=rick@openfortress.nl; q=dns/txt; s=fame; t=1591699602; 
 h=message-id : date : from : mime-version : to : cc : 
 subject : references : in-reply-to : content-type : 
 content-transfer-encoding : date : from : subject; 
 bh=QGDQaBerjib9Mc4KeW8PHPtDtrxQgBpyL8wEw33Bu8U=; 
 b=X6SlcR26aN+s+09bMwi8YBKjUAkMKJyMgVNpY5SDbqioKL5rcguZuVjO
 s1l0pI7P0Lw3RyYnmuzExg51DmPOBg0QQvT/JfDJDfl6bsex7d0CSPiuFH
 S4KEgF98NkF1VyPm5Nd23pLXcWl4h5ZqJHY0yk1xRBhwxb3HLlGv92ccI=
Received: by fame.vanrein.org (Postfix, from userid 1006)
        id 2FE283D15E; Tue,  9 Jun 2020 10:46:41 +0000 (UTC)
Received: from airhead.fritz.box (phantom.vanrein.org [83.161.146.46])
        by fame.vanrein.org (Postfix) with ESMTPA id E28163CDB0;
        Tue,  9 Jun 2020 10:46:36 +0000 (UTC)
Message-ID: <5EDF687A.6020801@openfortress.nl>
Date:   Tue, 09 Jun 2020 12:46:18 +0200
From:   Rick van Rein <rick@openfortress.nl>
User-Agent: Postbox 3.0.11 (Macintosh/20140602)
MIME-Version: 1.0
To:     Florian Westphal <fw@strlen.de>
CC:     netfilter-devel@vger.kernel.org
Subject: Re: Extensions for ICMP[6] with sport, dport
References: <5EDE75D5.7020303@openfortress.nl> <20200609094159.GA21317@breakpoint.cc>
In-Reply-To: <20200609094159.GA21317@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Bogosity: Unsure, tests=bogofilter, spamicity=0.520000, version=1.2.4
X-CMAE-Envelope: MS4wfDfwQo/f1GKR5gek+SFMgc2JZKS44Y/+BrE3q+kdw6gykZSBgdN+hJKMdTS97HGy62kBbmXyyJhwmmlFwJbWNnszNxtt7pIF4tcBYsOxWK0wdCxD3Pa0
 1SPYWewmERSbqOMIDqLZeiU7qmMRZBX137DYyEFl+pIPiaxGOiKOuPkvHCWX2Z4zjQl6zHHGZ45WPp27aGUxvUnhTs9NkjKT+Zg=
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hey Florian,

You are generalising ICMP matching to tunnel matching, and then conclude that it is quite complex.

Yes, there is some overlap, but ICMP is also quite different:

 - Encapsulated traffic travels in reverse compared to a tunnel
 - ICMP-contained content must be NAT-reversed, unlike tunnel content
 - ICMP carries cut-off headers: IP header + 8 bytes of its payload
 - In practice, the contents of interest would be ip|ip6 and th
 - References "icmp ip" and "icmp th" are simple-yet-enough
 - General tunnel logic may be less efficient?

I originally proposed to treat ICMP as a side-case to TCP et al, but that won't fly.  There's also an embedded saddr/daddr pair to be treated.  This also means that the silent reversal of sport/dport is not needed, which is a relief.

> I think instead of this specific use case it would be preferrable to
> tackle this in a more general way, via more generic "ip - in foo"
> matching.

Given the differences above, do you still think so?

I would argue that these provide (not 100% hard) reasons to treat ICMP differently from tunnels.  Possibly syntaxes, in line with what "nft" does now, could say things like

ip protocol icmp
icmp protocol { tcp, udp, sctp, dccp }
icmp th daddr set
   icmp th dport map @my-nat-map

This looks like an extension of the nft command, under my assumption that it computes fixed offsets.  There may be more trouble with two-variable comparisons, which would cover paranoid checks like

icmp daddr = saddr
icmp saddr = daddr
icmp th dport = sport
icmp th sport = dport


If this ends up being kernel work, then I'm afraid I will have to let go.


Thanks,
 -Rick
