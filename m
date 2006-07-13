From: Patrick McHardy <kaber@trash.net>
Subject: Re: what is the iptable command on shell to enable ping from DMZ
 host	to Router-----PLEASE HELP
Date: Thu, 13 Jul 2006 10:01:18 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0607131000320.15827@x2>
References: <a919cbc70607130053n66eaa7bas9bfacf60329c48b1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: manish Jamwal <manish.jamwal@gmail.com>
In-Reply-To: <a919cbc70607130053n66eaa7bas9bfacf60329c48b1@mail.gmail.com>
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

On Thu, 13 Jul 2006, manish Jamwal wrote:

> Hi
> what is the iptable command on shell to enable ping from DMZ host to Router.
> I have executed this command on shell
>
> iptables -A INPUT -i ixp0.2 -p icmp --icmp-type echo-reply -j ACCEPT
>
> But still not able to ping from DMZ host to router

The users list is for this kind of questions 
(netfilter@lists.netfilter.org), and please don't post the same mail 
multiple times.
