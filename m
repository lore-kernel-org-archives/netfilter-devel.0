From: Karel Rericha <karel@maxtel.cz>
Subject: Extending class handle from 16bit to 32bit
Date: Thu, 28 Feb 2013 14:49:28 +0100
Message-ID: <CAN==1RrDHivRrzE1FKcDykRkgh2Obp+XC+5NEeuOE0NWJ=cn_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:40337 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab3B1Nt3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2013 08:49:29 -0500
Received: by mail-bk0-f52.google.com with SMTP id jk13so847365bkc.39
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Feb 2013 05:49:28 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

we are about to hit the 16bit limit for number of qdisc classes (we
have over 40k classes in one qdisc). Currently there is 32bit handle,
which htb and hfsc interpret as 16bit qdisc and 16bit class. We would
like to extend the 16bit class handle and considering two approaches:

a) low effort
Fork hfsc and in forked hfsc interpret 32bit handle as 8bit qdisc and
24bit class.
- not "clean" solution, no chance to accept to mainstream IMHO
- requires just fork hfsc and add support for forked hfsc to iptables ???

b) extensive way
Extend handle to 64bit, intepret as 32bit qdisc and 32bit class.
- need to touch all qdisc to work with 64bit handle
- same apply for iptables, make it work with 64bit handle
- add some compatibility layer for software depending on 32bit ?
- what about different architectures than x86 ?

Does anyone have any idea/experience how to solve this ?

We are open to offer bounty for actuall programming work as soon as
the right way will be chosen.

Thanks for suggestions,

Karel Rericha
ISP Alliance a.s.
Czech Republic
