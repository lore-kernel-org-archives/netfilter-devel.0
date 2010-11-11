From: Jan Kasprzak <kas@fi.muni.cz>
Subject: Re: iptables: Resource temporarily unavailable.
Date: Thu, 11 Nov 2010 19:03:05 +0100
Message-ID: <20101111180305.GD20871@fi.muni.cz>
References: <20101111150055.GI15421@fi.muni.cz> <1289489728.17691.1331.camel@edumazet-laptop> <4CDC1263.8070206@trash.net> <20101111172511.GB20871@fi.muni.cz> <1289498295.17691.1589.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from minas.ics.muni.cz ([147.251.4.40]:44212 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381Ab0KKSDJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:03:09 -0500
Content-Disposition: inline
In-Reply-To: <1289498295.17691.1589.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet wrote:
: > 	There probably can be some other iptables commands running
: > occasionally (automatic blacklisting of some IP addresses, enabling
: > traffic to authenticated laptops, etc.), but not in the chains I am
: > trying to modify with my firewall initscript. Can this also be a problem?
: 
: Yes it is a problem. iptables manipulates the whole table, not a
: subtree.

	So do you suggest I should implement some kind of user-space
locking, or is the current approach of "retry after 1 sec when it fails"
OK from the kernel point of view?

	Thanks,

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
Please don't top post and in particular don't attach entire digests to your
mail or we'll all soon be using bittorrent to read the list.     --Alan Cox
