From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] proto_to_name duplication
Date: Sat, 22 Jul 2006 09:39:05 -0700
Message-ID: <20060722163905.GA6846@linuxace.com>
References: <20060721225612.GA3951@linuxace.com> <44C22C7C.2080909@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44C22C7C.2080909@trash.net>
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

On Sat, Jul 22, 2006 at 03:47:40PM +0200, Patrick McHardy wrote:
> > Incidentally - it's probably time to remove the superfluous mport
> > match.  Anyone still using it can probably stick with older userspace.
> 
> You're probably right, but as long as it doesn't cause any work I
> also have no problem with keeping it. Do you know how long ago the
> mport patch was removed from pom? Couldn't find anything in the
> SVN history.

It was removed in mid-May.  But you're right - might as well just leave it
alone unless it becomes a maintenance headache.

Phil
