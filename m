From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Add a rule to PREROUTING table
Date: Mon, 22 Dec 2008 22:59:22 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812222258510.25979@fbirervta.pbzchgretzou.qr>
References: <8a38e1330812221344l51472479s2ff1e57b4bee08b7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jianqing Zhang <arrow.jianqing@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <8a38e1330812221344l51472479s2ff1e57b4bee08b7@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Monday 2008-12-22 22:44, Jianqing Zhang wrote:

>I add a rule to the chain of PREROUTING for the nat table as follows:
>
> iptables -t nat -I PREROUTING -p udp --dport 4309 -j NFQUEUE --queue-=
num 0
>
>However, when I run "iptables -L ", I can see nothing under PREROUTING=
 chain

>Do miss something?

The manpage.

filter:
      This  is  the default table (if no =E2=80=90t option is passed). =
 It
      contains the built=E2=80=90in chains INPUT (for packets destined =
 to
      local  sockets),  FORWARD  (for packets being routed through
      the box), and OUTPUT (for locally=E2=80=90generated packets).



