From: jamal <hadi@cyberus.ca>
Subject: Re: [PATCH 9/18] Netfilter:  Clean up the kmod handling code in
	iptables.c
Date: 06 Jan 2005 09:28:23 -0500
Message-ID: <1105021703.2315.51.camel@jzny.localdomain>
References: <1104896029.20582.72.camel@localhost.localdomain>
	<20050105181249.GS26856@postel.suug.ch>
	<1104973817.20582.110.camel@localhost.localdomain>
	<20050106013031.GT26856@postel.suug.ch>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
	Rusty Russell <rusty@rustcorp.com.au>, Netfilter development mailing list
	<netfilter-devel@lists.netfilter.org>, rmk@arm.linux.org.uk
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Graf <tgraf@suug.ch>
In-Reply-To: <20050106013031.GT26856@postel.suug.ch>
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

On Wed, 2005-01-05 at 20:30, Thomas Graf wrote:

> > I looked harder at this, and I prefer this patch:
> 
> Looks fine to me.

Thanks Thomas for catching this.
Patch looks good from here too. Andrew caught the unexported
ipt_find_target for completion.

BTW, do we have a sane IDE maintainer yet?[1] If we do, maybe its time i
joined lk list again ;-> I have been waiting for a decade to fulfil that
promise;-> 
At some point Alan took over - but Alans sanity is somewhere on the edge
of genius and insanity - so i wasnt sure which side of the line he was
going to end up on after he took over.  As Russell King puts it in not
so many words "What is it with Linux IDE and its maintainers?". Alas! my
attempts to monitor Alan were short lived.

I hear the new guy may be ok - but at times conflicting sentiments cross
my path about him. So still watching ...

cheers,
jamal
[1] Ok, theres actually some moral to this caffeine tale;-> netdev cc
for net patches.
