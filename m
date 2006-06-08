From: Simon Lodal <simonl@parknet.dk>
Subject: Re: Bridge netfilter defered hooks
Date: Thu, 8 Jun 2006 23:40:41 +0200
Message-ID: <200606082340.41755.simonl@parknet.dk>
References: <448051F3.1070509@trash.net> <4487CEA8.8060701@trash.net>
	<44888CD7.8090601@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, Martijn Lievaart <m@rtij.nl>
In-Reply-To: <44888CD7.8090601@rtij.nl>
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

On Thursday 08 June 2006 22:47, Martijn Lievaart wrote:
> Patrick McHardy wrote:
> >Carl-Daniel Hailfinger wrote:
> >>IIRC the mark has only 32 bits. Not so long ago, I was using 30 bits
> >>of that in my firewalling rules on a bridge-router. I might have
> >>squeezed the physdev match in the remaining 2 bits, but I'm not
> >>sure. I do admit the setup was fairly uncommon (bridging and
> >>double nat with only one machine).
> >
> >Yes, its getting a bit tight in there, but so far in all setups I've
> >seen it was possible to get along with the 32 bits using masks or
> >reusing bits after they are no longer needed. I guess we'll have to
> >wait and see ..
>
> Something I've been thinking about. Currently it is impossible to write
> any kind of generic tool that uses the mark and plays nice with other
> generic tools. Maybe we need some kind of API that allocates bits in the
> mark. Something like "give me two bits", that returns some handle to the
> bits. That handle could then be used for identifying the bits in the mark.
>
> As an added benefit, this encapsulates the operations on the mark,
> making it trivial to switch to say 64 bits for the mark.
>
> What do others think?
>
> M4

Sounds nice. If the handles are names it becomes a sort of runtime-defined bit 
struct. Would be nice to have across the tools, instead of doing the black 
bit magic directly (and in parallel) in each place.

Why not define the mark size at compile time, in case you need more bits?


Greetings

Simon
