From: Patrick McHardy <kaber@trash.net>
Subject: Re: BUG somewhere in NAT mechanism [was: my linux box does not learn
 from redirects]
Date: Sun, 13 Apr 2003 14:25:47 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E99574B.5060306@trash.net>
References: <Pine.LNX.4.51.0304121406180.24111@dns.toxicfilms.tv> <8765pj6lg9.fsf@saurus.asaurus.invalid>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Maciej Soltysiak <solt@dns.toxicfilms.tv>,
	netfilter-devel@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kevin Buhr <buhr@telus.net>
In-Reply-To: <8765pj6lg9.fsf@saurus.asaurus.invalid>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Kevin Buhr wrote:

>Maciej Soltysiak <solt@dns.toxicfilms.tv> writes:
>  
>
>>In a nutshell:
>>- iptable_nat, _may_ cause the box to ignore icmp redirects (maybe other
>>  things too)
>>    
>>
>
>It looks like the relevant bit of code is:
>
>ip_nat_core.c:881 (in 2.4.20)
>        /* Redirects on non-null nats must be dropped, else they'll
>           start talking to each other without our translation, and be
>           confused... --RR */
>        if (hdr->type == ICMP_REDIRECT) {
>                /* Don't care about races here. */
>                if (info->initialized
>                    != ((1 << IP_NAT_MANIP_SRC) | (1 << IP_NAT_MANIP_DST))
>

Apart from what you're saying, it should be:

                            if (info->initialized
                                 & ((1 << IP_NAT_MANIP_SRC) | (1 << 
IP_NAT_MANIP_DST))

otherwise (maybe that's what Maciej is seeing) redirects for connections 
without natbindings
will be dropped too.

Bye
Patrick

>                    || info->num_manips != 0)
>                        return NF_DROP;
>        }
>
>This looks wrong.  It's true that you don't want to translate the
>redirect and pass it on after NATting, the way you would with a "host
>unreachable" packet.  But if it was originally directed at you, you
>don't just want to drop it, you want to act on it yourself.
>
>In particular, an ICMP redirect originally directed to one of your own
>interfaces whose internal packet belongs to a source NATted connection
>should have the inner packet (which looks like it came from you)
>reverse source NATted (so it looks like it came from the machine you
>NATted it for) but the outer packet left untouched so it can be
>delivered locally to the kernel.
>
>Any thoughts?
>
>  
>
