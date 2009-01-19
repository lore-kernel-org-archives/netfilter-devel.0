From: Simon Labrecque <simon@clubbeadplus.com>
Subject: Permit *any* destination port from source ip
Date: Mon, 19 Jan 2009 15:11:11 -0500
Message-ID: <C59A488F.D281%simon@clubbeadplus.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from simmts12-qfe0.srvr.bell.ca ([206.47.199.141]:59129 "EHLO
	simmts12-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751603AbZASULP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:11:15 -0500
Received: from simip10-ac.srvr.bell.ca ([206.47.199.89])
          by simmts12-srv.bellnexxia.net
          (InterMail vM.5.01.06.13 201-253-122-130-113-20050324) with ESMTP
          id <20090119201113.ORXA1599.simmts12-srv.bellnexxia.net@simip10-ac.srvr.bell.ca>
          for <netfilter-devel@vger.kernel.org>;
          Mon, 19 Jan 2009 15:11:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

   I would like to have a specific connection act like an "authentication"
service; that is, when a connection to a specific port is made and once the
required data has passed between the 2 hosts, the client is now
authenticated, permitting access to other network services which are flagged
with the RELATED state (and not the NEW one).

   I implemented this in a very simple conntrack module. For example, I can
use something like when the module is in place:

iptables -A INPUT -p tcp --dport 22 -m state --state ESTABLISHED,RELATED -j
ACCEPT

   ...and it works once the "parent" connection has "authenticated" the
client.

   However, currently it seems I can only specify 1 single destination port
in the expectation (this would be port 22 in my example above), wherever I
would like to be able to support *any* port (as we can with the source
port). The filtering would then be made using subsequent iptables rules.

   Is this possible? It seems it was possible a while ago (while
exp->mask.dst was still present), but this was removed and I don't see how I
can achieve the same functionality with the current structures. Am I missing
something?


   Thanks a lot!
-- 
Simon Labrecque


