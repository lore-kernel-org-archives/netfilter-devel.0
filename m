From: Gonzalo Augusto Arana Tagle <garana@uolsinectis.com.ar>
Subject: Re: [PATCH] New Target SWITCH
Date: Wed, 2 Oct 2002 10:56:09 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021002105609.7cc8578c.garana@uolsinectis.com.ar>
References: <200209241349.g8ODnQI01594@gonzalo.hq.sinectis.com.ar>
	<20021002153736.B13233@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20021002153736.B13233@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


> >   I am developing a new target which should redirect
> > packets to a given host, no matter what routing table
> > says.
> 
> where is the difference between this and the ROUTE target?

As far as I know, the ROUTE target just let you choose an interface,
not a next-hop.  SWITCH target (probably should be renamed) would let
you choose a next-hop.

> 
> And even if there is a difference, the functionality seems to be quite
> similar, doesn't it make sense to implement the two functions in a single
> target?

mmm.... If I am right about ROUTE target capabilities, this target is
quite more flexible, right?

> 

-- 
Gonzalo A. Arana
