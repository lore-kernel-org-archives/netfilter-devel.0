From: Rick Kennell <kennell@ecn.purdue.edu>
Subject: Re: port-based filtering of ESP packets with in-kernel IPsec?
Date: 30 Jul 2003 10:42:36 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1059579755.22690.6.camel@k7.localnet>
References: <Pine.LNX.4.44.0307301124150.22684-100000@localhost>
Reply-To: netfilter-devel@lists.netfilter.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
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

On Wed, 2003-07-30 at 05:34, Chris Wilson wrote:
> Hi Rick,
> 
> > Since ESP packets that reach the mangle INPUT chain are destined for a
> > local process, why not unencapsulate them just before that point?  It
> > might still be nice to have an indication that this was once an ESP
> > packet for filtering, but that could be done by setting a mark in the
> > mangle PREROUTING chain.
> 
> The ESP itself will presumably be for a security association (SA) which
> terminates on the machine, but it could easily be for some tunnel, in
> which case the unencrypted packet should be sent through FORWARD instead 
> of INPUT.

Mmm, sure.  But if it is directed to INPUT, it should still be
decapsulated.

> Logically, it makes sense to me that the packet should pass through the 
> whole of Netfilter _again_ after it's been decapsulated, similarly to what 
> now happens with FreeS/WAN (but presumably without an ipsec0 interface 
> being involved).

I thought about this for a while trying to figure out how to do so
without an extra interface.  Maybe a netfilter rule to decapsulate and
requeue to PREROUTING?

> Or, maybe it should be decapsulated before routing (and 
> hence visible unencrypted in FORWARD, INPUT and OUTPUT).

If the packet were being routed by the local host (i.e. from one subnet
to another) we'd want to preserve the encapsulation.  Actually, we
probably wouldn't be able to decapsulate it.

-- 
Rick Kennell <kennell@ecn.purdue.edu>
Purdue University School of Electrical and Computer Engineering
