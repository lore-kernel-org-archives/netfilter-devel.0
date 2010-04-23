From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: DDoS attack causing bad effect on conntrack searches
Date: Fri, 23 Apr 2010 14:45:59 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1004231440190.840@ask.diku.dk>
References: <1271941082.14501.189.camel@jdb-workstation>
 <q2h412e6f7f1004220613m488c2ee4r6d24a8d1e65997d4@mail.gmail.com>
 <4BD04C74.9020402@trash.net> <1271946961.7895.5665.camel@edumazet-laptop>
 <4BD17CF9.4020502@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Changli Gao <xiaosuo@gmail.com>, hawk@comx.dk,
	Linux Kernel Network Hackers <netdev@vger.kernel.org>,
	netfilter-devel@vger.kernel.org,
	Paul E McKenney <paulmck@linux.vnet.ibm.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:43080 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767Ab0DWMqH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Apr 2010 08:46:07 -0400
In-Reply-To: <4BD17CF9.4020502@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 23 Apr 2010, Patrick McHardy wrote:

> That sounds like a good idea. But lets what for Jesper's test results
> before we start fixing this problem :)

I will first have time to perform the tests Monday or Tuesday.

BUT I have just noticed there seems to be a corrolation between conntrack 
early_drop and searches.  I have upload a new graph:

  http://people.netfilter.org/hawk/DDoS/2010-04-12__001/conntrack_early_drop002.png

I have not had time to checkout the code path yet...

Cheers,
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
