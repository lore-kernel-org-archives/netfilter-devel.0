From: Brad Chapman <kakadu_croc@yahoo.com>
Subject: Re: [PATCH?] Fix getorigdst() in ip_conntrack_core.c on 2.4.22-ac2
Date: Wed, 10 Sep 2003 14:27:15 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030910212715.80212.qmail@web40906.mail.yahoo.com>
References: <Pine.LNX.4.44.0309102151530.31287-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0309102151530.31287-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Mr. Nordstrom,

--- Henrik Nordstrom <hno@marasystems.com> wrote:
> On Wed, 10 Sep 2003, Brad Chapman wrote:
> 
> > Hi everyone!
> > 
> > gcc fails with the following error when compiling ip_conntrack_core.c on
> 2.4.22-ac2
> > with gcc 3.2.2:
> 
> See my post a few days ago..

OK. I temporarily suspended my subscription a month ago because I was very busy
and no longer had time to read e-mails. I'll check the pipermail archives.

> 
> > +	struct ip_conntrack_tuple *tuple;
> 
> > +	IP_CT_TUPLE_BLANK(tuple);
> 
> Won't work.. the tuple needs to be allocated somewhere. If you make this 
> change then you will cause random memory corruption or segmentation 
> faults.

Hmmmm, OK. Does that mean that the tuple can't be allocated on the stack, but
instead has to be allocated from the heap ([v,k]malloc()?) I had a feeling that
something was amiss, since the original code _appeared_ to be correct, but
did not compile. My patch made it compile, but since I have no apps which use
SO_ORIGINAL_DST, I can't tell if it would cause it to crash.

> 
> > gcc 3.2.2 compiles this properly with only a warning about the possiblity that
> > tuple will be uninitialized. The original code looks perfectly legal and proper,
> > so why would gcc 3.x fail?
> 
> Because the original code is not legal in any C compiler and should not be
> accepted by any compiler, not only GCC 3.x (I am using RH GCC 2.96).  The
> problem is the IP_CT_TUPLE_BLANK which is an incorrectly constructed
> macro.

Then how should it be constructed? It almost sounds like you would need to write
an actual function, and code it and getorigdst() something like this (I'm sure this
is horribly wrong):

static void ip_ct_tuple_blank(struct ip_conntrack_tuple *tuple)
{
         tuple->src.u.all = 0;
         tuple->dst.u.all = 0;
}

static int getorigdst(...)
{
....
         struct ip_conntrack_tuple *tuple;

         tuple = kmalloc(sizeof(ip_conntrack_tuple), GFP_ATOMIC);
         if (!tuple) return -ENOMEM;
         ip_ct_tuple_blank(tuple);
....
         kfree(tuple);
....
}

Would this work, or would it be horribly worse? Where can I get an app which uses
SO_ORIGINAL_DST to test this out?

> 
> Regards
> Henrik
> 

Brad


=====
Brad Chapman

Permanent e-mail: kakadu_croc@yahoo.com

__________________________________
Do you Yahoo!?
Yahoo! SiteBuilder - Free, easy-to-use web site design software
http://sitebuilder.yahoo.com
