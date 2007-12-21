From: Jesper Dangaard Brouer <jdb@comx.dk>
Subject: [PATCH 0/3] Solve scalability issue for chain list "name" searching
Date: Fri, 21 Dec 2007 14:44:19 +0100
Message-ID: <1198244659.23885.8.camel@localhost.localdomain>
Reply-To: jdb@comx.dk
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Martin Josefsson <gandalf@netfilter.org>,
	Jesper Dangaard Brouer <jdb@comx.dk>
To: Netfilter Developers <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:46389 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbXLUNs7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Dec 2007 08:48:59 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Primary focus, of this patch set, is to solve a scalability issue; For
chain list "name" searching. Functions:
iptcc_find_label(),iptc_is_chain().

It also includes a patch for inline'ing some functions, and
introducing a chain counter.

The main patch still include some debugging print statements, that can
be enabled by defining "DEBUG" when compiling the code.  This kept to
allow an easier code review.

The patches and test scripts, can also be found here:
 http://people.netfilter.org/hawk/patches/scalability/bsearch/

The patches are tested against SVN r7147.

-- 
Med venlig hilsen / Best regards
  Jesper Brouer
  ComX Networks A/S
  Linux Network developer
  Cand. Scient Datalog / MSc.
  Author of http://adsl-optimizer.dk
  LinkedIn: http://www.linkedin.com/in/brouer
