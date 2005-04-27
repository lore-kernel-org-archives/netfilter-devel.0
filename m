From: Patrick McHardy <kaber@trash.net>
Subject: Re: Status of owner-socketlookup
Date: Wed, 27 Apr 2005 21:37:01 +0200
Message-ID: <426FE9DD.80201@trash.net>
References: <Xine.LNX.4.44.0504270037490.16008-100000@thoron.boston.redhat.com>	<426F64C8.1070601@trash.net>	<426FA44A.2010008@evtek.fi>	<426FA73E.3090605@trash.net>
	<20050427114926.45a91b5e.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: juha.heljoranta@evtek.fi, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20050427114926.45a91b5e.davem@davemloft.net>
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

David S. Miller wrote:
> Good point.  It does mean that the best thing you can do is
> block reception at recvmsg() time, nothing more.  You can't
> drop the packet at recvmsg() time because TCP has ACK'd
> the thing already etc.

I think what it comes down to is that we can filter in socket
context, but the only useable attributes in both input- and
output-path for owner-matching are
sk->sk_socket->file->f_{uid,gid}. This should still be enough
for many usage cases (and for mine), so I'm going to finish the
patch.

@james: Out of interest, what are the requirements for selinux?

Regards
Patrick
