Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337AF18A6BF
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2024 10:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731405829; cv=none; b=TeOiVXQnO33NZdEG7CxUpHVAtEPVqw773C+c4cCzt6QNll4fnHvtDFsZK/+wOHcfCNrfFgQxLp7B7TFRhnbMInprEeD1v88CRGbIaoyxpFcjd0x3XPKc+xc21i9Qos+7T94Bj/ZUBtej3r5JrGz+N8mHC9U/egDIsoN1tkaBxzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731405829; c=relaxed/simple;
	bh=AfijD7bJCJegDVJb9doH4aKt85yfX3drG5swjIEqV/I=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QdKCRcMmqosOxKz/FU6Ri9NcHBHGIKvjmIJseeKESRZyJQEOA/Lr1Dwp95yQZ9c7z6l4M4mrjszeh5V14vTqx3+uUDZY051LusRG1EX2W/TbCwVw2iE+EgLCSmCJUjDiwNfuH3hoFo4iYhBjqQeodjE6XJOScm0T6izcodqnQEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NEIQsW8p; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NEIQsW8p"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-20cdbe608b3so54864085ad.1
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2024 02:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731405826; x=1732010626; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DKAW/5mS4sIWJfWJBGPlCs4ZQv0oRG04rODoHn5qDX4=;
        b=NEIQsW8pF1hg9n94LDaX6V6A2KC7uWPsYt4ovtfzlV4bflh2vHW4FcclUDAGjR21e5
         k7ecPBOh7Otn3/mw/9fKu32FeO7FU/GefwYeaT0tavN1ZeUZbH4iFbKN8F6m07MU3USs
         yZCGs30PWTfzO0pP3nbJ5uZf4eMxBK3O3GOScWIio8U0Czuv+LLThTFTJjfquxvOcD3g
         4/Xs/acTtvV7HUvTMSwCdzo9MSTzFdgsrZX3qVWbbfedr1lgxeZCCwXRRfRCyc7kD7LT
         lRs99opHpjxLHpIO6udrAAmlYNoxbrzFWQzP45EwyaO8jNYeODYaQ2o2waNa3KEzU41b
         NLxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731405826; x=1732010626;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DKAW/5mS4sIWJfWJBGPlCs4ZQv0oRG04rODoHn5qDX4=;
        b=ZvJ5eeeEzRSf/G6Qr9UQEwHG3uAToBCo7uM8tOFVu9EQ+h0/1DwNt6GeRcQn0eIf4w
         DyJqswBUDIGXVnyFg7HxOh2/V2jVTNwUCmr0I21HM4iBORqTkaUIdYWqCgh1GmsaMPLR
         lb2I2S8kOB2mi/13+Vnqn3M76j5D5hw0h/pmvc30rf6yHbmNezTn/DUlnj3j6NFeVElS
         34f9P/Y4f8H1+xW2VRUHEhoLNSDespbxKaoY9XLWd/r69cS2r0dRUOVNxALTqXdMs5yR
         zcRVdfuXgL7dA4O9IaAX149j6OfEleiOMOUx7Tl7C5FxhUI6r1SxCdxJ4Nkz/hyEdELg
         HYDQ==
X-Gm-Message-State: AOJu0YzkxQnkxPra5N9cVDryz8+nZ+vTJxuHpZ4eglM6Ze9+sUCk2WN6
	VMjiRlOBnFH3Lt4Zzez7AUIuZCmjLyLU5gk+LM1GAMRviQc/94bwLciqPg==
X-Google-Smtp-Source: AGHT+IGDVEd2QWpNLKe4d66Oj7UjvRgT6Q4GRbML3qolKDEbSS47P1AB4YOxiLAszjEIsUdMyI+7KQ==
X-Received: by 2002:a17:903:228b:b0:20c:5533:36da with SMTP id d9443c01a7336-211ab9ccf30mr25962725ad.42.1731405826356;
        Tue, 12 Nov 2024 02:03:46 -0800 (PST)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177e4148esm88277825ad.125.2024.11.12.02.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 02:03:45 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Tue, 12 Nov 2024 21:03:42 +1100
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl] whitespace: remove spacing irregularities
Message-ID: <ZzMn/kNbAymOjeaZ@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20241111025608.8683-1-duncan_roe@optusnet.com.au>
 <ZzHcsEYWLdt_j0Iy@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzHcsEYWLdt_j0Iy@calendula>

Hi Pablo,

On Mon, Nov 11, 2024 at 11:30:08AM +0100, Pablo Neira Ayuso wrote:
> On Mon, Nov 11, 2024 at 01:56:08PM +1100, Duncan Roe wrote:
> > Two distinct actions:
> >  1. Remove trailing spaces and tabs.
> >  2. Remove spaces that are followed by a tab, inserting extra tabs
> >     as required.
> > Action 2 is only performed in the indent region of a line.
> >
> > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > ---
> >  include/linux/netlink.h | 6 +++---
> >  src/callback.c          | 4 ++--
> >  src/socket.c            | 6 +++---
> >  3 files changed, 8 insertions(+), 8 deletions(-)
>
> Submit uapi/netlink.h update upstream via netdev@
>
> This is a cached copy of uapi/netlink.h
>
> If I take this, the extra line spaces and indentation will come back
> sooner or later.
>
> Thanks.

Thanks for that advice, I've submitted a v2 which only fixes spacing in 2
.c files. The .c files are the ones giving me grief because q, the editor I
use, is configured to fix spacing on saving any file. I could change the
configuration but would rather not.

As for uapi/linux/netlink.h, well hmm. One of the q editor's "party tricks"
is to go through the entire kernel tree correcting all the space irregularities.
I've wondered about sending a kernel-wide patch except there are a few
sources which seem to assume 4-char tabs: I'd leave them out for now.

q finds 120 space-irregular files under uapi/linux alone, but obviously only a
few are appropriate for netdev@.

Just these 2?

| include/uapi/linux/netlink.h                        |   6 +++---
| include/uapi/linux/rtnetlink.h                      |   8 ++++----

Or these as well?

| include/uapi/linux/netfilter/nf_conntrack_common.h  |   2 +-
| include/uapi/linux/netfilter/nfnetlink.h            |   6 +++---
| include/uapi/linux/netfilter/nfnetlink_compat.h     |   8 ++++----
| include/uapi/linux/netfilter/x_tables.h             |   4 ++--
| include/uapi/linux/netfilter/xt_NFQUEUE.h           |   2 +-
| include/uapi/linux/netfilter/xt_ecn.h               |   2 +-
| include/uapi/linux/netfilter_arp/arp_tables.h       |   2 +-
| include/uapi/linux/netfilter_bridge.h               |   2 +-
| include/uapi/linux/netfilter_bridge/ebt_802_3.h     |   2 +-
| include/uapi/linux/netfilter_bridge/ebt_among.h     |   4 ++--
| include/uapi/linux/netfilter_bridge/ebt_vlan.h      |   2 +-
| include/uapi/linux/netfilter_bridge/ebtables.h      |  10 +++++-----
| include/uapi/linux/netfilter_ipv4.h                 |   2 +-
| include/uapi/linux/netfilter_ipv4/ip_tables.h       |   2 +-
| include/uapi/linux/netfilter_ipv4/ipt_ECN.h         |   2 +-
| include/uapi/linux/netfilter_ipv6.h                 |   4 ++--
| include/uapi/linux/netfilter_ipv6/ip6_tables.h      |   6 +++---
| include/uapi/linux/netfilter_ipv6/ip6t_ipv6header.h |   2 +-

and what about this lot?

| include/uapi/linux/ax25.h                           |  14 +++++++-------
| include/uapi/linux/icmpv6.h                         |  24 ++++++++++++------------
| include/uapi/linux/if.h                             |   6 +++---
| include/uapi/linux/if_eql.h                         |   2 +-
| include/uapi/linux/if_hippi.h                       |   6 +++---
| include/uapi/linux/if_plip.h                        |   2 +-
| include/uapi/linux/if_pppox.h                       |  14 +++++++-------
| include/uapi/linux/if_slip.h                        |   8 ++++----
| include/uapi/linux/if_tun.h                         |   8 ++++----
| include/uapi/linux/if_vlan.h                        |   6 +++---
| include/uapi/linux/in.h                             |   2 +-
| include/uapi/linux/in6.h                            |   8 ++++----
| include/uapi/linux/inet_diag.h                      |   2 +-
| include/uapi/linux/ip.h                             |   2 +-
| include/uapi/linux/ipv6.h                           |   4 ++--
| include/uapi/linux/ipv6_route.h                     |   6 +++---
| include/uapi/linux/netdevice.h                      |  14 +++++++-------
| include/uapi/linux/ppp_defs.h                       |   2 +-
| include/uapi/linux/sockios.h                        |   8 ++++----
| include/uapi/linux/x25.h                            |   4 ++--

Any advice greatly appreciated,

Cheers ... Duncan.
