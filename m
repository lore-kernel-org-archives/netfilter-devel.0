From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack tree
Date: Wed, 16 Mar 2005 15:36:54 +0100
Message-ID: <42384486.1050509@trash.net>
References: <42377F54.8070408@trash.net>
	<200503160648.j2G6mXVT014699@toshiba.co.jp>
	<42380204.5020201@eurodev.net>
	<Pine.LNX.4.58.0503161107160.9555@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: usagi-core@linux-ipv6.org, netfilter-devel@lists.netfilter.org,
	Pablo Neira <pablo@eurodev.net>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0503161107160.9555@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:
> When working on a conntrack-friendly TARPIT target, I added "general" glue
> function support in order to avoid unnecessary cross-dependency. Have a
> look at the attached patch.

I thought about this. I thought it would require too many glue functions
that are mostly only have a single user, but actually it doesn't look so
bad. ipt_conntrack (worst one AFAICT) should be ok with a struct
nf_conntrack_common + two glue functions:

tuple_proto_cmp
tuple_addr_cmp(direction, src/dst)

Seems to be the best idea so far. We could also get rid of some of the
uglies in net/core/netfilter.c.

Regards
Patrick
