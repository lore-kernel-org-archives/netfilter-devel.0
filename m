From: <amir73il@gmail.com>
Subject: Re: ongoing textsearch/string match - 3 patches
Date: Thu, 26 Jan 2006 13:51:57 +0200
Message-ID: <18730dc50601260351s7dab9451x420f3eb88bc90162@mail.gmail.com>
References: <18730dc50512220611nfea98e2l88da4f25c97f341d@mail.gmail.com>
	<43AB2739.6080608@eurodev.net>
	<18730dc50512250828i2f214c8di49c348f03c84593f@mail.gmail.com>
	<43AF689F.2070106@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
In-Reply-To: <43AF689F.2070106@eurodev.net>
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

On 12/26/05, Pablo Neira Ayuso <pablo@eurodev.net> wrote:
> Amir Goldstein wrote:
> > On 12/23/05, Pablo Neira Ayuso <pablo@eurodev.net> wrote:
> >
> >>>test:
> >>>------
> >>>I have tested ongoing string match using netcat UDP connection
> >>>and it successfully matched the string:
> >>>s
> >>>tr
> >>>ing
> >>
> >>So, in this example, my understanding is that you want to find matching=
s
> >> splitted in several packets.
> >>
> >>>which was sent in different 3 packets.
> >>>the netcat test required using --from 28 to skip the udp header and
> >>>some test code to ignore the new line characters.
> >>
> >>I'm curious: We implement matching through fragments with KMP (not for
> >>BM yet). So, what kind of application would require such pattern
> >>matching policy?
> >>
> >
> > it's the basics for content filtering in netfilter.
> > of course, more work needs to be done:
> > - connect this code with connection tracking
> > - handle out of order tcp packets
>
> OK. But I'm still in doubt about the usefulness of matching a pattern
> between packets. What kind of application splits a request, represented
> in the form of a pattern, between packets? Going back to your example:
>
> 1st packet) s
> 2nd packet) tr
> 3rd packet) ing
>
> Could you comment any realistic scenario?
>

Hi Pablo,

the usefulness of matching a pattern between packets is for network virus s=
can.
it took me some time to finalize my kclamav module, but here it is:
http://sourceforge.net/projects/kclamav/

I patched the string match netfilter because it was the closest filter
to what I needed, but as I said, there is still work to be done to
make this a useful virus scan filter.
perhaps a more generic "content filter" is more appropriate here.

I hope you will find this contribution useful and help me get my
patches into the kernel.

Amir.
