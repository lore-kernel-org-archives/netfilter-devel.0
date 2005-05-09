From: Vinay Reddy <vinayvinay@gmail.com>
Subject: Re: Urgent SNAT help required
Date: Mon, 9 May 2005 18:32:16 +0530
Message-ID: <537f59d105050906025948aa0c@mail.gmail.com>
References: <20050509083018.20467.qmail@web41413.mail.yahoo.com>
Reply-To: Vinay Reddy <vinayvinay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: cranium2003 <cranium2003@yahoo.com>, netfilter-devel@lists.netfilter.org
In-Reply-To: <20050509083018.20467.qmail@web41413.mail.yahoo.com>
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

On 5/9/05, cranium2003 <cranium2003@yahoo.com> wrote:
> hello,
>          I want to execute my code at
> NF_IP_POST_ROUTING. For that First i want to know
> which functions are executing at NF_IP_POST_ROUTING
> Hook. Then i have enabled SNAT and I have wrriten code
> at NF_IP_POST_ROUTING but i want to get outgoing
> packets' IP address as new one SNAT'ed IP address not
> the one that is before SNAT? How can i do that?
Execute your code after SNAT has finished.
>          I observe that my code and SNAT are executing
> at same HOOK NF_IP_POST_ROUTING. But my code is
> executed first and then SANT is doen but how to
> reverse that?
Use the following while declaring an nf_hook_ops struct:
struct nf_hook_ops post_route =3D {
  {NULL, NULL},
  post_route_handler,
  THIS_MODULE,
  PF_INET,
  NF_IP_POST_ROUTING,
  NF_IP_PRI_NAT_SRC +1,  // <--- This is important. It is the priority.
};

Note that the last field gives the priority for this handler. The
higher it is, the earlier it is executed.

HTH,
Vinay

> regards,
> cranium
>=20
> Yahoo! Mail
> Stay connected, organized, and protected. Take the tour:
> http://tour.mail.yahoo.com/mailtour.html
>=20
>=20


--=20
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
