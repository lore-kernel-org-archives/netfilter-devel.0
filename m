From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [RFC] Event Cache per-cpu
Date: Wed, 10 Nov 2004 18:43:58 +0100
Message-ID: <4192535E.6090409@eurodev.net>
References: <418FC922.9080004@eurodev.net>
	<20041109171319.GG22257@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041109171319.GG22257@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:

>On Mon, Nov 08, 2004 at 08:29:38PM +0100, Pablo Neira wrote:
>  
>
>>Hi all,
>>c) per packet cache. I don't see any possible race with this approach at 
>>the moment, but I'll need to use the nfcache field in skbuff. I prefer 
>>this than adding a new field to a skbuff, I think that Davem won't like 
>>that.
>>    
>>
>
>seems fine to me.
>  
>

tony the tiger says grrrreat :)

>>There's 15 bits in nfcache available now (because IPVS guys are using 
>>one in private). My last patch has 11 events.
>>    
>>
>
>who authorized IPVS people to use that bit ? It's ours, and we fought
>hard for it  ;)  [just kidding, but I didn't know that before].
>  
>

I'll sync this between IPVS and netfilter. Make them move that to 
netfilter.h if they really need it. We'll see, later.

>>enum ip_conntrack_events
>>{
>>      IPCT_NEW,                       /* New conntrack                */
>>      IPCT_RELATED,                   /* Expected connection          */
>>      IPCT_DESTROY,                   /* Destroyed conntrack          */
>>      IPCT_STATUS,                    /* Status has changed           */
>>      IPCT_REFRESH,                   /* Timer has been refreshed     */
>>      IPCT_PROTOINFO,                 /* Update of protocol info      */
>>      IPCT_PROTOINFO_VOLATILE,        /* Volatile protocol info       */
>>      IPCT_HELPER,                    /* New helper for conntrack     */
>>      IPCT_HELPINFO,                  /* Update of helper info        */
>>      IPCT_HELPINFO_VOLATILE,         /* Volatile helper info         */
>>      IPCT_NATINFO,                   /* NAT info                     */
>>};
>>
>>Patrick suggests that we could run out of bits soon if events go in 
>>nfcache, that's true. To fix that, could we remove this stuff in 
>>netfilter_ipv4.h, nobody is using it ?
>>    
>>
>
>No, I think this can be removed, nobody has ever used nfcache the way it
>was originally intended.
>  
>

Ok, expect a new patch in next days.

Pablo
