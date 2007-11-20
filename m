From: Jesper Dangaard Brouer <jdb@comx.dk>
Subject: [FIX] Re: Make/compile error for iptables-1.4.0rc1
Date: Wed, 21 Nov 2007 00:10:42 +0100
Message-ID: <1195600242.1228.7.camel@localhost.localdomain>
References: <1195245146.15945.50.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0711162234000.21235@fbirervta.pbzchgretzou.qr>
	 <1195390182.15945.57.camel@localhost.localdomain>
	 <1195395787.15945.77.camel@localhost.localdomain>
Reply-To: jdb@comx.dk
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>
To: yasuyuki@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:32826 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbXKTXMJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:12:09 -0500
In-Reply-To: <1195395787.15945.77.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


The problem is that "linux/netfilter/x_tables.h" got included in SVN
(changeset 6920).  The fix is to delete it from SVN, so that the systems
"x_tables.h" has effect again.

Can someone with SVN write access fix this?

  "svn rm include/linux/netfilter/x_tables.h"

-- 
Med venlig hilsen / Best regards
  Jesper Brouer
  ComX Networks A/S
  Linux Network developer
  Cand. Scient Datalog / MSc.
  Author of http://adsl-optimizer.dk
  LinkedIn: http://www.linkedin.com/in/brouer
