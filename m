From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: port-based filtering of ESP packets with in-kernel IPsec?
Date: Wed, 30 Jul 2003 21:10:10 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0307302108370.14762-100000@filer.marasystems.com>
References: <Pine.LNX.4.44.0307301124150.22684-100000@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>
In-Reply-To: <Pine.LNX.4.44.0307301124150.22684-100000@localhost>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 30 Jul 2003, Chris Wilson wrote:

> Logically, it makes sense to me that the packet should pass through the 
> whole of Netfilter _again_ after it's been decapsulated, similarly to what 
> now happens with FreeS/WAN (but presumably without an ipsec0 interface 
> being involved). Or, maybe it should be decapsulated before routing (and 
> hence visible unencrypted in FORWARD, INPUT and OUTPUT).

It needs to pass routing first unless something has changed drastically 
in the 2.6 IP networking code, or else the kernel won't know if the 
ipsec packet is to be decapsulated or routed.

Regards
Henrik
