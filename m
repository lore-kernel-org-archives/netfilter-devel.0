From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: xt_connlimit 20070605
Date: Tue, 5 Jun 2007 18:47:40 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706051839120.20829@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706051315400.20829@yvahk01.tjqt.qr>
	<46654BF8.30406@trash.net>
	<Pine.LNX.4.61.0706051405510.20829@yvahk01.tjqt.qr>
	<20070605143742.7fdd6268.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Eric Dumazet <dada1@cosmosbay.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070605143742.7fdd6268.dada1@cosmosbay.com>
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

Hi Eric,

On Jun 5 2007 14:37, Eric Dumazet wrote:
>>
>> +static inline unsigned int connlimit_iphash(u_int32_t addr)
>> +{
>> +	return (addr ^ (addr >> 8) ^ (addr >> 16) ^ (addr >> 24)) & 0xff;
>> +}
>> +
>> +static int count_them(struct xt_connlimit_data *data, u_int32_t addr,
>> +		      u_int32_t mask, struct nf_conn *ct)
>
>I suggest you use jhash and a random value (initialized at boot time), so that
>the attacker has hard work to guess your hash function.

Do you think it is secure enough to use % 256 (or & 0xFF) on jhash()?
E.g. in xt_connlimit.c:count_them():

        hash  = &data->iphash[jhash_1word(addr, IV) & 0xFF];                   



Thanks,
	Jan
-- 
