From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: what is okfn?
Date: Wed, 3 Dec 2003 11:32:36 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312031128390.6278-100000@filer.marasystems.com>
References: <E1ARSRZ-0003OX-3y@vishnu.netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Fangweiwei <fangweiwei@tom.com>
In-Reply-To: <E1ARSRZ-0003OX-3y@vishnu.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 3 Dec 2003, Fangweiwei wrote:

> netfilter-devel=A3=AChi=A3=A1
>         who can tell me where is okfn defined ? and how it works? I fou=
nd it in the netfilter.h.

There is several. Any specific use of okfn in netfilter.h you refer to?

In all cases okfn is a pointer to the function which will be called when
the operation is completed sucessfully. The actual pointer is given by th=
e=20
caller. For example the okfn sent to netfilter hooks is given by the hook=
=20
in the kernel telling netfilter where the kernel wishes to continue when=20
netfilter has done it's job..

Regards
Henrik
