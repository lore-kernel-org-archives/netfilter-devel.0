From: Phil Oester <kernel@linuxace.com>
Subject: ip6_finish_output2 change broke netfilter xt_TEE target
Date: Tue, 17 Sep 2013 12:54:34 -0700
Message-ID: <20130917195434.GA8424@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: yoshfuji@linux-ipv6.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34341 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab3IQTyN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Sep 2013 15:54:13 -0400
Received: by mail-pd0-f179.google.com with SMTP id v10so6095055pde.10
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Sep 2013 12:54:13 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The change made in commit 6fd6ce20 (ipv6: Do not depend on rt->n in
ip6_finish_output2) broke the xt_TEE target for IPv6 packets.  Instead
of using the nexthop provided in the --gateway option, ip6_finish_output2
is now performing neighbor solicitation for the original daddr in the
copied skb.

Similar breakage occurred in IPv4, and was fixed (in 2ad5b9e4) by using
the flag FLOWI_FLAG_KNOWN_NH.  I can find no easy way to make use of that
flag here.  Reverting 6fd6ce20 makes TEE work again, but I am not clear
on what problem that commit was attempting to solve.  Yoshifuji?

Phil

