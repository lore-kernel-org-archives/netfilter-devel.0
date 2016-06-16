From: Matt Whitlock <kernel@mattwhitlock.name>
Subject: "header-y += xt_SYNPROXY.h" is missing in include/uapi/linux/netfilter/Kbuild
Date: Thu, 16 Jun 2016 01:39:37 -0400
Message-ID: <3148965.oLjBbxIsye@crushinator>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from resqmta-ch2-09v.sys.comcast.net ([69.252.207.41]:41268 "EHLO
	resqmta-ch2-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751124AbcFPFr6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2016 01:47:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There is a line missing in include/uapi/linux/netfilter/Kbuild:

header-y += xt_SYNPROXY.h

Without this line, the file xt_SYNPROXY.h does not get installed in /usr/include/linux/netfilter/, and thus user-space programs cannot make use of it.

Please correct this oversight at your convenience. Thank you.
