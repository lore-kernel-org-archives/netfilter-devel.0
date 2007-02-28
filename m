From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_queue man page
Date: Wed, 28 Feb 2007 13:43:24 +0100
Message-ID: <45E578EC.2060803@netfilter.org>
References: <2e25cc380702270005sfdf44a3q50305cdfa65b4732@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
To: Julien DHERSIN <dhersin@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <2e25cc380702270005sfdf44a3q50305cdfa65b4732@mail.gmail.com>
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

Julien DHERSIN wrote:
> But, I still have a question : I would like to add an extension in
> filtered IPv6
> multicast packets headers. Do you think, I can do this in the userspace
> using libnetfilter queue ? And, how precisely does it work ? Is it
> something like this :

Yes, you can process packets from userspace via libnetfilter_queue.

> 1. Activate the hook NF_IP6_LOCAL_OUT with an iptables rule

ip6tables -I OUTPUT -j NFQUEUE

> 2. Launch my software with libnetfilter_queue
> 3. Modify the header
> 4. Return the whole packet to netfilter

Correct.

> Do I have tocreate a specific kernel module ?

Not necessarily, you can do it from userspace, anyway this question also
depends on your needs.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
