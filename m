From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: netfilter h323 helper extension
Date: Fri, 30 Jul 2004 14:50:31 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0407301441380.31121-100000@blackhole.kfki.hu>
References: <200407271650.36835.michaelc@mikeit.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Michael Carmody <michaelc@mikeit.com.au>
In-Reply-To: <200407271650.36835.michaelc@mikeit.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Tue, 27 Jul 2004, Michael Carmody wrote:

> It seems that Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> has a very tight
> spam filter and has rejected all my mails so far.

Sorry. In fall we'll improve our spam filtering system to handle
unintentionally closed-out messages better.

> Trying this out for a H.323 Interop project between cisco and 3com VoIP gear.
>
> Without any helper and just basic port redirection I get phones ringing but of
> course since the H.225 packet is not being mangled the systems try to connect
> to the wrong IP.
>
> With your ip_conntrack_h323 and ip_nat_h323 modules loaded I get non-function.

The modules work in some cases while in other cases they simply does not
work at all. In the latter case I always suggest to setup a H.323
gatekeeper/proxy instead.

There is no way to fix the current modules without a complete rewriting
from the ground. To be honest, I do not plan to start such a project in
the near future...

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
