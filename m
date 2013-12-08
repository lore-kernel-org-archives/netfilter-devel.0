From: "Nicki P." <xastx@gmx.de>
Subject: ipt_SYNPROXY: kernel panic caused by nullpointer dereference
Date: Sun, 8 Dec 2013 08:16:00 +0100
Message-ID: <e9d26e1c009f406b1bb5a893aebc7771.squirrel@webmail.interwerk.de>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx.interwerk.de ([188.40.98.140]:46395 "EHLO mx.interwerk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab3LHHYs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Dec 2013 02:24:48 -0500
Received: from mx.interwerk.de (localhost [127.0.0.1])
	by mx.interwerk.de (Postfix) with ESMTP id C411BC3C254A2
	for <netfilter-devel@vger.kernel.org>; Sun,  8 Dec 2013 08:16:00 +0100 (CET)
Received: from webmail.interwerk.de (localhost [127.0.0.1])
	by mx.interwerk.de (Postfix) with ESMTP id 93670C3C254A1
	for <netfilter-devel@vger.kernel.org>; Sun,  8 Dec 2013 08:16:00 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hi,

when activating ipt_SYNPROXY with:
iptables -t raw -A PREROUTING -p tcp -d 1.2.3.4 --dport 80 --tcp-flags
SYN,ACK,RST,FIN SYN -j SYNPROXY

and sending a SYN packet to port 80:
hping3 -S -d 64 1.2.3.4 -p 80

I get kernel panic:
http://goo.gl/L6dCz6

I'm using kernel v3.12.2 and iptables v1.4.21. Am I doing something wrong,
or is it a bug?

thank you for help beforehand :)

greetings,
nicki



