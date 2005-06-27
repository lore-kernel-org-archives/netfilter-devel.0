From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: Linux 2.6.12/iptables 1.3.1+CLUSTERIP issues
Date: Mon, 27 Jun 2005 13:34:30 -0400
Message-ID: <876ef97a0506271034378f5c7b@mail.gmail.com>
References: <876ef97a0506201904a05582a@mail.gmail.com>
	<20050622121509.GG4551@obroa-skai.de.gnumonks.org>
	<876ef97a050622060750b078bd@mail.gmail.com>
	<20050622191742.GN4551@obroa-skai.de.gnumonks.org>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Tobias DiPasquale <codeslinger@gmail.com>,
	nf-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20050622191742.GN4551@obroa-skai.de.gnumonks.org>
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

On 6/22/05, Harald Welte <laforge@netfilter.org> wrote:
> On Wed, Jun 22, 2005 at 09:07:02AM -0400, Tobias DiPasquale wrote:
> > On 6/22/05, Harald Welte <laforge@netfilter.org> wrote:
> > > this should never happen.  iptables always prefers
> > > $KERNEL_DIR/include/linux/netfilter_ipv4 above its local copy.  Are y=
ou
> > > sure KERNEL_DIR was set correctly while compiling iptables?
>=20
> Ok, I now found what your problem was.  Instead of copying the
> kernel-ipt_CLUSTERIP.h to iptables, you should have done it the other
> way around (copy itpables-header to the kernel and recompile both).
>=20
> The reason is that somehow one of the bugfixes for ipt_CLUSTERIP that I
> sent DaveM some 7 weeks ago did not make it into 2.6.12 for unknown
> reasons :(

I think I see the reason: the new header file from the patch you're
referring to installs into "linux/netfilter_ipv4/ipt_CLUSTERIP.h", not
"include/linux/netfilter_ipv4/ipt_CLUSTERIP.h" where it should go.

--=20
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
