From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] extensions: libxt_multiport: Add translation to nft
Date: Mon, 30 May 2016 20:34:15 +0200
Message-ID: <CAOkSjBjoO_Sh12mZL6JcjTuQ1e98xsG=wXreymHKwyijZe6eRg@mail.gmail.com>
References: <20160530182749.GA11081@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34750 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933509AbcE3Seg convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 14:34:36 -0400
Received: by mail-wm0-f67.google.com with SMTP id n129so25161019wmn.1
        for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:34:35 -0700 (PDT)
In-Reply-To: <20160530182749.GA11081@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 30 May 2016 at 20:27, Laura Garcia Liebana <nevola@gmail.com> wrote:
> Add translation for multiport to nftables, which it's supported nativ=
ely.
>
> Examples:
>
> $ sudo iptables-translate -t filter -A INPUT -p tcp -m multiport --dp=
orts 80,81 -j ACCEPT
> nft add rule ip filter INPUT ip protocol tcp tcp dport 80,81 counter =
accept
>
> $ sudo iptables-translate -t filter -A INPUT -p tcp -m multiport --dp=
orts 80:88 -j ACCEPT
> nft add rule ip filter INPUT ip protocol tcp tcp dport 80-88 counter =
accept
>
> $ sudo iptables-translate -t filter -A INPUT -p tcp -m multiport ! --=
dports 80:88 -j ACCEPT
> nft add rule ip filter INPUT ip protocol tcp tcp dport !=3D 80-88 cou=
nter accept
>

These examples use invalid syntax, you should use:

 tcp dport {80,81}
 tcp dport {80-81}

regards

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
