From: "David Vogt" <beunlovable@gmail.com>
Subject: Re: libipq does not shorten package
Date: Fri, 10 Mar 2006 07:28:59 +0100
Message-ID: <859616420603092228r23e174dam@mail.gmail.com>
References: <859616420603090530p24d0cb9cg@mail.gmail.com>
	<44104FF7.1030104@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <44104FF7.1030104@trash.net>
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

2006/3/9, Patrick McHardy <kaber@trash.net>:
> David Vogt wrote:
> > I am using iptables and queue packets to user space. Packets are
> > either augmented (with a signature) or shortened (removal of
> > signature). The augmentation works.
> >  However, when removing the signature, the resulting packet contains
> > the correct data, but its overall size is equal to the original
> > (signed) packet. (i.e. original packet size: 83, signed packet size:
> > 163)
>
> Thomas Graf posted a patch that should fix this a couple of days
> ago, check the list archives.
>

I haven't seen that patch, altough I have been reading netfilter-devel
for quiete some time now. Sorry for the inconvenience.

D.
