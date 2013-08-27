From: "Laurence J. Lane" <ljlane@debian.org>
Subject: spurious errors with protocol names used as chain names
Date: Tue, 27 Aug 2013 15:53:40 -0400
Message-ID: <CA+0KVf39i-73Z1WR_jbPC2W-81TS2cvy0YhCmMm41VYJx+_F4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ankh.ljlane.net ([71.19.149.249]:41510 "EHLO ankh.ljlane.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab3H0TyE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Aug 2013 15:54:04 -0400
Received: from mail-vc0-f174.google.com (mail-vc0-f174.google.com [209.85.220.174])
	(using TLSv1 with cipher ECDHE-RSA-RC4-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: google-debian@ankh.ljlane.net)
	by ankh.ljlane.net (Postfix) with ESMTPSA id 8C8881177A
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Aug 2013 15:54:02 -0400 (EDT)
Received: by mail-vc0-f174.google.com with SMTP id gd11so3306358vcb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Aug 2013 12:54:01 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

http://bugs.debian.org/699537

Using a protocol name as user-defined chain name produces an error
when creating the chain or applying it as a target. The chain seem to
work fine despite the error. udplite and "all" do not produce an
error.

# iptables -N tcp
/lib/xtables/libxt_tcp.so: no "tcp" extension found for this protocol
# iptables -A INPUT -p tcp --dport 80 -j tcp
/lib/xtables/libxt_tcp.so: no "tcp" extension found for this protocol
