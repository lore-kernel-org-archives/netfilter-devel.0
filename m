From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: New iptables structure (was: [PATCH 1/2] ipt_MARK extension
	with backwards compatibilty...)
Date: Sat, 27 Nov 2004 15:14:25 +0100
Message-ID: <200411271514.25237.bdschuym@pandora.be>
References: <1101358191.5842.26.camel@localhost.localdomain>
	<41A7B514.9030703@eurodev.net> <41A85AC4.5080006@anduras.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Anders <anders@anduras.de>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <41A85AC4.5080006@anduras.de>
Content-Disposition: inline
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

On Saturday 27 November 2004 11:45, Sven Anders wrote:
> Pablo Neira wrote:
> | My idea, I don't know how crazy it is. Instead of using the size to
> | guess the target/match version, we could steal 1 byte from char name[]
> | to define a new field called version, so we could register different
> | versions of a match/target.
>
> Once again, we need a field more...
> Wasn't there an suggestion to reuse the 'nfcache' field too??
> Wasn't the need to an unique rule id posted?
> What more???
>
> Why not break compatibilty, if it hamper the development?

Rusty's solution allows backwards compatibility and adding new features. Your 
suggestion only allows adding new features. Furthermore, both solutions add 
the same kind of code complexity.
A unique rule id per table is easily constructed. As all the rules of the 
chains are located after each other, one can just use the number of previous 
rules, or the address offset from the first rule.
Ergo, backwards compatibility need not be broken.

cheers,
Bart
