From: DarKRaveR <DarKRaveR@habitat-b.de>
Subject: Re[2]: libiptc/rules with MAC match
Date: Wed, 12 Feb 2003 22:53:49 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <13014040629.20030212225349@habitat-b.de>
References: <647994215.20030212211303@habitat-b.de>
 <20030212210522.GG30133@calix.csn.tu-chemnitz.de>
Reply-To: DarKRaveR <DarKRaveR@habitat-b.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Poehnitzsch <thomas.poehnitzsch@informatik.tu-chemnitz.de>
In-Reply-To: <20030212210522.GG30133@calix.csn.tu-chemnitz.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Thomas,

Kewl, thanx for that so far, it sounds really promising, now the term
'mask' makes sense and it opens a whole new arsenal of possibilities
how to define rules. I really never came across this, but this might
really help me, I could gather all vlan devices on on NIC, nice stuff,
thnx.

Wednesday, February 12, 2003, 10:05:22 PM, you wrote:

TP> Hi,

TP> On Wed, Feb 12, 2003 at 09:13:03PM +0100, DarKRaveR wrote:

>>   Within this struct there an ipt_ip struct, with the properties:
>>   char iniface[IFNAMSIZ], outiface[IFNAMSIZ];
>>   unsigned char iniface_mask[IFNAMSIZ], outiface_mask[IFNAMSIZ];
>> 
>>   What's the difference between those two ?

TP> just have a look at parse_interface() in $IPT_SOURCE/iptables.c or
TP> ip_packet_match() in $KERNELDIR/net/ipv4/netfilter/ip_tables.c.


TP> To make a long story short: 

TP> Iptables allows you to specify a device like this: "-i eth+", which
TP> means all devices that start with "eth".

TP> In this example iniface would contain: "eth+", whereas iniface_mask
TP> contains something like { 0xFF,0xFF,0xFF,NULL }.

TP> So when iptables comes to compare the actual device with the device
TP> specified in the rule it compares only the first 3 caracters.

TP> Example:

TP> eth1  actual device of packet
TP> eth+  device in rule
TP> 1110  mask (see every "1" as a "0xFF" for a character comparator)
TP> ----
eth   ->> match


TP> At least this is how I understood the sources.

TP> Ciao!
TP>     Thomas

-- 
Best regards,
 DarKRaveR                            mailto:DarKRaveR@habitat-b.de
