From: Patrick McHardy <kaber@trash.net>
Subject: Re: BUG somewhere in NAT mechanism [was: my linux box does not learn
 from redirects]
Date: Sun, 13 Apr 2003 15:41:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E9968FB.8050409@trash.net>
References: <Pine.LNX.4.51.0304121406180.24111@dns.toxicfilms.tv> <8765pj6lg9.fsf@saurus.asaurus.invalid> <3E99574B.5060306@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Maciej Soltysiak <solt@dns.toxicfilms.tv>,
	netfilter-devel@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kevin Buhr <buhr@telus.net>
In-Reply-To: <3E99574B.5060306@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



Patrick McHardy wrote:

>> Maciej Soltysiak <solt@dns.toxicfilms.tv> writes:
>>  
>> It looks like the relevant bit of code is:
>>
>> ip_nat_core.c:881 (in 2.4.20)
>>        /* Redirects on non-null nats must be dropped, else they'll
>>           start talking to each other without our translation, and be
>>           confused... --RR */
>>        if (hdr->type == ICMP_REDIRECT) {
>>                /* Don't care about races here. */
>>                if (info->initialized
>>                    != ((1 << IP_NAT_MANIP_SRC) | (1 << 
>> IP_NAT_MANIP_DST))
>>
>
> Apart from what you're saying, it should be:
>
>                            if (info->initialized
>                                 & ((1 << IP_NAT_MANIP_SRC) | (1 << 
> IP_NAT_MANIP_DST))
>
> otherwise (maybe that's what Maciej is seeing) redirects for 
> connections without natbindings
> will be dropped too. 


Sorry this was wrong, it seems because of null_bindings every connection 
has at least one
binding per direction.

Bye
Patrick
