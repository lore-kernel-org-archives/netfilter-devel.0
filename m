From: Sam Johnston <samj@aos.net.au>
Subject: Re: iptables - quota patch - periodicallyl reset
Date: Wed, 26 Mar 2003 09:07:49 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E80D335.3020201@aos.net.au>
References: <FPECKACNBMMEFMLKMPHPAEEECAAA.fgaab@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Florian Gaab <fgaab@web.de>
In-Reply-To: <FPECKACNBMMEFMLKMPHPAEEECAAA.fgaab@web.de>
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

Florian Gaab wrote:
| Hello,
|
| I want to use your iptables matching rule "quota" for limiting
| transfered data within a predefined time span. E.g. not more
| than 100 megabytes within 24 hours. Is it posible to reset the
| accumulated amount periodically (probably with a cronjob like
| "echo 0 > /proc/somewhere/labyrinth/deeper/and_deeper/quota/amount")?

It is not currently possible to examine or manupulate quotas via procfs
(at least not directly). Something like this is probably not a bad idea,
but I'm not sure how to go about implementing it, nor whether it would
be worth the effort given you can accomplish this by creating/deleting
rules as appropriate.

I'm more likely to implement soft quotas before I look into more
advanced quota manipulation - besides, how would you differentiate
between rules in procfs?

Sam

- --
Sam Johnston, Director
Australian Online Solutions
1300 132 809
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQE+gNM1j4XJViLpTR0RAtwxAJ40DQL8T4rw7TUUOLpsJqZ9qfD/jACeNUHx
Z7jdevqwfI5DCpuJsQQ6ILQ=
=X1Gl
-----END PGP SIGNATURE-----
