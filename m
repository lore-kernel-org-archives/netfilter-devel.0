From: Christian Theil <christiantheilhave@gmail.com>
Subject: Re: HElp with script execution!!
Date: Wed, 27 Jul 2005 12:05:06 +0000
Message-ID: <33d4ee9405072705052bba8705@mail.gmail.com>
References: <9927912d05072704113d7e8707@mail.gmail.com>
Reply-To: Christian Theil <christiantheilhave@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <9927912d05072704113d7e8707@mail.gmail.com>
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

You can definitely do this with the QUEUE target. You're going to need
(to write) a userspace application that retrieves the packets using
libipq. See "man libipq" for an example on how to do this.

Regards,
Christian Theil Have.

On 7/27/05, Visham Ramsurrun <vishamr2000@gmail.com> wrote:
> Hi to all,
>=20
> I wanted to ask if it is possible to get a signal (i don't know from
> where, maybe a function in the kernel or from the NIC) just before
> every packet is sent out the NIC. The signal then causes a script to
> execute. I basically want to execute a script on a per-packet basis.
> But I don't know how to go about it. I thought about the QUEUE target
> but i'm not sure. What things I should be looking at?
>=20
> Thx in advance..
>=20
> Warm regards,
> Visham
>=20
>
