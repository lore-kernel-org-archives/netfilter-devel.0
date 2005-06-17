From: pud <pud@safetpin.homeunix.org>
Subject: Re: kernel panic with ctnetlink/nfnetlink
Date: Fri, 17 Jun 2005 02:44:26 +0200
Message-ID: <20050617004426.GC18454@safetpin.homeunix.org>
References: <20050615164034.GA15168@safetpin.homeunix.org>
	<42B0BC21.3020004@eurodev.net>
	<20050616010225.GA18652@safetpin.homeunix.org>
	<42B0D7A1.70508@eurodev.net>
Reply-To: pud@subnet666.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <42B0D7A1.70508@eurodev.net>
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

On Do, 16 Jun 2005, Pablo Neira wrote:

> pud wrote:
> >
> >i tried some other new modules as well (h323, ipp2p and so on),
> 
> That "so on" is rather big.

i know, i was playing a little :) but i added them one by one and
tested each of them a little... last patch added were the netlink patches
and after this the kernel got in panic...
(yes my english sucks)


> >but i'm sure it only happens if the kernel is patched with 
> >ctnetlink/nfnetlink
> 
> Why?

...so i just guessed, that these are causing it.


> Did you run your box *only* with ctnetlink patches applied? All 

err... no :( is on the todo-list now


> that stuff you've mentioned is under development as well. If you patch 
> your kernel with tons of experimental stuff is hard to know what's wrong.

ok, seems logical to me :)


> Please, decode this with ksymoops.

i'm not a kernel hacker, sorry. ksymoops carps a little, so i'll try
with CONFIG_KALLSYMBOLS


=;p)ud

-- 
pgp-key at https://safeTpin.homeunix.org/pud.asc
