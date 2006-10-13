From: "J. Federico Hernandez" <fede.hernandez@gmail.com>
Subject: Re: netfilter-devel Digest, Vol 27, Issue 18
Date: Fri, 13 Oct 2006 19:01:54 -0300
Message-ID: <c0db55360610131501p9eaea68rc2d7d30ca81bd687@mail.gmail.com>
References: <452eff66.604d9017.02d2.ffffb024SMTPIN_ADDED@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: mbr@cipherdyne.org, netfilter-devel@lists.netfilter.org
In-Reply-To: <452eff66.604d9017.02d2.ffffb024SMTPIN_ADDED@mx.google.com>
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

> On Oct 12, 2006, Alexey Toptygin wrote:
>
> > On Wed, 11 Oct 2006, Luis Floreani wrote:
> >
> > >>If you're interested in port knocking, you might want to read this
> > >>paper:  http://www.acsac.org/2005/abstracts/156.html  It covers security
> > >>issues relating to port knocking in detail, and presents an architecture
> > >>for solving most of them.
> > >>
> > >>Full disclosure:  I wrote that paper.  Feel free to contact me if you
> > >>have questions.
> > >>
> > >>Rennie deGraaf
> > >
> > >In our implementation, for security, we are using the Tumbler protocol, we
> > >found it simple yet powerful, check it out here:
> > >http://tumbler.sourceforge.net/.
> >
> > It seems that Tumbler is not capable of working across NAT, unless the
> > client can somehow obtain its public IP address. Also, it relies on clocks
> > being synchronized, since authentication will fail if the UTC time in
> > minutes is not identical on the client and server. Tumbler is not as
> > stealthy as the techniques in Rennie deGraaf's paper, since it uses an
> > open UDP port.
>
> Why not use fwknop in Single Packet Authorization mode?:

Why not using iptables to implement port knocking?
You won't depend on any daemon.

If you know the iptables syntaxis, you don't need to learn the daemon
syntaxis or its configuration.

-- 
Federico
