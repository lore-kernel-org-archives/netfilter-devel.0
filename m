From: Anders Fugmann <afu@fugmann.dhs.org>
Subject: Re: Fixed proken MARK target in POM.
Date: Fri, 10 Jan 2003 17:38:42 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E1EF712.8000100@fugmann.dhs.org>
References: <3E1D7419.1060502@fugmann.dhs.org> <20030110140024.GU1353@sunbeam.de.gnumonks.org> <3E1EE68C.7030004@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <3E1EE68C.7030004@fugmann.dhs.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Anders Fugmann wrote:
> Harald Welte wrote:
> 
>> On Thu, Jan 09, 2003 at 02:07:37PM +0100, Anders Fugmann wrote:
>>
>>
>>> The patch maintains backward compability, and I request that this 
>>> patch is applied to mainstream (and pushed to the Andrea for kernel 
>>> inclusion), 
>>
>>
>>
>> 1) Where is the compatibility?  I cannot see how this code change would
>>    ensure that
>>     a) old, unpatched kernel works with new, patched userspace
>>     b) new, patched kernel works with old, unpatched userspace
>>    Those two conditions need to be fulfilled, otherwise we cannot make a
>>    change during the stable kernel series.
Looking at bit further, this seems non-trivial as I guess that the 
userspace should compile no matter kernel-headers version - no?

Are defines tolerated? Something like:
#define MARK_BITOPS

and then in the userspace do a:
#ifdef MARK_BITOPS
Whenever the new fileds in the structure is used.

But IMHO this clutters the code up and I would rather avoid that.
Do you know of modules that had the same problem, or do you regard it as 
unresolvable to add an extra field to a structure in the stable series?

Regards
Anders Fugmann
