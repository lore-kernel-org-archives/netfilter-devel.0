From: <ggeorgiev@eurista.com>
Subject: Need a way to match vlan / pcp fields in 802.1q header - from netfilter
 list
Date: Tue, 12 Mar 2013 15:33:32 -0700
Message-ID: <20130312153332.e96aff9bbdc3fe78db33ffdcbc125810.e9b5961a6f.wbe@email03.secureserver.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from p3plsmtp03-04-2.prod.phx3.secureserver.net ([72.167.218.216]:59205
	"EHLO p3plwbeout03-04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756152Ab3CLWie convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:38:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello everyone,

I need an advice of how to make an ebtables/iptables rule or custom
application, matching 802.1q CoS field on the raw vlan interface (eth0),
and no one seems to have an idea in the 'netfilter' list.
Libnetfilter_queue seems to be of no use, as iptables do not see the
vlan tag, so what is the alternative? 

For more details you can check the recent article with similar name in
'netfilter' list. Will really appreciate an advice of how to handle this
task. Am I first ever to need this?

Thanks, George.
