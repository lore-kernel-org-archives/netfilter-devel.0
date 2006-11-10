From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Conntrack timeout
Date: Fri, 10 Nov 2006 01:37:28 +0100
Message-ID: <4553C9C8.1090600@netfilter.org>
References: <J8GZ11$7A6D86EA0A1A0E5E6A1868598F117CEE@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	netfilter <netfilter@lists.netfilter.org>
Return-path: <netfilter-bounces@lists.netfilter.org>
To: "mael.boutin@laposte.net" <mael.boutin@laposte.net>
In-Reply-To: <J8GZ11$7A6D86EA0A1A0E5E6A1868598F117CEE@laposte.net>
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

mael.boutin@laposte.net wrote:
>> You can change them via:
>> - /proc/sys/net/ipv4/netfilter/ip_conntrack_[tcp|udp]_*
>> - conntrack tool/libnetfilter_conntrack library
> 
> In fact i m tracking ipv6 connections. Therefore the first one
> is not available (i m using nf_conntrack)

check /proc/sys/net/netfilter/nf_conntrack_*

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
