From: ilninno <ilninno@gmail.com>
Subject: How can i leave a packet to continue the iptables ruleset checking?
Date: Tue, 23 Dec 2008 22:02:04 +0100
Message-ID: <92770c820812231302q709cba94ua93e0ec210a906a1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:51948 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbYLWVCH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Dec 2008 16:02:07 -0500
Received: by yw-out-2324.google.com with SMTP id 9so925926ywe.1
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Dec 2008 13:02:05 -0800 (PST)
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
