From: David Miller <davem@davemloft.net>
Subject: rules matching ipv6 prefix addrs
Date: Tue, 02 Nov 2010 13:52:54 -0700 (PDT)
Message-ID: <20101102.135254.226783976.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53844
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752111Ab0KBUwa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Nov 2010 16:52:30 -0400
Received: from localhost (localhost [127.0.0.1])
	by sunset.davemloft.net (Postfix) with ESMTP id 6B10F24C08A
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2010 13:52:54 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


H. Peter Anvin just mentioned something interesting to me,
basically it's the fact that when your prefix addresses
change on an interface in ipv6, this can invalidate your
netfilter rules.

So it would be nice if there were some way to match "the
ipv6 prefix address on interface X", and through some
kind of caching this could be optimized so it wouldn't
really cost anything.

Thoughts?
