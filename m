From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: QUEUE target and IPT_CONTINUE verdict ?
Date: Sun, 15 May 2005 13:05:34 -0400
Message-ID: <876ef97a05051510053c6827c2@mail.gmail.com>
References: <200505131729.39430.laurent.guyon@adelux.fr>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: nf-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Laurent Guyon <laurent.guyon@adelux.fr>
In-Reply-To: <200505131729.39430.laurent.guyon@adelux.fr>
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

On 5/13/05, Laurent Guyon <laurent.guyon@adelux.fr> wrote:
> Just wondering why we can't return an IPT_CONTINUE verdict at the end of =
the
> QUEUE target.
>=20
> I understand that the QUEUE target registers on a Netfilter queue_handler
> (that is a special kind of hook), and then it must call nf_reinject in th=
e
> end.
>=20
> I understand too that the nf_reinject function accepts only NF_ACCEPT,
> NF_DROP ... verdicts, but why ? Is it technically impossible to give
> nf_reinject an IPT_CONTINUE verdict and implement the relevant code to
> let packets continue their path in the rules ? or anyone hadn't ever thou=
ght
> about such a feature ?

I believe the reason for this is that, to do this, the kernel would
have to remember where it was in the processing of the rules and thus
save some state with every packet sent to userspace to be used in the
case where the ip_queue handler returned IPT_CONTINUE.

I don't believe that such state is hard to add, it would just waste
space. Feel free to code up a patch and submit it.

--=20
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
