From: =?ISO-8859-2?Q?Tom=E1=B9_Macek?= <maca02@atlas.cz>
Subject: Re: cannot kmalloc nor vmalloc
Date: Tue, 1 Feb 2005 15:36:25 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0502011532300.24642@maca.fortech.cz>
References: <Pine.LNX.4.61.0501171957130.8115@maca.fortech.cz>
	<20050201125939.GE6878@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-86691136-310292061-1107268585=:24642"
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050201125939.GE6878@sunbeam.de.gnumonks.org>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---86691136-310292061-1107268585=:24642
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by maca.fortech.cz id
	j11EaPTn025469

Thank you for your answer.
I've really read the kernel hacking guide, looked into the kernel netfilt=
er sources, but without an idea how to do it.
The only way how to do it, is to allocate big amount of memory outside of=
 the interrupt by means of vmalloc() and then manage it with pointers.
Nowadays I think there is no other way to do it.

Thank you


On Tue, 1 Feb 2005, Harald Welte wrote:

> On Mon, Jan 17, 2005 at 08:00:55PM +0100, Tom=E1? Macek wrote:
>> Hi, I'm just developing a new "match" (like ipt_limit for example) ipt=
ables module under RH FC 2, kernel 2.6.5-1.328.
>> If I make a request for about 100 kB of memory in the registered match
>> function in my module by means of kmalloc(size, GPF_ATOMIC) and set it
>> via memset() to zero, the computer freezes with kernel panic and
>> debugging output. Maybe it has not enaugh memory. I tried something
>> more and never got more than about 40 kB.
>
> please try to read up some general kernel hacking guide.
>
> GFP_ATOMIC is for in-interrupt allocations, and you shouldn't ever need
> to allocate very large pieces of memory from within an interrupt anyway.
>
>> I also tried to get large chunk of memory outside the match function,
>> just before I register the match - in the __init() of my module, and I
>> was able to get more than 100 MB via vmalloc().
>
> yes, because it's not called form interrupt
>
>> How can I get bigger chunk of memory in the interrupt? I will need
>> more (about 5-10) chunks of 100 kB memory.
>
> no way.
>
>> Tomas
>
>
---86691136-310292061-1107268585=:24642--
