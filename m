From: Anton <anton.vazir@gmail.com>
Subject: NFLOG - missing packets?
Date: Sat, 10 May 2008 16:57:44 +0500
Message-ID: <200805101657.45111.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>, Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:36178 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbYEJL55 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 May 2008 07:57:57 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello!

Just did several test on the ULOGD2 - via NFLOG, and 
confused about the amount of data logged to the database.

In the tests - I'm transferring 700Mb of data file, but sum 
of the field in DB (ulog2.ip_totlen) for transferred amount 
is ~280M. At the same time iptables -nL -v for the 
correspondinf iptables NFLOG enties - shows correct amount 
of matches - ~700Mb

Tryed to set --nflog-range 100 or 200 (100 should be is more 
than enough though) - with no luck. 

Kernel - 2.6.24 
iptables v 1.4.0
ulogd2 SVN - rev 7519 (checked today)
DB - Postgresql 8.3.0

ulogd - logs no errors
dmesg logs no errors
db logs no errors

Am I missing something or ULOGD2 do not insert all of the 
packets into the DB (so this should be bug?) ?

Regards,
Anton.

