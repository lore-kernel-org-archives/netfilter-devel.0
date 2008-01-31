From: Jozsef Kadlecsik <kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org>
Subject: Re: cups slow on linux-2.6.24
Date: Thu, 31 Jan 2008 11:40:04 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801311136540.23769@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0801290635001.23096@boston.corp.fedex.com>
	<Pine.LNX.4.64.0801290855360.19273@blackhole.kfki.hu>
	<b6a2187b0801291924k15f883aeg54f704156e4f2e3e@mail.gmail.com>
	<47A07FEA.3000702@trash.net>
	<b6a2187b0801301823m331957e9n9d9bb9613622c844@mail.gmail.com>
	<b6a2187b0801301826l5a50ce84p7d5dce3d0a74b3c0@mail.gmail.com>
	<47A13573.7090804@trash.net>
	<b6a2187b0801301921s4a7842cg6cfec09a393cd63@mail.gmail.com>
	<47A13FBD.8050803@trash.net>
	<b6a2187b0801302101l46d614c9y53f798a025b57dc3@mail.gmail.com>
Reply-To: "Mirror of cups.bugs Newsgroup" <cups-bugs-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Krzysztof Piotr Oledzki <ole-gcSpNFQc7Gg@public.gmane.org>,
	Patrick McHardy <kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org>,
	Netfilter Development Mailinglist <netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, cups-bugs <cups-bugs-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
To: Jeff Chua <jeff.chua.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <cups-bugs-bounces-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <b6a2187b0801302101l46d614c9y53f798a025b57dc3-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <http://lists.easysw.com/mailman/listinfo/cups-bugs>,
	<mailto:cups-bugs-request-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org?subject=unsubscribe>
List-Post: <mailto:cups-bugs-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
List-Help: <mailto:cups-bugs-request-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org?subject=help>
List-Subscribe: <http://lists.easysw.com/mailman/listinfo/cups-bugs>,
	<mailto:cups-bugs-request-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org?subject=subscribe>
Sender: cups-bugs-bounces-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org
Errors-To: cups-bugs-bounces-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

Hi Jeff,

On Thu, 31 Jan 2008, Jeff Chua wrote:

> On the bad run, I got the following message ...
> 
> boston kernel: nf_ct_tcp: invalid packed ignored IN= OUT=
> SRC=127.0.0.1 DST=127.0.0.1 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=8162
> DF PROTO=TCP SPT=1016 DPT=515 SEQ=3834958843 ACK=0 WINDOW=32792
> RES=0x00 SYN URGP=0 OPT (0204400C0402080A0000CC190000000001030307)
> UID=0 GID=65534

I can't find this packet in the last lo.bad pcap file. Could you dump the 
bad traffic and send it together with the generated log record?

Strange, but there are a lot of incorrect checksum packets. How does it 
come on the loopback interface?

Best regards,
Jozsef
-
E-mail  : kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org, kadlec-tC8PEuNsDRr1hxmkv4H60w@public.gmane.org
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
