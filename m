From: Ramin Dousti <ramin@cannon.eng.us.uu.net>
Subject: Re: TTL patch buggy?
Date: Wed, 7 Jan 2004 16:19:51 -0500
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <20040107211951.GC20346@cannon.eng.us.uu.net>
References: <Pine.LNX.4.44.0401071709030.4717-100000@filer.marasystems.com> <1073502275.16972.10.camel@jasiiitosh.nexusmgmt.com> <20040107193547.GF6629@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
   "John A. Sullivan III" <john.sullivan@nexusmgmt.com>,
   Henrik Nordstrom <hno@marasystems.com>, netfilter@lists.netfilter.org,
   netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20040107193547.GF6629@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jan 07, 2004 at 08:35:47PM +0100, Harald Welte wrote:

> The most dangerous cases of incrementing the TTL are:
> 
> a) incrementing the TTL of transit traffic (not close to sender or receiver)
> b) incrementing the TTL of multicast traffic

Can you explain (b) a bit more, Harald? Multicast traffic is being
dealt with by the routers in exactly the same way as the unicast
traffic with regards to the TTL (as far as I understand it).
Or did you mean by "multicast traffic", the IGMP messages?

Appreciate the explanation.

Ramin
