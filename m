From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: locking issue in ip_conntrack_alter_reply
Date: Mon, 3 May 2004 11:05:42 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405031057120.24224-100000@blackhole.kfki.hu>
References: <40928861.2010902@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40928861.2010902@eurodev.net>
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

On Fri, 30 Apr 2004, Pablo Neira wrote:

> Well, actually I found a contradiction here, we write-locked the
> conntrack table but that assertion says that this conntrack is not
> confirmed, this implies that the conntrack is not in the hash table yet.
> If that assertion is right, we should replace that write_lock for a
> read_lock while calling __ip_conntrack_find and remove that write_lock
> at the end of the function.
>
> int ip_conntrack_alter_reply(struct ip_conntrack *conntrack,
>                              const struct ip_conntrack_tuple *newreply)
> {
>         WRITE_LOCK(&ip_conntrack_lock);
>         if (__ip_conntrack_find(newreply, conntrack)) {
>                 WRITE_UNLOCK(&ip_conntrack_lock);
>                 return 0;
>         }
>         /* Should be unconfirmed, so not in hash table yet */
>         IP_NF_ASSERT(!is_confirmed(conntrack)); <--------------------------
>
>
> I'll study if that assertion is right before submitting a patch.

The assertion is right, because we alter unconfirmed packets when setting
up nat info. And you're also right, write-locking is unnecessary: the
entry is not in the hash table yet, so nobody else can grab and modify the
conntrack entry. [And it is overlooked in the per bucket locking patch too.]

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
