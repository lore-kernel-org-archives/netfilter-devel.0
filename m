From: "Archills Zhao" <archills_81@yahoo.com.cn>
Subject: Re: To send a  skb  cloned in netfilter HOOK out
Date: Wed, 9 Mar 2005 18:14:50 +0800
Message-ID: <001e01c52490$e1157ea0$02010101@archills>
References: <002a01c51ae2$de33b970$18a8a8c0@archills>
	<20050225094855.GA8697@earth.dsh.org.uk>
	<001d01c5246b$63b3b730$02010101@archills>
	<20050309094729.GA25404@earth.dsh.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: "Ian Norton" <bredroll@darkspace.org.uk>
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

Hi,
I do used skb_copy();
Anyway,Thanks!

Brgds,
Archills

  ----- Original Message -----=20
  From: Ian Norton=20
  To: Archills Zhao=20
  Cc: netfilter-devel@lists.netfilter.org=20
  Sent: Wednesday, March 09, 2005 5:47 PM
  Subject: Re: To send a skb cloned in netfilter HOOK out


  Hi,

  You can't send a 'cloned' skb, you need to send a copy to each =
destination,

  ie,=20

  new_skb =3D skb_copy(old, GFP_ATOMIC);

  A clone will share the same data with the original but different =
values in
  head.

  A copy will have a copy of the data and relavant head pointers.

  to send the copy out of another interface you need to also tell =
netfilter that
  it is not the same packet that went in.

  =
http://www.netfilter.org/documentation/HOWTO/netfilter-hacking-HOWTO-6.ht=
ml

  Ian
