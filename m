From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] ulogd 2.0.0beta2
Date: Fri, 15 Aug 2008 22:34:10 +0200
Message-ID: <48A5E842.8030407@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-announce@lists.netfilter.org,
	netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54649 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757573AbYHOVuB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 17:50:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi!

The netfilter project proudly presents:

  * ulogd 2.0.0beta2

ulogd is a userspace logging daemon for netfilter/iptables related
logging. This includes per-packet logging of security violations,
per-packet logging for accounting purpose as well as per-flow logging.

ulogd comes in two flavours: ulogd-1.x has been around since 2000 and is
the stable series. All production systems should use the stable series
at this time. The 1.x series are frozen, do not expect new features into
this line. ulogd-2.x is currently in beta stage.

You can download them from:

http://www.netfilter.org
ftp://ftp.netfilter.org

Enjoy,
Pablo - on behalf of the Netfilter Project.

Note: Sorry, this release does not include changelog, you can browse the
changes in the git tree, we expect to provide the changelog in the
upcoming releases. It is worth mention than most of the changeset comes
from Harald Welte and Eric Leblond.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

