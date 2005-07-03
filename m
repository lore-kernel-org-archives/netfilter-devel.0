From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: Iptables and kernel modules
Date: Sun, 03 Jul 2005 21:09:08 +0000
Message-ID: <42C853F4.6010702@outerspace.dyndns.org>
References: <20050701004115.34697.qmail@web26507.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, laarouch@enseirb.fr
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: LAAROUCHI Youssef <laarouchi_yous@yahoo.fr>
In-Reply-To: <20050701004115.34697.qmail@web26507.mail.ukl.yahoo.com>
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

Quoting LAAROUCHI Youssef on 2005-07-01 00:41 UTC:
> Hi,
> 
> I've created a kernel module to modify the format of
> exchanged IP packets... This module is correctly inserted
> into the kernel. I then want to make this module receive
> the packets by using the following command :
> 
> #iptables -t mangle -A INPUT -p icmp --icmp-type 38 -j 
> puzClient
> 
> This command returns an error asking for .so file... The
> problem is that I don't know the format of .so files.. I
> have generated one .so file by adding -shared in the link
> command, but it doesn't solve the problem. I have undefined
> symbols error.

You need to create a userspace helper for your kernel module. If your
kernel module is named ipt_puzClient.c, the userspace helper should be
named libipt_puzClient.c and be placed in the iptables source tree in
the extensions/ directory. There are also a few more files in the same
directory that you need to create, see sections 9-12 in the
README.newpatchs in patch-o-matic-ng e.g.

http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/README.newpatches?rev=4018&view=auto

You can look at libipt_MARK.c for an example..

> So can you specify to me how the .so files are generated ?

After you get the files in place and your kernel has been configured to
compile your module, compile iptables and it should detect that it needs
to create libipt_puzClient.so and create it for you.

> and what is the necessary format to generate a ipt_target
> so file. And eventually, can we make iptables working
> directly  with kernel modules without using .so files  ? ? 

Everything's possible, but that wouldn't be very nice. Creating the .so
file shouldn't be too hard as soon as you understand how to do it. I
think you can copy-paste a lot from libipt_MARK.c to get going..

> Thanks,
> 
> Youssef

Good luck! :)

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCyFPyxyF48ZTvn+4RAtJiAJ98X0JbIrbm0sgpe2kSgv2uzq8xogCeMrJL
BBwA6+jInSxYcFbAfpmgPpI=
=7P8r
-----END PGP SIGNATURE-----
