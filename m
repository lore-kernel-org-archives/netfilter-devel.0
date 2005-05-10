From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: Patch won't apply
Date: Mon, 9 May 2005 20:10:01 -0400
Message-ID: <debc30fc05050917104a2930a5@mail.gmail.com>
References: <debc30fc05050916341490ee44@mail.gmail.com>
Reply-To: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <debc30fc05050916341490ee44@mail.gmail.com>
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

Just found out what caused the problem! It seems that patch in the SVN
which was done 4 days ago broke the versionning completely, reverting
it repaired the problem on my side.

http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/Netfilt=
er_POM.pm?rev=3D3896&r1=3D3820&r2=3D3896

On 5/9/05, J=E9r=F4me Poulin <jeromepoulin@gmail.com> wrote:
> I just downloaded the kernel-2.6.12-rc3-mm3, the latest snapshot from
> iptables and pom-ng (2005-05-09) and I tried to apply ./runme extra,
> only 4 patchs were suited for my kernel, others won't apply saying
> they "does not match your source trees". The 4 to apply were "set",
> "connrate" (with 3 rejects / 4 hunks), "goto" and "h323-conntrack".
>=20
> I compared them and found out all the patchs not having a Requires:
> line in their info file were not matching, so I added Requires:
> linux-2.6 >=3D 2.6.10  to all the patch I know were working in my last
> kernel and it worked, they applied. I think the runme script is broken
> or something because it always worked perfectly before.
>
