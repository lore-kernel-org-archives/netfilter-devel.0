From: Patrick McHardy <kaber@trash.net>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 19:53:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F942115.9030402@trash.net>
References: <Pine.LNX.4.44.0310200820260.23179-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0310200820260.23179-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:

>>- we can use some sorting algorithm which benefits from pre-sorted
>>input. this would give better average performance. IIRC new conntracks
>>are added at the head of the chains, so if we sort and walk backwards
>>through the chains we only have to resort after an id counter wrap.
>>    
>>
>
>Could work. In such case the bucket should at most times be sorted
>naturally with no need to resort. There is a few theoretical races
>where entries may be inserted in another order (more so on SMP), but these
>are hopefully relatively rare.
>  
>

Entries are always inserted with the list locked so I can't see these 
cases. I also
calculated, with 64bit and 10^7 connections/s 64 bit won't wrap for 
58494 years.
So we don't need resorting at all.

Best regards,
Patrick
