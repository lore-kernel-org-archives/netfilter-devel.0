From: ilninno <ilninno@gmail.com>
Subject: Please i need help with this error, hunting bugs
Date: Sat, 31 Jan 2009 22:19:58 +0100
Message-ID: <92770c820901311319q2a35ca0fnd42112ab9b3db6fe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.185]:46258 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZAaVUB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 31 Jan 2009 16:20:01 -0500
Received: by rn-out-0910.google.com with SMTP id k40so678118rnd.17
        for <netfilter-devel@vger.kernel.org>; Sat, 31 Jan 2009 13:19:59 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello again.


I tested the issue in different examples:

1- When using NF_REPEAT with only 1 queue, there isnt any problem
   $IPTABLES -A OUTPUT -m state --state NEW -m mark ! --mark 1 -j NF_QUEUE 0
   $IPTABLES -A OUTPUT -j ACCEPT

2- When using NF_REPEAT with (program 1 in queue 0 and program 2 in queue 1)

                $IPTABLES -A OUTPUT -m state --state NEW -m mark !
--mark 1 -j NF_QUEUE 0
                $IPTABLES -A OUTPUT -m state --state NEW -m mark
--mark 1 -j NF_QUEUE 1

then i got kernel panic. I think the problem is that using
nfq_set_verdict_mark(myQueue, id, NF_REPEAT, htonl(1) ,0, NULL)  don't
modify packet length and kernel freezes, but im not sure, im newbie
please help me.
