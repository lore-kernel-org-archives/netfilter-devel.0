From: Swapnil Nagle <swapsn@rediffmail.com>
Subject: Re: IPT_ENTRY_ITERATE
Date: Thu, 23 Sep 2004 13:37:14 +0530
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41528432.3020702@rediffmail.com>
References: <415274A7.9030203@rediffmail.com>
	<Pine.LNX.4.58.0409230932400.20426@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <Pine.LNX.4.58.0409230932400.20426@tux.rsn.bth.se>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


>>grep shows  only one match :
>>
>>libiptc/libip4tc.c:#define ENTRY_ITERATE    IPT_ENTRY_ITERATE
>>    
>>
>
>These defines are used backwards... the function in libiptc.c is called
>ENTRY_ITERATE() which then gets expanded to IPT_ENTRY_ITERATE() when it's
>compiled for ipv4. This is because most of the libiptc code is shared
>
>  
>
...

>You want to look at ENTRY_ITERATE() in libiptc.c
>
>  
>
I couldn't find the definition for either ENTRY_ITERATE() or 
IPT_ENTRY_ITERATE() in libiptc.c.
Basically I want to see the code that iterates through the entries and 
calls the function specified through ENTRY_ITERATE().

Regards,
Swapnil.
