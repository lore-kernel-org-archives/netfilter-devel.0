From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Subject: Every other char with LOG netfilter output (bug?)
Date: Tue, 28 Oct 2008 15:09:02 -0200
Message-ID: <rlujt5-k63.ln1@tux.abusar.org.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:58402 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbYJ1R2c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:28:32 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KusMn-0004iX-Rr
	for netfilter-devel@vger.kernel.org; Tue, 28 Oct 2008 17:28:29 +0000
Received: from c934d65e.virtua.com.br ([201.52.214.94])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2008 17:28:29 +0000
Received: from fragabr by c934d65e.virtua.com.br with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2008 17:28:29 +0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

	Since Linux kernel 2.6.25, I get stalled connections and when it happens, I have this on the log:

Oct 28 13:39:22 tux vmunix: 1:3e:79:01:fe:b2:80 R=9.6.. S=9.6.. E=9
O=x0PE=x0TL6 D410POOUPST10 P=41 E=7

	It seems that are missing chars here.

	A bug?

	Ps: in fact this issue seems to be much more complex than this. There's a huge thread we 
talked about those stalled connections, but we are unable to discover what causes this, so I opened 
this bug report:

http://bugzilla.kernel.org/show_bug.cgi?id=11588

	At least if netfilter developers could figure it out why the above log line happens, maybe we 
could trace this bug and solve it.

	Thank you!

	Ps: I tested with 2.6.28-rc2 and the problem remains.

-- 
Linux 2.6.28-rc2: Killer Bat of Doom
http://u-br.net


