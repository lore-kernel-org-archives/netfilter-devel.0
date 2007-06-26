From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ANNOUNCE] Release of iptables 1.3.8
Date: Tue, 26 Jun 2007 11:21:58 +0200
Message-ID: <4680DAB6.9000903@trash.net>
References: <467FC146.3040801@netfilter.org> <467FCECA.5060302@blue-labs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: David Ford <david@blue-labs.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467FCECA.5060302@blue-labs.org>
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

David Ford wrote:
> http://bugs.gentoo.org/show_bug.cgi?id=166201
> 
> 
> bug quote>
> 
>>I got this error after upgrading to sys-kernel/gentoo-sources-2.6.20(with
>>net-firewall/iptables-1.3.7).
>>
>># iptables --table mangle --append OUTPUT --jump MARK --set-mark 2
>>iptables: Invalid argument
>>
>>dmesg says:
>>ip_tables: MARK target: invalid size 16 != 24
>>
>>similar error occurs when using CONNMARK target, mark match and connmark match.
>>
>>I found an entry on the netfilter mailing list saying:
>>The latest -git kernel includes compatibility functions for 32 bit
>>userspace. You need to compile your iptables without the
>>KERNEL_64_USERSPACE_32 thing though (edit main Makefile).
>>
>>
>>I did so and removed -DKERNEL_64_USERSPACE_32 from the Makefile and it worked.
> 
> 
> Any comments from netfilter team on this?


Indeed, thanks for the reminder. The KERNEL_64_USERSPACE_32 stuff
needs to go.

Patches for that are welcome.
