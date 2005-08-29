From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER] Kill lockhelp.h for rtsp-conntrack
Date: Mon, 29 Aug 2005 22:53:14 +0200
Message-ID: <431375BA.7080900@trash.net>
References: <m2u0h8vekb.fsf@cerbere.dyndns.info>
	<m2k6i4veb1.fsf@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Samir Bellabes <sbellabes@mandriva.com>
In-Reply-To: <m2k6i4veb1.fsf@cerbere.dyndns.info>
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
> Samir Bellabes <sbellabes@mandriva.com> writes:
> 
> 
>>Please apply at top of the svn tree.

All applied, thanks. I've changed the raw spinlock/rwlock declarations
to DEFINE_SPINLOCK/DECLARE_RWLOCK.

> well, in fact, it should be applyed to a new 'linux-2.6.13' directory..

Do you mean it needs to be applied to other directories than -p1 in the
patchlets dir?
