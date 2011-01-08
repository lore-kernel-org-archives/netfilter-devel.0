From: Steven Jan Springl <steven@springl.ukfsn.org>
Subject: Possible bug with ip6tables hl module.
Date: Sat, 8 Jan 2011 00:38:34 +0000
Message-ID: <201101080038.34932.steven@springl.ukfsn.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.springl.ukfsn.org ([84.45.199.6]:41650 "EHLO
	mail.springl.ukfsn.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab1AHAqd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Jan 2011 19:46:33 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.springl.ukfsn.org (Postfix) with ESMTP id D21CC20D2F
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Jan 2011 00:38:35 +0000 (GMT)
Received: from mail.springl.ukfsn.org ([127.0.0.1])
	by localhost (l2.home [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ji4Q5VGDZUdi for <netfilter-devel@vger.kernel.org>;
	Sat,  8 Jan 2011 00:38:35 +0000 (GMT)
Received: from l3.home (l3.home [IPv6:2001:4d48:ad51:24:250:daff:fe6d:bbdd])
	by mail.springl.ukfsn.org (Postfix) with ESMTP id 2443520D20
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Jan 2011 00:38:35 +0000 (GMT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello

I am using ip6tables 1.4.10 and kernel 2.6.37.

If I type the following command:

ip6tables -A INPUT -m length --length 100 -m hl --hl-gt 100 -j ACCEPT

It works.

If I swap the length and hl options around:

ip6tables -A INPUT -m hl --hl-gt 100 -m length --length 100 -j ACCEPT

It fails with the following message:

ip6tables v1.4.10: Can't specify HL option twice

Steven.


