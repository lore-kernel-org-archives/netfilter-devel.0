From: Amin Azez <azez@ufomechanic.net>
Subject: Re: IPCT_NEW comes from was Re: extending conntrack event data
Date: Mon, 25 Apr 2005 17:43:33 +0100
Message-ID: <426D1E35.4030605@ufomechanic.net>
References: <42677180.60003@ufomechanic.net> <42677732.1000905@ufomechanic.net>
	<20050421180723.03CF.LARK@linux.net.cn>
	<426788B0.4090908@eurodev.net> <426CF5FC.6090409@ufomechanic.net>
	<426D1C69.2060107@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <426D1C69.2060107@ufomechanic.net>
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

Further investigation points to the layer 7 matching and mangle-tables 
rules etc, once I remove those rules it stops the magical increment from 
4078 to c079.

Possibly this has been the cuase of the problems, I'll check tomorrow to 
see how this could cause it.

Amin

Amin Azez wrote:

> Looking at some of my skb->nfcache debugging
> (de8ce580 is the skb address)
>
> during tcp_packet, I get calls to ip_conntrack_event_cache which 
> changes nfcache thus:
> * event_cache on de8ce580 from 4000 to 4040
> * event_cache on de8ce580 from 4040 to 4060
> * {leave tcp_packet}
> * event_cache on de8ce580 from 4060 to 4068
> * event_cache on de8ce580 from 4068 to 4078
> * deliver_cached_events c079 right now skb de8ce580
>
> By the time ip_confirm is called some more stuff has happened to 
> nfcache, hence ip_confirm c079 de8ce580
>
> Question is how did the nfcache get from 4078 to c079
> It was c079 when ip_confirm was called
>
> Whence the extra 8001 that has been combined? The 1 is IPCT_NEW, the 
> 8000 is NFC_ALTERED
>
> NFC_ALTERED is used in various places, the most like in 
> ip_ct_gather_frags but this hardly seems likely if src and dst 
> machines are on the same subnet?
> I confirmed with logging that it isn't there so I will have to add 
> debug to all the other places to see which one is guilty.
>
> Azez
>
