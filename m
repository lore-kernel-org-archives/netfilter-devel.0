From: Chris Wilson <chris@netservers.co.uk>
Subject: Re: IPtables performance (fwd)
Date: Sat, 3 May 2003 11:32:24 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0305031129230.8273-100000@localhost>
References: <Pine.LNX.4.33.0305021628100.8241-100000@fantomas.insite.com.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>,
   Robert Olsson <robban@robtex.com>, John McEleney <john@netservers.co.uk>,
   Ben McKeegan <ben@netservers.co.uk>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andre Uratsuka Manoel <andre@insite.com.br>
In-Reply-To: <Pine.LNX.4.33.0305021628100.8241-100000@fantomas.insite.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Andre,

> 	I also may be making a fool of myself (not a first), but my take
> is this:

It looks like you have found some very efficient algorithms (not to 
mention a nice visual metaphor). Would you mind if I try to reimplement 
mark_source_chains using these algorithms?

I'm also wondering if the two steps, loop-detection and colouring, should 
be combined as they currently are for brevity and performance, or 
separated for simplicity and intuitive correctness?

Cheers, Chris.
-- 
   ___ __     _
 / __// / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_ / ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\ _//_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
