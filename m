From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] modification in current protocol helper API to handle
 error/unclean packets
Date: Mon, 14 Jun 2004 13:37:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40CD8E0A.6050900@eurodev.net>
References: <40CCECFF.9070907@eurodev.net> <40CD0BE7.3050802@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <40CD0BE7.3050802@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick and Jozsef,

I'll reply you both in this email

Jozsef Kadlecsik wrote:

>I like it, too! I think the tcp-window-tracking patch should be made
>dependent of your patch
>  
>

happy that you both like it! :-)

>NF_DROP == 0, so it should simply return an NF_* value. Thus the condition
>
>+       /* It may be an special packet, error, unclean... */
>+       if ((ret = proto->error(*pskb, &ctinfo, hooknum)))
>+               return ret;
>
>should be
>
>+       /* It may be an special packet, error, unclean... */
>+       if ((ret = proto->error(*pskb, &ctinfo, hooknum)) != NF_ACCEPT)
>+               return ret;
>  
>

I'm still in doubt, if we found an unclean packet, we should return 
NF_ACCEPT, so we let the packet continues its travel. In that case, the 
skbuff  won't have a conntrack associated and the sysadmin could 
explicitely drop invalid packets with an iptables rule, am I right?

So I need a return value to say: "do nothing", that is, go ahead with 
conntrack session, and I can  use neither NF_ACCEPT to do that nor 0 
because == NF_DROP. Should I use -1 then?

>And as Patrick noted, UDP checksumming in IPv4 is not mandatory.
>

I missed that, I'll take it into account for an extra patch to check for 
udp/icmp unclean packets which will go on top of my patch.


Patrick McHardy wrote:

> Couldn't you use ip_ct_find_proto(IPPROTO_ICMP)->error() instead ?


true, I'll have a look at this

> invert_tuple and find_tuple probably should be prefixed with ip_ct_
> then.


so, I could rename those

>> - oh! I added udp checksum checking, well, I just stole that from 
>> Joszef's tcp tracking code and rename things...
>
>
> This should be an extra patch.


ok, so I'll do them like an extra patch on top of this.

regards,
Pablo
