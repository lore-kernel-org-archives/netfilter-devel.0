From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [RFC] Die to NOTRACK/TRACE, long live MARK!
Date: Thu, 20 May 2004 12:48:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40AC8D07.3090308@eurodev.net>
References: <Pine.LNX.4.33.0405192236590.3749-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.33.0405192236590.3749-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Jozsef,

Jozsef Kadlecsik wrote:

>Willy Tarreau suggested that the TCP window tracking code could be used to
>protect connections against the "TCP vulnerabilities" brought up recently
>(see for example http://www.uniras.gov.uk/vuls/2004/236929). After some
>discussion and code-fragments the result is that it could be done fairly
>easily: the SYN/RST probes could be counted and when a threshold is
>reached, we'd deliberately drop in-window SYN/RST segments to protect the
>connection. However, it'd then mean a violation of the TCP protocol
>specification and therefore I'd definitely not like to enable it by
>default or to enable it for all traffic. So there should be a way to tell
>the system which connections (packets) to protect.
>  
>

I agree, these options shouldn't be enable by default, as I told you in 
my last email related to window-tracking stuff that we could set the 
default action (NF_*) applied to packet via sysctl, so a sysadmin could 
choose to perform an agressive window /secuence tracking, this way if we 
see out-of-window packets, we could log and drop them.

>We could introduce a new silly target for that purpose like NOTRACK or
>TRACE. However it's pure marking and we do have a interface to mark
>packets: the MARK target. So if we could tell the system which mark value
>has got the given special meaning, we wouldn't need a new target and we
>could even eliminate the NOTRACK/TRACE targets.
>  
>

yes, I think that's ok, we could implement a set of "security" matches 
which perform some action depending on the mark. For example, 
mark_rst_protection could use internal tcp conntrack information to see 
if an rst was retransmited too many times and block rst's during a 
timeout to reduce effects of an rst attack or whatsoever. So we should 
reserve a range of marks.

regards,
Pablo
