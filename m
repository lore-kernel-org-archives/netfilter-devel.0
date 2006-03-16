From: Herve Eychenne <rv@wallfire.org>
Subject: Re: Knowing tables change
Date: Thu, 16 Mar 2006 11:12:26 +0100
Message-ID: <20060316101226.GO25252@eychenne.org>
References: <44155BE4.80001@wengo.fr> <441587CF.4050203@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org,
	Sebastien Tricaud <sebastien.tricaud@wengo.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <441587CF.4050203@trash.net>
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

On Mon, Mar 13, 2006 at 03:55:11PM +0100, Patrick McHardy wrote:

> Sebastien Tricaud wrote:
> > Hi folks,
> >=20
> > I would like to know if there is a way to watch for tables alteration=
.
> >=20
> > I am sure there is a better way than doing "iptables -t table -L" loo=
p
> > and compare with previously stored data.

> watch -n 1 -d iptables -vxnL :)

> > When I look over Internet for possible answers, I can find something
> > that would do the job. It seems libpkttnetlink is for this purpose.
> > However no developments are latter than 2002. Is it a working stuff a=
nd
> > nothing has to be improved anymore ?
> >=20
> > At a lower level, I can see libnfnetlink is the low level library I c=
an
> > also use for it: there is the following quote -> "provides
> > open/close/receive functions only to be used by other libraries
> > libctnetlink/libpkttnetlink".

> There are no notifications for ruleset updates currently, since
> ruleset exchange between kernel and userspace isn't built on
> netlink and happens as one atomic operation, so the kernel
> doesn't know which rules are new.

Does listing the rules imply some locking? I guess it can be a costly
operation if the ruleset is big...
It would at least be nice to send a "signal" (via netlink) when the
ruleset is changed, so that third party applications can figure out
the changes themselves only when needed (without having to do regular
active polls).

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
