From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] modification in current protocol helper API to handle
 error/unclean packets
Date: Mon, 14 Jun 2004 11:05:28 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406141057510.12847-100000@blackhole.kfki.hu>
References: <40CCECFF.9070907@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40CCECFF.9070907@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

On Mon, 14 Jun 2004, Pablo Neira wrote:

> I added a new function to the current protocol helper API. It is called
> before resolve_normal_ct, this could let us perform actions before
> starting a new session/conntrack.
>
> These actions could be:
> - check for malformed/unclean packets.
> - handle special packets like in ICMP.
>
> This way, Jozsef could call unclean() here in his tcp-window-tracking
> patch and we won't need to add protocol specific function to the core of
> the conntrack system like icmp_error_track to handle special ICMP
> messages. We could also check for unclean udp and icmp packets.

I like it, too! I think the tcp-window-tracking patch should be made
dependent of your patch, because it'd make the code cleaner (the quick fix
for the local checksum problem reported by Martin was to pass down the
hooknum as additional argument of the packet/new functions, but it's ugly
and changes the API as well.)

> This function returns 0 if no error was found or an action (NF_*) if an
> error/special action needs to be done to handle a message.

NF_DROP == 0, so it should simply return an NF_* value. Thus the condition

+       /* It may be an special packet, error, unclean... */
+       if ((ret = proto->error(*pskb, &ctinfo, hooknum)))
+               return ret;

should be

+       /* It may be an special packet, error, unclean... */
+       if ((ret = proto->error(*pskb, &ctinfo, hooknum)) != NF_ACCEPT)
+               return ret;

And as Patrick noted, UDP checksumming in IPv4 is not mandatory.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
