From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: How to match protocol 0
Date: Sat, 2 Jun 2007 23:19:52 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706022314440.28357@yvahk01.tjqt.qr>
References: <20070428220206.GA26272@linuxace.com>
	<463524E7.60107@netfilter.org>
	<Pine.LNX.4.61.0704301038100.22744@yvahk01.tjqt.qr>
	<20070430171317.GA6904@linuxace.com>
	<Pine.LNX.4.61.0704301924021.29151@yvahk01.tjqt.qr>
	<20070430173654.GB6904@linuxace.com>
	<Pine.LNX.4.61.0706022042100.5076@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Phil Oester <kernel@linuxace.com>
To: Netfilter Mailing List <netfilter@lists.netfilter.org>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706022042100.5076@yvahk01.tjqt.qr>
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



On Jun 2 2007 20:49, Jan Engelhardt wrote:
>Hello all,
>
>
>regarding your questions in
>http://lists.netfilter.org/pipermail/netfilter/2007-April/068496.html 
>and the thread
>http://lists.netfilter.org/pipermail/netfilter-devel/2007-April/027675.html
>
>I think it's actually quite easy. How about:
>
>	iptables -m u32 --u32 "8&0x0F00=0"

minor glitch, it should read:
for TCP (prot  6): iptables -m u32 --u32 "8 & 0x00FF0000 = 0x00060000"
for UDP (prot 17): iptables -m u32 --u32 "8 & 0x00FF0000 = 0x00110000"
for HBH (prot  0): iptables -m u32 --u32 "8 & 0x00FF0000 = 0x00000000"

(Leading zeroes can be omitted of course.)
And, for example completeness, have some shift,

TCP: iptables -m u32 --u32 "8 & 0xFF0000 >> 16 = 6"

Happy matching.



	Jan
-- 
