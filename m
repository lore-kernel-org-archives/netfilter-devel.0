From: Amin Azez <azez@ufomechanic.net>
Subject: Re: libnfnetlink_conntrack encapsulation issues
Date: Fri, 28 Jul 2006 22:13:36 +0100
Message-ID: <44CA7E00.5000803@ufomechanic.net>
References: <44C89B2E.1080401@ufomechanic.net> <44CA2F93.9000409@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44CA2F93.9000409@netfilter.org>
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


Thanks for your help Pablo.

Pablo Neira Ayuso wrote:
>
> enums are OK, the problem is out-of-tree scary things like this layer 
> 7 stuff that makes an insane use of libnetfilter_conntrack.
>

ummmm it seems quite normal use, such as any iptables extension that 
stores per-conntrack information might want to use. I already mentioned 
the per-flow mark, so that each flow of a conntrack can have its own 
mark; just like it suseful to get one mark via conntrack, its useful to 
get the rest too.

I agree, out-of-tree is where it gets scary. I send myself to sleep at 
night thinking up alternative methods.

Sam
