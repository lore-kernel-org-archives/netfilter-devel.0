From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Mangle on a Connection, not on a Packet
Date: Fri, 17 Oct 2003 07:03:56 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310170658280.17002-100000@filer.marasystems.com>
References: <200310170326.h9H3QVK17619@singularity.tronunltd.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ian Latter <Ian.Latter@mq.edu.au>
In-Reply-To: <200310170326.h9H3QVK17619@singularity.tronunltd.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 17 Oct 2003, Ian Latter wrote:

> 1. for my input/output rules I would add rules to send any
> new connections on my "special ports/protos" to the 
> CONNMARK target for marking .. but I'd want an arbitrary
> unique mark per connection, not a static one .. is this 
> possible?  (and I'd need that mark to be made free when
> the connection is removed from netfilter).

Then you need something a little more advanced than CONNMARK I think.

>From your description it sounds like you could be using the conntract 
handle as is. This will give you an arbitrary integer of size (void *).

> 2. in the mangle table, I would use connmark matching to
> send all marked connections to the XOR target .. but am
> I able to access the arbitrary unique mark from within
> the XOR target module itself (programatically)?

The conntrack mark is available as ct->mark.

Examle code snipped accessing the conntrack mark:

      enum ip_conntrack_info ctinfo;
      struct ip_conntrack *ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
      if (!ct)
          return 0;

      mark = ct->mark;

Regards
Henrik
