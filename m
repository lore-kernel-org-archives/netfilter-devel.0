From: Patrick McHardy <kaber@trash.net>
Subject: Re: nat/conntrack helper locking problem?
Date: Thu, 20 Nov 2003 13:11:38 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FBCAF7A.1070609@trash.net>
References: <Pine.LNX.4.44.0311201256200.9468-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0311201256200.9468-100000@filer.marasystems.com>
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

>On Thu, 20 Nov 2003, Patrick McHardy wrote:
>
>  
>
>>It's a relative uncritical error, ip_nat_helper_register races with
>>ip_conntrack_helper_unregister. The attached patch should
>>fix it.
>>    
>>
>
>The same change needs to be done in both functions I presume.. the warning 
>is given on both register and unregister.
>
>I will give it a try. 
>
>Hmm.. to be correct doesn't the lock need to be held until the module
>counter have been increased in ip_nat_helper_register? And does this lock
>really solve the race in the first place? What prevents
>ip_conntrack_helper_unregister from unregistering the conntrack helper
>when the lock is released? The module use count check has already been
>long passed at that time..
>
>But as you say it is a relatively uncritical error. The chance for 
>concurrent ip_conntrack_helper_unregister and ip_nat_helper_register is 
>close to nil (of not non-existent)
>  
>

Your right the fix is incorrect, I should have taken more time for it.
Will do so right away ..

Patrick

>Regards
>Henrik
>  
>
