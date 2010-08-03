From: m <martinbarrowcliff@gmail.com>
Subject: nfqueue
Date: Tue, 03 Aug 2010 13:01:54 -0400
Message-ID: <4C584B82.2090907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54220 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab0HCRDG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:03:06 -0400
Received: by gxk23 with SMTP id 23so1668353gxk.19
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Aug 2010 10:03:04 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have used both Snort and Suricata inline on my firewall.
With snort I use ip_queue, and with Suricata I use nf_queue.
Both seem to function in the same manner.

example:

iptables -t raw -I PREROUTING -j QUEUE

or

iptables -t raw -I PREROUTING -j NFQUEUE 1

After that I never see any further traffic in the raw table, despite 
there might be a lot more rules to traverse. The -j never returns.
Instead the traffic magically reappears in the mangle table.
To make this function correctly I add that rule at the end of the table
where I rely on Snort/Suricata to report disposition.

I have tried this in all tables and saw the same results but the 
application is processing the packets...

Either I am missing something very important, or this is an issue, AKA 
bug. Not sure what I need to work on to fix it.
Suggestions?

Marty B.


