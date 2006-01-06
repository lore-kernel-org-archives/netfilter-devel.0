From: Patrick McHardy <kaber@trash.net>
Subject: Re: Patch for H323 connection tracking for kernel 2.6.14 and Panic
 with SIP tracking
Date: Fri, 06 Jan 2006 12:57:03 +0100
Message-ID: <43BE5B0F.8010406@trash.net>
References: <c4d05cbe0512311447v33a9cb13w4e6201c5d6ccbd00@mail.gmail.com>	<c4d05cbe0601021028x4dad0a18n2b3c1b8e10506f11@mail.gmail.com>	<43BA605E.3020801@trash.net>	<43BD7AF4.2040506@nk.nl>
	<43BE39B2.5020605@nk.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Victor Julien <victor@nk.nl>
In-Reply-To: <43BE39B2.5020605@nk.nl>
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
> Hmmm, while it still hasn't crashed on me, i can't get it to operate
> either. I am using 2.6.15 + pom 20060101 + the above fix. I am trying to 
> get the following setup working:
> 
> softphone (lan) --- sip proxy on gateway --- sip server (@isp)
> 
> I have rules to allow port 5060/udp. I expected that by loading
> ip_conntrack_sip this rule, together with accepting
> all RELATED traffic, sip conversations would work.
> 
> If i call a number, i see the following entry appear in
> /proc/net/ip_conntrack_expect:
> 176 proto=17 src=217.66.118.164 dst=80.126.xx.xx sport=0 dport=7071
> 176 proto=17 src=192.168.1.1 dst=192.168.1.2 sport=0 dport=8000
> 
> (lan client 192.168.1.2, firewall has 192.168.1.1 and 80.126.xx.xx, sip 
> server is 217.66.118.164).
> 
> But the connection does not work. I have added the following rule to all 
> chains in all tables (mangle, nat, filter):
> iptables -t <table> -I <chain> 1 -m helper --helper sip
> to see if the sip match ever gets reached, but all counters remain on 0 
> all the time.
> 
> If i do the same for ftp, i can see the counters increase.
> 
> Does anyone have an idea what is going wrong?

Try to find out if the expectations ports are correct by logging
the incoming traffic or using tcpdump.
