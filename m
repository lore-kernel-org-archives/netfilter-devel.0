From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: TTL patch buggy?
Date: Wed, 7 Jan 2004 21:54:05 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401072153050.6249-100000@filer.marasystems.com>
References: <20040107211951.GC20346@cannon.eng.us.uu.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   "John A. Sullivan III" <john.sullivan@nexusmgmt.com>,
   <netfilter@lists.netfilter.org>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ramin Dousti <ramin@cannon.eng.us.uu.net>
In-Reply-To: <20040107211951.GC20346@cannon.eng.us.uu.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 7 Jan 2004, Ramin Dousti wrote:

> Can you explain (b) a bit more, Harald? Multicast traffic is being
> dealt with by the routers in exactly the same way as the unicast
> traffic with regards to the TTL (as far as I understand it).

Yes, but the difference is that multicast does actually use the ttl to 
limit the scope of how wide the traffic is distributed, as opposed to most 
other protocols just using the ttl to kill forwarding loops.

Regards
Henrik
