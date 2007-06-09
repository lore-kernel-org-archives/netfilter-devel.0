From: Simon <simon.xhz@gmail.com>
Subject: Re: libipq
Date: Sat, 9 Jun 2007 14:29:16 -0500
Message-ID: <f7de5e030706091229ob9b9a8dj717886ded9743c78@mail.gmail.com>
References: <f7de5e030706091046m2a6bbfb7m8ced3774e06b924a@mail.gmail.com>
	<1181412913.24499.3.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: "Eric Leblond" <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1181412913.24499.3.camel@localhost>
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

Hi Eric,
  thanks for the quick reply!  I was misled by "libipq" and I found
all I need to get started, already downloaded the 2 libs (main one and
_queue) and I'm trying to compile right now (well... i'm still
compiling deps though).

  I got lots of things to try now and hopefully I'll be back later
with good questions.

Thanks,
  Simon

On 6/9/07, Eric Leblond <eric@inl.fr> wrote:
> Hi,
>
> Le samedi 09 juin 2007 =E0 12:46 -0500, Simon a =E9crit :
> > Hi there,
> >   I've been working with iptables a long time but only as a newbie.
> > Now I moved up the ladder to the rank of amateur and I made myself a
> > companion program to iptables that helps manage it.
> >   One more thing i whish to do is to examine packets one after the
> > other (only certain types of packet, not all traffic) and I understand
> > I should QUEUE packets and use libipq to read those packets.
>
> You should not use the deprecated and almost dead ipq. Use
> libnetfilter_queue.
>
> >
> >   Now my question: is this a good place for any questions regarding
> > libipq ?
>
> Yes
>
> >   And if it is, can you guys tell me in advance where I can
> > find a more in-depth documentation that the simple man-page i could
> > only find?
>
> libnetfilter_queue or ip_queue lack documentation but you can look at
> some code sample like the one I wrote for NuFW :
> http://software.inl.fr/trac/trac.cgi/browser/mirror/edenwall/nufw/trunk/n=
ufw/src/nufw/packetsrv.c
>
> BR,
> --
> Eric Leblond <eric@inl.fr>
> INL
>
>
