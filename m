From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables compile error: NFC_IP_TOS undeclared
Date: Thu, 10 Feb 2005 18:50:08 +0100
Message-ID: <420B9ED0.1020303@trash.net>
References: <Pine.GSO.4.33.0502101758010.19216-100000@indigo>
	<420B8623.9050308@niksula.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Jonas Berlin <jberlin@niksula.hut.fi>
In-Reply-To: <420B8623.9050308@niksula.hut.fi>
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

Jonas Berlin wrote:

> Alexander Piavka wrote:
>
>>
>> actually there is no match from  NFC_IP_TOS in the whole
>> /usr/src/linux-2.6.10-ct_sync-rc1/include subtree
>>  
>>
> Ok, I'm not that familiar with different kernel versions, but my 
> 2.6.10 at least has that one. Could it be that the ct_sync patch takes 
> it away? Do you have ct_sync as a patch or did you get the kernel 
> pre-patched?

Yes, it reuses the bits to record state changes. The nfcache bits
don't affect any functionality, just define it to anything you want
or remove it.

Regards
Patrick
