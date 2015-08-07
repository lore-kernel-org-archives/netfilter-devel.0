From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 2/2] extensions: restore matching any SPI id by default
Date: Fri, 7 Aug 2015 13:38:01 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1508071321280.18255@nerf40.vanv.qr>
References: <1436964819-28109-1-git-send-email-jengelh@inai.de> <1436964819-28109-3-git-send-email-jengelh@inai.de> <20150715162442.GA22476@salvia> <alpine.LSU.2.20.1507151837110.15534@nerf40.vanv.qr> <20150715165515.GA4177@salvia>
 <alpine.LSU.2.20.1507151907560.1320@nerf40.vanv.qr> <20150715173035.GA5675@salvia> <alpine.LSU.2.20.1507151937160.528@nerf40.vanv.qr> <20150807110754.GA13279@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:51768 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbbHGLiD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Aug 2015 07:38:03 -0400
In-Reply-To: <20150807110754.GA13279@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2015-08-07 13:07, Pablo Neira Ayuso wrote:
>On Wed, Jul 15, 2015 at 07:46:05PM +0200, Jan Engelhardt wrote:
>[...]
>> Printing it differently is a separate concern one can think about,
>> but with a separate patch. :-)
>
>Either way...
>
>Will you send me that follow up patch so I can get this applied?


When specifying e.g. "-m policy --dir in", the xt_policy kernel
module will indeedx test for much more than just the direction, but
the additional tests it does on other fields are idempotent after
all.

I oppose that idempotent expressions in rules, implicit or explicit,
shall lead to output when the ruleset is read back. A rule like

	-A INPUT -m policy --dir in

should not, by default, cause `iptables -S` to output a
rule with terms essentially irrelevant to the human reader.

	-A INPUT -m policy --dir in --reqid 0:4294967295 --spi
	0:4294967295 proto 0 --mode 0 --tunnel-src 0.0.0.0/0
	--tunnel-dst 0.0.0.0/0
