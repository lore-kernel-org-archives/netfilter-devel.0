From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Reviewing a piece of code, locking questions
Date: Mon, 31 May 2004 10:36:49 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405311028450.4215-100000@filer.marasystems.com>
References: <40BA6F4E.1050706@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matthias Dettling <m-dettling@gmx.de>
In-Reply-To: <40BA6F4E.1050706@gmx.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 31 May 2004, Matthias Dettling wrote:

> many thanks for your help.
> This is what I meant, when saying "a patched version" of ipt_conntrack.c.
> I found your patch on the net and applied it. So my work was only 
> extending ipt_conntrack.c for matching tracked informations.

Is this the old patch where I add port matches to ipt_conntrack?

> This means that my work depends on your patch because I use the same 
> functions as your code does. I looked in the current CVS version of 
> patch-o-matic about your patch as also in the file 
> patch-o-matic-ng-20040302.tar.bz2 but didn't find it.

I never got any response from the ipt_conntrack author on these changes.

> Because my work needs your patch am I allowed to add your patch to my 
> patch (of course I would mention your name)?

Yes.

> You gave me the hint for simplifying kernel code storing the port 
> numbers in network byte order. If I'm right I think that you don't do so 
> in your patch. Because my work depends strongly on your it would be 
> awkward to do so. But if it is really better for performance I could 
> change the whole code in this way.

If I don't do so then please change my patch by moving the ntohs calls to 
libipt_conntrack.

> If I have created a patch as tarball where should I send this that it 
> will be included in future releases of patch-o-matic?

Here to the mailinglist.

Regards
Henrik
