From: Patrick Schaaf <bof@bof.de>
Subject: Re: Reset conntrack...
Date: Fri, 3 Dec 2004 07:08:19 +0100
Message-ID: <20041203060819.GG4605@oknodo.bof.de>
References: <41AF92B1.30802@anduras.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Anders <anders@anduras.de>
Content-Disposition: inline
In-Reply-To: <41AF92B1.30802@anduras.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> Is it possible to reset the conntrack list or set any entry to the state 
> NEW to force a recheck against new filter rules?
> ~  If I set the (new) filtering rules with the target DROP, I want old
> ~  (existing) connections to be dropped immediatly.

Consider using REJECT. This has two advantages: it gives the end
systems you are now blocking a chance at state cleanup (instead of
needlessly wasting memory and CPU resources on a connection that you
now elect to forbit). But, the greater advantage: the packets that
the end systems exchange in response to the connection teardown,
are JUST what you need to get rid of their conntracks.

Of course, one could do what you requested. Maybe even without coding.
I wouldn't know. Maybe others.

best regards
  Patrick
