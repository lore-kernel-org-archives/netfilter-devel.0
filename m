From: Patrick McHardy <kaber@trash.net>
Subject: Re: Patch for H323 connection tracking for kernel 2.6.14 and Panic
 with SIP tracking
Date: Sat, 07 Jan 2006 02:50:29 +0100
Message-ID: <43BF1E65.60805@trash.net>
References: <c4d05cbe0512311447v33a9cb13w4e6201c5d6ccbd00@mail.gmail.com>	<c4d05cbe0601021028x4dad0a18n2b3c1b8e10506f11@mail.gmail.com>	<43BA605E.3020801@trash.net>	<43BD7AF4.2040506@nk.nl>	<43BE39B2.5020605@nk.nl>
	<43BE5B0F.8010406@trash.net> <43BE6019.2020804@nk.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Victor Julien <victor@nk.nl>
In-Reply-To: <43BE6019.2020804@nk.nl>
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

Victor Julien wrote:
>> Try to find out if the expectations ports are correct by logging
>> the incoming traffic or using tcpdump.
>>
> 
> When making a call:
> 
> # cat /proc/net/ip_conntrack_expect
> 174 proto=17 src=217.66.118.164 dst=80.126.43.45 sport=0 dport=7071
> 174 proto=17 src=192.168.1.1 dst=192.168.1.2 sport=0 dport=8000
> 
> tcpdump:
> 13:05:46.220869 IP 192.168.1.2.8000 > 192.168.1.1.7072: UDP, length: 172
> 
> syslog:
> Jan  6 13:05:46 sanctorium kernel: vrmr: REJECT reject-in IN=eth0 OUT= 
> MAC=aa:00:04:00:0a:04:00:90:27:57:31:29:08:00 SRC=192.168.1.2 
> DST=192.168.1.1 LEN=200 TOS=0x00 PREC=0x00 TTL=64 ID=401 DF PROTO=UDP 
> SPT=8000 DPT=7072 LEN=180
> 
> REJECT is the default policy for lan to firewall traffic.
> 
> Can it be that the expectation direction is wrong?
> dropped traffic is src 192.168.1.2:8000 to dst 192.168.1.1:7072
> expect is src 192.168.1.1 to dst 192.168.1.2:8000

Possible. In which direction (relative to registration) does
the call go?
