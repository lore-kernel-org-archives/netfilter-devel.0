From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] flow statistic match
Date: Wed, 18 Sep 2002 23:59:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020918215958.GE10465@oknodo.bof.de>
References: <Pine.LNX.4.44L.0209172337160.10390-102000@hunger.screamingdaemon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@gnumonks.org>, netfilter-devel@lists.netfilter.org,
  netfilter@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jay Schulist <jschlst@linux-sna.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L.0209172337160.10390-102000@hunger.screamingdaemon.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jay,

> Here is a new match which adds per tuple packet and byte statistics along
> with allowing the user to match on the number of bytes and packets for a
> flow.

Sorry, but another nitpicking comment from me :-)

Is it neccessary to call this "flow"? All the other matches related
to connection tracking, at least keep some semblance of that name in
their own naming. "flow" stands out as some new kind of connection
tracking concept (being in use in other systems for just that purpose,
e.g. the unidirectional Cisco netflow accounting stuff.)

As a proposal out of the blue, what about calling it "ctvolume", instead?

Would it be possible, in the near future, to use a "ctnetlink" interface
to get at the final counters when a conntrack is destroyed? :-)

best regards
  Patrick
