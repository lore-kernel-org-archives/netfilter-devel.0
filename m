From: Chris Wilson <chris@netservers.co.uk>
Subject: Re: conntrack match and locking
Date: Thu, 27 May 2004 11:11:27 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0405271104570.27895@chris.camcom.co.uk>
References: <Pine.LNX.4.44.0405261804070.31237-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0405261804070.31237-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Henrik,

> > The conntrack match from POM-ng doesn't appear to do any locking while 
> > accessing conntrack structures. Is that a problem?
> 
> Not really a problem, the conntrack is locked by the reference from the
> skb (packet), and we know there is no others (legally) messing with this
> skb while iptables processes it.

Is there some documentation which describes this process? I didn't find 
anything in the netfilter hacking HOWTO. Are the conntrack entries 
(original and reply) actually spin_locked, or just held in memory by the 
reference? If two packets are being processed at the same time on an SMP 
machine, who holds what locks?

Thanks very much for your help,

Cheers, Chris.
-- 
_  __ __     _
 / __/ / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_  ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\__/_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
