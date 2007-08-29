From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Last vestiges of NFC
Date: Wed, 29 Aug 2007 18:58:33 +0200
Message-ID: <46D5A5B9.2030107@trash.net>
References: <46D06522.2090509@hotpop.com> <46D06FF8.5090004@hotpop.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Peter.Riley@hotpop.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46D06FF8.5090004@hotpop.com>
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

Peter Riley wrote:
> Hi,
> 
>> But I found some vestiges remaining in iptables-1.3.8 that look like this
>> -	*nfcache |= NFC_UNKNOWN;
>> remaining in the init() functions of these extensions:
>>
>>      libipt_policy.c    libip6t_policy.c
>>      libipt_connmark.c  libip6t_connmark.c
> 
> 
> Oops, nevermind about connmark.  I see that's already taken care of
> recently in latest svn.  But the policy modules still have it.


I count 132 occurences of nfcache (a few are in headers that must stay
though). I'll happily apply a patch that kills them all.
