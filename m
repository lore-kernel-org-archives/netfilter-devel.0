From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Warn people that ipchains and ipfwadm are going away.
Date: Wed, 22 Sep 2004 07:58:22 +1000
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1095803902.1942.211.camel@bach>
References: <1095721742.5886.128.camel@bach>
	<20040921143613.2dc78e2f.Ballarin.Marc@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@osdl.org>, netfilter-devel@lists.netfilter.org,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marc Ballarin <Ballarin.Marc@gmx.de>
In-Reply-To: <20040921143613.2dc78e2f.Ballarin.Marc@gmx.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2004-09-21 at 22:36, Marc Ballarin wrote:
> On Tue, 21 Sep 2004 09:09:02 +1000
> "Rusty Russell (IBM)" <rusty@au1.ibm.com> wrote:
> 
> > Name: Warn that ipchains and ipfwadm are going away
> > Status: Trivial
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> Isn't a compile-time warning a bit "soft"? Especially when compilation of
> a kernel easily produces > 100 warnings, as it does right now.

Sure, but you have to start somewhere.  Next step will be #error.  Then
finally remove the whole thing (I don't want to remove the whole thing
to start with, since that would create a silent failure).

Cheers,
Rusty.
-- 
http://linux.conf.au - Call for papers.  Join us!
