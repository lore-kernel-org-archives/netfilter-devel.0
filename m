From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's
 brain broke!)
Date: Thu, 15 Jan 2004 14:07:30 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401151406140.15295-100000@filer.marasystems.com>
References: <40068069.60108@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <40068069.60108@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 15 Jan 2004, Patrick McHardy wrote:

> That is true, but if you want to save the routing call in MASQUERADE all
> you've got is the route that was determined at input routing (for
> non-local packets).

Right.. so that shortcut can not be taken.

Regards
Henrik
