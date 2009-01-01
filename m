From: ilninno <ilninno@gmail.com>
Subject: How can i leave a packet to continue the iptables ruleset checking?
Date: Thu, 1 Jan 2009 21:55:39 +0100
Message-ID: <92770c820901011255y76b557b7ha4850c54fd62b28e@mail.gmail.com>
References: <92770c820812231302q709cba94ua93e0ec210a906a1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.187]:15843 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbZAAUzm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Jan 2009 15:55:42 -0500
Received: by rn-out-0910.google.com with SMTP id k40so4118349rnd.17
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Jan 2009 12:55:40 -0800 (PST)
In-Reply-To: <92770c820812231302q709cba94ua93e0ec210a906a1@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello! I have some problems with netfilter_queue:

I created a queue and registered my c program, when a packet matchs
with the iptables rules my code get the event. i usually return
NF_ACCEPT and NF_DROP, but sometimes i need to leave the packet to
continue with iptables rules checking, i tried with:

1- Using NF_QUEUE: WIth this option the packet enter again in iptables
rules (from rule 1 to NFQUEUE rule), but i only want to check (from
NFQUEUE rule to end).


rule:   $IPTABLES -A OUTPUT -m state --state NEW -j NFQUEUE --queue-num 0



How can i leave the packet to continue in iptables ruleset without
beginning again?  Thanks for your time.


Please, someone can help me
