From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit 20070625
Date: Mon, 25 Jun 2007 16:46:06 +0200
Message-ID: <467FD52E.4050705@trash.net>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
	<467BAF07.6020502@trash.net>
	<Pine.LNX.4.64.0706251309521.3137@fbirervta.pbzchgretzou.qr>
	<467FA9CE.8000805@trash.net>
	<Pine.LNX.4.64.0706251405280.3137@fbirervta.pbzchgretzou.qr>
	<467FB87D.9020004@trash.net>
	<Pine.LNX.4.64.0706251451000.3137@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706251451000.3137@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> On Jun 25 2007 14:43, Patrick McHardy wrote:
> 
>>>Indeed - leftovers from its POM ascendant. But do I have to add ipv6 now?
>>>
>>>(It would also be quite a duplicate of count_them() and connlimit_match() -
>>>is there a better way without too many if()s?)
>>>  
>>
>>I'd use a conditional in count_them and add an connlimit_match6 function.
> 
> 
> Thing is..
> static int count_them(struct xt_connlimit_data *data, u_int32_t addr,
>                       u_int32_t mask, struct nf_conn *ct)
> 
> I'd need a u_int128_t for IPv6. (Or a clever idea.)
> Suggestions for elegant solution?

struct xt_conntrack_address
>>>>Incorrect comment, it does use &.
>>>
>>>I reword it.
> 
> 
>         /*
>          * The hash needs to be folded down (using the % modulo operator) to
>          * actually yield a value that is greater or equal than 0 and smaller
>          * than ARRAY_SIZE(iphash). If ARRAY_SIZE(iphash) is exactly a power of
>          * two, the (most likely faster) "& mask" operation can also be used,
>          * where mask is the size minus one.
>          */
> 
> Does that read better?

That falls into the "i++ /* increment i */" category IMO.
If someone doesn't know how basic operators work he won't
learn it here either .. so I'd just remove it.


> 
> 
>>>>__read_mostly?
>>>
>>>No other xt_ modules have it, but I can add it.
>>
>>They don't? I'll add it to the others.
> 
> 
> Not even ipt_ or ip6t_ modules have it.

I've added it to all matches and tarets.

> 
> 
>>>The routing code (where Eric pointed me to) does it on boot-up.
>>
>>It does not use get_random_bytes during boot and reinitizalizes the
>>random value after a flush.
> 
> 
> So what should xt_connlimit do? Grab the rnd per xt_connlimit_data
> (= per rule)?

That doesn't seem necessary, just do what others do:

static int hash_rnd_initted;
static int hash_rnd;

static int hash(...)
{
	if (unlikely(!hash_rnd_initted)) {
		get_random_bytes(&hash_rnd, 4);
		hash_rnd_initted = 1;
	}
