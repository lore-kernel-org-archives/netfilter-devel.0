From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: iptable_nat module slows/hoses my Redhat 9.0 box
Date: Sat, 13 Dec 2003 01:07:37 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312130106170.20326-100000@filer.marasystems.com>
References: <EFBADA8C200C2B418DA39734FD15475B0B20F1@skat.sky.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "'Jan Kaastrup'" <jka@protego.dk>, <netfilter@lists.netfilter.org>,
   "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kishore Dharmavaram <kishored@servgate.com>
In-Reply-To: <EFBADA8C200C2B418DA39734FD15475B0B20F1@skat.sky.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 12 Dec 2003, Kishore Dharmavaram wrote:

> Yes I want to do that for UDP & ICMP, can you tellme how to remove stateful
> inspection(connection tracking) for just ICMP and UDP protocols without
> removing NAT on ICMP and UDP packets.

One way is by using iproute NAT instead of iptables/netfilter NAT.. and 
don't load ip_conntrack.

Regards
Henrik
