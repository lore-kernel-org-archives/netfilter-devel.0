From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: [PATCH 2.4] raw table and NOTRACK support
Date: Sun, 27 Nov 2005 19:22:44 +0100
Message-ID: <4389F974.5060405@drugphish.ch>
References: <4381A0C3.7020406@tac.ch>	<438327D2.5090506@tac.ch>	<43833BE3.8060909@tac.ch>	<43833F1D.3060309@tac.ch>
	<438468E8.4090309@tac.ch> <4389D26A.8070904@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Willy Tarreau <willy@w.ods.org>,
	Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Roberto Nibali <ratz@tac.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4389D26A.8070904@trash.net>
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

Hello Patrick,

Thanks for replying.

>> --- linux-2.4.32-orig/net/ipv4/ip_output.c      2005-11-21 11:29:41 +0100
>> +++ linux-2.4.32-pab2/net/ipv4/ip_output.c      2005-11-23 11:42:13 +0100
>> @@ -167,6 +167,9 @@
>>         nf_debug_ip_finish_output2(skb);
>>  #endif /*CONFIG_NETFILTER_DEBUG*/
>>
>> +       /* Drop conntrack reference when packet leaves IP */
>> +       nf_reset(skb);
>> +
>>         if (hh) {
>>                 int hh_alen;
>>
>> Is there a reason not to include this patch in 2.4.x?
> 
> Yes, it turned out to break a lots of things on loopback.

Although I don't see how in 2.4.x, I now vaguely remember the bug report.

> We put a different patch in 2.6, which dropped the reference
> at known points where the packet would be queued, except
> for the qdiscs. We can put the same patch in 2.4.

That would be perfect, could you point me to the git reference to this
patch, please?

Cheers,
Roberto Nibali, ratz
-- 
echo
'[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
