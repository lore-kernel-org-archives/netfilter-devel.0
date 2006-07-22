From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] proto_to_name duplication
Date: Sat, 22 Jul 2006 15:47:40 +0200
Message-ID: <44C22C7C.2080909@trash.net>
References: <20060721225612.GA3951@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20060721225612.GA3951@linuxace.com>
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

Phil Oester wrote:
> Update multiport match to use the iptables version of proto_to_name
> instead of reinventing the wheel.

Also applied, thanks Phil.

> I looked at a similar ipv6 cleanup, but the ipv6header header match
> makes this somewhat trickier.
> 
> Incidentally - it's probably time to remove the superfluous mport
> match.  Anyone still using it can probably stick with older userspace.

You're probably right, but as long as it doesn't cause any work I
also have no problem with keeping it. Do you know how long ago the
mport patch was removed from pom? Couldn't find anything in the
SVN history.
