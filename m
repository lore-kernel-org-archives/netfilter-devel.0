From: Balazs Scheidler <balazs.scheidler@balabit.com>
Subject: nftables: parser conflict between tokens & symbols
Date: Fri, 26 Jun 2015 14:44:23 +0200
Message-ID: <20150626124423.GB5835@bzorp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 5E1BE96B.mobile.pool.telekom.hu ([94.27.233.107]:50142 "EHLO
	bzorp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752751AbbF0M1c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Jun 2015 08:27:32 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I've noticed that our set of keywords in nftables is pretty rich and
this can cause conflicts in the grammar when a keyword is also used
as a symbol.

For instance, we do have a "redirect" expression and "redirect" as
a word is also used as an ICMP message type.

# here is the redirect expression in action, which works:
$ nft add rule tcp dport 80 redirect to 8080

# here's an ICMP rule that works
$ nft add rule filter input icmp type echo-request accept

# here's an ICMP rule that should work, but it doesn't
$ nft add rule filter input icmp type redirect accept

The root cause is that "redirect" is now recognized as a token, whereas the
icmp type is expecting a STRING token.

I have tried to solve this but the idea I had didn't work out, and I don't
really have more time now to fix it, but still thought this information
would be useful.

Cheers,
Bazsi
