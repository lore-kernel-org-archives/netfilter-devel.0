From: Olaf Rempel <razzor@kopf-tisch.de>
Subject: Re: [iptables 1.3.0 / libiptc patch] sort chains by hooknum/names
Date: Sat, 5 Mar 2005 00:15:33 +0100
Message-ID: <20050305001533.66dc697b@coruscant>
References: <20050304212114.130e2a7c@coruscant>
	<20050304220827.GA23938@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050304220827.GA23938@linuxace.com>
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

On Fri, 4 Mar 2005 14:08:27 -0800
Phil Oester <kernel@linuxace.com> wrote:

> Why is the old behaviour better than the current?  Any scripts you have
> should be smart enough to check for '^Chain ______' to determine chain.

It's not about scripts. I just think it's easier to understand: 
Having the the builtins arranged like the packets traverse them, and 
being on top of the chains they "jump" into. 

I see no advantage of changing to the new behavior, only that it confuses
people that had worked for years with the old behavior.

And last but not least:
libiptc.c:565 	/* FIXME: sort chains */

I read this like: not implemented yet :)

Olaf
