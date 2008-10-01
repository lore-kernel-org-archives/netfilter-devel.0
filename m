From: Christoph Paasch <christoph.paasch@gmail.com>
Subject: Connection Protocol in the state?
Date: Wed, 1 Oct 2008 22:06:52 +0200
Message-ID: <200810012206.52512.christoph.paasch@gmail.com>
Reply-To: Christoph Paasch <christoph.paasch@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:55508 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYJAUG5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Oct 2008 16:06:57 -0400
Received: by ey-out-2122.google.com with SMTP id 6so260539eyi.37
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Oct 2008 13:06:56 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I would like to know, that if I have a filter like the one shown below 
(allowing outgoing connections of every protocol-type), does netfilter stores 
in the state of the established outgoing connection also the protocol which 
established the connection? (TCP, UDP, ....) Or does it opens the connection 
for any protocol?

iptables -A FORWARD -i eth0 --ctstate NEW, RELATED, ESTABLISHED -j ACCEPT


Thanks in advance

-- 
Christoph Paasch

www.rollerbulls.be
--

