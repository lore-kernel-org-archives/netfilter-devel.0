From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH 2/2] tests/shell: add testcases for Netfilter bug #965
Date: Sat, 19 Mar 2016 16:57:44 +0100
Message-ID: <CAOkSjBgLF2gs=CgPTrP7SY7bOU3AUbqxTUpVa3mMx2-VQHbxgg@mail.gmail.com>
References: <145832846678.11442.11097916539235202354.stgit@nostromo> <145832847321.11442.4869938717972076465.stgit@nostromo>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sander.contrib@gmail.com, Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36054 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbcCSP6G convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Mar 2016 11:58:06 -0400
Received: by mail-wm0-f68.google.com with SMTP id l68so12304431wml.3
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Mar 2016 08:58:05 -0700 (PDT)
In-Reply-To: <145832847321.11442.4869938717972076465.stgit@nostromo>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18 March 2016 at 20:14, Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com> wrote:
> Testscases for Netfilter bug #965:
>  * add rule at position
>  * insert rule at position
>  * replace rule with given handle
>  * delete rule with given handle
>  * don't allow to delete rules with position keyword
>
> Netfilter Bugzilla: http://bugzilla.netfilter.org/show_bug.cgi?id=3D9=
65
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com=
>

sorry for the duplicated patches, something was wrong with my email con=
fig.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
