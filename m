From: Patrick McHardy <kaber@trash.net>
Subject: Re: libnetfilter_conntrack question
Date: Fri, 16 Mar 2007 09:58:42 +0100
Message-ID: <45FA5C42.2040003@trash.net>
References: <45F4B34F.3020007@ipom.com>
	<45F527F2.40404@netfilter.org>	<45F6558A.2070601@ipom.com>
	<45F671CA.6010401@netfilter.org>	<45F8D7DD.8040901@ipom.com>
	<45F92FD3.2080708@netfilter.org> <45FA58D7.4030507@ipom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Dibowitz <phil@ipom.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45FA58D7.4030507@ipom.com>
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

Phil Dibowitz wrote:
> One other question - I noticed that I can't seem to delete ICMP states. This
> is true both from my own code, as well as from conntrack(8):
> 
> [phil@rider libnetfilter_conntrack]$ sudo grep icmp /proc/net/ip_conntrack
> icmp     1 29 src=10.1.1.2 dst=209.40.128.125 type=8 code=0 id=43603
> [UNREPLIED] src=209.40.128.125 dst=10.1.1.2 type=0 code=0 id=43603 use=1
> 
> [phil@rider libnetfilter_conntrack]$ sudo conntrack -D conntrack  -s
> 10.1.1.2 -d 209.40.128.125 -p icmp --icmp-type 8 --icmp-code 0
> NFNETLINK answers: No such file or directory
> Operation failed: such conntrack doesn't exist
> 
> I get the same thing either way - that the conntrack doesn't exist. I can
> delete TCP and UDP just fine, but not ICMP. And just for clarity, yes, I'm
> attempting to delete it before it expires (this is easy to check by keeping
> iptstate running in a window).
> 
> Am I doing something wrong, or can you not delete ICMP states?


I think you have to specify --icmp-id as well, otherwise the tuple is
incomplete.
