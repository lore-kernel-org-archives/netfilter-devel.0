From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: xt_u32 kernel 20070620_2
Date: Wed, 20 Jun 2007 13:05:35 +0200
Message-ID: <467909FF.5060904@netfilter.org>
References: <Pine.LNX.4.64.0706200037570.5731@fbirervta.pbzchgretzou.qr>
	<4678F9E3.7050002@netfilter.org>
	<Pine.LNX.4.64.0706201209310.5731@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kaber@trash.net
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706201209310.5731@fbirervta.pbzchgretzou.qr>
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
> On Jun 20 2007 11:56, Pablo Neira Ayuso wrote:
>> Jan Engelhardt wrote:
>>> +	base = head = skb_header_pointer(skb, 0, skb->len, u32_buffer);
>> Since we calculate the offset and just take chunks of 32 bits. Why not use
>> skb_copy_bits instead and copy 4 bytes to a small buffer allocated in the
>> stack? This would remove the big buffer requirement.
> 
> Much more than that, it would actually make xt_u32 truly SMP-"capable" (you
> name it), because now there is no buffer that would need to be locked.
> 
> Patch below.

Wrong patch? :-)

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
