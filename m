From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER] Kill lockhelp.h for rtsp-conntrack
Date: Tue, 30 Aug 2005 23:49:58 +0200
Message-ID: <4314D486.9040406@trash.net>
References: <m2u0h8vekb.fsf@cerbere.dyndns.info>
	<m2k6i4veb1.fsf@cerbere.dyndns.info> <431375BA.7080900@trash.net>
	<m2k6i48j5n.fsf@cerbere.dyndns.info> <4313939A.4030002@trash.net>
	<20050830071102.GD4202@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Samir Bellabes <sbellabes@mandriva.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050830071102.GD4202@rama.de.gnumonks.org>
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

Harald Welte wrote:
> On Tue, Aug 30, 2005 at 01:00:42AM +0200, Patrick McHardy wrote:
> 
> 
>>>I mean that linux-2.6.11 don't need this patch at all.
>>>As far a you push 'kill lockhelp.h patch' in 2.6.13, people who use
>>>p-o-m with a kernel version < 2.6.13, should use lockhelp.h again.
>>>But now, this 3 patches will apply to all versions.
>>
>>I don't know what the general feeling about supporting old versions
>>in pom is, I would tend to ignore them if it means starting a third
>>linux subdirectory that should be maintained in some patchlets.
>>Harald, what is your opinion on this?
> 
> 
> I would rather start a new subdirectory than patching the old code.
> This way users of old kernels can have a working version, too (even if
> that old version doesn't have all the features or receives all the
> patches that newer versions do).  At least as long as we're using the
> current patch-o-matic-ng, I think that's the way to go.

Ok, I'll fix it up tomorrow. Still something to discuss at the workshop
I think, putting time into maintaining compatibility with old kernels
is badly invested time IMO.

> When we decide do get rid of patch-o-matic-ng at some point, we
> obviously can also drop the 'old kernel' requirement.

Obviously :)
