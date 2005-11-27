From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.4] raw table and NOTRACK support
Date: Sun, 27 Nov 2005 19:49:26 +0100
Message-ID: <4389FFB6.8000705@trash.net>
References: <4381A0C3.7020406@tac.ch>	<438327D2.5090506@tac.ch>	<43833BE3.8060909@tac.ch>	<43833F1D.3060309@tac.ch>
	<438468E8.4090309@tac.ch> <4389D26A.8070904@trash.net>
	<4389F974.5060405@drugphish.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Willy Tarreau <willy@w.ods.org>,
	Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Roberto Nibali <ratz@tac.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@drugphish.ch>
In-Reply-To: <4389F974.5060405@drugphish.ch>
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

Roberto Nibali wrote:
>>>Is there a reason not to include this patch in 2.4.x?
>>
>>Yes, it turned out to break a lots of things on loopback.
> 
> 
> Although I don't see how in 2.4.x, I now vaguely remember the bug report.

One of the things it broke was SO_ORIGINAL_DST support for
transparent proxying, which also affects 2.4.

>>We put a different patch in 2.6, which dropped the reference
>>at known points where the packet would be queued, except
>>for the qdiscs. We can put the same patch in 2.4.
> 
> 
> That would be perfect, could you point me to the git reference to this
> patch, please?

It was commit 84531c24f27b02daa8e54e2bb6dc74a730fdf0a5, titled
"[NETFILTER]: Revert nf_reset change".
