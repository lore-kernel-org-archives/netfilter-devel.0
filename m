From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: NAPT with several IP addresses?
Date: Fri, 21 Nov 2003 11:36:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FBDDCA2.5030307@netlab.hut.fi>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hei!

I was looking at the Linux Netfilter Hacking HOWTO and at the source 
code in ip_nat_proto_tcp.c and I realized that doing NAPT with several 
ports is not supported, am I right?
I mean, in the HOWTO it's written "If IP_NAT_RANGE_PROTO_SPECIFIED isn't 
set, it means that the user is doing NAT, not NAPT". Well, we could also 
use a range of IP addresses and still perform NAPT, couldn't we? Still 
this possibility is not implemented, isn't it?

Anyway, that's just a remark to be sure that I'm not misunderstanding 
the code, nothing more.

            Emmanuel
