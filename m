From: Joost Remijn <remijnj@eidetica.com>
Subject: RE: libipq packet id
Date: Thu, 26 Sep 2002 17:51:02 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0209261748150.7774-100000@fruit.eidetica.com>
References: <003801c26578$b48e22d0$97025a3e@SHAGWELL>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "'James Morris'" <jmorris@intercode.com.au>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Moshe Ashkenazi <moshea@checkpoint.com>
In-Reply-To: <003801c26578$b48e22d0$97025a3e@SHAGWELL>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

But did you actually mark the packet. Check the iptables manpage to see
how to mark a packet.

Joost

On Thu, 26 Sep 2002, Moshe Ashkenazi wrote:

> If have those two rules:
>
> 1    QUEUE      icmp --  anywhere             anywhere
> 2    QUEUE      tcp  --  anywhere             anywhere           tcp
> dpt:ftp
>
> mark return always zero and hook return 1 even the second rule queue the
> packet (I did ftp)
>
>
> Moshe Ashkenazi,
>
> -----Original Message-----
> From: Joost Remijn [mailto:remijnj@eidetica.com]
> Sent: Thursday, September 26, 2002 5:04 PM
> To: James Morris
> Cc: Moshe Ashkenazi; netfilter-devel@lists.netfilter.org
> Subject: Re: libipq packet id
>
>
>
> On Fri, 27 Sep 2002, James Morris wrote:
>
> > On Thu, 26 Sep 2002, Moshe Ashkenazi wrote:
> >
> > > Hi, All -
> > >
> > > I'm using libipq to retrieve packet from netfilter in userspace, and
> its
> > > work cool.
> > >
> > > My question is how can I know on userspace mode from which netfilter
> > > rule the packet arrive?
> > >
> >
> > This information is not passed to userspace.
>
> What about the mark and hook values in the struct ipq_packet_msg_t.
> That looks like a possibility to get some info from userspace about the
> rule.
>
> Joost
>
> > --
> > James Morris
> > <jmorris@intercode.com.au>
> >
> >
> >
>
>
>
