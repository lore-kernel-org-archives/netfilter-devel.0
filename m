From: Marian Stagarescu <marian@ti.com>
Subject: Re: PPTP conntrack w/out DEBUG is broken ???
Date: Wed, 2 Oct 2002 10:02:01 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200210021002.01553.marian@ti.com>
References: <20021002153013.A13233@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
   =?iso-8859-1?q?C=E9dric=20Rivard?= <cedric@yemanja.net>@sunbeam.gnumonks.org,
   Netfilter-devel <netfilter-devel@lists.netfilter.org>,
   Netfilter <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20021002153013.A13233@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wednesday 02 October 2002 09:30 am, Harald Welte wrote:
> On Wed, Sep 25, 2002 at 04:48:42PM -0400, Marian Stagarescu wrote:
> > i run into one problem with PPTP conntrack:
> >
> > run it with debug on: works
> > run it w/out debug on: does not.
>
> what do you call 'debug' ?  Does this mean the DEBUG #defines in the
> respective sourcecode .c files

yes. ip_conntrack_pptp.c, ip_nat_pptp.c, ip_conntrack_proto_gre.c,=20
ip_nat_proto_gre.c are compiled with DEBUGP defined.

> or are you talking about
> CONFIG_NETFILTER_DEBUG?

i have this turned on as well

> > this debug issue was tracked down to a single printk statement in
> > ip_conntrack_pptp.c: line 244,245:
> >
> > DEBUGP("%s, CID=3D%X, PCID=3D%X\n", strMName[msg]
> >                      ntohs(*cid), ntohs(*pcid));
>
> What happens?  Does the kernel oops at this statement?

no opps but the PPTP session is not established.

I'll come back with a detailed debug log.


> > thanks for any input,
> > marian
