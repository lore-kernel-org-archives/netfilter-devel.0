From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: Matching MLD with ip6tables
Date: Fri, 1 May 2015 04:56:12 +0200
Message-ID: <20150501025612.GB2465@odroid>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.passe0815.de ([188.40.49.9]:44050 "EHLO mail.passe0815.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbbEADD7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Apr 2015 23:03:59 -0400
Received: from mail.passe0815.de (localhost [127.0.0.1])
	by mail.passe0815.de (Postfix) with ESMTP id 9269F586503
	for <netfilter-devel@vger.kernel.org>; Fri,  1 May 2015 04:56:13 +0200 (CEST)
Received: from localhost (unknown [IPv6:2001:67c:2d50:0:b571:10f4:7627:69e7])
 (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
 (No client certificate requested)
 by mail.passe0815.de (Postfix) with ESMTPSA id A3E7C586502
 for <netfilter-devel@vger.kernel.org>; Fri,  1 May 2015 04:56:12 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

According to RFC4890 ("Recommendations for Filtering ICMPv6
Messages in Firewalls"), page 35, a rule like this should match
MLD packets:

$ ip6tables -A icmpv6-filter -p icmpv6 --icmpv6-type {130,131,132,143} ...

However, this does not seem to work for me. My guess is that it
does not match because --protocol is not 'icmpv6' but actually
the hop-by-hop-option first. Is this a bug in the RFC (and if so,
should I report it on some IETF mailing list?)?

Also, is there a way to somehow match IPv6 protocols with IPv6
options in between?

Cheers, Linus
