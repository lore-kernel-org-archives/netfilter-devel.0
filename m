From: Martijn Lievaart <m@rtij.nl>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Wed, 20 Apr 2005 23:39:17 +0200
Message-ID: <4266CC05.5040103@rtij.nl>
References: <4250FA72.3020502@trash.net>
	<20050404204716.GA4067@linuxace.com>	<20050406044806.GA9711@linuxace.com>
	<4263108E.1030707@trash.net>	<20050419005847.GA591@linuxace.com>
	<42666F4C.5080706@trash.net>	<20050420155308.GA7057@linuxace.com>
	<42667E51.3060005@trash.net>	<20050420172406.GB7057@linuxace.com>
	<42669674.3020905@trash.net> <20050420182505.GA7612@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050420182505.GA7612@linuxace.com>
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

Phil Oester wrote:

>On Wed, Apr 20, 2005 at 07:50:44PM +0200, Patrick McHardy wrote:
>  
>
>>>I'm aware of that, but again I claim that it is irrelevant in this case
>>>because the PORT commands will not be processed out of order (even if the
>>>data packets are), and thus the adjustments will occur sequentially.
>>>      
>>>
>>Why wouldn't they be processed out of order by nat?
>>    
>>
>
>Because a second transfer will not be started until the first completes
>in my experience.  Thus, there will not be two 'PORT' packets floating 
>around to potentially arrive out of order
>
>  
>

Some Windows graphical FTP frontends do multiple transfers. I think one 
should take these into account. OTOH, how often do PORT commands arrive 
out of sequence even given that it is possible?

M4
