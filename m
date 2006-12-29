From: Victor Stinner <victor.stinner@haypocalc.com>
Subject: New libnetfilter_conntrack API: why two values of layer 3/4?
Date: Fri, 29 Dec 2006 17:59:14 +0100
Message-ID: <200612291759.14121.victor.stinner@haypocalc.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Hi,

In new libnetfilter_conntrack API, I see:

ATTR_ORIG_L3PROTO = 15
ATTR_REPL_L3PROTO = 16
ATTR_ORIG_L4PROTO = 17
ATTR_REPL_L4PROTO = 18

Is it possible to change layer 3 protocol with NAT? or layer4? If not, one 
constant will be enough ;-)

And for counters, are they 32 or 64 bits?

ATTR_ORIG_COUNTER_PACKETS = 26
ATTR_REPL_COUNTER_PACKETS = 27
ATTR_ORIG_COUNTER_BYTES = 28
ATTR_REPL_COUNTER_BYTES = 29

32 bits (2 GB) sounds small with a gigabyte interface or long uptime (old 
connection).

Haypo
