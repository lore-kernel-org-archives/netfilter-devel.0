From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: MARK target extension
Date: Wed, 9 Jun 2004 15:43:37 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406091535410.4854-100000@filer.marasystems.com>
References: <40C6CF8D.8080201@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Grzegorz Nosek <blackfire@metal.art.pl>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <40C6CF8D.8080201@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 9 Jun 2004, Patrick McHardy wrote:

> Nice, although the xor operation (0x80/0) is a bit non-intuitive.

And therefore also quite easy to get wrong.. for me the intuitive meaning
of 0x80/0 is to set bit 0x80 or nothing, not xor.

I do agree that it is nice to have the functionality of xor. 

May I propose that to solve this a userspace option is added "--xor-mark
value", and that mask 0 is probited in --set-mark if this representation
is used.

> One of my concerns was that MARK and CONNMARK should look and behave
> the same way. We should either change CONNMARK to also use xor, or
> change your patch to using or. Henrik, what do you think ?

I have no problem adjusting CONNMARK if a acceptable notation is found. It
has not yet been submitted to the kernel even if this has been favorly
discussed many times already.

Regards
Henrik
