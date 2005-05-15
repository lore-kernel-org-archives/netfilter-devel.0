From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: About matching (also was: Multiple Targets)
Date: Sun, 15 May 2005 09:05:28 +0000
Message-ID: <428710D8.6090801@outerspace.dyndns.org>
References: <20050413152307.0312.LARK@linux.net.cn> <425CEFE3.2010200@rtij.nl>
	<20050413182822.0317.LARK@linux.net.cn> <425CFFE0.1000803@rtij.nl>
	<20050413112518.GB22865@oknodo.bof.de>
	<Pine.LNX.4.61.0504140315010.16405@filer.marasystems.com>
	<7174b1e40504140101b5138e0@mail.gmail.com>
	<425E3032.2060409@outerspace.dyndns.org>
	<Pine.LNX.4.61.0504141340130.28938@filer.marasystems.com>
	<425E6E4C.2010406@outerspace.dyndns.org>
	<42780DE4.9060808@outerspace.dyndns.org>
	<Pine.LNX.4.58.0505040909090.18836@blackhole.kfki.hu>
	<42787CEE.1090503@outerspace.dyndns.org>
	<Pine.LNX.4.58.0505040947330.18836@blackhole.kfki.hu>
	<4278D431.5000606@outerspace.dyndns.org>
	<Pine.LNX.4.58.0505050833580.21246@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0505050833580.21246@blackhole.kfki.hu>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Quoting Jozsef Kadlecsik on 2005-05-05 06:36 UTC:
> In my opinion cascade targets should return IPT_CONTINUE. They may
> return NF_DROP in error conditions, but other return values are not
> allowed.

Right.

How about hotdrop? I guess it should be checked in the
IPT_TARGET_ITERATE macro?

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFChxDXxyF48ZTvn+4RAnEQAKC6vOY1ucjHWxmUI7TJrFems2gtOACdFWsa
ELwbGpmrNwdcBT1WACkVBKQ=
=d18+
-----END PGP SIGNATURE-----
