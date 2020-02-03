Return-Path: <SRS0=ffOv=3X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A74E8C33CAC
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 13:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D8422166E
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 13:54:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="knNQWUds"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbgBCNyk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Feb 2020 08:54:40 -0500
Received: from mail-40130.protonmail.ch ([185.70.40.130]:38165 "EHLO
        mail-40130.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727494AbgBCNyj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 08:54:39 -0500
Date:   Mon, 03 Feb 2020 13:54:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1580738076;
        bh=OFdiTIMRr9CKLh8jUhcTeYLf9TN9FQ+Y21QjYyUQpyk=;
        h=Date:To:From:Reply-To:Subject:Feedback-ID:From;
        b=knNQWUdsRsk1NPWQCdT4w89mafF8FthJcmDWzMSBayvntwG37DtIXu9KXf4K4GLR0
         O/qBd6qPyuh83D86LKLFfZM87x1zb1fA+bJYRHnMruYJBE0Y0UthfOmo/Q6Jv/FmA3
         mgInlbITD6ARtSizMIXqKH60YFaS1Nve5J8K8/bs=
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From:   dyslexicatheist <dyslexicatheist@protonmail.com>
Reply-To: dyslexicatheist <dyslexicatheist@protonmail.com>
Subject: invalid read in
Message-ID: <gwRjoIGUgI5MEgxSob7CBSUwPbYkxILRc4_ZrYWYNI7d1-T5Ej95p3XkEY_f9hLqHK5nVun7dk6RqObi0c_4482IJ6s6U33PyS6Hrm4z46E=@protonmail.com>
Feedback-ID: LnsYXauhtR_e9kgk2d-isThAhyxIsD2PcS0_jrp6ej-3I2WPS9tR2zudCE_YY9WCDyXkRWYo2nBz1g-cDBMDOQ==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

I've written a filter to parse out punicode from DNS payloads and rewrite t=
he packet in case it contains any IDN (xn--) marker unless the IDN is on a =
whitelist. Valgrind reports that nfq_create_queue() returns uninitialized
bytes resulting in thiserror:


sudo valgrind --tool=3Dmemcheck --leak-check=3Dyes --show-reachable=3Dyes \
           --num-callers=3D20 --track-fds=3Dyes --track-origins=3Dyes -s \
            ./nfq --syslog --facility LOG_LOCAL0 --log-level info \
                  --port 53  --renice -20 --rewrite-answer
      =3D=3D714384=3D=3D
      =3D=3D714384=3D=3D Syscall param socketcall.sendto(msg) points to uni=
nitialised byte(s)
      =3D=3D714384=3D=3D    at 0x4B977C7: sendto (sendto.c:27)
      =3D=3D714384=3D=3D    by 0x486BE02: nfnl_send (in /usr/lib/x86_64-lin=
ux-gnu/libnfnetlink.so.0.2.0)
      =3D=3D714384=3D=3D    by 0x486DBD2: nfnl_query (in /usr/lib/x86_64-li=
nux-gnu/libnfnetlink.so.0.2.0)
      =3D=3D714384=3D=3D    by 0x4A73995: nfq_set_mode (libnetfilter_queue.=
c:639)
      =3D=3D714384=3D=3D    by 0x10B247: start_nfqueue_processing (nfq.c:53=
2)
      =3D=3D714384=3D=3D    by 0x10C289: main (nfq.c:987)
      =3D=3D714384=3D=3D  Address 0x1ffefefbfd is on thread 1's stack
      =3D=3D714384=3D=3D  in frame #3, created by nfq_set_mode (libnetfilte=
r_queue.c:623)
      =3D=3D714384=3D=3D  Uninitialised value was created by a stack alloca=
tion
      =3D=3D714384=3D=3D    at 0x10A1B0: ??? (in /src/nfq/src/nfq)

After searching on this list archive, I found 1 question but without a foll=
ow-up answer:
https://marc.info/?l=3Dnetfilter-devel&m=3D137132916826745&w=3D4

Having already spent over a day chasing this. Not having come across other =
cases on github except this person self reporting[1] made me think it must =
be indeed something in my code that I'm missing and that could have trigger=
ed this. Or is it really rare (harmless) bug in libnetfilter?

[1] https://github.com/misje/dhcpoptinj/issues/5

thanks for any help,
~DA
