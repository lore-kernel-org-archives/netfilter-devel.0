From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: PATCH: extra conntrack stats
Date: Thu, 01 May 2003 16:46:44 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030501064732.ADD9C2C003@lists.samba.org>
References: <20030501060522.GB15143@oknodo.bof.de>
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
	Harald Welte <laforge@netfilter.org>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-reply-to: Your message of "Thu, 01 May 2003 08:05:22 +0200."
             <20030501060522.GB15143@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <20030501060522.GB15143@oknodo.bof.de> you write:
> > 	struct nf_ct_info infos[IP_CT_NUMBER];
> > 7 * 4 bytes.  We could eliminate this by adding an skb field to hold
> > the state.
> 
> Given a guaranteed cacheline alignment of our 'struct ip_conntrack',
> we could make the current pointer on the skbuffs a tagged pointer,
> i.e. stuff our 3 info bits into the low 3 bits, without consuming
> more room in the skbuffs.

That was my original implementation.  It was fairly ugly, but worse, I
can imagine an arch where it would break.  None would at the moment,
though, since kmalloc cacheline aligns (although we'd have to be a
little careful to explicitly align a conntrack if we were to use a
dummy one for a "notrack" target.

> See http://lists.netfilter.org/pipermail/netfilter-devel/2002-July/008703.html

That looks like a good patch anyway...

Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
