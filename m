From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] netfilter: ECN target corrupts packets (2.6 only)
Date: Mon, 03 Jan 2005 21:15:34 +1100
Message-ID: <1104747334.14092.22.camel@localhost.localdomain>
References: <1104664660.17292.19.camel@localhost.localdomain>
	<1625859504.20050102160729@dns.toxicfilms.tv>
	<41D861F0.8000303@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Maciej Soltysiak <solt@dns.toxicfilms.tv>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41D861F0.8000303@trash.net>
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

On Sun, 2005-01-02 at 22:04 +0100, Patrick McHardy wrote:
> There's more brokeness, it mangles the tcp header before making
> it writable and doesn't reload pointers after doing so. This patch
> should fix all of it and as a side-effect avoids some useless
> copying. Any voluteers for testing ? :)

I see more nfsim work coming up...

Thanks!
Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
