From: Jonas Berlin <jberlin@niksula.hut.fi>
Subject: Re: iptables compile error: NFC_IP_TOS undeclared
Date: Thu, 10 Feb 2005 18:04:51 +0200
Message-ID: <420B8623.9050308@niksula.hut.fi>
References: <Pine.GSO.4.33.0502101758010.19216-100000@indigo>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Alexander Piavka <piavka@cs.bgu.ac.il>
In-Reply-To: <Pine.GSO.4.33.0502101758010.19216-100000@indigo>
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

Alexander Piavka wrote:

>On Thu, 10 Feb 2005, Jonas Berlin wrote:
>  
>
>>Alexander Piavka wrote:
>>    
>>
>>>gcc -O2 -Wall -Wunused -I/usr/src/linux-2.6.10-ct_sync-rc1/include
>>>-Iinclude/ -DIPTABLES_VERSION=\"1.3.0rc1\"  -fPIC -o
>>>extensions/libipt_dscp_sh.o -c extensions/libipt_dscp.c
>>>extensions/libipt_dscp.c: In function `init':
>>>extensions/libipt_dscp.c:29: error: `NFC_IP_TOS' undeclared (first use in
>>>this function)
>>>
>>  grep NFC_IP_TOS
>>/usr/src/linux-2.6.10-ct_sync-rc1/include/linux/netfilter_ipv4.h
>>    
>>
> no match
>
>actually there is no match from  NFC_IP_TOS in the whole
>/usr/src/linux-2.6.10-ct_sync-rc1/include subtree
>  
>
Ok, I'm not that familiar with different kernel versions, but my 2.6.10 
at least has that one. Could it be that the ct_sync patch takes it away? 
Do you have ct_sync as a patch or did you get the kernel pre-patched?

-- 
- xkr47
