From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Patch won't apply
Date: Mon, 9 May 2005 19:34:13 -0400
Message-ID: <debc30fc05050916341490ee44@mail.gmail.com>
Reply-To: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

I just downloaded the kernel-2.6.12-rc3-mm3, the latest snapshot from
iptables and pom-ng (2005-05-09) and I tried to apply ./runme extra,
only 4 patchs were suited for my kernel, others won't apply saying
they "does not match your source trees". The 4 to apply were "set",
"connrate" (with 3 rejects / 4 hunks), "goto" and "h323-conntrack".

I compared them and found out all the patchs not having a Requires:
line in their info file were not matching, so I added Requires:
linux-2.6 >=3D 2.6.10  to all the patch I know were working in my last
kernel and it worked, they applied. I think the runme script is broken
or something because it always worked perfectly before.
