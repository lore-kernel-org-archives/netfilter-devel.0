From: "Joonwoo Park" <joonwpark81@gmail.com>
Subject: [PATCH 0/8] textsearch: case insensitive pattern matching for netfilter
Date: Sat, 21 Jun 2008 00:54:55 -0700
Message-ID: <b25c3fa70806210054o74a46068ifa3b396662080265@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>, "Thomas Graf" <tgraf@suug.ch>,
	"Pablo Neira Ayuso" <pablo@netfilter.org>,
	"David Miller" <davem@davemloft.net>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:57421 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbYFUHy4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Jun 2008 03:54:56 -0400
Received: by rv-out-0506.google.com with SMTP id k40so6015109rvb.1
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Jun 2008 00:54:56 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

This patchset aim at supporting case insensitive text search for netfilter
string extension.
It contains fixing of Boyer-Moore algorithm and Knuth-Morris-Pratt algorithm.
Also this includes bug fixing of Boyer-Moore algorithm.

Please consider applying this patchset.

Thanks,
Joonwoo
