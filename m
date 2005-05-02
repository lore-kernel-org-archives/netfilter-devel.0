From: "Vincent" <cs83152@csie.chu.edu.tw>
Subject: RE: LOG and DROP some specified packets in the same iptables rule
Date: Mon, 2 May 2005 14:49:08 +0800
Message-ID: <000c01c54ee3$0dfb4180$aa0ba8c0@l7.com.tw>
References: <20050502060322.GF25226@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'Patrick Schaaf'" <bof@bof.de>
In-Reply-To: <20050502060322.GF25226@oknodo.bof.de>
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

> > Can I simply do the change in ipt_LOG.c like the following.
> > 
> > --- ipt_LOG.c.old       2005-05-02 12:58:18.000000000 +0800
> > +++ ipt_LOG.c   2005-05-02 12:58:45.000000000 +0800
> > @@ -346,7 +346,7 @@ ipt_log_target(struct sk_buff **pskb,
> >         printk("\n");
> >         spin_unlock_bh(&log_lock);
> > 
> > -       return IPT_CONTINUE;
> > +       return NF_DROP;
> >  }
> > 
> > Will this change cause any side effect that I don't know?
> 
> If you do this privately, I don't think so.
> 
> Of course, nobody would take such a patch from you, as it 
> breaks compatibility with each and every LOG using ruleset in 
> current use.
> 

Yes, I would do the changes and rename the module (ex. DLOG) for
incompatibility. 
When I want to log and then drop the specified packets, I can write like
the following 
iptables rule to reduce the amounts of rule number for performance
improvement in the system.
Do you think so?

iptables -t mangle -A FORWARD -p udp --dport 1024: -j DLOG --log-prefix
"Drop this packet "

Vincent
