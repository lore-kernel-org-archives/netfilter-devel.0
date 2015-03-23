From: Laurent Bercot <ska-devel@skarnet.org>
Subject: Re: [PATCH libnftnl] src: restore static array with expression operations
Date: Mon, 23 Mar 2015 14:37:01 +0100
Message-ID: <551016FD.1020909@skarnet.org>
References: <1427111052-5510-1-git-send-email-pablo@netfilter.org> <20150323114411.GH603@acer.localdomain> <20150323123400.GA6511@salvia> <20150323130805.GN603@acer.localdomain> <5510135A.9020809@skarnet.org> <20150323133306.GW603@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.tech.numericable.fr ([82.216.111.39]:44441 "EHLO
	smtp3.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbbCWNhA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2015 09:37:00 -0400
In-Reply-To: <20150323133306.GW603@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


  Here is the first mail I sent to netfilter@.
  The whole thread can be read at
  http://comments.gmane.org/gmane.comp.security.firewalls.netfilter.general/47842

-----
  Hello,

  (Platform: Intel Atom (x86_64), Linux 3.19.1, musl 1.1.7,
latest nftables/libnftnl/libmnl from git. All iptables modules
out of the kernel, all necessary nftables modules in.)

  I can flush tables, create tables and create chains with nft
without trouble; however, every time I try and add a rule to
a chain, no matter what chain, no matter in what table, I get
the following error:

  netlink.c:182: Memory allocation failure

  I dug a bit and found that the error always happens when
alloc_nft_expr() is called for the *first* time (which is also
the last, since nft exits at that point...) and it is always
called with the argument "payload".

  What is happening ? Anything I could do to help fix it ?
  Thanks,

-- 
  Laurent
-----
