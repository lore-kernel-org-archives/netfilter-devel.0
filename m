From: Thomas Jacob <jacob@internet24.de>
Subject: ulogd2/NFLOG: nfnetlink_log: error creating log nlmsg
Date: Wed, 20 May 2009 20:05:30 +0200
Message-ID: <1242842730.8076.60.camel@enterprise.ims-firmen.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout01.ims-firmen.de ([213.174.32.96]:53898 "EHLO
	mailout01.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbZETSFa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 May 2009 14:05:30 -0400
Received: from mailin02.ims-firmen.de ([192.168.1.111])
	by mailout01.ims-firmen.de with esmtp (Exim 4.69)
	(envelope-from <jacob@internet24.de>)
	id 1M6qAV-00053U-BO
	for netfilter-devel@vger.kernel.org; Wed, 20 May 2009 20:05:31 +0200
Received: from [213.174.32.254] (helo=[192.168.0.170])
	by mailin02.ims-firmen.de with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <jacob@internet24.de>)
	id 1M6qAV-0007jW-Aa
	for netfilter-devel@vger.kernel.org; Wed, 20 May 2009 20:05:31 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello List,

I am trying to get ulogd2 to log NFLOG-collected data
correctly, and am getting lots of "nfnetlink_log: error creating log
nlmsg" and only very few actual log entries.

As far as I can tell this happens when there is not enough skb_tailroom
for the log-message in __build_packet_message, but in
nfulnl_log_packet there also a check of skb_tailroom against a different
size value which is supposed to result in flushing messages if there
is no space.

Bug? Feature? If it's the latter, how can I prevent this from
happening?

   Thanks,
      Thomas

Installation details:

conntrack-tools-0.9.12
iptables-1.4.3.2
libnetfilter_conntrack-0.0.99
libnetfilter_log-0.0.16
libnfnetlink-0.0.41
linux-2.6.27.21 (Greg Kroah-Hartman's "stable" branch)
ulogd2 (fairly recent git pull, <1.5 month)

I am logging using "-m limit 1/s --burst 60 -j NFLOG --threshold 10
--prefix SOMETHING" with maybe 3-4 different rules like this in the main
data path. Log volume therefore shouldn't be that high.

Ulogd2 uses the example NFLOG stack [log1:NFLOG] (i.e.
LOGEMU/PRINTPKT...) and sync=0, the rest are default settings.


