From: Ulysses Almeida <munky@maluco.com.br>
Subject: Re: Netfilter-HA
Date: Wed, 19 May 2004 20:43:17 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040520004316.GA2750@maluco.com.br>
References: <20040519194131.M96666@linkexpress.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Daniel =?iso-8859-1?Q?Corr=EAa?= de Azevedo <nielca@linkexpress.com.br>
Content-Disposition: inline
In-Reply-To: <20040519194131.M96666@linkexpress.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Daniel,

  I think you mean using netfilter-iptables, to make other high
avaiable service, like apache (http). For this task, I think you
should read about LVS (http://www.linuxvirtualserver.org), it is
implemented with netfilter hooks.

  Good luck.

On Wed, May 19, 2004 at 05:50:16PM -0300, Daniel Corr=EAa de Azevedo wrot=
e:
>    Hi there.
>    Where can I find out more about the netfilter-ha module? Is there an=
y=20
> documentation on that?
>    I=B4m doing an academic project about making netfilter-iptables a hi=
gh=20
> availabe service and I really could use some help from the netfilter=20
> developers community. Any clues or documentations are welcome.
>    Thanks,
>=20
>           Daniel Azevedo

--=20
    .~.  Ulysses Almeida
   / V \  munky@maluco.com.br
 / (   ) \  Seja livre, use GNU/Linux!=20
   ^^-^^
