From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] note owner match brokenness
Date: Fri, 1 Oct 2004 14:12:51 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041001211251.GA30542@linuxace.com>
References: <20041001204447.GA30390@linuxace.com> <415DC791.3060409@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <415DC791.3060409@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Oct 01, 2004 at 11:09:37PM +0200, Patrick McHardy wrote:
> Phil Oester wrote:
> 
> >Someone recently complained in bugzilla that the note about owner
> >match being broken on SMP took hours to find because it was in
> >syslog instead of userspace.  Hopefully the below patch will
> >save others some time.
> >
> >This closes bugzilla #244
> >
> If we warn in userspace, we should warn when then options are used
> instead of in the helptext.

Agreed, but do we want to:

   1) warn on every single use of owner match?
   2) have iptables determine if we are running on an SMP box, and
      only warn in that case?

I didn't think either of these were terribly appealing.

Phil
