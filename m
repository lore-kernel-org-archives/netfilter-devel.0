From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] kernel panic with rpc.patch
Date: Fri, 03 Sep 2004 18:15:52 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <413898B8.6080406@trash.net>
References: <20040902232357.GA18422@linuxace.com> <4137CE4D.7070702@trash.net>
	<20040903042113.GA19923@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20040903042113.GA19923@linuxace.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Phil Oester wrote:

>On Fri, Sep 03, 2004 at 03:52:13AM +0200, Patrick McHardy wrote:
>
>>Applied, but wondering on second thought. There are still two
>>__MOD_DEC_USE_COUNT left, and __MOD_INC_USE_COUNT does actually
>>do something :) Why are they useless ?
>>    
>>
>
>Yes, perhaps 'useless' is the wrong word -- they do something, but 
>something which is deprecated and in 2.6 netfilter nonexistent. And
>following davem's policy of no refcounts for network drivers [1], it
>seems to make sense.
>
>Agreed, however, that removing the INC without also removing the DEC
>is sloppy.  Attached find a patch to do so.
>  
>
Thanks, applied.

Regards
Patrick
