From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 0/3] expedited "big hammer" RCU grace periods
Date: Wed, 24 Jun 2009 20:03:03 +0200
Message-ID: <20090624180303.GE7576@elte.hu>
References: <20090624164535.GA13334@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, akpm@linux-foundation.org,
	torvalds@linux-foundation.org, davem@davemloft.net,
	dada1@cosmosbay.com, zbr@ioremap.net, jeff.chua.linux@gmail.com,
	paulus@samba.org, laijs@cn.fujitsu.com, jengelh@medozas.de,
	r000n@r000n.net, benh@kernel.crashing.org,
	mathieu.desnoyers@polymtl.ca
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:49752 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbZFXSD3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:03:29 -0400
Content-Disposition: inline
In-Reply-To: <20090624164535.GA13334@linux.vnet.ibm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

>  include/linux/rcuclassic.h    |   15 ++-

heh, we dont have this file anymore ... as of today, right? :)

	Ingo
