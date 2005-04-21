From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Thu, 21 Apr 2005 14:32:46 +0200
Message-ID: <42679D6E.6000204@trash.net>
References: <4250FA72.3020502@trash.net> <20050404204716.GA4067@linuxace.com>
	<20050406044806.GA9711@linuxace.com> <4263108E.1030707@trash.net>
	<20050419005847.GA591@linuxace.com> <42666F4C.5080706@trash.net>
	<20050420155308.GA7057@linuxace.com> <42667E51.3060005@trash.net>
	<20050420172406.GB7057@linuxace.com> <42669674.3020905@trash.net>
	<20050420182505.GA7612@linuxace.com> <4267042A.2090906@trash.net>
	<Pine.LNX.4.62.0504211416020.11020@nike.zcu.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Milos Wimmer <wimmer@zcu.cz>
In-Reply-To: <Pine.LNX.4.62.0504211416020.11020@nike.zcu.cz>
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

Milos Wimmer wrote:
> On Thu, 21 Apr 2005, Patrick McHardy wrote:
> 
>> Can someone affected by the problem please confirm that this patch
 >> fixes it?
> 
>  I applied your patch to vanilla kernel 2.6.11.7 and it works great.

Thanks Milos, I'll submit it tonight.

Regards
Patrick
