From: Joost Remijn <remijnj@eidetica.com>
Subject: Re: libipq packet id
Date: Thu, 26 Sep 2002 17:04:05 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0209261702120.7774-100000@fruit.eidetica.com>
References: <Mutt.LNX.4.44.0209270037340.12159-100000@blackbird.intercode.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Moshe Ashkenazi <moshea@checkpoint.com>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: James Morris <jmorris@intercode.com.au>
In-Reply-To: <Mutt.LNX.4.44.0209270037340.12159-100000@blackbird.intercode.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



On Fri, 27 Sep 2002, James Morris wrote:

> On Thu, 26 Sep 2002, Moshe Ashkenazi wrote:
>
> > Hi, All -
> >
> > I'm using libipq to retrieve packet from netfilter in userspace, and its
> > work cool.
> >
> > My question is how can I know on userspace mode from which netfilter
> > rule the packet arrive?
> >
>
> This information is not passed to userspace.

What about the mark and hook values in the struct ipq_packet_msg_t.
That looks like a possibility to get some info from userspace about the
rule.

Joost

> --
> James Morris
> <jmorris@intercode.com.au>
>
>
>
