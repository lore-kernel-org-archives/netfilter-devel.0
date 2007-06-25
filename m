From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_connlimit 20070625
Date: Mon, 25 Jun 2007 16:41:57 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706251451000.3137@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
	<467BAF07.6020502@trash.net>
	<Pine.LNX.4.64.0706251309521.3137@fbirervta.pbzchgretzou.qr>
	<467FA9CE.8000805@trash.net>
	<Pine.LNX.4.64.0706251405280.3137@fbirervta.pbzchgretzou.qr>
	<467FB87D.9020004@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467FB87D.9020004@trash.net>
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


On Jun 25 2007 14:43, Patrick McHardy wrote:
>>
>> Indeed - leftovers from its POM ascendant. But do I have to add ipv6 now?
>>
>> (It would also be quite a duplicate of count_them() and connlimit_match() -
>> is there a better way without too many if()s?)
>>   
> I'd use a conditional in count_them and add an connlimit_match6 function.

Thing is..
static int count_them(struct xt_connlimit_data *data, u_int32_t addr,
                      u_int32_t mask, struct nf_conn *ct)

I'd need a u_int128_t for IPv6. (Or a clever idea.)
Suggestions for elegant solution?


>> > Incorrect comment, it does use &.
>> I reword it.

        /*
         * The hash needs to be folded down (using the % modulo operator) to
         * actually yield a value that is greater or equal than 0 and smaller
         * than ARRAY_SIZE(iphash). If ARRAY_SIZE(iphash) is exactly a power of
         * two, the (most likely faster) "& mask" operation can also be used,
         * where mask is the size minus one.
         */

Does that read better?

>> > __read_mostly?
>> No other xt_ modules have it, but I can add it.
> They don't? I'll add it to the others.

Not even ipt_ or ip6t_ modules have it.

>> The routing code (where Eric pointed me to) does it on boot-up.
>
> It does not use get_random_bytes during boot and reinitizalizes the
> random value after a flush.

So what should xt_connlimit do? Grab the rnd per xt_connlimit_data
(= per rule)?

> Think of a diskless system.

I would not add the disk subsystem to the entropy pool.


	Jan
-- 
