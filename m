From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: DNAT dosen't work
Date: Sat, 11 Oct 2003 22:10:06 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310112208340.14382-100000@filer.marasystems.com>
References: <A59F9B5C2A83424F9A8679E1BAB3E56610DCAA@exchange.zoodomain.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Slav Rilov <Slav.Rilov@Zoo.org>
In-Reply-To: <A59F9B5C2A83424F9A8679E1BAB3E56610DCAA@exchange.zoodomain.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 10 Oct 2003, Slav Rilov wrote:

> I have log that tracks pakets and I see that packet arrives, then it
> destination addresses changes to 10.10.1.1 and hits eth1 instead of eth0
> and stops, never gets to eth0

The packet arrives on eth1 and can not jump to eth0 as the cable carrying 
the packet is connected on eth1.

However, all addresses present on eth0 also exist on eth1.

Please describe in more detail what your problem is.

Regards
Henrik
