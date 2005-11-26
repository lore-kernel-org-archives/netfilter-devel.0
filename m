From: Patrick McHardy <kaber@trash.net>
Subject: Re: again oops: conntrack & 2.6.14-git14
Date: Sat, 26 Nov 2005 15:36:58 +0100
Message-ID: <4388730A.2060003@trash.net>
References: <43760B97.9010603@fliegl.de> <4380B5B1.9040506@trash.net>
	<4384A904.4080700@fliegl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Deti Fliegl <deti@fliegl.de>
In-Reply-To: <4384A904.4080700@fliegl.de>
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

Deti Fliegl wrote:
> Patrick McHardy wrote:
> 
>> I can't see how this can happen, but I'm looking at 2.6.15-rc2.
>> Can you please test again with 2.6.15-rc2 and without ipt_ipp2p
>> and other external patches?
> 
> Well it does (now on 2.6.15-rc2-git2, without ipt_ipp2p), see log attached.

I hate these unreadable x86_64 oopses. What commands do you use in your
stresstest?
