From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: locking issue in ip_conntrack_alter_reply
Date: Tue, 04 May 2004 09:01:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1083654107.1742.6.camel@nienna.balabit>
References: <Pine.LNX.4.33.0405031057120.24224-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Cc: Pablo Neira <pablo@eurodev.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0405031057120.24224-100000@blackhole.kfki.hu>
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

2004-05-03, h keltezéssel 11:05-kor Jozsef Kadlecsik ezt írta:
> > Well, actually I found a contradiction here, we write-locked the
> > conntrack table but that assertion says that this conntrack is not
> > confirmed, this implies that the conntrack is not in the hash table yet.
> > If that assertion is right, we should replace that write_lock for a
> > read_lock while calling __ip_conntrack_find and remove that write_lock
> > at the end of the function.
> >
> > int ip_conntrack_alter_reply(struct ip_conntrack *conntrack,
> >                              const struct ip_conntrack_tuple *newreply)
> > {
> >         WRITE_LOCK(&ip_conntrack_lock);
> >         if (__ip_conntrack_find(newreply, conntrack)) {
> >                 WRITE_UNLOCK(&ip_conntrack_lock);
> >                 return 0;
> >         }
> >         /* Should be unconfirmed, so not in hash table yet */
> >         IP_NF_ASSERT(!is_confirmed(conntrack)); <--------------------------
> >
> >
> > I'll study if that assertion is right before submitting a patch.
> 
> The assertion is right, because we alter unconfirmed packets when setting
> up nat info. And you're also right, write-locking is unnecessary: the
> entry is not in the hash table yet, so nobody else can grab and modify the
> conntrack entry. [And it is overlooked in the per bucket locking patch too.]

  Why is the whole check necessary here? ip_conntrack_alter_reply() is
called by ip_nat_setup_info() to change the reply tuple of the
conntrack. However, by assuring that there is no clashing conntrack
entry at this time, we gain nothing. get_unique_tuple() tries to return
such a tuple, and ip_conntrack_alter_reply() checks once more in vain: a
new clashing conntrack entry can be created and confirmed before
confirmation of this conntrack.

  So I'd say this hash lookup should be removed completely.

-- 
 Regards,
   Krisztian KOVACS
