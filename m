From: Kevin Buhr <buhr@telus.net>
Subject: Re: BUG somewhere in NAT mechanism [was: my linux box does not learn from redirects]
Date: 12 Apr 2003 22:00:22 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <8765pj6lg9.fsf@saurus.asaurus.invalid>
References: <Pine.LNX.4.51.0304121406180.24111@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <Pine.LNX.4.51.0304121406180.24111@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Maciej Soltysiak <solt@dns.toxicfilms.tv> writes:
> 
> In a nutshell:
> - iptable_nat, _may_ cause the box to ignore icmp redirects (maybe other
>   things too)

It looks like the relevant bit of code is:

ip_nat_core.c:881 (in 2.4.20)
        /* Redirects on non-null nats must be dropped, else they'll
           start talking to each other without our translation, and be
           confused... --RR */
        if (hdr->type == ICMP_REDIRECT) {
                /* Don't care about races here. */
                if (info->initialized
                    != ((1 << IP_NAT_MANIP_SRC) | (1 << IP_NAT_MANIP_DST))
                    || info->num_manips != 0)
                        return NF_DROP;
        }

This looks wrong.  It's true that you don't want to translate the
redirect and pass it on after NATting, the way you would with a "host
unreachable" packet.  But if it was originally directed at you, you
don't just want to drop it, you want to act on it yourself.

In particular, an ICMP redirect originally directed to one of your own
interfaces whose internal packet belongs to a source NATted connection
should have the inner packet (which looks like it came from you)
reverse source NATted (so it looks like it came from the machine you
NATted it for) but the outer packet left untouched so it can be
delivered locally to the kernel.

Any thoughts?

-- 
Kevin <buhr@telus.net>
