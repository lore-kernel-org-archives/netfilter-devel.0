From: Patrick McHardy <kaber@trash.net>
Subject: Re: Status of owner-socketlookup
Date: Wed, 27 Apr 2005 12:09:12 +0200
Message-ID: <426F64C8.1070601@trash.net>
References: <Xine.LNX.4.44.0504270037490.16008-100000@thoron.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: James Morris <jmorris@redhat.com>
In-Reply-To: <Xine.LNX.4.44.0504270037490.16008-100000@thoron.boston.redhat.com>
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

James Morris wrote:
> It probably is.  I'd like to find a clean way to get at the destination
> sock via iptables for locally arriving packets, for SELinux.  i.e. match
> incoming packets against a destination security context.
> 
> There's already an LSM hook via sk_filter(), but I also need the iptables
> framework to make use of matches, targets, chains etc.

I also need a clean way for work, so I started with Dave's suggestion of
putting new hooks in the protocols that get the socket as new argument.
The ->rcv functions are split after the socket lookup and netfilter is
called:

         return NF_SK_HOOK(AF_INET, NF_IP_LOCAL_IN, sk, skb, skb->dev, NULL,
                           udp_rcv_finish);

I still need to convert parts of iptables to handle the new argument,
I'll post a patch in a few days. Unfortunately, this doesn't solve
the other problems of the owner match, for properly working pid and
command matching we need at least the pid of the sending process to
look it up. Any ideas for solving this are welcome.

Regards
Patrick
