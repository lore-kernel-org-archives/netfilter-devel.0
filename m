From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: pb fingerprint icmp on netfilter/linux
Date: Mon, 28 Nov 2005 15:08:02 +0100
Message-ID: <131467063.20051128150802@dns.toxicfilms.tv>
References: <Pine.LNX.4.64.0511281009250.1323@npre.npre.pbz>
Reply-To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: rmkml <rmkml@free.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.64.0511281009250.1323@npre.npre.pbz>
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

Hi,

> I have a little pb, Im received icmp ping echo request,
> normaly echo request are type 8 and code 0,
> but this echo request are type 8 and code 19 !
> my iptables rules is :
>   iptables -A INPUT -j ACCEPT -p icmp --icmp-type echo-request
use:
icmp-type 8/19 to match type 8/code 19

`iptables -p icmp --help` says about that.

--
regards,
Maciej
