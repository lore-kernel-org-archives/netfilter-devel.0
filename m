From: Thomas Mader <thezema@gmail.com>
Subject: Re: remove connections notification by conntrack?
Date: Sat, 23 Sep 2006 11:23:04 +0200
Message-ID: <200609231123.09148.thezema@gmail.com>
References: <200609221359.22676.thezema@gmail.com>
	<200609221519.52127.thezema@gmail.com>
	<4513FA76.1010304@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3442040.SZ2LmR6zPP";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <4513FA76.1010304@netfilter.org>
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

--nextPart3442040.SZ2LmR6zPP
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> Use the event API, do not forget to enable it (it's still marked as
> experimental): have a look at ctnetlink_conntrack_event inside
> ip_conntrack_netlink.c, that will help I think.
>
> Use the unsigned long parameter of your notify function above and wait
> for the event IPCT_DESTROY.

Now it looks like this:

int ipaddr_conntrack_event(struct notifier_block *this, unsigned long event=
s,=20
void *ptr) {
	struct ip_conntrack *ct =3D (struct ip_conntrack *)ptr;
=09
	if (events =3D=3D IPCT_DESTROY) {
		printk("We have been notified that connection %d was deleted!\n", ct->id);
	}
=09
	return 0;
}


static struct notifier_block ctnl_notifier =3D {=20
	.notifier_call =3D ipaddr_conntrack_event,
};=20


static int __init init(void)
{
	int ret;
	need_conntrack();
	ret =3D ip_conntrack_register_notifier(&ctnl_notifier);
	if (ret < 0) {
		printk("ipaddr_init: cannot register notifier.\n");
		goto err_unreg_notifier;
	}
	//ip_conntrack_destroyed =3D destroyed_connect;
    =20
	printk(KERN_CRIT "init!\n");
   	return ipt_register_match(&ipaddr_match);
=09
err_unreg_notifier:
		ip_conntrack_unregister_notifier(&ctnl_notifier);
		return 1;
}

But the problem remains the same. It works for TCP and I get properly notif=
ied=20
about those but not about UDP.


> BTW, some tips about the code that I hope that you can find useful:
>
> Don't nest the code like that, it is hard to read and really ugly, I
> always tell that to my students: invert the logic, check for errors not
> for sucess, I don't blame I used to do that time ago.
>
> Don't forget that a foo_get(...) operation usually requires a
> foo_put(...) afterwards.

Thanks for your comments we are hacking kernel stuff for the first time.


> There is no floating point in kernel (double) because of portability issu=
es

We need to save the arriving time of the packets and we need a bit of=20
precision.
It would work also when we would save sec and usec separately but this woul=
d=20
make everything more complicated and for now we are just trying things out.

> And, out of curiosity, what do you want to do? Can't you do it with
> ctnetlink and in userspace?

We thought about that when we started but than it happend that we started=20
implementing  as kernel space only. ;)
Our main focus was performance but maybe we need to go into userspace fully=
=20
because we need to save a lot of data.

We try to write a module which detects bursts and if a burst was detected a=
=20
package will be injected at the end of the burst.
We will make a kernel space module first which saves just one time stamp an=
d=20
id per connection. (The list I posted earlier makes somthing different but =
I=20
get the idea mentioned right now some time later)
Then we implement a second algorithm for detecting bursts which is much mor=
e=20
complicated than that and relies on a special container structer which coul=
d=20
be implemented with lists afair.
The thing is that we will need much memory for this and therefore should be=
=20
placed in userspace maybe.

Is there a general rule when to write something for user/kernel space?

--nextPart3442040.SZ2LmR6zPP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iQIVAwUARRT8/BjLzKnHCDEhAQKAAA/9Gmui9bVxtgBXpFj6CwHnEdiPHyppGVFm
5TkvucuYBRprcxkPeEneTDv3W8FPqw1Qtd2NwsF6hQaB4Wjfhby6RPxS1aHKhmy7
JT1g5x/LPhwJf9cy5RJURpRzijEkByBDH/XtLXMtDwX9+FtpiG8gLZvTo+fHH0Pr
KF8IUG46zNIJtEBePMKsp14TV3NzlNg1Wn6S7kHLXqD7xVLV6cpfdTcaPNMGKfXq
fF8DCZ3x2mNuKjMhMBm7VB1XFD0MnnwGRkuxlMBzOd6GklCn6R1U+cnb95tnLJjK
AXwZ4X6OkneuunVp8353+Y7vvgydHk+WbNOy9Ih79RDVcMvICWaXsUUGGyz5mMJE
ZmqaR1LLwgk7CDJFy5WQ95OImEyg035JPlGGc/AGexflzZKzt61LBEaab9ifZkUO
k+5KddiU5OpeAV1GLCuAluJblRi8INa5f8C8mSoi9ggiCvb+6laPpzBEadfLCdzl
Y0c2EpssJqymkN/UKIoraCyR3+9LCAT5JWim0tK5oD1M2fPSu4EBGbQk0qZ8l28N
lWZ9qcC4dCOR+jAGHuRl0J1uh3GonKfFfw9tNlP0uS1DTn/TTrkZKaYCvs48v8EX
+VrRaGvi141tC85GGEeZMsamufi/Ips5VnDGDsI8EU5oKIEXp8g17eZkJBO1blmv
iMB1CIoj+Pg=
=b2al
-----END PGP SIGNATURE-----

--nextPart3442040.SZ2LmR6zPP--
