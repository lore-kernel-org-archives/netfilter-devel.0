From: "Daniel Chemko" <dchemko@smgtec.com>
Subject: RE: Iptable Extension Arg question
Date: Thu, 11 Mar 2004 17:39:27 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <7C9884991ADAE0479C14F10C858BCDF5122F11@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: "John Fastabend" <jfastabe@up.edu>,
	<netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

John Fastabend wrote:
> 1) on line 92 of libipt_TOS.c where it says
> 	struct ipt_tos_target_info *tosinfo =3D
> 		(struct ipt_tos_target_info *)(*target)->data;
>=20
>    does this mean that the args from the command line are stored in
> target->data? And if so does that mean I will have to pass the args
> another way if I am trying to pass a couple ip addresses which would
> be longer then data which is an unsigned char. i think.

This means that tosinfo points to the actual ipt_tos_target_info
structure at the location (*target)->data.
In this case 'data' is a pointer to an instance of ipt_tos_target_info.
The size of the data passing to the kernel is
sizeof(ipt_tos_target_info), not sizeof(ipt_tos_target_info *).

Haven't looked at the implementation, so I can't say about the rest of
your questions.
