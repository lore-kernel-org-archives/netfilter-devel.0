From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Thu, 6 Jun 2002 21:11:33 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.21.0206062101120.11802-100000@dns.toxicfilms.tv>
References: <3CFFAF5D.4010103@cs.auc.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
In-Reply-To: <3CFFAF5D.4010103@cs.auc.dk>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > I belive that state NEW says: a packet never seen before. A tuple that
> > does not exist in currect tracked connections table.
> 
> So, what are the INVALID packets ?????
quote:
"A packet which could not be identified for some
 reason: this includes running out of memory and ICMP errors which
 don't correspond to any known connection."

> After this, I was assuming that we were in the ESTABLISHED state.
Hmm, i think we are in established just after the first SYN.
so the SYN/ACK and ACK are ESTABLISHED, as having the same parameters as
the first SYN. Same tuple.

So i think conntrack works irregardles of the protocol seen.

If this is true (i am going to research that), that would mean my
assumption regarding how conntrack wroks is true.


Regards,
Maciej
