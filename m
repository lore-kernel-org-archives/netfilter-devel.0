From: Victor Julien <victor@nk.nl>
Subject: sip connection tracking & expectations
Date: Sat, 07 Jan 2006 17:33:00 +0100
Message-ID: <43BFED3C.9040907@nk.nl>
References: <c4d05cbe0512311447v33a9cb13w4e6201c5d6ccbd00@mail.gmail.com>	<c4d05cbe0601021028x4dad0a18n2b3c1b8e10506f11@mail.gmail.com>	<43BA605E.3020801@trash.net>	<43BD7AF4.2040506@nk.nl>	<43BE39B2.5020605@nk.nl>	<43BE5B0F.8010406@trash.net>
	<43BE6019.2020804@nk.nl> <43BF1E65.60805@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
In-Reply-To: <43BF1E65.60805@trash.net>
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

Hello people,

I have retried getting sip working. I have tried to create manual 
expectations, to see which one works, since the default onces created by 
the sip conntrack module in pom don't work for me.

For simplicity (only one expectation) i have tried a nat setup:

lan client ---- nat gateway ---- sip server

lan client has: 192.168.1.2
nat gateway: 192.168.1.1 and 80.126.43.45
sip server: 217.66.118.164

Kernel 2.6.15, pom 20060101 with ip_ct_refresh fix.

ip_conntrack_sip and ip_nat_sip loaded, all RELATED is accepted.


The client (192.168.1.2) registers at the sip server sip.xs4all.nl 
(217.66.118.164).

When i call my voicemail 1233@sip.xs4all.nl i see the following 
expectations getting generated automaticly:
180 proto=17 src=217.66.118.164 dst=80.126.43.45 sport=0 dport=7078
180 proto=17 src=217.66.118.164 dst=80.126.43.45 sport=0 dport=10500

After the call was initiated, i started to see REJECTs on the lan side 
of my firewall like this:
192.168.1.2:7078 -> 217.66.118.146:34106
(note the different ipaddress, this is not a typo)

Then i manually added this expectation using the conntrack tool:
180 proto=17 src=192.168.1.2 dst=217.66.118.146 sport=7078 dport=34106

And the REJECT messages stopped, and i suddenly heard the audio!

Next to the REJECTs above, i saw in a low frequency (about 1 for 30 of 
above) the following REJECTs:
192.168.1.2:7079 -> 217.66.118.146:34107

So i added that expectation as well:
180 proto=17 src=192.168.1.2 dst=217.66.118.146 sport=7079 dport=34107

Now no REJECTs were showing at the firewall anymore.

When all is working i see the following connections in 
/proc/net/ip_conntrack

udp      17 3562 src=192.168.1.2 dst=217.66.118.164 sport=5060 
dport=5060 packets=8 bytes=4714 src=217.66.118.164 dst=80.126.43.45 
sport=5060 dport=5060 packets=12 bytes=4003 [ASSURED] mark=0 use=3

udp      17 29 src=192.168.1.2 dst=217.66.118.146 sport=7079 dport=34107 
packets=7 bytes=1036 [UNREPLIED] src=217.66.118.146 dst=80.126.43.45 
sport=34107 dport=7079 packets=0 bytes=0 mark=0 use=1

udp      17 179 src=192.168.1.2 dst=217.66.118.146 sport=7078 
dport=334106 packets=2283 bytes=455820 src=217.66.118.146 
dst=80.126.43.45 sport=34106 dport=7078 packets=2278 bytes=455600 
[ASSURED] mark=0 use=1


If you need more info, let me know.

Regards,
Victor
