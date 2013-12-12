From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH 2/2] table: Add support for NFTA_TABLE_USE
 nftables attribute
Date: Thu, 12 Dec 2013 14:06:47 +0100
Message-ID: <CAOkSjBjOCcfthVBjt90P0NKx--L-0zzMRijeVe_J7xapmn_19w@mail.gmail.com>
References: <1386853244-16783-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1386853244-16783-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:59278 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab3LLNHI convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:07:08 -0500
Received: by mail-la0-f54.google.com with SMTP id b8so289011lan.13
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Dec 2013 05:07:07 -0800 (PST)
In-Reply-To: <1386853244-16783-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 December 2013 14:00, Tomasz Bursztyka
<tomasz.bursztyka@linux.intel.com> wrote:
>  static int nft_table_snprintf_xml(char *buf, size_t size, struct nft=
_table *t)
>  {
>         return snprintf(buf, size, "<table><name>%s</name><family>%s<=
/family>"
> -                       "<flags>%d</flags></table>",
> -                       t->name, nft_family2str(t->family), t->table_=
flags);
> +                       "<flags>%d</flags><use%d</use></table>",

small typo: <use>%d</use>

regards

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
