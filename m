From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: --reject-with admin-prohib - Suggested Solution.
Date: Wed, 4 Dec 2002 21:12:37 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0212042040540.3788-100000@dns.toxicfilms.tv>
References: <Pine.LNX.4.33.0212040052300.29619-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@gnumonks.org>, <g@naboo.gnumonks.org>,
	<netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0212040052300.29619-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > No.  You will make the libipt_REJECT.so dependent on the particular
> > source code installed on the machine where iptables was compiled.
>
> Why don't we simply add an INCOMPATIBILITIES file to the userspace source
> tree, together with a similar section in the manpage?
>
Hmm, that could be a solution.

Also, we could add an [*] to the libipt_REJECT.c help and say that [*]
works only with kernels 2.x.y+

> Backward compatibility is very important, but we shouldn't insist on it at
> every cost.
>
What is more important here? Backward compatibility or RFC compliance.

I see it has been hard to have both, and that is why Harald is fighting
for both compatibility and compliance, but maybe here we can cut corners.

Regards,
Maciej Soltysiak
