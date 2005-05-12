From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: [PATCH pom-ng] port TARPIT to linux 2.6.12
Date: Thu, 12 May 2005 17:01:41 -0400
Message-ID: <debc30fc050512140130aa399e@mail.gmail.com>
References: <20050512182024.GA23331@roonstrasse.net>
Reply-To: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
In-Reply-To: <20050512182024.GA23331@roonstrasse.net>
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

Heh, does anyone checked the message with subject ipt_TARPIT.c from
me, submitted the same patch...

On 5/12/05, Max Kellermann <max@duempel.org> wrote:
> Hi,
>=20
> the following two mini patches port the TARPIT target to linux
> 2.6.12.
>=20
> tarpit-01-fix_indent.patch
> - fix the indentation in the source file (tabs)
>=20
> tarpit-02-linux_2_6_12_api.patch
> - call dst_mtu() instead of dst_pmtu() on 2.6.12 (conditional)
>=20
>=20
> Max
>=20
>=20
>
