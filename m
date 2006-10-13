From: "Luis Floreani" <lucholaf@gmail.com>
Subject: Re: new match extension to implement port knocking in one
Date: Thu, 12 Oct 2006 23:50:51 -0300
Message-ID: <cd08d610610121950i23a9b7d3udc26d5be6f533a01@mail.gmail.com>
References: <cd08d610610111333m4db2ccc3l78dedcc3da060128@mail.gmail.com>
	<Pine.NEB.4.64.0610121956250.24305@otaku.freeshell.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Alexey Toptygin" <alexeyt@freeshell.org>
In-Reply-To: <Pine.NEB.4.64.0610121956250.24305@otaku.freeshell.org>
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

On 10/12/06, Alexey Toptygin <alexeyt@freeshell.org> wrote:
> On Wed, 11 Oct 2006, Luis Floreani wrote:
>
> >> If you're interested in port knocking, you might want to read this
> >> paper:  http://www.acsac.org/2005/abstracts/156.html  It covers security
> >> issues relating to port knocking in detail, and presents an architecture
> >> for solving most of them.
> >>
> >> Full disclosure:  I wrote that paper.  Feel free to contact me if you
> >> have questions.
> >>
> >> Rennie deGraaf
> >
> > In our implementation, for security, we are using the Tumbler protocol, we
> > found it simple yet powerful, check it out here:
> > http://tumbler.sourceforge.net/.
>
> It seems that Tumbler is not capable of working across NAT, unless the
> client can somehow obtain its public IP address.

Yes, with our implementation you need to know the public IP. On the
other hand, the Rennie implementation makes that easier, but from a
security point of view, both ways leaves the service open to the
public IP address, so anybody behind the NAT has the service port
open. That's a general problem with PK.

> Also, it relies on clocks
> being synchronized, since authentication will fail if the UTC time in
> minutes is not identical on the client and server.

it's very easy to sync a clock, you can do it with "rdate". e.g: $
rdate time-a.nist.gov

> Tumbler is not as
> stealthy as the techniques in Rennie deGraaf's paper, since it uses an
> open UDP port.

In our netfilter extension, the knock ports are CLOSED, also, the
server never sends an answer to any client knock, which really means
being "stealthy".
