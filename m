From: Patrick Schaaf <netdev@bof.de>
Subject: Re: nftables with ipset combined types
Date: Wed, 29 Jan 2014 12:34:12 +0100
Message-ID: <24843182.8UhhjTCEZr@rofl>
References: <52E8AD76.5050808@aim.com> <20140129093010.GA4332@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mars.intermailgate.com ([80.242.145.70]:43276 "EHLO
	mars.intermailgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbaA2Lk4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jan 2014 06:40:56 -0500
In-Reply-To: <20140129093010.GA4332@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

another useful feature of ipset is that the same set is usable in the
filter, nat, and mangle tables.

If I'm not mistaken, sets in nftables are right now scoped within a table,
so I could not reuse them in that fashion.

Am I mistaken? Or, is that another thing on the invisible roadmap? :)

best regards
  Patrick
