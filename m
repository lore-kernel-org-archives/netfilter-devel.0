From: Chris Wilson <chris@netservers.co.uk>
Subject: Re: IPtables performance (fwd)
Date: Sat, 3 May 2003 11:34:34 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0305031132330.8273-100000@localhost>
References: <20030502201425.GP26924@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Robert Olsson <robban@robtex.com>,
   John McEleney <john@netservers.co.uk>, Ben McKeegan <ben@netservers.co.uk>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030502201425.GP26924@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,

> > Therefore, if the patched code does actually succeed in visiting each rule 
> > once, and detecting loops, and setting the appropriate bit in comefrom, 
> > then it's functionally equivalent to the original code, right?
> 
> yes. Are you claiming that it does so?

I think so, but I'm still working on it so no promises yet =)

How about I rewrite the function using Andre's suggested algorithms, so
that we know it's both correct and optimally efficient?

Cheers, Chris.
-- 
   ___ __     _
 / __// / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_ / ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\ _//_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
