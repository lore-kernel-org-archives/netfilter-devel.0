From: Patrick McHardy <kaber@trash.net>
Subject: Re: MARK target extension
Date: Sun, 13 Jun 2004 22:23:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1087158188.11287.33.camel@ws>
References: <Pine.LNX.4.44.0406091535410.4854-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Grzegorz Nosek <blackfire@metal.art.pl>,  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0406091535410.4854-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2004-06-09 at 15:43, Henrik Nordstrom wrote:
> On Wed, 9 Jun 2004, Patrick McHardy wrote:
>
> I do agree that it is nice to have the functionality of xor. 
> 
> May I propose that to solve this a userspace option is added "--xor-mark
> value", and that mask 0 is probited in --set-mark if this representation
> is used.

Seems like a good way. I'm also going to add --and-mark and --or-mark as
alternative representations. I'll post the patch before applying it to
see if everyone is happy.

> > One of my concerns was that MARK and CONNMARK should look and behave
> > the same way. We should either change CONNMARK to also use xor, or
> > change your patch to using or. Henrik, what do you think ?
> 
> I have no problem adjusting CONNMARK if a acceptable notation is found. It
> has not yet been submitted to the kernel even if this has been favorly
> discussed many times already.

Yes, I know. I hope it will go in soon ..

Regards
Patrick
