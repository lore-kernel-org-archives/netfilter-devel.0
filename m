From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: Re: nfsim problem with NAT
Date: Tue, 18 Jan 2005 18:28:22 -0500
Message-ID: <41ED9B96.5010105@cookinglinux.org>
References: <20050118231729.GA11445@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
In-Reply-To: <20050118231729.GA11445@roonstrasse.net>
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

Max Kellermann wrote:
> Hi,

Hi Max !

> 
> I'm trying to write a nfsim test for the H.323 conntrack module. The
> NAT part fails, because I cannot set up the NAT rule:
> 
>14:iptables -t nat -A POSTROUTING -o eth1 -p tcp --dport 1720 -j SNAT --to-source 192.168.0.100
>  iptables: Invalid argument
>  iptables: command failed
>  Script failed at line 14: 
>  iptables failed

both userspace and kernelspace use same structure ?

it works well for me:

 > iptables -t nat -A POSTROUTING -o eth1 -p tcp --dport 1720 -j SNAT 
--to-source 192.168.0.100
 >

NOTE: I use SVN iptables. but shouldn't matter. I think.

Samuel
