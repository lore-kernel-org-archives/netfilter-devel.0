From: Chris Wilson <chris@netservers.co.uk>
Subject: Re: [PATCH] Orphaned expectations
Date: Wed, 21 Apr 2004 12:17:48 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404211215030.726-100000@chris.camcom.co.uk>
References: <4085B33A.2080805@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
   <kernel@linuxace.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4085B33A.2080805@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

> a) a new conntrack is created.
> b) a helper is asigned to this conntrack.
> c) and if this helper exists (case of tftp helper), it is also called.
> 
> So now, with only an udp packet, we have a conntrack which is not 
> confirmed with an expectation associated, and as Phil pointed out, if 
> this conntrack is destroyed the expectation keeps there forever.

Thanks very much for your explanation. So, to prevent this from happening, 
what is the best thing to do?

1. Audit all helpers to check that they don't create expectations to 
unconfirmed conntracks

2. Modify destroy_conntrack to destroy any associated expectations, 
whether or not the conntrack is confirmed (presumably right now it only 
does so if the conntrack is confirmed? hence the problem?)

Cheers, Chris.
-- 
_  __ __     _
 / __/ / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_  ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\__/_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
