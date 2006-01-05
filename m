From: Moises Silva <moises.silva@gmail.com>
Subject: Re: Patch for H323 connection tracking for kernel 2.6.14 and Panic
	with SIP tracking
Date: Thu, 5 Jan 2006 15:32:19 -0600
Message-ID: <c4d05cbe0601051332w1f6554dblb256513e6bc30dea@mail.gmail.com>
References: <c4d05cbe0512311447v33a9cb13w4e6201c5d6ccbd00@mail.gmail.com>
	<c4d05cbe0601021028x4dad0a18n2b3c1b8e10506f11@mail.gmail.com>
	<43BA605E.3020801@trash.net> <43BD7AF4.2040506@nk.nl>
	<c4d05cbe0601051220v54ab169cled8109df66cd12db@mail.gmail.com>
	<43BD80C6.10603@nk.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <43BD80C6.10603@nk.nl>
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

hum, i guess mine is a different problem. The thing that seems to be
causing panic is the coexistence of ppp_asyc nad ip_nat_sip (or the
consequent ip_conntrack_sip). Im preparing an explanation of the tests
i made, i will post it here in a while. Hopefully some developer will
be able to know whats the problem.

Regards

On 1/5/06, Victor Julien <victor@nk.nl> wrote:
> Moises Silva wrote:
> > Victor: Did you were getting kernel panics as well?
> >
>
> Yes, as soon as i loaded the ip_nat_sip module (which in also loaded the
> ip_conntrack_sip module) it caused a kernel panic when there was SIP
> traffic. Now it seems to work fine. I had a few conversations, no panics
> yet :-)
>
> Regards,
> Victor
>
>


--
"Su nombre es GNU/Linux, no solamente Linux, mas info en http://www.gnu.org=
"
