From: "Maarten Wijnants" <maarten.wijnants@pandora.be>
Subject: Re: ipq_set_verdict gives errors for multicast packets but works
	fine	for unicast (kernel 2.6)
Date: Thu, 6 Jan 2005 16:49:17 +0100
Message-ID: <015a01c4f407$482a32d0$642813ac@in.edm.luc.ac.be>
References: <013301c4f341$50919b00$642813ac@in.edm.luc.ac.be>
	<41DD3737.4080808@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Pablo Neira" <pablo@eurodev.net>
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

Hello Pablo (and rest of list),

Thanks for your reply,

> Maarten Wijnants wrote:
>
>> This all worked fine on kernel version 2.4. However, I have just upgraded 
>> to kernel 2.6.6, and all of a sudden my application doesn't work anymore.
>
>
> Update to lastest kernel stable 2.6. Patrick McHardy pushed forward some 
> patches which fixes some problems in ip_queue some time ago.
>

Well I tried a variety of kernels already. More specifically, I started out 
with kernel 2.4.20. Everything works fine on this kernel version. 
Afterwards, I have tried kernel 2.4.28, 2.6.6, 2.6.9 and 2.6.10. I even 
patched 2.6.10 with the latest snapshot from kernel.org. On none of these 
kernel versions the rule

ipq_set_verdict(ipq_handle, m->packet_id, NF_ACCEPT, m->data_len, packet);

works for an altered packet with a multicast destination. For unicast 
destination packets, the rule works on any kernel version. On kernel 2.4.20, 
this rule works perfectly correct in all situations (i.e. both unicast and 
multicast destinations). I have absolutely no idea what is going wrong in 
the other kernel versions. Any ideas?

Thanks in advance.

Kind regards,
Maarten 
