From: Igor Fuks <fuks@alarit.com>
Subject: Re[2]: [PATCH] Nexthop match
Date: Sun, 23 Nov 2003 13:17:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <644915578.20031123131721@alarit.com>
References: <18729960090.20031123024241@alarit.com>
 <20031123082906.GB23141@alpha.home.local> <373135098.20031123124741@alarit.com>
 <20031123110354.GA23247@alpha.home.local>
Reply-To: Igor Fuks <fuks@alarit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
In-Reply-To: <20031123110354.GA23247@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Willy,

Sunday, November 23, 2003, 1:03:54 PM, you wrote:

WT> On Sun, Nov 23, 2003 at 12:47:41PM +0200, Igor Fuks wrote:
>> >> 
>> >> iptables -A OUTPUT -m nexthop --nexthop 10.1.1.5 -s 10.1.10.0/24 -j DROP
>> >> 
>> >> Means stations in 10.1.10.0/24 net will have not connectivity via 10.1.1.5
>> >> neighbour.
>> 
>> WT> It should have been in POSTROUTING or FORWARD for this, isn't it ?
>> 
>> It works for POSTROUTING, FORWARD and OUTPUT.

WT> Sorry, I meant that the above rule only matches locally generated packets
WT> (OUTPUT), which is a bit in contradiction with the comment 'stations in...'.

You are right. Not a good example. This rule really matches locally
generated packets only _with_ source 10.1.10.0/24. It is possible when
netfilter box have several interfaces, including some in 10.1.10.0/24,
and by some reason sends traffic via 10.1.1.5 with different source
addresses. I agree, this is not so useful example...

>> WT> Does it also match packets going TO the gateway, or only packets routed
>> WT> THROUGH the gateway ?
>> 
>> Not only THROUGH, it match packets going TO the gateway(s) too.

WT> Thanks for this clarification.

--
Igor Fuks
