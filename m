From: Bryan Ford <baford@mit.edu>
Subject: Re: New draft document on nat / traversal / hole punching (with Dan
	Kegel)
Date: Wed, 17 Nov 2004 11:47:52 -0500
Message-ID: <200411171147.52308.baford@mit.edu>
References: <20041109154946.GD22257@sunbeam.de.gnumonks.org>
	<200411161538.48528.baford@mit.edu>
	<Pine.LNX.4.61.0411171646370.17188@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: srisures@yahoo.com,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	Harald Welte <laforge@netfilter.org>,
	Rusty Russell <rusty@rustcorp.com.au>, dank@kegel.com,
	Netfilter Core Team <coreteam@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0411171646370.17188@filer.marasystems.com>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wednesday 17 November 2004 11:04, Henrik Nordstrom wrote:
> I think most of the Netfilter developers understands the problems and
> approaches quite well by now.

Excellent - in that case perhaps the long message I sent just before receiving 
your message wasn't necessary after all; you made all my points much more 
succinctly and eloquently. :)

> The question is how much of the quite nice 
> properties we have today should/need to be sacrified in order to become
> more P2P friendly.

As I pointed out in the previous message, in practice I don't think these nice 
properties need to be sacrificed - the NAT could keep the traditional 
symmetric NAT behavior for existing, well-known protocols such as HTTP that 
don't need the cone NAT property, while providing exclusive port allocation, 
and thus more predictable, P2P-friendly cone NAT behavior for new or unknown 
protocols.  Since it's only the standard, well-known protocols that are ever 
likely to push the port allocation limitations of cone NAT, it seems to me 
that this strategy should work quite well in practice even on a large 
industrial NAT that might handle millions of connections at once.

Thanks,
Bryan
