From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RESEND][PATCH] Recent match jiffies wrap mismatches
Date: Wed, 30 Nov 2005 08:43:33 +0100
Message-ID: <438D5825.2070304@trash.net>
References: <20051129050813.GA30630@linuxace.com> <438CDE4E.8070006@trash.net>
	<20051129235159.GA3680@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20051129235159.GA3680@linuxace.com>
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
> On Wed, Nov 30, 2005 at 12:03:42AM +0100, Patrick McHardy wrote:
> 
>>Applied, thanks. The lines just above that have the same problem, don't
>>they?
> 
> 
> No, since we aren't comparing to values which have been memset to zero.
> We are comparing against last_seen + seconds, which will be a legitimate
> value. 

But last_seen is initialized to 0 too. Is there something I'm missing
that prevents these entries from beeing used?

>>[slightly reformated for better readability]
> 
> 
> (this file could seriously use a pass through Lindent)

Or better some serious rewriting .. its a pile of junk.
