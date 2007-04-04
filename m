From: Ross Vandegrift <ross@kallisti.us>
Subject: Re: iptables match rule for DNS RR?
Date: Wed, 4 Apr 2007 09:56:52 -0400
Message-ID: <20070404135651.GA20727@kallisti.us>
References: <20070404131825.GB20515@kallisti.us>
	<twig.1175694568.67940@bugmachine.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org,
	Ross Vandegrift <ross@eris.kallisti.us>
To: Samuel Jean <jix@bugmachine.ca>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <twig.1175694568.67940@bugmachine.ca>
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

On Wed, Apr 04, 2007 at 01:49:28PM -0000, Samuel Jean wrote:
> On Wed, Apr 4, 2007, Ross Vandegrift <ross@kallisti.us> said:
> > Is there any netfilter work, either production or in development, that
> > provides a way to filter traffic based on DNS RR type?
> 
> Sorry -- matching packets based on RR is not possible inside the kernel.
> Netfilter needs to make a decision pretty fast and cannot wait for DNS
> queries
> each time a packet passes by. IMO, this makes huge sense.

Wait, I don't want to perform a DNS lookup - rather, I have DNS
servers, and I want to be able to filter out DNS requests based on the
the types of RRs in the question section.

We're experiencing a pretty major DoS attack against our DNS servers.
One thing that we have noticed is that the questions contain lots of
RRs we know we can't answer for - ISDN, AFSDB, and other
outdated/obscure types.


-- 
Ross Vandegrift
ross@kallisti.us

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
