From: Ramin Dousti <ramin@cannon.eng.us.uu.net>
Subject: Re: TTL patch buggy?
Date: Wed, 7 Jan 2004 17:16:14 -0500
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <20040107221614.GE20346@cannon.eng.us.uu.net>
References: <20040107211951.GC20346@cannon.eng.us.uu.net> <Pine.LNX.4.44.0401072153050.6249-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>,
   "John A. Sullivan III" <john.sullivan@nexusmgmt.com>,
   netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0401072153050.6249-100000@filer.marasystems.com>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jan 07, 2004 at 09:54:05PM +0100, Henrik Nordstrom wrote:

> On Wed, 7 Jan 2004, Ramin Dousti wrote:
> 
> > Can you explain (b) a bit more, Harald? Multicast traffic is being
> > dealt with by the routers in exactly the same way as the unicast
> > traffic with regards to the TTL (as far as I understand it).
> 
> Yes, but the difference is that multicast does actually use the ttl to 
> limit the scope of how wide the traffic is distributed, as opposed to most 
> other protocols just using the ttl to kill forwarding loops.

Absolutely. For a sec I forgot all about the dense mode. Thanks, Henrik.
However, I still don't see any "danger" about this. It might not be
desirable but not dangerous, as multicast forwarding has a builtin mechanism
against the loops.

Ramin

> Regards
> Henrik
