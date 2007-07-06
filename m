From: "Nick Landry" <nick.landry@gmail.com>
Subject: Re: ipq_get_packet receives proper TCP and IP headers but the rest
	of payload is junk
Date: Fri, 6 Jul 2007 13:48:01 -0400
Message-ID: <9010780e0707061048j4852c83egbbad8ee64f5d688e@mail.gmail.com>
References: <9010780e0707060538r3c754988ibebe5fa7d0c11ff2@mail.gmail.com>
	<9010780e0707060539y7623fbfgf2bd899a8b2f8162@mail.gmail.com>
	<468E3D00.9070604@post.rwth-aachen.de>
	<9010780e0707060712u586b0c77i31882b43c2028d2e@mail.gmail.com>
	<468E5481.3040203@trash.net>
	<9010780e0707060838y5da5004bj37c9928c7d3cdf83@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Christian Gorecki <christian.gorecki@post.rwth-aachen.de>,
	netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <9010780e0707060838y5da5004bj37c9928c7d3cdf83@mail.gmail.com>
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

I had also forgot to mention that when running tethereal, the packet
contents looked fine.  Not sure what the differences are between how
tethereal captures packets and how ip_queue reads packets.




Nick

On 7/6/07, Nick Landry <nick.landry@gmail.com> wrote:
> Checked TSO, and it turns out it is disabled at startup.  I'm really
> stumped on this one.
>
>
>
> Nick
>
> On 7/6/07, Patrick McHardy <kaber@trash.net> wrote:
> > Nick Landry wrote:
> > > Thanks, I checked that but the issue is that I am sending the exact
> > > same GET request (Accept-Encoding is the same as well) for when the
> > > message passes through any of the machines.  The read from ip_queue
> > > for one machine is headers + ascii which is what I'd expect.  The
> > > other machine outputs headers + junk.
> > >
> > > Here's a hex dump for the machine that isn't working (payload length
> > > is 1500 bytes but I'll only print a small part):
> > >
> > > -->  45 00 05 78 02 37 40 00 42 06 18 5b 0a b3 00 0c
> > > -->  0a 2b 04 05 c5 3a 00 50 26 a2 08 34 a8 d5 7c f7
> > > -->  80 10 4f b0 de f3 00 00 08 0a e4 eb 14 02 d5 6e
> > > -->  e4 1c 00 00 08 00 01 00 06 00 0f f7 b5 9b 00 00
> > > -->  00 00 00 00 00 00 00 00 30 00 00 00 00 00 00 00
> > > -->  45 00 00 30 bf 76 40 00 7c 06 d4 35 0a b1 2c 0f
> > > -->  0a b3 29 a9 13 4b 01 bd 29 7a 9e 75 00 00 00 00
> > > -->  70 02 40 00 fb 0b 00 00 02 04 05 b4 01 01 04 02
> > > -->  01 01 04 02 00 15 17 29 49 62 08 00 45 08 00 34
> > > -->  64 1b 40 00 40 06 be 0d 0a 2a 02 21 0a 2a 02 1f
> > > -->  80 03 bb 06 8c bc 41 58 79 bb 93 af 80 10 80 00
> > > -->  62 96 00 00 01 01 08 0a 00 2d 7d cc 19 d0 cd 3f
> > > -->  b1 18 40 00 7e 00 40 00 00 00 00 00 82 00 16 00
> > > -->  38 18 04 00 7e 00 40 00 00 00 08 00 00 00 00 00
> > > -->  01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > -->  00 00 00 00 00 00 00 00 b1 18 40 00 54 00 40 00
> > > -->  01 00 01 00 80 00 01 00 01 00 01 00 01 00 14 00
> > > -->  3b 03 05 00 7e 00 40 00 00 00 00 00 00 00 00 00
> > > -->  82 00 16 00 3e 00 07 00 b1 18 40 00 73 00 40 00
> > > -->  7e 00 40 00 00 00 00 00 00 00 00 00 82 00 16 00
> > > [....]
> > >
> > > And it just goes on like that.  The NULLs are what leads me to believe
> > > that I'm getting back data that the kernel copied from the wrong part
> > > of memory (that and the output is different every time I run it, even
> > > though it's the same GET message).
> >
> >
> > Possibly related to ip_queue TSO handling bugs in old kernels. Are
> > you using TSO?
> >
>
