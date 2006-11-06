From: Maximilian Wilhelm <max@rfc2324.org>
Subject: Created debian/ dir for dpkg-buildpackage (was: Re: [ANNOUNCE]
	conntrackd-0.9.1 released)
Date: Mon, 6 Nov 2006 20:37:41 +0100
Message-ID: <20061106193740.GA5251@galois.math.uni-paderborn.de>
References: <454F7707.3010904@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,
	netfilter-ha@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <454F7707.3010904@netfilter.org>
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

Am Montag, den  6. November hub Pablo Neira Ayuso folgendes in die Tasten:

> Status:

> This project is under development, people feeling brave are encouraged
> to test a send nice reports ;)
 
So far: It seems to work :)

I felt brave enough to create a debian like init.d script and a whole
debian directory for the source tree to simplify building of conntrackd
packages.

Also I wrote a little script to be used as heartbeat resource.d plugin
which is included in the tar-ball as exmaple.

As a debian dir is included in the libnetfilter_conntrack and libnfnetlink
tar-balls it thought this could be helpfull. :)

You can download the tarball of the debian/ dir at
 http://files.rfc2324.org/conntrackd/

Pablo, would you include this in further versions?

Btw at
 deb http://debian.rfc2324.org/debian sarge conntrackd
 deb-src http://debian.rfc2324.org/debian sarge conntrackd
you can download precompiled packages for sarge.

Ciao
Max
-- 
|           |                 Follow the white penguin.
|  |\/|  |  |-----------------------------------------------------------.
|  |  |/\|  |  Rechnerbetrieb Mathematik  |   Meine Baustellen:  TSM    |
|           |  Universitaet Paderborn     |   Hostmaster, Linux, LDAP   | 
