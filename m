From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: libipq and ip_queue
Date: Wed, 25 Feb 2004 22:51:58 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402252238180.32183-100000@filer.marasystems.com>
References: <20040225041703.GG19291@hserus.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chandrakanth Chereddi <kanth@hserus.net>
In-Reply-To: <20040225041703.GG19291@hserus.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 25 Feb 2004, Chandrakanth Chereddi wrote:

> Marking the words *almost anything*, I had my doubts and thought that the
> devel list would be the best place to get further information.

There is a few limitations to ip_queue, but probably nothing major for 
your application.

ipqueue provides you access to the IP packet and payload, but does not
give you access to the complete MAC header of the packet, only the
destination MAC address.

You can modify the packet payload including IP header, but you can not
modify the nfmark, routing or other skb fields outside the packet payload.
I think there was a patch floating around to extend ipq with the ability 
to set the nfmark if needed some time ago (many months).

In addition, packet mangling via ip_queue or in fact any netfilter hook
outside the same does not work well together with netfilter conntrack or
NAT so be careful if you plan on using any of these features.

Regards
Henrik
