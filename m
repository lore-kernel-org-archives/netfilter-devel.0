From: Saikiran Madugula <hummerbliss@gmail.com>
Subject: Question about CTA_NAT_SEQ_UNSPEC
Date: Mon, 03 Aug 2009 11:25:21 +0100
Message-ID: <4A76BB11.7050507@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52988 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbZHCKZY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Aug 2009 06:25:24 -0400
Received: by ewy10 with SMTP id 10so2898229ewy.37
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Aug 2009 03:25:23 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Was checking diff of libnetfilter_conntrack/include/linux_nfnetlink_conntrack.h
and stable linux-2.6.27.y/include/linux/netfilter/nfnetlink_conntrack.h and the
latter is missing CTA_NAT_SEQ_UNSPEC which seems to have been fixed in the
Commit 092cab7e2cd868cb0b30209a0337689c3ffd6133     netfilter: ctnetlink: fix
missing CTA_NAT_SEQ_UNSPEC.

Should this fix be also in .27 stable tree ? I haven't tested it but curious.
