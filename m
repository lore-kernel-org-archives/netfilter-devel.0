From: "Jim Fleming" <JimFleming@ameritech.net>
Subject: 0x62....and Area 0x51
Date: Wed, 25 Sep 2002 17:22:53 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <01ad01c264e2$178c91b0$d6ea2543@repligate>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte laforge@gnumonks.org 
On Tue, Sep 17, 2002 at 01:22:48PM +0300, Andrei Ivanov wrote:
> 
> Hello,
> I'm trying to filter packets which have a TOS value of 0x62, and it seems
> I cannot.
because it's an invalid TOS value.
======================================================

The TOS field is 8 bits, ALL values are valid....0 to 255

0x62 is a packet from the 6 (src) to the 2 (dst) address space...

128-bit DNS AAAA Record Flag Day Formats
2002:[IPv4]:[SDLL.OFFF.FFFF.TTTT]:[64-bit IPv8 or IPv16 Persistent Address]
[YMDD]:[IPv4]:[SDLL.OFFF.FFFF.TTTT]:[64-bit IPv8 or IPv16 Persistent Address]
1-bit to set the Reserved/Spare ("SNOOPY") bit in Fragment Offset [S]
1-bit to set the Don't Fragment (DF) bit [D]
2-bits to select 1 of 4 common TTL values (255, 128, 32, 8) [LL]
1-bit for Options Control [O]
7-bits to set the Identification Field(dst) [FFFFFFF]
4-bits to set the TOS(dst) Field [TTTT]
Default SDLL.OFFF.FFFF.TTTT = 0000.0000.0000.0000
FFF.FFFF.TTTT = GGG.SSSS.SSSS
http://www.ntia.doc.gov/ntiahome/domainname/130dftmail/unir.txt

Area 0x51 is not controlled by the DOD...

Jim Fleming
2002:[IPv4]:000X:03DB:...IPv8 is closer than you think...IPv16 is even closer...
http://www.netfilter.org/
http://www.analogx.com/contents/dnsdig.htm
http://ipv8.dyndns.tv
http://ipv8.yi.org
http://ipv8.dyns.cx
http://ipv8.no-ip.com
http://ipv8.no-ip.org
http://ipv8.no-ip.biz
http://ipv8.no-ip.info
http://ipv8.myip.us
http://ipv8.dyn.ee
http://ipv8.community.net.au
http://ipv8.ods.org
