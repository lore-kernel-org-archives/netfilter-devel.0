From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] comment match port to pom-ng
Date: Sun, 16 May 2004 14:26:49 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405161417160.30410-100000@filer.marasystems.com>
References: <Pine.LNX.4.33.0405141055450.21804-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Brad Fisher <brad@info-link.net>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0405141055450.21804-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 14 May 2004, Jozsef Kadlecsik wrote:

> Sorry, but could you demonstrate the necessity/usefulness of such a
> feature? I tried to figure out at least one, but failed.

What I remember from last time this was discussed was that hte comment 
match allowed one to add inline comments within the iptable, eleminating 
the need of documenting the rules elsewhere.

Either you are of the view that iptables should be self-contained, then 
the comment match is quite useful. Or you are of the opinion that iptables 
should only care about what is needed to match/act on packets then the 
comment match is useless.

Myself consider me having one leg in each camp, and see why someone would
like to have a comment match to allow iptables-save etc to automatically
include some notes on why rules look like they do even if I would not
consider using such functions myself in production. However, I see some
quite useful debugging applications of a comment match in applications
automatically generating iptables ruleset to add some traces to how the
ruleset got build, especially if this is done in incremental steps not 
using a intermediary rule database between the update process and the 
kernel where these comments/trace information can be kept..

So bottom line, I don't see any reason why not to include a match like the
comment match in pom-ng. It would be even better if it could be done in a
way that does not add overhead to the execution of the iptable, but with
the design of iptables a match is unfortunately the closest approximation
available. I do however question if a comment match should be pushed 
forward to the main kernel.

Regards
Henrik
