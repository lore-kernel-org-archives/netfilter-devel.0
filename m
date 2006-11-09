From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Conntrack timeout
Date: Thu, 09 Nov 2006 15:51:43 +0100
Message-ID: <4553407F.1060707@netfilter.org>
References: <J8GVB6$58359DC0230295AB48BF9CF1D57F3A80@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	netfilter@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: "mael.boutin" <mael.boutin@laposte.net>
In-Reply-To: <J8GVB6$58359DC0230295AB48BF9CF1D57F3A80@laposte.net>
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

Hi,

I've cc'ed this email to netfilter users mailling list since I think 
that this question is not so related with the development.

mael.boutin wrote:
> I wanted to know if it is possible to change the default
> timeout for conntrack entries. And if a modification of these
> timeout will not have border effects on other system features.

You can change them via:
- /proc/sys/net/ipv4/netfilter/ip_conntrack_[tcp|udp]_*
- conntrack tool/libnetfilter_conntrack library

What do you mean with border effects? Of course the behaviour will 
change, think about halted TCP connections for whatever reason, if the 
timeout is higher then they will get stuck longer in the conntrack table.

> I noticed for example that the UDP timeout is set to 30
> seconds if the connection is not assured and 180 in the other
> case.
> 
> The problem i am facing is that i want to detect the end of a
> connection as soon as possible and a delay of 1 or 2 minutes
> is clearly not acceptable.
> 
> I found some conf files in /proc/sys/net/netfilter, however
> not all the timeouts are represented

Which timers are you referring to?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
