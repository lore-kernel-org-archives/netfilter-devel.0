From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] ROUTE target : update to pom-ng + new version for kernel
 2.6.x
Date: Mon, 26 Apr 2004 06:46:01 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404260616130.2326-100000@filer.marasystems.com>
References: <20040424210127.27cbc7fc.eribicic@uolsinectis.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Esteban Ribicic <eribicic@uolsinectis.com>
In-Reply-To: <20040424210127.27cbc7fc.eribicic@uolsinectis.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 24 Apr 2004, Esteban Ribicic wrote:

> now, what i notice is that ESTABLISHED connections are rarely under 2000 seconds? isnt it rare?

The timeout of a ESTABLISHED TCP is 5 days (432000 seconds).. A
ESTABLISHED connecting with a timeout under 2000 seconds needs to have
been idle in almost 5 days..

TCP state timeouts from ip_conntrack_proto_tcp:

unsigned long ip_ct_tcp_timeout_syn_sent =      2 MINS;
unsigned long ip_ct_tcp_timeout_syn_recv =     60 SECS;
unsigned long ip_ct_tcp_timeout_established =   5 DAYS;
unsigned long ip_ct_tcp_timeout_fin_wait =      2 MINS;
unsigned long ip_ct_tcp_timeout_close_wait =   60 SECS;
unsigned long ip_ct_tcp_timeout_last_ack =     30 SECS;
unsigned long ip_ct_tcp_timeout_time_wait =     2 MINS;
unsigned long ip_ct_tcp_timeout_close =        10 SECS;


Each packet while the TCP is in the given state extends the timeout.


On UDP the timeouts is much smaller due to the stateless nature of the 
protocol

unsigned long ip_ct_udp_timeout = 30*HZ;
unsigned long ip_ct_udp_timeout_stream = 180*HZ;


30 seconds for traffic in only one direction, 180 if traffic has been 
seen in both directions.

Regards
Henrik
