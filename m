From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] TCP window tracking patch backported from the 2.6 tree
Date: Wed, 6 Jul 2005 13:40:09 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0507061332170.3713@blackhole.kfki.hu>
References: <Pine.LNX.4.58.0506281201590.12765@blackhole.kfki.hu>
	<42C17443.60909@drugphish.ch>
	<Pine.LNX.4.58.0506290926400.14936@blackhole.kfki.hu>
	<42C26765.2060304@tac.ch>
	<Pine.LNX.4.58.0506291223440.14974@blackhole.kfki.hu>
	<20050629145545.GO26761@insomnia.benzedrine.cx>
	<Pine.LNX.4.58.0506300903350.16566@blackhole.kfki.hu>
	<20050630111344.GP26761@insomnia.benzedrine.cx>
	<Pine.LNX.4.58.0507011150500.19392@blackhole.kfki.hu>
	<20050706111546.GI6024@insomnia.benzedrine.cx>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, 'Krisztian Kovacs' <hidden@sch.bme.hu>,
	Roberto Nibali <ratz@tac.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Daniel Hartmeier <daniel@benzedrine.cx>
In-Reply-To: <20050706111546.GI6024@insomnia.benzedrine.cx>
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

Hi,

On Wed, 6 Jul 2005, Daniel Hartmeier wrote:

> On Fri, Jul 01, 2005 at 01:58:45PM +0200, Jozsef Kadlecsik wrote:
>
> > Attached is the anonymized txt version of a traffic dump. If the last
> > packet is blocked by the firewall, the session hangs on the client side.
> > By using the rightmost edge of the SACK blocks as ACK in calculating the
> > acceptable window, the connection finishes all right. (There were multiple
> > independent reports - this was unique being easily reproducible anytime.)
> >
> > But it's as interesting for me as SACK handling that you use the original
> > conditions from Guido's article. However I strongly believe the boundaries
> > for valid data stated there are not RFC compliant: data is not required to
> > fit into the window, it must just overlap. Receiver even may hold segments
> > with higher sequence numbers for later processing. What's your opinion?
[...]
> I don't know why both client and server seem to think that selectively
> acknowledged sections should not be counted as occupying the advertised
> window. This is clearly wrong. A recipient stack that allocates a
> specific number of bytes for one socket's receive buffer cannot pass
> selectively acknowledged sections to userland (when, like in this case,
> there's a hole). Hence, the selectively acknowledged sections do use up
> kernel buffer memory. Maybe if an implementation uses separate buffers
> for SACK sections and tcp receive buffers, it will allow this on
> reception.
>
> But it's a violation of the TCP RFC, and any sender doing this can't
> expect the receiver to not drop the segments past the window. In fact, a
> receipient might have a problem with such violations, and we expect the
> packet filter to protect it from exploitation.

I agree that it seems to be a violation of the TCP RFC. As I wrote, what
was really strange is that if the oow packet was blocked, the connection
hanged.

> What stacks do generate (and accept) this? Do they do this on purpose?
> If so, how well do they react if they get sent malicious SACK sections,
> trying to use up as much buffer space as possible? Sounds like a DoS
> waiting to happen.

Krisztian, could you write the OS type/version on both the server and the
client?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
