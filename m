From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] datalen variable unused in ftp helper.
Date: Tue, 09 Mar 2004 22:20:15 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <404E350F.8060608@eurodev.net>
References: <404E0A4D.3070303@eurodev.net> <404E2AC5.1080803@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
 netfilter-devel@lists.netfilter.org
In-Reply-To: <404E2AC5.1080803@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

Patrick McHardy wrote:

>> --- linux-2.6.3/net/ipv4/netfilter/ip_conntrack_ftp.c    2004-03-09 
>> 18:49:21.000000000 +0100
>> +++ linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_ftp.c    
>> 2004-02-18 04:59:06.000000000 +0100
>> @@ -281,7 +281,7 @@
>>      datalen = skb->len - dataoff;
>
>
> ^^ Shouldn't the patch remove the variable entirely then ?


I'm not sure what's better. Adding a new parameter to the stack is cheap 
and this way I'm sure that gcc won't generate code to calculate skb->len 
- dataoff over and over again. I'm not a compiler geek, so I could be 
wrong :-). If you think that removing datalen is a better solution, 
please let me know and I'll post the patch.

regards,
Pablo
