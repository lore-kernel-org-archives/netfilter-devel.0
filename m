From: Jay Schulist <jschulist@bivio.net>
Subject: Re: [PATCH] flow statistic match
Date: Wed, 18 Sep 2002 15:15:48 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0209181513130.5702-100000@beavis.networkrobots.com>
References: <20020918215958.GE10465@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jay Schulist <jschlst@linux-sna.org>, Harald Welte <laforge@gnumonks.org>,
   <netfilter-devel@lists.netfilter.org>, <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20020918215958.GE10465@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 18 Sep 2002, Patrick Schaaf wrote:

> Is it neccessary to call this "flow"? All the other matches related
> to connection tracking, at least keep some semblance of that name in
> their own naming. "flow" stands out as some new kind of connection
> tracking concept (being in use in other systems for just that purpose,
> e.g. the unidirectional Cisco netflow accounting stuff.)
> 
> As a proposal out of the blue, what about calling it "ctvolume", instead?
> 

Hello Patrick,
I am not really stuck on a the flow name, it was just what I happened to 
call it, we can definately call it something better.

> Would it be possible, in the near future, to use a "ctnetlink" interface
> to get at the final counters when a conntrack is destroyed? :-)
> 

Yeah, this is already available with the new iptables2/nfnetlink patches I 
will make available in a few days.

J.
