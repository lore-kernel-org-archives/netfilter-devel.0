From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: libipq question
Date: Sat, 26 Jun 2004 01:56:30 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406260132170.8200-100000@filer.marasystems.com>
References: <A516FD6F11040F4E881C92EDA23F31A802ACF8AE@mx1.bsafeonline.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: spanishmack@mchsi.com
In-Reply-To: <A516FD6F11040F4E881C92EDA23F31A802ACF8AE@mx1.bsafeonline.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 25 Jun 2004, Steve Ashley wrote:

> Error in recv().
> Broken pipe.

Odd.. you should not receive a broken pipe error on the netlink socket
only because your application is running for a long time.. 

The "Error in recv()" seems to be a message from your application? If so 
what is the result in errno at that time? This message does not exists in 
libipq.

I suspect the "Broken pipe." is a sideeffect of the first recv() error 
and the actions taken there, not the cause to your error.

> Then the application exits.

Here is three possible causes, sortet in level of probability

a) The SIGPIPE is not handled. Default signal action for SIGPIPE is to 
immediately terminate the application. If set to SIG_IGN then EPIPE is 
returned by the failing operations instead.

b) The error code dealing with netlink/libipq errors is broken causing 
your application to exit.

c) Your application does willingly exit when encountering netlink/libipq 
errors.

> Also, just for information sake.  At some point, if I add more features
> into my application, I fear using a userspace application may not be
> sufficient.  Where can I find a good example of a new netfilter target
> kernel module code?

There is some documentation in the hacking guide, but the architecture is
fairly simple and my opinion is that it is best studied by reading one of
the simpler existing targets or matches depending on what it is you want
to do. It is not that different from normal programming, except that there
is no mercy on errors.. (kernel panic, not just a segmentation fault or
odd application result).  The use of user-mode-linux greatly helps in
leveling out out the differences in kernel and application programming.

A good understanding of the skbuff also helps understaing how to properly 
access the packet details within the kernel, but if unsure a lot can be 
learned by looking at the existing modules.

If unsure on anything ask here on the mailinglist.

Regards
Henrik
