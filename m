From: Moises Silva <moises.silva@gmail.com>
Subject: Patch for H323 connection tracking for kernel 2.6.14 and Panic with
	SIP tracking
Date: Sat, 31 Dec 2005 16:47:16 -0600
Message-ID: <c4d05cbe0512311447v33a9cb13w4e6201c5d6ccbd00@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

I was patching my 2.6.14 kernel for SIP and H323 connection tracking
support, and got some errors of patch-o-matic h323 patches (i guess is
normal since the version supported is 2.6.12 ), i would like some one
with enough experience check the patch i made and tell me if it ok,
since is compiling just fine, and it makes sense to me, but i could be
wrong.

Patch to be applied in the kernel directory directly, something like
patch -p1 < blah...

http://galileo.ivsol.net/h323-conntrack-nat-kernel-2.6.14.patch

and a patch for patch-o-matic sources

http://galileo.ivsol.net/patch-o-matic-ng-20051230-h323.patch


Additionally im having kernel panics with SIP conntrack extension. I
have it as kernel module (ko). I still does not copy the core dump,
but says something about "interrupt error, not syncing" or something
like that. I will try to compile it inside the kernel to see if it
still panics ( please some one could tell me if this makes any
relevant difference?? )


Thanks in advance

- Moises Silva < moy at ivsol dot net >
--
"Su nombre es GNU/Linux, no solamente Linux, mas info en http://www.gnu.org=
"
