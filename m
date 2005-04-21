From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: [PATCH] ipt_connlimit / speed-up.
Date: Thu, 21 Apr 2005 08:44:09 +0000
Message-ID: <426767D9.3050808@outerspace.dyndns.org>
References: <200504210510.01886.pluto@pld-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pawel Sikora <pluto@pld-linux.org>
In-Reply-To: <200504210510.01886.pluto@pld-linux.org>
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

Quoting Pawel Sikora on 2005-04-21 03:10 UTC:

I just had to test one alternative.. :)

> ipt_iphash: (fixed)

>         movl    %eax, %edx

>         shrl    $8, %edx

>         xorl    %eax, %edx
>         shrl    $16, %eax

>         xorl    %eax, %edx
>         shrl    $8, %eax

>         xorl    %eax, %edx

>         movzbl  %dl,%eax

>         ret

I grouped the instructions of your solution according to my outdated and
maybe incomplete knowledge of how Pentium processors execute
instructions in parallell. This gives 7 groups.

> +	return ((addr ^
> +		(addr >>  8) ^
> +		(addr >> 16) ^
> +		(addr >> 24)) & 0xff);

My approach:

	unsigned tmp = addr ^ (addr >> 16);
	return ((tmp >> 8) ^ tmp) & 255;

Which gives:

        movl    %eax, %edx
        shrl    $16, %eax

        xorl    %edx, %eax

        movl    %eax, %edx

        shrl    $8, %edx

        xorl    %edx, %eax

        andl    $255, %eax

        ret

This also gives 7 groups. If the compiler had only used eax instead in
"shrl $8, %edx", the instruction could have been grouped with the
previous instruction and my solution would have beaten yours, but no,
the compiler chose to modify the copy instead of the original.. :)

So both my and your solution end up using the same amount of cpu
although my code has one instruction less and also results in one byte
less of assembler instructions.. :)

However, on my processor, your solution results in 7 groups of code
while mine results in 8 (again, the compiler chose to modify a copy
instead of the original), so I'm going to vote for your version :D

For the fun of it, here's what your version looks like on x86_64:

	movl	%edi, %eax
	movl	%edi, %edx

	shrl	$8, %eax
	shrl	$16, %edx

	xorl	%edi, %eax
	shrl	$24, %edi

	xorl	%edx, %eax

	xorl	%edi, %eax

	andl	$255, %eax

	ret

Keep up the good work :)

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCZ2fYxyF48ZTvn+4RAgHyAJ9B3vcxnPRHZOhHT3Eh6U/p8Mjh8QCeJwL2
OPiZ1VtkT8Y+Jug3UwCDdIg=
=UwcV
-----END PGP SIGNATURE-----
