From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Re: How do I use ip_conntrack_destroyed? [previous message erratum]
Date: Fri, 05 Dec 2003 17:56:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD0AAAD.5020609@netlab.hut.fi>
References: <Pine.LNX.4.44.0312032243000.11739-100000@filer.marasystems.com> <3FCEE93C.5040104@balabit.hu> <3FCF413D.1060405@netlab.hut.fi> <3FCF4E6A.8070202@balabit.hu> <3FD09CF7.1090402@netlab.hut.fi>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: emmanuel@netlab.hut.fi
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>
> About this patch, I cannot install it. I started over from a clean 
> linux 2.4.22 kernel and applied the patches. First I used ./runme base 
> and applied everything I could. then I used ./runme extra and in the 
> extra patches I only tried to apply the nfnetlinc patch (thus I did 
> not install the two conflicting patches - ctstat and 
> netfilter-docbook). Still, it does not work. Is there any other 
> required/conflicted patch that I am not aware of?
>
>
>             Emmanuel
>
I got it work with a new 2.23 kernel and applying _only_ this patch. 
Please, forget about my previous message.

                Emmanuel
