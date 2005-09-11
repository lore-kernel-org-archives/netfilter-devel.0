From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: MASQUERADE + DHCP problem
Date: Mon, 12 Sep 2005 09:34:35 +1000
Message-ID: <1126481675.9832.3.camel@localhost.localdomain>
References: <43244826.5020405@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43244826.5020405@trash.net>
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

On Sun, 2005-09-11 at 17:07 +0200, Patrick McHardy wrote:
> 2) Add a special hack to masquerade to handle DHCP while no
>    local address exists by looking at the port and src/dst
>    address. Incredibly ugly and wrong :)

If IP src is 0.0.0.0, let it through untouched.  Those packets are
presumably not supposed to be masqueraded, so it's the Right Think
AFAICT.

Will that fix DHCP?
Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
