From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] add direction match to conntrack match
Date: Sun, 03 Jun 2007 19:10:42 +0200
Message-ID: <4662F612.9060801@trash.net>
References: <46604886.4080400@ufomechanic.net> <46604998.3050602@trash.net>
	<4660734B.3090203@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4660734B.3090203@ufomechanic.net>
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

Amin Azez wrote:
> Patrick McHardy wrote:
> 
>> But I think use should use a regular flag for this. The
>> XT_CONNTRACK_STATE_SNAT are already a not so great idea
>> since the same information is in the status bits, which
>> can also be matched.
>>   
> 
> The regular flags are declared as u_int8_t, and all 8 bits are already
> used.
> 
> This was the neatest way I could come up with without destroying
> user-space compatability.


You're right of course. Extending the flags like Henrik suggested would
probably make sense, sooner or later we're going to have more conntrack
related things someone wants to match on. Port numbers come to mind ..
