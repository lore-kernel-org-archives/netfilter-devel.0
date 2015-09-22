From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft] all chains of a table are listed
Date: Tue, 22 Sep 2015 14:06:25 +0200
Message-ID: <CAOkSjBiSbL1sJ268dL-6n1upXNW=5c0j864dTubu8FKMSxQruw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35471 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbbIVMGr convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Sep 2015 08:06:47 -0400
Received: by wicge5 with SMTP id ge5so158125043wic.0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2015 05:06:45 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi!

It seems all chains of a given table are always listed. Is this the
intended behaviour?

% sudo nft list table test
table ip test {
  chain test1 {
  }

  chain test2 {
  }
}

% sudo nft list chain test test1
table ip test {
  chain test1 {
  }

  chain test2 {
  }
}

% sudo nft list chain test test2
table ip test {
  chain test1 {
  }

  chain test2 {
  }
}

This is with nftables v0.5.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
