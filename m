From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: chain_cache
Date: Fri, 21 May 2004 10:57:22 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405211055180.21575-100000@filer.marasystems.com>
References: <40ADA2B6.3040107@aiqa.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ozgur Akan <akan@aiqa.com>
In-Reply-To: <40ADA2B6.3040107@aiqa.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 21 May 2004, Ozgur Akan wrote:

> Also it may be a patch for insert_rules. insert_rules is used in all 
> rule manuplation functions in libiptc.

Problem with insert_rule is that you do not have all the information about
which chain the rule is inserted into or the position within the chain,
just the offset within the whole table so you will have to deduce a lot of
information to be able to do this there.. it is possible, just a lot 
harder.

Regards
Henrik
