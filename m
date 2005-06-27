From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: RSH helper concurrent sessions fix
Date: Mon, 27 Jun 2005 15:10:11 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0506271350050.11307@blackhole.kfki.hu>
References: <JBEOIOMFMBOPMPLFDIALKENHCJAA.aberle@infotech.de>
	<20050627090637.GD19928@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Sebastian Aberle <aberle@infotech.de>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050627090637.GD19928@sunbeam.de.gnumonks.org>
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

On Mon, 27 Jun 2005, Harald Welte wrote:

> On Wed, Jun 22, 2005 at 05:22:00PM +0200, Sebastian Aberle wrote:
> > Hi,
> >
> > here is a fix for a small error I discovered in the RSH conntrack
> > helper when trying to establish multiple concurrent sessions to a host
> > (working for me, at least).
>
> Thanks for your patch.
>
> It's up to Jozsef (Cc) to comment (and ACK/NACK) on this, he's the author of
> the rsh helper.

I'm not the author of the rsh helper ;-), but anyway, here goes my
opinion:

The protocol descriptions of rsh available for me are a little bit fuzzy:

- According to Chapman & Zwicky, both the source and destination ports of
  the error channel are below 1024.
- The source code of rshd from netkit-rsh indeed makes sure that both
  ports of the error channel be reserved.
- The manpage of rshd does not state that the destination port must be
  below 1024.
- The protocol description in ip_conntrack_rsh.c itself does not state
  either, but the code checks and rejects requested destination ports
  above 1023.

So first, what kind of system and rsh version do you use on the client and
the server side? Could you post a tcpdump recording of an rsh session
where the ports of the error channel are above 1023? Second, I don't
understand how could your patch relax the check on the destination port
without other modifications.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
