From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_connlimit kernel 20070620
Date: Wed, 20 Jun 2007 12:29:19 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706201224490.5731@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0706200039290.5731@fbirervta.pbzchgretzou.qr>
	<4678F7A2.6090203@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4678F7A2.6090203@netfilter.org>
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


On Jun 20 2007 11:47, Pablo Neira Ayuso wrote:
>> +
>> +struct xt_connlimit_info {
>> +	u_int32_t mask;
>> +	unsigned int limit, inverse;
>> +
>> +	/* this needs to be at the end */
>> +	struct xt_connlimit_data *data;
>                        ^^^
> IIRC, this should be:
>
> struct xt_connlimit_data __attribute__((aligned(8))) *data;
>
> to avoid problems with 32/64 bits architectures.

->data is a member that is only used by the kernel. Is the aligned(8)
still needed?

>> +		if (found_ct->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT) {
>> +			/*
>> +			 * we do not care about connections which are
>> +			 * closed already -> ditch it
>> +			 */
>> +			lh = lh->prev;
>> +			list_del(lh->next);
>> +			kfree(conn);
>> +			nf_conntrack_put(&found_ct->ct_general);
>> +			continue;
>> +		}
>
> This match seems completely dependent of TCP.

But it works with UDP too. This if() block looks merely like a
watch-out-for-TCP exception. (And obviously, lacks SCTP/DCCP checking.)

> I think that it would be worth a
> rework. Luke, use the connection tracking event API :)

Where may I find examples?



	Jan
-- 
