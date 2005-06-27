From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: CLUSTERIP and ProxyARP?
Date: Mon, 27 Jun 2005 07:11:24 -0400
Message-ID: <876ef97a0506270411795a4c62@mail.gmail.com>
References: <876ef97a0506231536656b269b@mail.gmail.com>
	<20050627090959.GE19928@sunbeam.de.gnumonks.org>
	<876ef97a050627035063f5d929@mail.gmail.com>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	nf-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <876ef97a050627035063f5d929@mail.gmail.com>
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

On 6/27/05, Tobias DiPasquale <codeslinger@gmail.com> wrote:
> On 6/27/05, Harald Welte <laforge@netfilter.org> wrote:
> > 1. all current linux kernel up to (and including 2.6.12) has a CLUSTERI=
P bug
> >    anyway
>=20
> What bug? Was it mentioned on this list earlier? I don't remember seeing =
it...

Were you referring to the fact that, without a patch from earlier on
this list (from Alex somebody?), CLUSTERIP won't mangle ARP requests?
I can see that this patch didn't make it into 2.6.12.

--=20
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
