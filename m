From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: Linux 2.6.12/iptables 1.3.1+CLUSTERIP issues
Date: Wed, 22 Jun 2005 19:27:18 -0400
Message-ID: <876ef97a05062216273a613d8c@mail.gmail.com>
References: <876ef97a0506201904a05582a@mail.gmail.com>
	<20050622121509.GG4551@obroa-skai.de.gnumonks.org>
	<42B9D299.1080902@eurodev.net>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>,
	nf-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42B9D299.1080902@eurodev.net>
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

On 6/22/05, Pablo Neira <pablo@eurodev.net> wrote:
> >>iptables -A INPUT -d 192.168.1.3 -i eth0 -p tcp --dport 3000 -j
> >>CLUSTERIP --new --hashmode sourceip-sourceport --clustermac
> >>01:23:45:67:89:AB --total-nodes 2 --local-node 1
> >>
> >>I then tried to remove it (I didn't update iptables rules again since
> >>then) by switching the -A to a -D and that failed. I tried all sorts
> >>of combinations of the arguments to -j CLUSTERIP but they all failed.
> >>Eventually, I was forced to remove the rule by using the iptables rule
> >># (e.g. iptables -D INPUT 10). I feel that this is in error, but I've
> >>seen at least two patches to CLUSTERIP that claim to fix rule
> >>deletion. Am I doing something wrong?
>=20
> fix-del-with-userspacesize-target.patch:
>=20
> You still need to apply this patch to iptables, it got lost somehow
> since I've posted it some time ago. It fixes ipt_CLUSTERIP deletion. To
> be precise, it fixes rule deletion of targets whose userspace size part
> differs from the kernel part.
>=20
> BTW, I forgot if you passed the patch here below (link) to davem? I
> can't see it in the current git snapshot. got lost as well ?
>=20
> http://people.netfilter.org/pablo/patches/fixes/kernel/pending/fix-layout=
-CLUSTERIP.patch
>=20
> @Tobias: With both patches applied you'll fix your problems with
> CLUSTERIP rule deletion.

This did indeed fix both issues that I was having. Thanks, Pablo!

--=20
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
