From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] Re: what's the lockingrules for
	ip_conntrack_expect_list?
Date: 12 Oct 2002 15:11:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1034428292.7595.40.camel@tux>
References: <Pine.LNX.4.33.0210111559050.29766-100000@blackhole.kfki.hu>
	<1034361771.25973.65.camel@tux>
	<20021012142502.Y13233@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20021012142502.Y13233@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2002-10-12 at 14:25, Harald Welte wrote:
 
> See my other mail, I don't agree with everything said in the thread before.
> Sorry for my late comments, I should have sent that mail two days earlier.

No problem, I'm happy that you cleared things up.

> It's always ugly to export a non-locking __foo function as API to another
> module.

Yes I know, but we need to do something about this.
 
> > Sure they are harmless but users don't know that and send reports. (this
> > problem goes away with Rustys patches for 2.5, exp_for_packet is completely
> > removed)
> 
> Yes I agree with the problem, but not with the style of the solution. 
> *sigh*. 
> 
> __find_proto should be inlined anyway. So if we put it into a header file,
> which is included by conntrack and nat (ip_conntrack.h), we would avoid
> exporting it as a symbol.

I'll whip up a patch.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
