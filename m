From: Volker Poplawski <volker@openbios.org>
Subject: libnl: Unmatched NL_ACT_DEL and NL_ACT_CHANGE
Date: Sun, 5 Jul 2009 11:44:51 +0200
Message-ID: <200907051144.51967.volker@openbios.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from khepri.openbios.org ([80.190.231.112]:52663 "EHLO
	khepri.openbios.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbZGEJqo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jul 2009 05:46:44 -0400
Received: from x4120.x.pppool.de ([89.59.65.32] helo=thinkpad.localnet)
	by khepri.openbios.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <volker@openbios.org>)
	id 1MNOJ4-0006Bm-JY
	for netfilter-devel@vger.kernel.org; Sun, 05 Jul 2009 11:46:46 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all.

Could s.o. please  have a look at my (short) code at
http://pastie.org/534637

(maybe compile it with g++ -Wall test.c -o test -I ... -L ... -lnl -lnl-genl -
lnl-nf -lnl-route)

What the code does is to listen to changes in the ct-table using libnl. It 
keeps score of reported ctId in a lookup table.

Problem is: I'm getting a lot of NL_ACT_CHANGE & NL_ACT_DEL without having 
seen a matching NL_ACT_NEW. (Also there seems to be no initial cache fill)

kernel 2.6.27 (opensuse 11.1), libnl 2.0 (git master)

Greetings
....Volker





