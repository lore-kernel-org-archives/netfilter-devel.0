From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] TTL target goes mainline ?
Date: Fri, 26 Aug 2005 13:43:55 +0200
Message-ID: <430F007B.20605@trash.net>
References: <20050826111832.GT4226@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050826111832.GT4226@rama.de.gnumonks.org>
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

Harald Welte wrote:
> Hi!
> 
> As we are in the process of pushing more 'new' code from
> patch-o-matic-ng into the mainline kernel, I was thinking whether or not
> we should also submit potentially-dangerous targets such as the TTL
> target to the kernel.
> 
> The TTL target allows setting, incrementing and decrementing of the TTL,
> and is therefore extremely dangerous. OTOTH, there are ISP's that check
> whether you use a router or not (and thus filter or not) by looking at
> the TTL of every packet that comes in on your link - so there is a
> practical use of this to a number of people.
> 
> At some point the kernel had a CONFIG_DANGEROUS, but that had been
> removed. I think CONFIG_DANGEROUS would be exactly the right thing for
> TTL manipulations.
> 
> So my proposal is to only allow decrementing (or setting to a value
> below the original one) the TTL unless CONFIG_EXPERIMENTAL is set. 

Why not, people can just as easy shoot themselves using bridging or
tc actions. But I'm not sure about enabling only parts of functionality
without CONFIG_EXPERIMENTAL, why not simply depend entirely on it?
