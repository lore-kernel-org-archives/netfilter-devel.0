From: Florian Boelstler <euphoria@web.de>
Subject: Handling incoming DCC session
Date: Wed, 09 Jun 2004 01:04:28 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40C645FC.7080505@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,

a long time ago someone posted a patch for 2.4.18 kernels [1], which
allowed incoming DCCs get caught by a default 'related' rule.

As far as I know this patch wasn't applied by the module maintainer.
Unfortunately the sources have changed in the meantime and the patch
doesn't work anymore.

I was trying to adapt the patch to kernel 2.6.5. But I don't have enough
knowledge to successfully modify it.

Is there anybody out there who owns a patch for 2.6.x series?
Or could assist me in creating a patch? :)


Thanks for your help!

  Florian


[1]
http://lists.netfilter.org/pipermail/netfilter-devel/2002-July/008665.html



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)
Comment: Using GnuPG with Debian - http://enigmail.mozdev.org

iD8DBQFAxkX8wT2gPfZm6tURApwQAJ4xeY22pdzupZWEu1ikejppOn814ACeLdrM
jPLpvzQ1NvEs97rRzsWftjA=
=elf+
-----END PGP SIGNATURE-----
