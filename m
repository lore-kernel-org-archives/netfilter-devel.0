From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 21:41:47 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031020194147.GA11786@balabit.hu>
References: <Pine.LNX.4.44.0310201133040.23768-100000@filer.marasystems.com> <3F942CB6.5060005@trash.net> <20031020183741.GB20288@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Henrik Nordstrom <hno@marasystems.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20031020183741.GB20288@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Oct 20, 2003 at 08:37:42PM +0200, Harald Welte wrote:
> On Mon, Oct 20, 2003 at 08:43:02PM +0200, Patrick McHardy wrote:
> 
> > >The dump operation should be connetion oriented with the userspace 
> > >application, not purely datagram based. The kernel should know for certain 
> > >if the userspace application terminates a dump operation mid-air.
> > >
> > 
> > Actually the kernel knows. If the socket is closed cb->done() is called.
> > However the kernel can not know if userspace still keeps the socket open
> > but doesn't read anymore. Connection oriented sockets don't help with this.
> 
> yes, but if the application is broken, that's not our problem.  If the
> API and the behaviour is documented, I don't see any problems with this.
> If an app wants to intentionally allocate many opjects in kernel space,
> there's nothing we can do.  Also, since we are sending to userspace, we
> could actually allocate this as virtual memory, right?

Sorry to jump into the conversation, it just occurred something I've read
about relayfs:

quoting from the announcement:

"relayfs is a filesystem designed to provide an efficient mechanism for
tools and facilities to relay large amounts of data from kernel space
to user space.  Full details can be found in Documentation/filesystems/
relayfs.txt.  The current version can always be found at
http://www.opersys.com/relayfs."

This _might_ be of interest when complete tables are to be dumped, though
the ctnetlink based interface is better when the userspace app provides more
specific queries.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
