From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Re: Mangle on a Connection, not on a Packet
Date: Fri, 17 Oct 2003 13:26:31 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200310170326.h9H3QVK17619@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Henrik Nordstrom" <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Ok, (read the POM docco) this looks pretty cool .. couple of questions, then;

  1.  for my input/output rules I would add rules to send any
       new connections on my "special ports/protos" to the 
       CONNMARK target for marking .. but I'd want an arbitrary
       unique mark per connection, not a static one .. is this 
       possible?  (and I'd need that mark to be made free when
        the connection is removed from netfilter).

  2.  in the mangle table, I would use connmark matching to
       send all marked connections to the XOR target .. but am
       I able to access the arbitrary unique mark from within
       the XOR target module itself (programatically)?


.. I guess the alternative would be to smash together the two 
modules into a single CONNXOR target ...?  That way the code
that identifies and marks new connections in CONNMARK 
could be readily matched and altered via the XOR code ... I'll
take a look at the CONNMARK code .. maybe this is easier ..




----- Original Message -----
>From: "Henrik Nordstrom" <hno@marasystems.com>
>To: "Ian Latter" <Ian.Latter@mq.edu.au>
>Subject:  Re: Mangle on a Connection, not on a Packet
>Date: Thu, 16 Oct 2003 16:30:44 +0200
>
> On Thu, 16 Oct 2003, Ian Latter wrote:
> 
> > I want to extend the functionality of the XOR module.  I am cool with
> > the connection tracking helper concepts, and I am cool with the way XOR
> > is doing its mangling as a target .. but what I'm not so cool with is
> > how I register my intent to mangle a "connection" with conntrack, rather
> > than the currently registerd mangle .. per a packet .. as with the
> > target.
> 
> For this purpose I think you should be able to use the CONNMARK patch to 
> mark the connection. The CONNMARK patch provides you with a 32bit piece of 
> memory per conntrack, and can be used very much like the MARK target.
> 
> Regards
> Henrik
> 
> 

--
Ian Latter
Internet and Networking Security Officer
Macquarie University
