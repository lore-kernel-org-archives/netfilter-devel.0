From: Steven Jan Springl <steven@springl.ukfsn.org>
Subject: Negation bug.
Date: Sat, 4 Apr 2009 21:00:33 +0100
Message-ID: <200904042100.34124.steven@springl.ukfsn.org>
References: <49C8DB3B.909@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.springl.ukfsn.org ([84.45.199.6]:50730 "EHLO
	mail.springl.ukfsn.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbZDDUAi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Apr 2009 16:00:38 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.springl.ukfsn.org (Postfix) with ESMTP id 0C4B421301
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Apr 2009 21:00:35 +0100 (BST)
Received: from mail.springl.ukfsn.org ([127.0.0.1])
	by localhost (l2.home [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7M7AM3DQWI8c for <netfilter-devel@vger.kernel.org>;
	Sat,  4 Apr 2009 21:00:34 +0100 (BST)
Received: from l3.home (l3.home [IPv6:2002:542d:c701:1:250:daff:fe6d:bbdd])
	by mail.springl.ukfsn.org (Postfix) with ESMTP id 6B6DF21300
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Apr 2009 21:00:34 +0100 (BST)
In-Reply-To: <49C8DB3B.909@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the following iptables rule is entered:

-A FORWARD  -p 6  -m conntrack  ! --ctorigdst 4.3.2.2  -j ACCEPT

If an iptables-save is then issued, the rule is listed but the "!" is missing.

Steven.



