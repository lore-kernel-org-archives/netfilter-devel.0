From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: How to match protocol 0
Date: Sat, 2 Jun 2007 20:49:37 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706022042100.5076@yvahk01.tjqt.qr>
References: <20070428220206.GA26272@linuxace.com>
	<463524E7.60107@netfilter.org>
	<Pine.LNX.4.61.0704301038100.22744@yvahk01.tjqt.qr>
	<20070430171317.GA6904@linuxace.com>
	<Pine.LNX.4.61.0704301924021.29151@yvahk01.tjqt.qr>
	<20070430173654.GB6904@linuxace.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Phil Oester <kernel@linuxace.com>
To: Netfilter Mailing List <netfilter@lists.netfilter.org>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-bounces@lists.netfilter.org>
In-Reply-To: <20070430173654.GB6904@linuxace.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello all,


regarding your questions in
http://lists.netfilter.org/pipermail/netfilter/2007-April/068496.html 
and the thread
http://lists.netfilter.org/pipermail/netfilter-devel/2007-April/027675.html

I think it's actually quite easy. How about:

	iptables -m u32 --u32 "8&0x0F00=0"

This takes bytes 8+4 of a packet (bytes 8,9,10,11), ANDs it with 0x0F00, 
so as to get only byte 9 (which is the IPv4 field for the Layer4 
protocol) and see if it is 0.

(Yes, we would have to use a shift before comparing, but since comparing 
for protocol zero, it does not matter.)

Ok, everyone got that? :)


	Jan
-- 
