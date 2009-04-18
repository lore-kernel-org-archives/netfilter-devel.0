From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: some unused netfilter config vars?
Date: Sat, 18 Apr 2009 09:10:55 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.0904180909580.499@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:59018 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545AbZDROQm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Apr 2009 10:16:42 -0400
Received: from [174.113.191.234] (helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1LvAKh-0005HC-IF
	for netfilter-devel@vger.kernel.org; Sat, 18 Apr 2009 09:11:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


===== IP_NF_MATCH_TTL
net/ipv4/netfilter/Kconfig:95:config IP_NF_MATCH_TTL
===== IP_NF_TARGET_TTL
net/ipv4/netfilter/Kconfig:325:config IP_NF_TARGET_TTL
===== IP6_NF_MATCH_HL
net/ipv6/netfilter/Kconfig:97:config IP6_NF_MATCH_HL
===== IP6_NF_TARGET_HL
net/ipv6/netfilter/Kconfig:133:config IP6_NF_TARGET_HL

  nothing seems to refer to any of the above.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
