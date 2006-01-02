From: Moises Silva <moises.silva@gmail.com>
Subject: Re: Patch for H323 connection tracking for kernel 2.6.14 and Panic
	with SIP tracking
Date: Mon, 2 Jan 2006 12:28:36 -0600
Message-ID: <c4d05cbe0601021028x4dad0a18n2b3c1b8e10506f11@mail.gmail.com>
References: <c4d05cbe0512311447v33a9cb13w4e6201c5d6ccbd00@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <c4d05cbe0512311447v33a9cb13w4e6201c5d6ccbd00@mail.gmail.com>
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

still getting kernel panic, copy the whole thing is a time consuming
task, for now doing nothing, but i have downgraded the kernel to
2.6.13 and at least it does not kernel panics. Some one has a patch
for sip connection tracking for kernel-2.6.14??

On 12/31/05, Moises Silva <moises.silva@gmail.com> wrote:
> I was patching my 2.6.14 kernel for SIP and H323 connection tracking
> support, and got some errors of patch-o-matic h323 patches (i guess is
> normal since the version supported is 2.6.12 ), i would like some one
> with enough experience check the patch i made and tell me if it ok,
> since is compiling just fine, and it makes sense to me, but i could be
> wrong.
>
> Patch to be applied in the kernel directory directly, something like
> patch -p1 < blah...
>
> http://galileo.ivsol.net/h323-conntrack-nat-kernel-2.6.14.patch
>
> and a patch for patch-o-matic sources
>
> http://galileo.ivsol.net/patch-o-matic-ng-20051230-h323.patch
>
>
> Additionally im having kernel panics with SIP conntrack extension. I
> have it as kernel module (ko). I still does not copy the core dump,
> but says something about "interrupt error, not syncing" or something
> like that. I will try to compile it inside the kernel to see if it
> still panics ( please some one could tell me if this makes any
> relevant difference?? )
>
>
> Thanks in advance
>
> - Moises Silva < moy at ivsol dot net >
> --
> "Su nombre es GNU/Linux, no solamente Linux, mas info en http://www.gnu.o=
rg"
>


--
"Su nombre es GNU/Linux, no solamente Linux, mas info en http://www.gnu.org=
"
