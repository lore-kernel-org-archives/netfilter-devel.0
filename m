From: Peter Lee <mclee@sfu.ca>
Subject: Re: netfilter for IPv6
Date: Mon, 04 Nov 2002 15:23:55 PST
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200211042323.gA4NNt6K016793@rm-rstar.sfu.ca>
Reply-To: Peter Lee <mclee@sfu.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: binary
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Thank you for your quick respond. In fact, I am porting an ad hoc routing
protocol called AODV, written in user space. The original author make use of
netfilter to retrive ip packet from the kernel to user space. I am
personally not familiar with netfilter and I am looking for more information
how to use netfilter hook for both IPv4 and IPv6.

Thanks again.
Peter

On Tue, 5 Nov 2002 00:13:00 +0100 netfilter-devel@lists.netfilter.org wrote:

> On Mon, Nov 04, 2002 at 03:09:10PM -0800, Peter Lee wrote:
> > Hi,
> >=20
> 
> hi. please direct netfilter-related questions to
> netfilter-devel@lists.netfilter.org
> 
> > Is there any good tutorial on how to use netfilter hooks for IPv6? I'm
> st= uck
> > in the middle of porting an IPv4 protocol to IPv6. Please help.
> 
> There is no difference between netfilter hooks for ipv4 and ipv6. You=20
> use them exactly the same way.
> 
> However, if you are porting a protocol, netfilter shouldn't be involved at

> all.	Transport Protocols (layer 4) are dealt with in the standard network

> stack
> 
> > Peter Lee
> > M.Eng. Student
> > Simon Fraser University
> 
> --=20
> Live long and prosper
> - Harald Welte / laforge@gnumonks.org 	    http://www.gnumonks.org/

>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=

>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=

>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=

> =3D
> "If this were a dictatorship, it'd be a heck of a lot easier, just so long

>  as I'm the dictator."	--  George W. Bush Dec 18, 2000
