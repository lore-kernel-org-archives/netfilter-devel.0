From: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [RFC] setting up throughput threshold indications to userspace
Date: Fri, 16 Jul 2010 11:20:31 +0300
Message-ID: <1279268431.1603.44.camel@powerslave>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Changli Gao <xiaosuo@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:30537 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935937Ab0GPIU7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jul 2010 04:20:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I've been trying to set up some rules that will send indications to the
userspace about the current throughput of a certain interface.  The idea
is to let the userspace enable or disable WLAN PS mode accordingly (the
validity of this idea is another subject ;).

This is related to the discussion we had in the thread about the NFNOTIF
thread.

I'm thinking about having this kind of ruleset:

-A INPUT -j throughput 
-A above -m connmark --mark 0x1 -j RETURN 
-A above -m rateest --rateest throughput --rateest-bps1 0bit --rateest-bps2 1000bit --rateest-gt -j LOG --log-prefix "ABOVE" 
-A above -m rateest --rateest throughput --rateest-bps1 0bit --rateest-bps2 1000bit --rateest-gt -j CONNMARK --set-xmark 0x1/0xffffffff 
-A below -m connmark --mark 0x2 -j RETURN 
-A below -m rateest --rateest throughput --rateest-bps1 0bit --rateest-bps2 1000bit --rateest-lt -j LOG --log-prefix "BELOW" 
-A below -m rateest --rateest throughput --rateest-bps1 0bit --rateest-bps2 1000bit --rateest-lt -j CONNMARK --set-xmark 0x2/0xffffffff 
-A throughput -j RATEEST --rateest-name throughput --rateest-interval 250.0ms --rateest-ewmalog 500.0ms 
-A throughput -j above 
-A throughput -j below 

I'm using a normal LOG just for simplicity reasons, in real life I'd use
NFLOG instead.

The idea here is that all packets would be collected by RATEEST for rate
estimation and then I'd check whether the throughput is above the
threshold.  If it is, I mark it as such and print the log.  Same thing
for below the threshold.  The RETURN rules are there to prevent more LOG
messages from being printed (what I need is to know only when the
throughput "crosses" the threshold).

Do you think this works?

There is one problem with this solution, which is that it works in a
per-connection basis (due to CONNMARK).  This is not exactly what I
want.  I need to have this on a per-ruleset basis.  For that, I need to
have a MARK (variable?) which can be set independently of connections or
packets.  This is similar to the proposed condition match, but what is
missing there is a way to set the condition with iptables itself,
without requiring the userspace to change the procfs file.  This could
probably be achieved with a "CONDITION" target or something similar.
Any ideas?


-- 
Cheers,
Luca.

