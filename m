Return-Path: <SRS0=44Uw=53=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A3ADC2BA2B
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Apr 2020 07:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 281332078E
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Apr 2020 07:25:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i8N6BvFN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgDKHZG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Apr 2020 03:25:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35569 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725869AbgDKHZG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Apr 2020 03:25:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586589905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=83q8+0q6/Bd67JIjEyGF9akq2N/0Xry6Mj5tSk/Wx8M=;
        b=i8N6BvFNXhPN5+byeEINeEsEwZ840I4Wzv8X6DZZSA3tJvuqsU5JnShMOlG0H8KkLBMmOq
        TviMeJ4t1h6IvC6mRitQhasXfs87GougC9LVM+KuEOxDNUhN58tR8nvqNlObbbfIzJEQp3
        lPi2r7acSDVIJoqZM0ADHc/gQ3gG/C0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-LU9fNu_pP56RBa8IbeuJzg-1; Sat, 11 Apr 2020 03:25:04 -0400
X-MC-Unique: LU9fNu_pP56RBa8IbeuJzg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 155C98018A2;
        Sat, 11 Apr 2020 07:25:03 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C476F9E0E4;
        Sat, 11 Apr 2020 07:25:01 +0000 (UTC)
Date:   Sat, 11 Apr 2020 09:24:56 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Thorsten Knabe <linux@thorsten-knabe.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: BUG: Anonymous maps with adjacent intervals broken since Linux
 5.6
Message-ID: <20200411092456.72e2ddd4@elisabeth>
In-Reply-To: <6d036215-e701-db81-d429-2c76856463ee@thorsten-knabe.de>
References: <6d036215-e701-db81-d429-2c76856463ee@thorsten-knabe.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Thorsten,

On Fri, 10 Apr 2020 19:25:49 +0200
Thorsten Knabe <linux@thorsten-knabe.de> wrote:

> Hello.
>=20
> BUG: Anonymous maps with adjacent intervals are broken starting with
> Linux 5.6. Linux 5.5.16 is not affected.
>=20
> Environment:
> - Linux 5.6.3 (AMD64)
> - nftables 0.9.4
>=20
> Trying to apply the ruleset:
>=20
> flush ruleset
>=20
> table ip filter {
> =C2=A0 chain test {
> =C2=A0=C2=A0=C2=A0 ip daddr vmap {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 10.255.1.0-10.255.1.255: accep=
t,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 10.255.2.0-10.255.2.255: drop
> =C2=A0=C2=A0=C2=A0 }
> =C2=A0 }
> }
>=20
> using nft results in an error on Linux 5.6.3:
>=20
> # nft -f simple.nft
> simple.nft:7:19-5: Error: Could not process rule: File exists
> =C2=A0=C2=A0=C2=A0 ip daddr vmap {

Thanks for reporting this issue. I can't test it right now, but:

commit 72239f2795fab9a58633bd0399698ff7581534a3
Author: Stefano Brivio <sbrivio@redhat.com>
Date:   Wed Apr 1 17:14:38 2020 +0200

    netfilter: nft_set_rbtree: Drop spurious condition for overlap detectio=
n on insertion

should be the fix for this. Can you try with that?

--=20
Stefano

