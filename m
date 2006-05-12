From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: NAT configuration over ctnetlink
Date: Fri, 12 May 2006 18:41:45 +0200
Message-ID: <4464BAC9.7010600@trash.net>
References: <4451BA40.4050207@trash.net> <445388B9.2010308@netfilter.org>
	<4457677D.7060607@trash.net> <44578E0C.5070705@netfilter.org>
	<4457926D.5010209@trash.net> <4457EBF9.3080606@netfilter.org>
	<44641FFC.8030500@trash.net> <446476B9.7060505@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <446476B9.7060505@netfilter.org>
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

Pablo Neira Ayuso wrote:
> OK, I'll finish the patch then. I'm thinking about hiding the definition
> of nfct_conntrack/nfct_tuple/... and provide the getters to access the
> attributes of the object. Since this structure could evolve in time, we
> wouldn't have any problems to introduce new changes in future. But that
> would definitely break code that initialize the structure by setting up
> the structure fields. Ideas?

I don't think thats necessary (and I'm no fan of hiding things unless
there's a good reason), basically all of these structures are similar
to semantically well-defined structures in the kernel that are very
unlikely to change in an incompatible way.
