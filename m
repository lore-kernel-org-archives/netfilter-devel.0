From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH-2.4.26] ip6tables cleanup
Date: Sun, 28 Mar 2004 12:16:01 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040328121601.21f98f0f.davem@redhat.com>
References: <20040328042608.GA17969@logos.cnet>
	<20040328115439.GA24421@pcw.home.local>
	<m2d66wsrg2.fsf@p4.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: willy@w.ods.org, marcelo.tosatti@cyclades.com,
        linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Peter Osterlund <petero2@telia.com>
In-Reply-To: <m2d66wsrg2.fsf@p4.localdomain>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On 28 Mar 2004 21:27:09 +0200
Peter Osterlund <petero2@telia.com> wrote:

> Willy TARREAU <willy@w.ods.org> writes:
> 
> > 2.4.26-rc1 returned this warning compiling ip6_tables :
> > 
> > ip6_tables.c: In function `tcp_match':
> > ip6_tables.c:1596: warning: implicit declaration of function `ipv6_skip_exthdr'
> > 
> > I had to add a cast because ipv6_skip_exthdr() expects a 'struct sk_buff*' while
> > its caller uses a 'const struct sk_buff*'. Here is a cleanup patch.
> 
> I think it would be better to change the ipv6_skip_exthdr() function
> to take a const struct sk_buff* instead. Unnecessary casts are evil.

Yes, and I believe this is how I fixed this warning in the 2.6.x
tree.
