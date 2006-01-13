From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] fix nf_conntrack_netlink expectation dumping/event
	notification
Date: Fri, 13 Jan 2006 10:45:10 +0100
Message-ID: <43C776A6.2010306@trash.net>
References: <43C76BA7.9080204@trash.net>	<200601130902.k0D92fVM026246@toshiba.co.jp>	<43C76D22.8050805@trash.net>
	<200601130938.k0D9c6Yo007986@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200601130938.k0D9c6Yo007986@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Fri, 13 Jan 2006 10:04:34 +0100
> 
> 
>>>I think that root caurse is missing check at __nf_ct_{l3}proto_find().
>>>I'll write patch for it. It will free people from taking care about
>>>expectation mask.
>>
>>I agree, that seems to be the best solution.
> 
> 
> Here you are. How about this ?

Thanks, looks good. Applied.
