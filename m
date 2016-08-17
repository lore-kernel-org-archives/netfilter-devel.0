From: Peter Wu <peter@lekensteyn.nl>
Subject: libipset developer documentation?
Date: Wed, 17 Aug 2016 14:12:29 +0200
Message-ID: <20160817121229.GC11256@al>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lekensteyn.nl ([178.21.112.251]:46501 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbcHQMr4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 08:47:56 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Recently I attempted to work on a new libipset program and also tried to
review something I wrote in the past (ssh-blocker). In order to find
some "best practices" or a reference manual, I went to:

    http://ipset.netfilter.org/

but surprisingly, it has no developer resources even though it is
supposed to be an alternative for calling the ipset program directly
(http://www.spinics.net/lists/netfilter/msg52100.html).

Other things that I did in order to learn how to use libipset:

 - Study ipset source code (stopped doing this since it is an
   implementation, internal details could change in the future).
 - Write a Wireshark dissector for netlink/netfilter/ipset and study the
   protocol communications when invoking the ipset tool directly
   (merged in Wireshark v2.3.0rc0-324-gdd15a6d).
 - Compare said protocol with lib/PROTOCOL to figure out what data must
   be set.
 - Open my ssh-blocker code, remove ipset_type_get() for IPSET_CMD_TEST
   because it seems unnecessary according to lib/PROTOCOL.
 - Discover that libipset does not send netlink message. Found the error
   reporting functions ipset_session_error and ipset_session_warning.
 - Look in ipset source code and discover that ipset_type_get() is not
   that optional, it sets IPSET_OPT_FAMILY and IPSET_OPT_TYPE...

As you can see this involved a lot trial and error. Suggestions for
improvement:

 - Add information to README for help resources (IRC, mailing list).
 - Add a tutorial on how (not) to use libipset (initialization, how to
   know what ipset_session_data_set to call, etc.)
 - API reference (like
   https://www.infradead.org/~tgr/libnl/doc/api/group__core.html)
 - (Link to other resources I have missed?)

Other than the documentation issue, ipset has been a very useful tool
for me, so thanks for that!
-- 
Kind regards,
Peter Wu
https://lekensteyn.nl
