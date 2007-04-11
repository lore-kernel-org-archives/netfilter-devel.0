From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: NetFilter - Packet Filter - TCP Packet Mangling
Date: Wed, 11 Apr 2007 17:18:31 +0200
Message-ID: <461CFC47.6070302@netfilter.org>
References: <b7e5e2640704110115x4d9b993bx5638260a2a522e06@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: krishna kumar <kris3984@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <b7e5e2640704110115x4d9b993bx5638260a2a522e06@mail.gmail.com>
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

krishna kumar wrote:
> Hi all,
>       I want to alter the IP Address of any outgoing TCP or HTTP Packet
> from a windows server2000 system.Is it possible to do it with the NetFilter
> and If so please suggest me where I can find the sample code .

Netfilter can help but you'll have to install Linux in your system. We
don't have any plan to port it to windows, probably we'll do it for Hurd
once it gets stable.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
