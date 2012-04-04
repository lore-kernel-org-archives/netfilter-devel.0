From: Simon Kirby <sim@netnation.com>
Subject: xt_LOG depends on ip6t_ext_hdr
Date: Wed, 4 Apr 2012 14:28:50 -0700
Message-ID: <20120404212850.GC21505@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from peace.netnation.com ([204.174.223.2]:45168 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117Ab2DDVqq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:46:46 -0400
Received: from sim by peace.netnation.com with local (Exim 4.72)
	(envelope-from <sim@netnation.com>)
	id 1SFXl4-0005sT-QS
	for netfilter-devel@vger.kernel.org; Wed, 04 Apr 2012 14:28:50 -0700
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

'lo!

In current Linus head, this build failure:

net/built-in.o:xt_LOG.c:function dump_ipv6_packet: error: undefined reference to 'ip6t_ext_hdr'

happens with these config options:

CONFIG_NETFILTER_XT_TARGET_LOG=y
CONFIG_IP6_NF_IPTABLES=m

Simon-
