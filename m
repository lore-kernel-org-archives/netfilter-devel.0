From: JC <bikkit@gmail.com>
Subject: Re: netfilter hook function error...
Date: Wed, 21 Sep 2005 07:09:38 +0100
Message-ID: <a60102c30509202309628deea@mail.gmail.com>
References: <a60102c3050920171352ae872c@mail.gmail.com>
	<20050921055121.GA25193@oknodo.bof.de>
Reply-To: JC <bikkit@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20050921055121.GA25193@oknodo.bof.de>
Content-Disposition: inline
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

Dear Patrick,

thank you kindly for the "Introduction to C" session. Your pointers
were of most use. However, I must note that failing to know the
purpose of print_string() calls in my code, in both occasions that
they appear in the code I posted, you failed slightly to understand
the severity of the warnings that the compiler "screamed in terror"
about. In both points, they are merely there for logging to the
current tty, as an alternative to printk. As a concequence of that,
they are being commented in and out of the running code, as debugging
requires at that particular moment.

The last point, and of interest to me at that moment, was solved by
Wei and this code seems to work:

my_ipheader =3D (struct iphdr *)((*skb)->nh.iph);

as I was quick to post back in the thread, for the reference of others.

Please feel free to correct my code in the other thread, with subject
"How to change the source address of a tcp packet", with the same
enthusiasm. I would be, again, most thankful.

kind regards,
JC

- Hide quoted text -

> > /home/jc/code/spider/spider.c:126: warning: ISO C90 forbids mixed
> > declarations and code
> >   print_string("Packet reached IN_HOOK.");
> >   struct iphdr *my_ipheader;
>
> In traditional C, a variable declaration (like your my_ipheader)
> MUST COME BEFORE ANY OTHER CODE IN A FUNCTION (like your print_string
> call)
>
> > /home/jc/code/spider/spider.c:134: warning: passing argument 1 of
> > 'print_string' discards qualifiers from pointer target type
> >         print_string(out->name);
>
> Not that I really know, because you have not shown your print_string()
> function prototype, but I bet that you made its first argument be
> a 'const char *', and out->name is a 'char *' without the 'const'.
>
> > /home/jc/code/spider/spider.c:150: error: request for member 'nh' in
> > something not a structure or union
> >             my_ipheader =3D skb->nh->iph;
>
> The compiler complains that the skb thing is not pointer to a structure.
> Which is correct. It is a pointer to a pointer to a structure. So you
> need to dereference it once, like '(*skb)->nh->iph'. However, I'm
> not sure that nh->iph is valid in all cases. Look at other hook
> functions which need the IP header.
>
> best regards
>  Patrick
>
