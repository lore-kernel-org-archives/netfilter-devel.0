Return-Path: <SRS0=xWIb=V6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D88C32750
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 20:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A5C720880
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 20:47:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="0cZkj17p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbfHBUr6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 16:47:58 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44400 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbfHBUr6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 16:47:58 -0400
Received: by mail-qk1-f194.google.com with SMTP id d79so55803733qke.11
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Aug 2019 13:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=l2xTmeRtEZTPMASSyFs2258/OlcrW4XV8UWTXw6h5+k=;
        b=0cZkj17p28vciM09SU3936/Q8DZdrQt6nHUUyhVZEvE5mPkdVaT3Bxk0GgtLCHVqUq
         J2zV2mcLdpHFem6LH415jDwmnqzUaPdUUfP1aSNzw1LsMvChYxCJ59CsKbw5eQkFfPr0
         pjsyrJYLIwhMGknijfLBcroM9GFWGqdBaPhL+qpPNt9mbShDS92VjCMfNGjW32B8bYi5
         NYtyRME50oGbbNNv5oqoTQtDkySWVMlyDcU81B491kQ5JY2nYV3lR90CV9MC0X1dUPF4
         WblnCHJPAtrr1rY1btjs6xomaxQ+Hfx3a1IOa0LLS6Hd7A7IL/BXXS9Ax66n3YNQuH4T
         kVKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=l2xTmeRtEZTPMASSyFs2258/OlcrW4XV8UWTXw6h5+k=;
        b=SWDiAlfmMT4faREayVlDkwGjCkD0AoWXc8gt8ww7/aJKKD+/DPw3JGOIBM4KTzte9S
         pkfTkooMqdqmDkFcZIGyMNYL9Ofp7ZzfL+aGdiX22CWlTIMi9+NtInxIOeguqfdgCeD6
         vK1uO5axK0kf5JSWJEU7X6EAZ/FEr7t9EJCQXoUsnCcjBlvNjMn4M3F5LJXY82gHB4Pa
         eOuITn8EdZ3tnTREqC4TECS+Df/KqDFcUxhBirayFt7mUxVkCYPb0O6+YusSl579xBVf
         gnpp08hvIDqgAdfxI44SiSGzcH6gc5vKuSF6il92QtzmfFE+Opse8UB7zj6NfL71uDJn
         LHoA==
X-Gm-Message-State: APjAAAXTneDIUbfuhZwL2pGn/ZOFN11VKmoDFHvpIer8YC141+h/YVyJ
        6CUPPMQsmLkI7cQ97gpHZOPzQbfRo7U=
X-Google-Smtp-Source: APXvYqyGPVP4pYNHM6j3aUEwLbB+3r04zY+QW4Rhajmc+Oriuf8YEYDgH6W+BTNlLSFJ3Q+vhcav0g==
X-Received: by 2002:a37:7cc5:: with SMTP id x188mr90076102qkc.456.1564778877066;
        Fri, 02 Aug 2019 13:47:57 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g2sm32862012qkf.32.2019.08.02.13.47.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 13:47:56 -0700 (PDT)
Date:   Fri, 2 Aug 2019 13:47:38 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, marcelo.leitner@gmail.com,
        jiri@resnulli.us, wenxu@ucloud.cn, saeedm@mellanox.com,
        paulb@mellanox.com, gerlitz.or@gmail.com
Subject: Re: [PATCH net 0/2] flow_offload hardware priority fixes
Message-ID: <20190802134738.328691b4@cakuba.netronome.com>
In-Reply-To: <20190802110023.udfcxowe3vmihduq@salvia>
References: <20190801112817.24976-1-pablo@netfilter.org>
        <20190801172014.314a9d01@cakuba.netronome.com>
        <20190802110023.udfcxowe3vmihduq@salvia>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2 Aug 2019 13:00:23 +0200, Pablo Neira Ayuso wrote:
> Hi Jakub,
>=20
> If the user specifies 'pref' in the new rule, then tc checks if there
> is a tcf_proto object that matches this priority. If the tcf_proto
> object does not exist, tc creates a tcf_proto object and it adds the
> new rule to this tcf_proto.
>=20
> In cls_flower, each tcf_proto only stores one single rule, so if the
> user tries to add another rule with the same 'pref', cls_flower
> returns EEXIST.

=F0=9F=98=B3=20

So you're saying this doesn't work?

ip link add type dummy
tc qdisc add dev dummy0 clsact
tc filter add dev dummy0 ingress protocol ipv6 prio 123 flower src_ip 1111:=
:1 action drop
tc filter add dev dummy0 ingress protocol ipv6 prio 123 flower src_ip 1111:=
:2 action drop
tc filter add dev dummy0 ingress protocol ipv6 prio 123 flower src_ip 1111:=
:3 action drop
tc filter add dev dummy0 ingress protocol ipv6 prio 123 flower src_ip 1111:=
:4 action drop
tc filter add dev dummy0 ingress protocol ipv6 prio 123 flower src_ip 1111:=
:5 action drop

tc filter show dev dummy0 ingress

filter protocol ipv6 pref 123 flower chain 0=20
filter protocol ipv6 pref 123 flower chain 0 handle 0x1=20
  eth_type ipv6
  src_ip 1111::1
  not_in_hw
	action order 1: gact action drop
	 random type none pass val 0
	 index 1 ref 1 bind 1

filter protocol ipv6 pref 123 flower chain 0 handle 0x2=20
  eth_type ipv6
  src_ip 1111::2
  not_in_hw
	action order 1: gact action drop
	 random type none pass val 0
	 index 2 ref 1 bind 1

filter protocol ipv6 pref 123 flower chain 0 handle 0x3=20
  eth_type ipv6
  src_ip 1111::3
  not_in_hw
	action order 1: gact action drop
	 random type none pass val 0
	 index 3 ref 1 bind 1

filter protocol ipv6 pref 123 flower chain 0 handle 0x4=20
  eth_type ipv6
  src_ip 1111::4
  not_in_hw
	action order 1: gact action drop
	 random type none pass val 0
	 index 4 ref 1 bind 1

filter protocol ipv6 pref 123 flower chain 0 handle 0x5=20
  eth_type ipv6
  src_ip 1111::5
  not_in_hw
	action order 1: gact action drop
	 random type none pass val 0
	 index 5 ref 1 bind 1


> I'll prepare a new patchset not to map the priority to the netfilter
> basechain priority, instead the rule priority will be internally
> allocated for each new rule.

In which you're adding fake priorities to rules, AFAICT,=20
and continue to baffle me.
