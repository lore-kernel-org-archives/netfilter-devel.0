From: Silimite <silimite@gmail.com>
Subject: Re: Handling large amounts of data (SIDE QUESTION)
Date: Mon, 16 May 2005 11:49:34 -0400
Message-ID: <5ad977d105051608496896aa0a@mail.gmail.com>
References: <OF9338F2A4.2824107C-ON86257003.0051EBEE-86257003.00546CEB@ra.rockwell.com>
Reply-To: Silimite <silimite@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Steven J Scott <sjscott@ra.rockwell.com>
In-Reply-To: <OF9338F2A4.2824107C-ON86257003.0051EBEE-86257003.00546CEB@ra.rockwell.com>
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

As far as I know iprange does what you are talking about for single
ranges.  So if you set a range like:

iptables -A INPUT -m iprange --src-range 192.0.0.0-192.255.255.255 -j DROP

It just does a less-than/greater-than to check IP's against the range.

My multirange module is similar except it takes it to the next level.=20
Since it needs to match against many thousands of ranges it has a
sorted table of all the ranges and then uses a binary search to find
matches within the ranges.

s


On 5/16/05, Steven J Scott <sjscott@ra.rockwell.com> wrote:
> When developing filters where rules can have IP ranges what is the most
> efficient way of handling this?  Do you have a single rule that your user
> space program breaks down to multiple rules in your kernel module?
>=20
> END USER PROGRAM: IP: 192.90.22.33->192.90.22.40, PORT: 90, BLOCK
>=20
> KERNEL MODULE TABLE:
>=20
> 192.90.22.33 BLOCK 90
> 192.90.22.34 BLOCK 90
> ....
> ....
> 192.90.22.40 BLOCK 90
>=20
> Then the kernel module just steps through each of the tables entries
> looking for a match.
>=20
> Or is there a more effiect way of taging a rule as a range and then have =
a
> function do some type of greater then or less operation?
>=20
> e.g.  compare the range of addresses in their native 32bit order to the
> packet that was captured?
>=20
> So if I have the range above I could use the following operation to do a
> very effient check:
>=20
> __u32 32bitLowIPRang =3D hton(192.90.22.33);
> --u32 32bitHighIPRange =3D hton(192.90.22.40);
>=20
> if ( captured_packets_ip_address >=3D 32bitLowIPRange &&
> captured_packets_ip_address <=3D 32bitHighIPRange)
>         printf("match!");
>=20
> Now I know with masks it gets tricky, but I am wondering how people handl=
e
> this specfic requiment.
>
