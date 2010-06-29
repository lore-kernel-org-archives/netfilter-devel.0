From: Jan Engelhardt <jengelh@medozas.de>
Subject: netns net_mutex deadlock in my path
Date: Tue, 29 Jun 2010 08:34:35 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006290826270.16794@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Alexey Dobriyan <adobriyan@gmail.com>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55748 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab0F2Gei (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 02:34:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


while preparing further patches, I came across an issue whereby a pernet 
subsys loads another module with a pernet subsys registration. In call 
stack:

ip6table_filter loading -> register_pernet_subsys -> 
ip6table_filter_net_init -> try_then_request_module("xt_quota") -> 
xt_quota loading -> register_pernet_subsys -> deadlock on "net_mutex".

(I have a patch that makes xt_quota per-netns.)

xt_quota is loaded to serve as the per-rule byte/packet counter. Since 
an empty table practically always starts with a tail rule (-> default 
policy), it happens to get loaded on table load already rather than 
later at `ip6tables -A` time.

The question is, what is the preferred solution to this problem? The 
straightforward solution would be to add a symbol dependency (similar to 
"need_conntrack") so that xt_quota is explicitly loaded before 
ip6table_filter. Other ideas?


thanks,
Jan
