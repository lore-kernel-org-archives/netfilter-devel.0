From: c0g <c0g@wp.pl>
Subject: Re: raw patch = kernel panic :(
Date: Mon, 06 Oct 2003 21:30:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F81C2DF.3030501@wp.pl>
References: <Pine.LNX.4.33.0310061238480.15175-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0310061238480.15175-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

|>I applied raw-patch from CVS patch-o-matic (20031003), and it appears
|>that loading rule in PREROUTING chain of table raw causes kernel panic.
|
|
| Yes, that was due to a stupid bug in the NOTRACK target. I have applied
| the fixed patch in p-o-m. Sorry for the previous buggy release.

Great! Thanks.

- --
c0g@wp.pl
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQE/gcLfPqmVt5WhbA8RAmEgAKCS62bNCPIBSBH8YufYDdBxoxTiXQCfaLUI
ygtDICgaQ5aaTj1l8b3LZ0A=
=eHLR
-----END PGP SIGNATURE-----
