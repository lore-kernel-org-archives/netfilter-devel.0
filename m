From: Pablo Neira <pablo@eurodev.net>
Subject: Re: nf_conntrack tree
Date: Wed, 16 Mar 2005 10:53:08 +0100
Message-ID: <42380204.5020201@eurodev.net>
References: <42377F54.8070408@trash.net>
	<200503160648.j2G6mXVT014699@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	kaber@trash.net
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200503160648.j2G6mXVT014699@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> 	3. The symbol "ip_conntrack_untracked" which depends on ip_conntrack.
> 	   state, conntrack, NOTRACK use this symbol. How about defining
> 	   "void *nf_ct_untracked" in net/core/netfilter.c and
> 	   set &ip_conntrack_untracked.general/&nf_conntrack_untracked.general
> 	   to it when initializing ip_conntrack/nf_conntrack ?

Something I have in mind. I think that we could use one of the bits of 
nfcache explicitely mark invalid connections. If we get an invalid 
packet, conntrack can set the NFC_INVALID bit. That way we interpret a 
NULL pointer in skb->nfct as a untracked connection and kill that fake 
conntrack.

--
Pablo
