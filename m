From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC] unidirectional NAT
Date: Wed, 5 Jun 2002 12:11:32 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0206051209270.8715-100000@blackhole.kfki.hu>
References: <20020605100657.GA10488@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Balazs Scheidler <bazsi@balabit.hu>
In-Reply-To: <20020605100657.GA10488@balabit.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 5 Jun 2002, Balazs Scheidler wrote:

> Let me think a bit about it. For UDP packets I don't really need
> conntracking sessions, I only need to translate single packets, but I'd like
> to avoid messing with IP and UDP header translation myself.
>
> So NOTRACK is good for me, I don't need NONAT since I don't need conntrack
> either. The question is how you mark an skb to avoid tracking? (an idea was
> to use a flag in nfct, is it still true?)

No, I'll go with Rusty's solution: a dummy conntrack entry is used.

> Is you patch available somewhere?

Not yet, but real soon I'll post it :-).

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
