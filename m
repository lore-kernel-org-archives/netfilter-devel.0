From: Andy Polyakov <appro@fy.chalmers.se>
Subject: Re: iptables performance under 2.6.0[-test9]
Date: Mon, 27 Oct 2003 19:05:20 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F9D5E60.866B0B63@fy.chalmers.se>
References: <3F9D4370.99795B87@fy.chalmers.se>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------76A106EEBA58B2E256A5345D"
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

This is a multi-part message in MIME format.
--------------76A106EEBA58B2E256A5345D
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

> I tried to deploy 2.6.0[-test9] iptables to masquerade a private
> interace. Strangely enough ip_conntrack.ko module seems to affect
> performance of *some* TCP connections. ... I'm looking for
> triggering factors...

Apparently it's not certain connections as wholes which are affected,
but only some outgoing packets. Those packets corresponding to socket
writes larger than MTU-40 [where 40 is size of TCP/IP header]... I fail
to imagine how come, but here is how I can reproduce the problem with
attached head.pl script:

- 'lsmod' to make sure *no* iptables modules are loaded;
- 'time ./head.pl some.host 2000' says that it takes a portion of
elapsed second for script to complete;
- modprobe ip_conntrack;
- 'time ./head.pl some.host 2000' now says that it takes over 3(!)
elapsed seconds to complete;

If I reduce amount of \n's send in first socket write by passing value
of 1460 or lower as the last command-line argument, the script completes
instantly regardless if ip_conntrack is loaded or not. Therefore the
conclusion about MTU-40... Cheers. A.
--------------76A106EEBA58B2E256A5345D
Content-Type: application/x-perl;
 name="head.pl"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="head.pl"

#!/usr/bin/env perl

use Socket;

$remote = shift	|| 'localhost';
$n  = shift	|| 2000;

socket (SOCK, PF_INET, SOCK_STREAM, 0)	|| die "socket: $!";
$iaddr   = inet_aton($remote)		|| die "no host: $remote";
connect(SOCK, sockaddr_in(80, $iaddr))	|| die "connect: $!";

use IO::Handle;
SOCK->autoflush(1);
SOCK->setbuf(8000);
print SOCK "\n" x $n, "HEAD / HTTP/1.0\n\n";
while(<SOCK>) { print ; }

--------------76A106EEBA58B2E256A5345D--
