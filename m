From: Sami Farin <safari-kernel@safari.iki.fi>
Subject: Re: Kernel oops during netfilter memory allocation
Date: Wed, 22 Aug 2007 19:45:36 +0300
Message-ID: <20070822164536.m7fihwju7bku7lll@m.safari.iki.fi>
References: <200708201808.08880.thomas.jarosch@intra2net.com> <20070820193103.GC2488@martell.zuzino.mipt.ru> <200708211133.56261.thomas.jarosch@intra2net.com> <200708221709.04992.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932440AbXHVRzp@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200708221709.04992.thomas.jarosch@intra2net.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Aug 22, 2007 at 17:09:04 +0200, Thomas Jarosch wrote:
> Hello,
> 
> > > 	kernel BUG at arch/i386/mm/highmem.c:38
> > >
> > > Try this.
> 
> I just tried kernel 2.6.22.4 and 2.6.23-rc3. Using 2.6.23-rc3 vanilla,
> the box survives only 3 seconds with ipt_CRASH. Here's the backtrace,
> it's only slightly different:
> 
> ------------[ cut here ]------------
> kernel BUG at arch/i386/mm/highmem.c:38!
> invalid opcode: 0000 [#1]
> Modules linked in: ipt_CRASH iptable_filter ip_tables x_tables deflate 
> zlib_deflate twofish twofish_common serpent blowfish des cbc ecb blkcipher 
> aes xcbcd

What are you using crypto stuff for?
Hopefully you are not calling crypto functions from
IRQ context.

-- 
Do what you love because life is too short for anything else.
