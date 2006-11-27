From: Michal Schmidt <xschmi00@stud.feec.vutbr.cz>
Subject: Re: [PATCH] SANE conntrack helper
Date: Mon, 27 Nov 2006 20:31:48 +0100
Message-ID: <456B3D24.9020405@stud.feec.vutbr.cz>
References: <4569F47C.2080203@stud.feec.vutbr.cz> <456B354F.5040101@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <456B354F.5040101@trash.net>
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

Patrick McHardy skrev:
> Michal Schmidt wrote:
>> Attached is nf_conntrack_sane, a netfilter connection tracking helper
>> module for the SANE protocol used by the 'saned' daemon to make scanners
>> available via network.
> Looks quite sane :) We have a large number of nf_conntrack patches
> queued up already, some of which change or enhance the API,
> so please port your helper on top of the nf_nat tree (check out
> the mailing list archives of the past two weeks for details
> how to clone it).
> 
> A few more comments below ..

Thank you for your suggestions. I'll check out the nf_nat tree and do 
the fixes you recommend.

>> +	/* It's a reply to SANE_NET_START */
>> +	if (datalen < 8) {
>> +		if (net_ratelimit())
>> +			printk(KERN_NOTICE "conntrack_sane: reply "
>> +			       "too short (%u bytes)\n", datalen);
> 
> Same here, please no ringbuffer spamming.
> 
>> +		ret = NF_DROP;
> 
> Dropping is quite unfriendly too. You should only do it if it is
> necessary for accurate tracking, f.e. in the FTP newline case.

Yes, I'm aware of that. This assumption that the reply packet will 
always contain at least 8 data packets makes the implementation easier 
(and in practice, 'saned' always does that). I'll have to think a bit 
about how to do it without depending on this.

>> +	sane_port = ntohl(*(u32 *)(sb_ptr+4));
>> +	if (sane_port > 0xffff)	{
> 
> 32 bit port numbers? :)

That's right. In the SANE protocol, the port number is encoded into a 
"SANE_Word" type, which is surprisingly 32-bit.

Thanks,
Michal
