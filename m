From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: xt_connlimit kernel 20070620
Date: Wed, 20 Jun 2007 13:07:04 +0200
Message-ID: <46790A58.9050106@netfilter.org>
References: <Pine.LNX.4.64.0706200039290.5731@fbirervta.pbzchgretzou.qr>
	<4678F7A2.6090203@netfilter.org>
	<Pine.LNX.4.64.0706201224490.5731@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kaber@trash.net
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706201224490.5731@fbirervta.pbzchgretzou.qr>
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
> On Jun 20 2007 11:47, Pablo Neira Ayuso wrote:
>>> +
>>> +struct xt_connlimit_info {
>>> +	u_int32_t mask;
>>> +	unsigned int limit, inverse;
>>> +
>>> +	/* this needs to be at the end */
>>> +	struct xt_connlimit_data *data;
>>                        ^^^
>> IIRC, this should be:
>>
>> struct xt_connlimit_data __attribute__((aligned(8))) *data;
>>
>> to avoid problems with 32/64 bits architectures.
> 
> ->data is a member that is only used by the kernel. Is the aligned(8)
> still needed?

Yes, some architectures use 64 bits for long/pointers in kernel space 
but use 32 bits in userspace. Since the private match info memory blob 
is passed from userspace to kernel, the size checking fails. This won't 
be a problem if we wouldn't share structure between kernel and 
userspace. IIRC, even for the 32/64 bits compatibility mode for x86_64 
leads to problems. Solution: we force 8 bytes allocation

>>> +		if (found_ct->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT) {
>>> +			/*
>>> +			 * we do not care about connections which are
>>> +			 * closed already -> ditch it
>>> +			 */
>>> +			lh = lh->prev;
>>> +			list_del(lh->next);
>>> +			kfree(conn);
>>> +			nf_conntrack_put(&found_ct->ct_general);
>>> +			continue;
>>> +		}
>> This match seems completely dependent of TCP.
> 
> But it works with UDP too. This if() block looks merely like a
> watch-out-for-TCP exception. (And obviously, lacks SCTP/DCCP checking.)

I see, still I think that it would be worth to make it completely 
independent of it.

>> I think that it would be worth a
>> rework. Luke, use the connection tracking event API :)
> 
> Where may I find examples?

Have a look at nf_conntrack_netlink.c look for the x_events() function. 
If you have more questions on it. Let me know.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
