From: Emmanuel Kasper <kdev@no-log.org>
Subject: Re: U60: no iptables
Date: Sat, 08 Oct 2005 14:41:54 +0200
Message-ID: <4347BE92.7000103@no-log.org>
References: <4347A731.7010509@frankengul.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org,
	debian-sparc@lists.debian.org
Return-path: <bounce-debian-sparc=debian-sparc=m.gmane.org@lists.debian.org>
To: =?ISO-8859-1?Q?S=E9bastien_Bernard?= <seb@frankengul.org>
In-Reply-To: <4347A731.7010509@frankengul.org>
Resent-Message-ID: <t1TayD.A.ZoF.J87RDB@murphy>
List-Post: <mailto:debian-sparc@lists.debian.org>
List-Help: <mailto:debian-sparc-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-sparc-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-sparc-request@lists.debian.org?subject=unsubscribe>
List-Id: netfilter-devel.vger.kernel.org

 >How can I get the copy of the trace without handwriting ?

You can use a serial console for that, with another machine connected to=20
the serial port of your u60, with minicom/hyperterminal/tip
Sun machines handle that quite well.
See http://www.obsolyte.com/sunFAQ/serial/ ( amongst others )
Manu


S=E9bastien Bernard a =E9crit :

> Hi there.
>
> Being the owner of a two-way U60, I've been happy with it until 2.6.11.=
6.
>
> The machine is a 2x300Mhz Uii with 1536Mb of memory and 2 scsi=20
> internal disk.
>
> Since 2.6.12, I'm unfortunately unable to use it as gateway box, since=20
> the installation of iptables
> cause a OOPS in the ipt_mangle.
>
> I'm unable to send you the trace now because once it happened, it is=20
> not written on the files, only on the console.
>
> This oops happens from the 2.6.12.x to the 2.6.13.x - not tried the=20
> 2.6.14-rc.
> It is related to the iptables subsystem.
> It also happen with the official debian kernel (2.6.12-1-smp).
>
> I'll try this week-end to setup early 2.6.12-rcx to check when the=20
> problem occured.
>
> I will post the oops as soon as I write it down.
> How can I get the copy of the trace without handwriting ?
> What is the information relevant in the oops ?  (register + stack=20
> trace ?)
>
>    Seb
>
>


--=20
To UNSUBSCRIBE, email to debian-sparc-REQUEST@lists.debian.org
with a subject of "unsubscribe". Trouble? Contact listmaster@lists.debian=
.org
