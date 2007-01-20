From: "Jorge Bastos" <mysql.jorge@decimal.pt>
Subject: Re: PPTP Problem with 2.6.20-rc1 >=
Date: Sat, 20 Jan 2007 14:19:20 -0000
Message-ID: <08ac01c73c9d$fa6ce100$0301a8c0@hercules.decimalint.pt>
References: <087801c73c89$cb5e00b0$0301a8c0@hercules.decimalint.pt>
	<45B208B0.8050707@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="ISO-8859-15";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Patrick McHardy" <kaber@trash.net>, <netfilter-devel@lists.netfilter.org>
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

Let me try... i'll give you feedback in a moment


----- Original Message ----- 
From: "Patrick McHardy" <kaber@trash.net>
To: "Jorge Bastos" <mysql.jorge@decimal.pt>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Saturday, January 20, 2007 12:18 PM
Subject: Re: PPTP Problem with 2.6.20-rc1 >=


> Jorge Bastos wrote:
>> As Patrick asked me to do, i'm reporting this to this list, below is the
>> complete report i did to the users list, and the info patrick told me to
>> add.
>>
>> nf_contrack, and below theres nf_conntrack_expect, i did a grep to show
>> only the lines that we need.
>> As soon you have a feedback tell me something to the list :P
>>
>> Jorge
>>
>>
>> cisne:/proc/net# cat nf_conntrack|grep -i 192.168.1.3
>> ipv4     2 tcp      6 431984 ESTABLISHED src=192.168.1.3
>> dst=84.91.32.190 sport=2521 dport=1723 packets=6 bytes=608
>> src=84.91.32.190 dst=195.23.114.78 sport=1723 dport=2521 packets=8
>> bytes=580 [ASSURED] mark=0 secmark=0 use=3
>> ipv4     2 gre      47 598 timeout=600, stream_timeout=18000
>> src=192.168.1.3 dst=84.91.32.190 srckey=0x4000 dstkey=0x280 packets=5
>> bytes=285 [UNREPLIED] src=84.91.32.190 dst=195.23.114.78 srckey=0x280
>> dstkey=0x4000 packets=0 bytes=0 mark=0 secmark=0 use=1
>>
>>
>> nf_conntrack_expect:
>>
>> cisne:/proc/net# cat nf_conntrack_expect|grep -i 192.168.1.3
>> 288 l3proto = 2 proto=47 src=192.168.1.3 dst=84.91.32.190 srckey=0x8000
>> dstkey=0x300
>> 253 l3proto = 2 proto=47 src=192.168.1.3 dst=84.91.32.190 srckey=0x4000
>> dstkey=0x280
>
> It seems like the connection was not properly recognized as expected,
> I guess because parts of the tuple are uninitialized, but compared to
> find the correct gre key.
>
> This is not the proper fix, but does this patch make the problem go
> away?
>
>
>
>


--------------------------------------------------------------------------------


> diff --git a/net/netfilter/nf_conntrack_proto_gre.c 
> b/net/netfilter/nf_conntrack_proto_gre.c
> index ac193ce..9b0c32d 100644
> --- a/net/netfilter/nf_conntrack_proto_gre.c
> +++ b/net/netfilter/nf_conntrack_proto_gre.c
> @@ -66,8 +66,8 @@ static inline int gre_key_cmpfn(const st
>  const struct nf_conntrack_tuple *t)
> {
>  return km->tuple.src.l3num == t->src.l3num &&
> -        !memcmp(&km->tuple.src.u3, &t->src.u3, sizeof(t->src.u3)) &&
> -        !memcmp(&km->tuple.dst.u3, &t->dst.u3, sizeof(t->dst.u3)) &&
> +        km->tuple.src.u3.ip == t->src.u3.ip &&
> +        km->tuple.dst.u3.ip == t->dst.u3.ip &&
>         km->tuple.dst.protonum == t->dst.protonum &&
>         km->tuple.dst.u.all == t->dst.u.all;
> }
> 
