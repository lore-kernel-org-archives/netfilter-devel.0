From: "Samuel Jean" <sj-netfilter@cookinglinux.org>
Subject: Re: [PATCH] ipt_hashlimit.c: expire's type overflow when showing
 tuples at bad moment.
Date: Tue, 1 Feb 2005 09:53:49 -0500 (EST)
Message-ID: <6732.142.169.215.10.1107269629.squirrel@142.169.215.10>
References: <41F2FE92.6020603@cookinglinux.org>
	<20050201132915.GJ6878@sunbeam.de.gnumonks.org>
	<41FF877D.4080309@trash.net>
	<20050201135423.GS6878@sunbeam.de.gnumonks.org>
	<41FF9024.3070101@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
In-Reply-To: <41FF9024.3070101@trash.net>
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

On Tue, February 1, 2005 9:20 am, Patrick McHardy said:
> ipt_hashlimit already uses %ld. Samuel, what problem are you seeing
> exactly ?
> Is it negative times or wrapped times ?

I see wrapped time.

I've tried making it print negative values, but seems I can't get
unsigned operations to result in a signed value. Is that right ?

However,

int r =3D (unsigned - unsigned) gave me negative value.

>
> Regards
> Patrick

Have a nice day,

Samuel

P.S.: Please disregard that patch, I`ve send another one [PATCH 1/2] whic=
h
doesn't use unecessary variable, I think. Thank you.
