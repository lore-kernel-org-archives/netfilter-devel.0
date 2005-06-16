From: Pablo Neira <pablo@eurodev.net>
Subject: Re: kernel panic with ctnetlink/nfnetlink
Date: Thu, 16 Jun 2005 03:36:33 +0200
Message-ID: <42B0D7A1.70508@eurodev.net>
References: <20050615164034.GA15168@safetpin.homeunix.org>	<42B0BC21.3020004@eurodev.net>
	<20050616010225.GA18652@safetpin.homeunix.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pud@subnet666.de
In-Reply-To: <20050616010225.GA18652@safetpin.homeunix.org>
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

pud wrote:
> On Do, 16 Jun 2005, Pablo Neira wrote:
> 
>>Please post the whole oops. Are you doing something with the conntrack
>>tool? Appreaciate a more detailled description, ruleset, etc...
> 
> sorry, i also forgot to mention that
> a) i tried recent 2.6-kernels (2.6.11, 2.6.12-rc[56])
> b) i wasn't using the conntrack tool, because it was my first try,
>     so a cronjob is still parsing /proc/net/ip_conntrack
> c) as long as the machine lives, conntrack tool is working,
>     and not causing the panic while it runs
> 
> i tried some other new modules as well (h323, ipp2p and so on),

That "so on" is rather big.

> but i'm sure it only happens if the kernel is patched with ctnetlink/nfnetlink

Why? Did you run your box *only* with ctnetlink patches applied? All 
that stuff you've mentioned is under development as well. If you patch 
your kernel with tons of experimental stuff is hard to know what's wrong.

> the whole ruleset may be too big for a list, but i can send you pm
> if you like
> 
> here the latest panic:
> 
> 
> Unable to handle kernel NULL pointer dereference

Please, decode this with ksymoops.

--
Pablo
