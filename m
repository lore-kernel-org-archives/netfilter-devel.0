From: Willy TARREAU <willy@w.ods.org>
Subject: Re: patch-o-matic-ng release candidate in cvs
Date: Mon, 10 May 2004 00:19:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040509221941.GA11533@pcw.home.local>
References: <20040509164411.GA20463@pcw.home.local> <Pine.LNX.4.44.0405092357270.14931-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0405092357270.14931-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Henrik,

On Mon, May 10, 2004 at 12:04:50AM +0200, Henrik Nordstrom wrote:
> On Sun, 9 May 2004, Willy TARREAU wrote:
> 
> > While INFOP needs at least 2 arguments :
> > 
> >    #define INFOP(fmt, args...) printk(KERN_INFO "%s: %s: " fmt, __FILE__, __FUNCTION__, ## args)
> 
> Actually I think the bug is that there is no space infront of the comma in
> the ## expansion. To limit the conflicts with C99 the GNU CPP varargs
> comma magics is only activated if there is a space infront of the comma
> like in this example from the GNU CPP manual:
> 
>      #define eprintf(format, args...) fprintf (stderr, format , ##args)

Hmm, interesting trick, I didn't know about this. Thanks for the tip !

> The binary should be unaffected as this is preprocessor juggling only.. 
> the resulting C code is identical in both cases.

Yes it can (and does) affect the binary size, because the compiler knows how
to merge strings. I reduced by about 1.5 kB the binary size of one of my
program by changing all __FILE__ ":" __FUNCTION__ ":" to 
"%s:%s" __FILE__, __FUNCTION__ because in the first case, the compiler
allocates a complete string for each different combination of __FILE__ and
__FUNCTION__, while in the second case, it allocates :
  - 1 "%s:%s" string
  - 1 __FILE__ string
  - 1 __FUNCTION__ string for each separate function

And in the RTSP case, the module went from 7400 bytes to 7300 when applying
your patch instead of mine. So I was right thinking that my patch would
increase the binary size (only by 1.3% though).

Anyway, this is a good news since it means that your patch works ;-)

Thanks,
Willy
