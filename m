From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: iptables.c changes submitted argv value
Date: Thu, 12 Aug 2004 13:11:53 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408121254480.20263@filer.marasystems.com>
References: <IDEAKKJENKGNPNLKJKODOEAECAAA.listuser@epygi.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sascha <listuser@epygi.de>
In-Reply-To: <IDEAKKJENKGNPNLKJKODOEAECAAA.listuser@epygi.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 12 Aug 2004, Sascha wrote:

>> The recommended method for doing this is using iptables-restore via a 
>> pipe from your daemon.
>
> That's not the point. I'm developing on an embedded device and i have no 
> space for iptables-store.c, iptables-restore.c and iptables.c.

All you need is iptables-restore. It has all functions of iptables plus 
more and is very well suited for batch or daemon operations. What 
iptables-restore is is a efficient batch interface using the same syntax 
as iptables (well, it is even the same code so..)

libiptc is considered private to iptables/iptables-save/iptables-restore 
and is not meant to be used outside these applications.

Regards
Henrik
