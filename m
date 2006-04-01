From: "David Vogt" <beunlovable@gmail.com>
Subject: Re: Regarding LIBIPQ problem
Date: Sat, 1 Apr 2006 12:36:00 +0200
Message-ID: <859616420604010236j1048f16anbe3edaa8b6967244@mail.gmail.com>
References: <1411.10.12.25.5.1143825446.squirrel@gpo.iitb.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Vasantha Kumar Puttappa" <vasanthakumar@iitb.ac.in>
In-Reply-To: <1411.10.12.25.5.1143825446.squirrel@gpo.iitb.ac.in>
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

2006/3/31, Vasantha Kumar Puttappa <vasanthakumar@iitb.ac.in>:
> Then I am setting the verdict as accept ,shown below
>
> status =3D ipq_set_verdict(h, m->packet_id,NF_ACCEPT, new_iphdr->tot_len,
> (unsigned char *)packet);
Shouldn't this look like this (ntohs missing?):

status =3D
  ipq_set_verdict(
    h, m->packet_id,NF_ACCEPT, ntohs(new_iphdr->tot_len), (unsigned
char *)packet
  );


> Problem:
>   Even though ipq_set_verdict is being executed successfully, the new
> packets are being dropped silently without any error message.
If the value is not interpreted correctly, the length value might be
negative or too large and thus the packet gets dropped.

Was the first thing that came to my mind. Tought I give it a shot.

Regards,
David
