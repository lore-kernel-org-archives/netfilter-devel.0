From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: CLUSTERIP and ProxyARP?
Date: Mon, 27 Jun 2005 06:50:28 -0400
Message-ID: <876ef97a050627035063f5d929@mail.gmail.com>
References: <876ef97a0506231536656b269b@mail.gmail.com>
	<20050627090959.GE19928@sunbeam.de.gnumonks.org>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	nf-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20050627090959.GE19928@sunbeam.de.gnumonks.org>
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

On 6/27/05, Harald Welte <laforge@netfilter.org> wrote:
> On Thu, Jun 23, 2005 at 06:36:08PM -0400, Tobias DiPasquale wrote:
> > Hi all,
> >
> > Does anyone know if ipt_CLUSTERIP and ProxyARP will work correctly
> > together on a current Linux kernel? Anything special to watch out for?
> > TIA :)
>=20
> 1. all current linux kernel up to (and including 2.6.12) has a CLUSTERIP =
bug
>    anyway

What bug? Was it mentioned on this list earlier? I don't remember seeing it=
...

> 2. I didn't think about interoperability with  proxyarp when
>    implementing CLUSTERIP.  In fact, CLUSTERIP is meant to run on
>    end-hosts (Such as webservers), not on gateways.
>=20
> CLUSTERIP mangles ARP requests (and replies) from/to the CLUSTER IP
> address.  So if you are proxy-ARP'ing for different IP addresses, it
> _should_ work.

I'm going to test it out today. I will let the list know the results. Thank=
s.

--=20
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
