From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.6] optimization of ip_conntrack_proto_tcp:tcp_packet()
Date: Tue, 30 Mar 2004 10:45:32 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040330104532.6b5cba46.davem@redhat.com>
References: <20040329103348.GC1528@sunbeam.de.gnumonks.org>
	<20040329201722.7a22cf7c.davem@redhat.com>
	<40694F1F.9070409@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40694F1F.9070409@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 30 Mar 2004 12:42:39 +0200
Pablo Neira <pablo@eurodev.net> wrote:

> as current tcp tracking doesn't perform so strong tcp transitions 
> checking, there won't be any problems. Joszef Kadlecsik is working on a 
> full featured tcp tracking system which will take care of this stuff, 
> but it still needs a bit of time.
 ...
> Actually, I think that this change won't modify the current behaviour of 
> the tcp connection tracking system because the conntrack will be drop 
> sooner or later if a rst is received.

You're right, in fact I keep getting reminded every few weeks about
the lack of sequence number checking in conntrack so I should have
known this :-)

Thanks for the clarification.
