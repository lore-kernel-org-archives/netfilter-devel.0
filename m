From: Phil Oester <kernel@linuxace.com>
Subject: Re: Deadlocks
Date: Tue, 29 Jun 2004 13:09:44 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040629200944.GA25735@linuxace.com>
References: <20040609180909.GA11445@linuxace.com> <1087156709.11287.8.camel@ws> <20040615044723.GA16891@linuxace.com> <40CE95DE.9090703@trash.net> <20040617155946.GA28564@linuxace.com> <40D1C4BF.8070605@trash.net> <20040618171214.GA750@linuxace.com> <40D62FDB.8090904@trash.net> <20040629175426.GA25242@linuxace.com> <40E1AE4D.7040306@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <40E1AE4D.7040306@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jun 29, 2004 at 08:00:45PM +0200, Patrick McHardy wrote:
> Phil Oester wrote:
> >Well, the box has now lasted 7 days without a deadlock, so I'd venture
> >to say your patch has solved the issue, and should probably be added to
> >mainline.
> 
> Thanks for the update, but I thought it kept crashing when you first
> tried the patch ?

It crashed once, but appears to have been stack corruption which
could've been caused by anything.  After it crashed I enabled
CONFIG_NETFILTER_DEBUG and it's been quiet ever since.  Possible
that enabling debugging prevents the issue?

Phil
