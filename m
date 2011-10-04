From: Manikandan R <mani.agape@gmail.com>
Subject: Reg:Conntrack-tool for packet dropping?
Date: Tue, 4 Oct 2011 19:39:03 +0530
Message-ID: <CAAG0ft4=CaBsdVxKApmvaBhP06xr+1522=Xcwo9O_59zSWunBA@mail.gmail.com>
References: <CAAG0ft6yyx+PzcvxpfsnCTok7U+cdx3mnsU4gyJMk=zqCOn45A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33749 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab1JDOJE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Oct 2011 10:09:04 -0400
Received: by vcbfk10 with SMTP id fk10so370994vcb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Oct 2011 07:09:04 -0700 (PDT)
In-Reply-To: <CAAG0ft6yyx+PzcvxpfsnCTok7U+cdx3mnsU4gyJMk=zqCOn45A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hi,
    I am developing application monitoring tool. When I gothru
http://netfilter.org/, I come to know about the conntrack-tool which
can be used for monitoring new connection.
    I used "conntrackd"(conntrack deamon) for monitoring the packets.
Using nfct_callback_register2() am able to handle new packets also,
but I need to drop this packet if its related to particular
pid/process. Is there is any way/api to drop packets?

   Hope am clear about my need, Thanks in advance.

 Regards,
 Manikandan R
