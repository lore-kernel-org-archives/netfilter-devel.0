From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH] update raw patch in POM
Date: Tue, 21 Jun 2005 02:34:41 +0200
Message-ID: <20050621003441.GI8335@postel.suug.ch>
References: <42A57FC4.7010508@tac.ch> <42A5B144.3090005@tac.ch>
	<42A625DA.7090807@eurodev.net> <42A6AB19.2040106@tac.ch>
	<42A6E685.3060408@eurodev.net> <42AEF774.8060300@tac.ch>
	<42B67BEC.1090105@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
Content-Disposition: inline
In-Reply-To: <42B67BEC.1090105@tac.ch>
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

* Roberto Nibali <42B67BEC.1090105@tac.ch> 2005-06-20 10:18
> > I'm not yet done with testing, however something is not quite right now:
> > 
> > CPU: 2
> > EIP: 0010:[<00000000>] Not tainted
> > Using defaults from ksymoops -t elf32-i386 -a i386
> > EFLAGS: 00010202
> > eax: 00000000 ebx: c287df30 ecx: f8aa1ef4 edx: c287c001
> > esi: 00000000 edi: f7b92a34 ebp: f7b92980 esp: c287deac
> > ds: 0018 es: 0018 ss: 0018
> > Process swapper (pid:0, stackpage=c287d000)
> > Stack: c02a8f74 f8aa1e80 c287df30 f7b92a34 c01de099 f4a4d920 c287df30 00000040
> >        f7b92980 f7b92800 00000000 00000001 00000001 f7b92800 f7b92a18 c01ddee9
> >        f7b92980 f7b928c4 f7b92800 00000002 c0417b20 2471321d 00000000 c02ad245
> > Call trace:  [<c02a8f74>] [<f8aa1e80>] [<c01de099>] [<c01ddee9>] [<c02ad245>]
> > [<c011f7ad>] [<c0108e00>] [<c0105330>] [<c0105330>] [<c0105330>] [<c0105330>]
> > [<c010535c>] [<c01053c2>] [<c011a859>]
> > Code: Bad EIP value.
> 
> Added following code in skbuff.h, because of the strange (overwritten) stack:
> 
> nf_conntrack_put(struct nf_ct_info *nfct)
> {
> +        if ((((long) nfct) & 0xf8000000) && atomic_read(&nfct->master->use) <= 1
> )
> +                BUG();
>         if (nfct && atomic_dec_and_test(&nfct->master->use))
>                 nfct->master->destroy(nfct->master);
> }
> 
> 
> BUG at /home/.../include/linux/skbuff.h: 1175!

:1175 is the BUG above, right? If so it means that we're about to call
destroy() on a conntrack entry which is not allocated. I assume it is
ip_conntrack_untracked.

My theory is:

ip_conntrack_untracked is put into the conntrack with a refcnt of 2
(+1 during init and +1 while assigning it to nfct). Once the packet
leaves the ip stack we release the first use, when the modules
get unloaded we release the entry again and call destroy() on it
resulting in a overall corruption.

The whole notrack thing seems to be a big hack. ;->
