Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FCBE82CD9
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 20:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjI0Usk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 16:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjI0Usj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 16:48:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6230F126
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 13:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695847676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YMq06b4ueJv2rqvhvzAhdjxLBU/UrlBbIgIXL0VcVNw=;
        b=TX2/TODOhDN/SDGQXouKdAec/jmqfY/seu3ZF7Xnir8Q7jlIvFeSO48deyxkt8349TUVvf
        c5MhZrM0zBjVl3B7x4ohXLHEVKLkqBJvPH2WSJr9AjauVfEWLQ9Egi+JSte+nfB/qTkm7m
        doebEYE8915EyC8zEBFik5s1JMlWOYU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-NbalMx5zO_-7k8Hy7Rydcw-1; Wed, 27 Sep 2023 16:47:54 -0400
X-MC-Unique: NbalMx5zO_-7k8Hy7Rydcw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-320089dad3cso1322381f8f.1
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 13:47:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695847673; x=1696452473;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YMq06b4ueJv2rqvhvzAhdjxLBU/UrlBbIgIXL0VcVNw=;
        b=UJCcJUWORWOgSLDNlZnl2ec5Tpe8c281N6pjUU9CLzC1jBBw0jJ0WJT/F2FbW8ykR/
         e8HfnVTE88oabiqv+DMvyn1g7I9LyitmsiJBDXyMzWHwMTLYn3XmJrfxajMhxaboHoyt
         XfVtaQHk4CIyic3HH1QfHdDAp8J+IUue1uhOVhF6l/YnqAuX+ycr2mhGc/LgfHyYrRGl
         wyxHbDM8SzBeQr4PDh5IlNSVCQejiQTIEh2w+bEvDNIfYyu9Iy6KzFag+Vy5lO+vkthk
         3c4tBZxI7/dCxIut3i/d/yDHzPgQA8myZn6SE8OSDcnVfXnoa1f2UlH/PF942o45Myu+
         nFrg==
X-Gm-Message-State: AOJu0Yx3+iXfytzcypxfmd6AhEnx8qzt32FHuxxZS9CKLmX3DeIPRtLU
        1OS5qYNecAu1Z35UEp0A1IEh1gL5tBJuJggyrdpwgg8zSdc1qH4P8wVhA99fvpFbG6Vf1g/ZfPA
        oHrtnMZoRNxSQke8TFcckApI1HkP8y/U6OW6u
X-Received: by 2002:a5d:60ca:0:b0:322:5251:d78b with SMTP id x10-20020a5d60ca000000b003225251d78bmr2443267wrt.6.1695847673490;
        Wed, 27 Sep 2023 13:47:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG37dQcLjbsmg9Zd6WsR3ECvE2Wy4co0fb4VVJFIzmRhg2TAfao9EWP45Z0eomiff/cExIo1w==
X-Received: by 2002:a5d:60ca:0:b0:322:5251:d78b with SMTP id x10-20020a5d60ca000000b003225251d78bmr2443258wrt.6.1695847673105;
        Wed, 27 Sep 2023 13:47:53 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id gs10-20020a170906f18a00b009ae40563b7csm9759219ejb.21.2023.09.27.13.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 13:47:52 -0700 (PDT)
Message-ID: <9751fa69c866b9772831123300991716ace08c5a.camel@redhat.com>
Subject: Re: [PATCH nft 0/3] tests/shell: minor improvements to
 "run-tests.sh"
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Wed, 27 Sep 2023 22:47:51 +0200
In-Reply-To: <ZRSQI9a2UQn6bZUY@calendula>
References: <20230918184634.3471832-1-thaller@redhat.com>
         <ZRSQI9a2UQn6bZUY@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2023-09-27 at 22:27 +0200, Pablo Neira Ayuso wrote:
> Hi Thomas,
>=20
> Not precisely related to this series in this email thread, but...
>=20
> I occasionally see errors like this when running tests in a loop:
>=20
> ./run-tests.sh: line 673: echo: write error: Interrupted system call
>=20
> it is happening since the recent updates, do you have any idea what
> could be wrong?
>=20
> Thanks.
>=20

Hi,


I think that line is

=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7echo scan > /sys/kernel/deb=
ug/kmemleak

Are you running with KMEMLEAK=3Dy? But also without that, it gets called
after every 30th test returning -- since usually the fast tests run
quickly in parallel, we would call it more frequently at the beginning
of the tests.


Note that the "check_kmemleak_force" function in the run-tests.sh
script does NOT run in parallel.=20


I am not familiar with kmemleak, but seems not serious.=20
Maybe just ignore the error output?

  ( echo scan > /sys/kernel/debug/kmemleak ) &>/dev/null


Thomas

