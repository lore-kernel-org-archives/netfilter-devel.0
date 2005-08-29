From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER] Kill lockhelp.h for rtsp-conntrack
Date: Tue, 30 Aug 2005 01:00:42 +0200
Message-ID: <4313939A.4030002@trash.net>
References: <m2u0h8vekb.fsf@cerbere.dyndns.info>	<m2k6i4veb1.fsf@cerbere.dyndns.info>
	<431375BA.7080900@trash.net> <m2k6i48j5n.fsf@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Samir Bellabes <sbellabes@mandriva.com>
In-Reply-To: <m2k6i48j5n.fsf@cerbere.dyndns.info>
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

Samir Bellabes wrote:
> Patrick McHardy <kaber@trash.net> writes:
> 
> 
>>All applied, thanks. I've changed the raw spinlock/rwlock declarations
>>to DEFINE_SPINLOCK/DECLARE_RWLOCK.
> 
> ok, thanks.
> 
> 
>>>well, in fact, it should be applyed to a new 'linux-2.6.13' directory..
>>
>>Do you mean it needs to be applied to other directories than -p1 in the
>>patchlets dir?
> 
> 
> I mean that linux-2.6.11 don't need this patch at all.
> As far a you push 'kill lockhelp.h patch' in 2.6.13, people who use
> p-o-m with a kernel version < 2.6.13, should use lockhelp.h again.
> But now, this 3 patches will apply to all versions.

I don't know what the general feeling about supporting old versions
in pom is, I would tend to ignore them if it means starting a third
linux subdirectory that should be maintained in some patchlets.
Harald, what is your opinion on this?
