From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [NEW TARGET] target for modifying conntrack timeout value
Date: Mon, 13 Dec 2004 22:14:45 +0100
Message-ID: <41BE0645.1000308@eurodev.net>
References: <EINSTEINyo3DjFbUcOV00000275@einstein.systemmetrics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Richard <richard@o-matrix.org>
In-Reply-To: <EINSTEINyo3DjFbUcOV00000275@einstein.systemmetrics.com>
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

Richard wrote:

>  
>
>>-----Original Message-----
>>From: Richard [mailto:richard@o-matrix.org]
>>Sent: Wednesday, December 08, 2004 3:48 PM
>>To: 'Pablo Neira'
>>Cc: 'netfilter-devel@lists.netfilter.org'
>>Subject: RE: [NEW TARGET] target for modifying conntrack timeout value
>>
>>    
>>
>>>+                ct->timeout.expires = new_expires;
>>>                  ^^^
>>>
>>>Hm I thought that I told you to use ip_ct_refresh... you should. Your
>>>target will look smarter and you can forget about proper locking...
>>>which is now completely broken...
>>>      
>>>
>>Hi Pablo,
>>
>>Thanks for the comments. I made the modification and attached the latest
>>copy. Now it uses ip_ct_refresh. The target first reads the existing
>>expire value, then modify it. If there is something in between, the expire
>>value might get changed. Even worse, the conntrack state might change.
>>That's why I locked it first, then read and write, finally unlock. If it
>>is broken, there is no difference anyway...
>>
>>    
>>
>
>Just wonder if there is any update on this please...
>  
>

sorry, I'm busy as hell right now. But I'll go through it as soon as I
find some spare time. Reviewing your target is still in my todo list.
Please, be patient.

--
Pablo
