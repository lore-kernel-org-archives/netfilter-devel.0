From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 2.6] optimization of ip_conntrack_proto_tcp:tcp_packet()
Date: Tue, 30 Mar 2004 12:42:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40694F1F.9070409@eurodev.net>
References: <20040329103348.GC1528@sunbeam.de.gnumonks.org> <20040329201722.7a22cf7c.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>,
 netfilter-devel@lists.netfilter.org
In-Reply-To: <20040329201722.7a22cf7c.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi davem,

David S. Miller wrote:

>For example, how it is valid, in this change, to blindly accept a
>RESET packet to kill a conntrack entry before verifying the sequence
>number(s) (as appropriate per rfc793 rules)?
>  
>
as current tcp tracking doesn't perform so strong tcp transitions 
checking, there won't be any problems. Joszef Kadlecsik is working on a 
full featured tcp tracking system which will take care of this stuff, 
but it still needs a bit of time.

>This looks really suspicious to me.
>  
>
Actually, I think that this change won't modify the current behaviour of 
the tcp connection tracking system because the conntrack will be drop 
sooner or later if a rst is received.

regards,
Pablo
