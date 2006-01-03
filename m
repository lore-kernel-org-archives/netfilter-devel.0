From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: Error compiling ipt_IPMARK with kernel 2.6.14-5, iptables 1.3.4,
	POM-20051227
Date: Tue, 3 Jan 2006 06:21:54 -0600
Message-ID: <925A849792280C4E80C5461017A4B8A26D6B@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Patrick McHardy" <kaber@trash.net>
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

Thanks

Btw, for anyone starting with FC4, I also learned a tough lesson.  The
initial FC4 installation messed up and didn't put in the swap space I
told it to do.  This has happened twice on two different installs.  So
the base system did not have any swap partition - but I didn't notice
until much later in the process.  So during the kernel build, when
depmod does its symbol checking, it just dies - because it runs out of
virtual memory.  The fix - use mkswap and swapon to add swap space.
Then the kernel build runs to completion.  Maybe the FC5 installation
will be a bit more stable.  I am also thinking about moving from RedHat
as a base to SUSE. =20

- Greg Scott


-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net]=20
Sent: Tuesday, January 03, 2006 6:15 AM
To: Greg Scott
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: Error compiling ipt_IPMARK with kernel 2.6.14-5, iptables
1.3.4, POM-20051227


Greg Scott wrote:
> Trying to to a kernel build for 2.6.14-5 with iptables 1.3.4 and=20
> POM-20051227.  Here is a snippet from the output.

Also fixed in SVN.
