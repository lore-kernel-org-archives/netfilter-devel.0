From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] iptables: extensions: libxt_CONNMARK: Add translation to nft
Date: Sat, 18 Jun 2016 13:34:12 +0200
Message-ID: <CAOkSjBhPqBEWYbtfTymhTq=0Z4HY-P20Omi_MbLCagrueJ3Z7Q@mail.gmail.com>
References: <1466179850-20928-1-git-send-email-rodanber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: =?UTF-8?Q?Roberto_Garc=C3=ADa?= <rodanber@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35922 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbcFRLec convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Jun 2016 07:34:32 -0400
Received: by mail-wm0-f68.google.com with SMTP id c82so445672wme.3
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jun 2016 04:34:32 -0700 (PDT)
In-Reply-To: <1466179850-20928-1-git-send-email-rodanber@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 17 June 2016 at 18:10,  <rodanber@gmail.com> wrote:
> From: Roberto Garc=C3=ADa <rodanber@gmail.com>
>
> Add translation for the CONNMARK target to nftables.
>
> The following options have no available translation:
>
>   --save-mark [--nfmask nfmask] [--ctmask ctmask]
>   --restore-mark [--nfmask nfmask] [--ctmask ctmask]
>
> Examples:
>
>   # iptables-translate -t mangle -A PREROUTING -j CONNMARK --set-mark=
 0x16
>   nft add rule ip mangle PREROUTING counter ct mark set 0x16
>
>   # iptables-translate -t mangle -A PREROUTING -j CONNMARK --set-xmar=
k 0x16/0x12
>   nft add rule ip mangle PREROUTING counter ct mark set ct mark xor 0=
x16 and
>   0xffffffed
>
>   # iptables-translate -t mangle -A PREROUTING -j CONNMARK --and-mark=
 0x16
>   nft add rule ip mangle PREROUTING counter ct mark set ct mark and 0=
x16
>
>   # iptables-translate -t mangle -A PREROUTING -j CONNMARK --or-mark =
0x16
>   nft add rule ip mangle PREROUTING counter ct mark set ct mark or 0x=
16
>
>   # iptables-translate -t mangle -A PREROUTING -j CONNMARK --save-mar=
k
>   nft add rule ip mangle PREROUTING counter ct mark set mark
>
>   # iptables-translate -t mangle -A PREROUTING -j CONNMARK --save-mar=
k \
>     --mask 0x12
>   nft add rule ip mangle PREROUTING counter ct mark set mark and 0x12
>
>   # iptables-translate -t mangle -A PREROUTING -j CONNMARK --restore-=
mark
>   nft add rule ip mangle PREROUTING counter meta mark set ct mark
>
>   # iptables-translate -t mangle -A PREROUTING -j CONNMARK --restore-=
mark \
>     --mask 0x12
>   nft add rule ip mangle PREROUTING counter meta mark set ct mark and=
 0x12
>
> Signed-off-by: Roberto Garc=C3=ADa <rodanber@gmail.com>
> ---
>  extensions/libxt_CONNMARK.c | 45 +++++++++++++++++++++++++++++++++++=
++++++++++
>  1 file changed, 45 insertions(+)

Acked-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
