From: Patrick McHardy <kaber@trash.net>
Subject: Re: [bug+patch] SCTP and chunk types over 0x1f
Date: Mon, 25 Jun 2007 15:58:43 +0200
Message-ID: <467FCA13.5050401@trash.net>
References: <20070622151940.GA20467@artesyncp.com> <467FC5CB.9080608@trash.net>
	<20070625135040.GV20467@artesyncp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Stephane Chazelas <stephane@artesyncp.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070625135040.GV20467@artesyncp.com>
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

Stephane Chazelas wrote:
> On Mon, Jun 25, 2007 at 03:40:27PM +0200, Patrick McHardy wrote:
> 
>>>- the chunkmap, which is a bitmap of which chunk is selected is
>>>  defined as an array of 256 / 4 u32s, that is 256 * 8 bits,
>>>  256 / 32 is enough (256 bits).
>>
>>
>>We can't change that since it breaks userspace compatibility.
> 
> 
> I see. But that doesn't look very tidy. Maybe some transitional
> code with a warning in both the kernel and iptables?


We could add a new revision, but still need to keep the old
structure for old binaries. Doesn't seem worth it for this
minor waste of space.


>>Could you please resend without the chunkmap changes? Thanks.
> 
> 
> That's just a matter of removing the first change:


Does it stay completely compatible (modulo fixed bugs) then?
