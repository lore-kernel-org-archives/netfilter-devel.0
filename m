From: Martijn Lievaart <m@rtij.nl>
Subject: Re: ip_conntrack_tuple and marks
Date: Mon, 25 Sep 2006 20:42:58 +0200
Message-ID: <45182332.8090303@rtij.nl>
References: <451448A9.6000407@gmx.net>	<4515F7F8.9030000@netfilter.org>	<4516C70A.3050502@gmx.net>	<451700B1.7070103@rtij.nl>
	<4517E205.8090807@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
In-Reply-To: <4517E205.8090807@gmx.net>
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

Carl-Daniel Hailfinger wrote:

>No, they are not. Let me explain:
>The box in question has two pairs of interfaces.
>eth0: 10.0.0.254/24   eth1: 10.0.1.254/24
>eth2: 10.0.0.254/24   eth3: 10.0.1.254/24
>I want to do routing and firewalling between eth0 and eth1. That's
>simple. However, I also want to do routing and filtering between
>eth2 and eth3. Although eth0 and eth2 have the same subnet, they
>are NOT the same network, they just happen to have identical
>configurations. Same goes for eth1 and eth3.
>  
>

OK, it's clear to me now. I don't think you can achieve that with 
current netfilter connection tracking.

>/\/\/\/\/\/\/\/\    +------+   /\/\/\/\/\/\/\/\
>\              /    |      |   \              /
> | 10.0.0.0/24 |---eth0  eth1---| 10.0.1.0/24 |
>/              \    |      |   /              \
>\/\/\/\/\/\/\/\/    +------+   \/\/\/\/\/\/\/\/
>
>
>/\/\/\/\/\/\/\/\    +------+   /\/\/\/\/\/\/\/\
>\              /    |      |   \              /
> | 10.0.0.0/24 |---eth2  eth3---| 10.0.1.0/24 |
>/              \    |      |   /              \
>\/\/\/\/\/\/\/\/    +------+   \/\/\/\/\/\/\/\/
>  
>

Why not do it exactly like that, but with two real boxes? Makes 
interconnecting later also a nobrainer (NETMAP).

M4
