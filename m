From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: iptables freeze
Date: Wed, 07 Jul 2004 11:29:27 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1089192566.2599.5.camel@nienna.balabit>
References: <20040706224021.GU32707@sunbeam2>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: arny@arny.ro
In-Reply-To: <20040706224021.GU32707@sunbeam2>
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

2004-07-07, sze keltezéssel 00:40-kor Harald Welte ezt írta:
> I have a p4 2,8 HT PC with slackware 9.1, kernel 2.6.7 SMP, runing
> squid(transparent proxy)+ firewall+routing. The trafic is 1M for 300
> clients.
> Sometimes the box freez. When is restarted i got this messages and after 3
> minutes it freez again. Maybe is a harware problem but i dont khow waht is
> exactly. I fallow the logs and i got this.
>
> Jul  6 00:41:51 gw kernel: LIST_DELETE:
> net/ipv4/netfilter/ip_conntrack_core.c:300
> `&ct->tuplehash[IP_CT_DIR_REPLY]'(f63
> 7a224) not in &ip_conntrack_hash[hr].
> Jul  6 00:41:51 gw kernel: LIST_DELETE:
> net/ipv4/netfilter/ip_conntrack_core.c:300
> `&ct->tuplehash[IP_CT_DIR_REPLY]'(f64
> f3824) not in &ip_conntrack_hash[hr].

  This looks just like the symptoms of an old bug, however, which should
not occur with 2.6.7... (It was caused by NAT changing the reply tuple
of an already hashed connection.) Just to make sure, could you provide
us your kernel config? Is 'NAT of local connections' enabled? It not,
can you try with that?

-- 
 Regards,
   Krisztian KOVACS
