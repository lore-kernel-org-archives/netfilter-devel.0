From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: 2.4 SNAT fails randomly
Date: Sun, 16 Nov 2003 10:52:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031116095206.GA32471@balabit.hu>
References: <200311151103.47454.timg@tpi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tim Gardner <timg@tpi.com>
Content-Disposition: inline
In-Reply-To: <200311151103.47454.timg@tpi.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, Nov 15, 2003 at 11:03:47AM -0700, Tim Gardner wrote:
> I think I have a case where SNAT is sometimes failing. I have a specific case 
> where UDP SNAT fails repeatedly. However, I have SPOOF log entries on some of 
> our servers that indicate TCP is also failing SNAT once in awhile.
>[snip] 
> This client has a NetGear router connected to our firewall. The NetGear router 
> has a well known bug wherein it attempts to get time/date via UDP/NTP from a 
> hardcoded destination (caesar.cs.wisc.edu). This is the UDP packet that is 
> not being SNAT'd. The packet in question is thus:
> 

NAT mappings are established for NEW connections only, isn't it possible that your 
client sent an NTP request while your rule was not yet established? This means that it
is entered the CONNTRACK table without the NAT manip and anything that comes later is
not NATed as it is not a fresh CONNTRACK.

Try filtering this traffic for 180secs and see it disappear from /proc/net/ip_conntrack, 
then remove the filtering and check whether it traversed the  nat/POSTROUTING chain.

-- 
Bazsi
