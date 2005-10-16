From: Harald Welte <laforge@netfilter.org>
Subject: Re: ip_queue: setting verdict blocks
Date: Sun, 16 Oct 2005 16:37:07 +0200
Message-ID: <20051016143707.GD17257@rama.0sec>
References: <200510131230.19776.ilkka.pietikainen@emicnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ilkka =?iso-8859-1?Q?Pietik=E4inen?= <ilkka.pietikainen@emicnetworks.com>
Content-Disposition: inline
In-Reply-To: <200510131230.19776.ilkka.pietikainen@emicnetworks.com>
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

On Thu, Oct 13, 2005 at 12:30:19PM +0300, Ilkka Pietik=E4inen wrote:
> Hello,
>=20
> We have seen this in two different environments: RedHat ES3 and Debian Sa=
rge=20
> (with the default kernels).

strange, since there are many ip_queue users=20

> We have an application that handles IP packets from ip_queue module (and=
=20
> basically DROP/ACCEPT each packet). Sometimer after the system has been u=
p=20
> and running for few hours the application can no longer set the verdict f=
or=20
> the packet (it seems that the sendmsg is blocking). Restarting of the=20
> application does not help and only way to get system back working is to r=
mmod=20
> all iptables related modules or reboot.

the /proc/net/ip_queue output would be interesting.=20

are you running smp?

what is the cpu usage rate when such a 'blocking' occurs?

> a) What could have caused sendmsg to block?

normally only the processing of the verdict, i.e. passing the packet
through the rest of the stack (in case of ACCEPT).

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie
