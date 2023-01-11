Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B57CC54EBC
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Jan 2023 13:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbjAKNyz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Jan 2023 08:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbjAKNyb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Jan 2023 08:54:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFABA187
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jan 2023 05:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673445221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wWaQCrDT7+lvfz8D0gEsNwehGSuZBX6PaH7pA/A1LRk=;
        b=b6vDRB4qkAqxVmA/XZVyGcuCp8LEV9hTCUHFOe5OL3WQxhV/1nvtQx//Ehrfws/KME5v18
        rQ2yr7tBcx270/H09EHrbvh85mvg1sjXKBYljozbJaGMHPJaeqhQi8kQ724MCqNSRgAXCK
        DXEcTM3ktHwDreF0QcyLmUL8PHAiWFg=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-458-OWYhwcpXPXWEfaX0yPhw1w-1; Wed, 11 Jan 2023 08:53:40 -0500
X-MC-Unique: OWYhwcpXPXWEfaX0yPhw1w-1
Received: by mail-vk1-f197.google.com with SMTP id o85-20020a1f2858000000b003d5eb4cc1e6so4549451vko.2
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jan 2023 05:53:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:in-reply-to
         :mime-version:references:from:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wWaQCrDT7+lvfz8D0gEsNwehGSuZBX6PaH7pA/A1LRk=;
        b=Y8P9MmvRikyyTBAN0OZMRjRrwHTV9io4u9r8UqQBYedc/VbCnvKb0YmMo3vDMoUeZk
         a3eM2QF3KchXWS7w+m3+jERLa9s5EcaF0bDHi6Zix8sSIJsAcaLGF9dNgTI2a/ga4jSi
         Xud7KheH06iy3XkcngAq52j5NgRwP9fiiIu1Ax+2ShenbDStMFGyzoqCK6mJOAZtg9+w
         bmIVDbwWnLXQe/vqkLUauaOaH8cv9sPzC4YmKB54tFhpu1Vo5czWrahjTUvoImZbcjT+
         5UXAXGeYLW7Pv365UqiRjBK/PyjEIKahh1oh6C5doCK8jUFR59KqEd4tBqZMGAZr/28b
         dv6g==
X-Gm-Message-State: AFqh2kr768UUmySM9BpNkJMEUdq8EJjvAI59hpj800AUWEoA/rIW7VVw
        V7JRQD7PtsgQuEbEFPGXNIEHhkHH91+kNVer/5sFFvjCFMkB1lOcBFB6WB8cCz9Ke26NLX3ou/R
        kE6sI8cTjqJkiQKW+R5V5ffc3UfY8CcZTZLf/ds8YzHsW
X-Received: by 2002:a67:ca11:0:b0:3b2:f520:9fcb with SMTP id z17-20020a67ca11000000b003b2f5209fcbmr9643559vsk.84.1673445220162;
        Wed, 11 Jan 2023 05:53:40 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuGB8yIwBIPVZWzKH+1sB+nmENGRBm0mOTMG12ZTEM/dsO82laQMFYfMq7mxSm5OByVk63ghtWcq8dn4TVzZzE=
X-Received: by 2002:a67:ca11:0:b0:3b2:f520:9fcb with SMTP id
 z17-20020a67ca11000000b003b2f5209fcbmr9643552vsk.84.1673445219819; Wed, 11
 Jan 2023 05:53:39 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 11 Jan 2023 05:53:39 -0800
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20230104113143.21769-1-sriram.yagnaraman@est.tech>
 <Y7WVAEky9Iy3Ri3T@salvia> <DBBP189MB1433F79520D32E1CB0F8A62A95FA9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
 <Y7a6VqqMmW191RIG@salvia> <DBBP189MB14337144265DA856B8321D1695FA9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
 <Y7dwTU9Ky6RN1u7L@salvia> <DBBP189MB1433F9BBBF659878DDEB6B1495FC9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
MIME-Version: 1.0
In-Reply-To: <DBBP189MB1433F9BBBF659878DDEB6B1495FC9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
Date:   Wed, 11 Jan 2023 05:53:39 -0800
Message-ID: <CALnP8ZY5CR9nZz6gmh9MsvyU512iJOypWRaBx_xMBHbxe9Cuvg@mail.gmail.com>
Subject: Re: [RFC PATCH] netfilter: conntrack: simplify sctp state machine
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>, Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jan 11, 2023 at 09:36:38AM +0000, Sriram Yagnaraman wrote:
> > -----Original Message-----
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > Sent: Friday, 6 January 2023 01:50
> > To: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
> > Cc: netfilter-devel@vger.kernel.org; Florian Westphal <fw@strlen.de>;
> > Marcelo Ricardo Leitner <mleitner@redhat.com>; Long Xin
> > <lxin@redhat.com>; Claudio Porfiri <claudio.porfiri@ericsson.com>
> > Subject: Re: [RFC PATCH] netfilter: conntrack: simplify sctp state mach=
ine
> >
> > On Thu, Jan 05, 2023 at 12:11:44PM +0000, Sriram Yagnaraman wrote:
> > > > -----Original Message-----
> > > > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > Sent: Thursday, 5 January 2023 12:54
> > > > To: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
> > > > Cc: netfilter-devel@vger.kernel.org; Florian Westphal
> > > > <fw@strlen.de>; Marcelo Ricardo Leitner <mleitner@redhat.com>; Long
> > > > Xin <lxin@redhat.com>; Claudio Porfiri
> > > > <claudio.porfiri@ericsson.com>
> > > > Subject: Re: [RFC PATCH] netfilter: conntrack: simplify sctp state
> > > > machine
> > > >
> > > > On Thu, Jan 05, 2023 at 11:41:13AM +0000, Sriram Yagnaraman wrote:
> > > > > > -----Original Message-----
> > > > > > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > > > Sent: Wednesday, 4 January 2023 16:02
> > > > > > To: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
> > > > > > Cc: netfilter-devel@vger.kernel.org; Florian Westphal
> > > > > > <fw@strlen.de>; Marcelo Ricardo Leitner <mleitner@redhat.com>;
> > > > > > Long Xin <lxin@redhat.com>
> > > > > > Subject: Re: [RFC PATCH] netfilter: conntrack: simplify sctp
> > > > > > state machine
> > > > > >
> > > > > > On Wed, Jan 04, 2023 at 12:31:43PM +0100, Sriram Yagnaraman
> > wrote:
> > > > > > > All the paths in an SCTP connection are kept alive either by
> > > > > > > actual DATA/SACK running through the connection or by HEARTBE=
AT.
> > > > > > > This patch proposes a simple state machine with only two
> > > > > > > states OPEN_WAIT and ESTABLISHED (similar to UDP). The reason
> > > > > > > for this change is a full stateful approach to SCTP is
> > > > > > > difficult when the association is multihomed since the
> > > > > > > endpoints could use different paths in the network during the=
 lifetime
> > of an association.
> > > > > >
> > > > > > Do you mean the router/firewall might not see all packets for
> > > > > > association is multihomed?
> > > > > >
> > > > > > Could you please provide an example?
> > > > >
> > > > > Let's say the primary and alternate/secondary paths between the
> > > > > SCTP endpoints traverse different middle boxes. If an SCTP
> > > > > endpoint detects network failure on the primary path, it will
> > > > > switch to using the secondary path and all subsequent packets wil=
l
> > > > > not be seen by the middlebox on the primary path, including
> > > > > SHUTDOWN sequences if they happen at that time.
> > > >
> > > > OK, then on the primary middle box the SCTP flow will just timeout?
> > > > (because no more packets are seen).
> > >
> > > Yes, they will timeout unless the primary path comes up before the
> > > SHUTDOWN sequence. And the default timeout for an ESTABLISHED SCTP
> > > connection is 5 days, which is a "long" time to clean-up this entry.
> >
> > Does the middle box have a chance to see any packet that provides a hin=
t to
> > shorten this timeout? no HEARTBEAT packets are seen in this case on the
> > former primary path?
>
> There will be HEARTBEAT as soon as a path becomes unreachable from the SC=
TP endpoints. But depending on the location of the network failure, the mid=
dlebox may or may not see the HEARTBEAT. Also, HEARTBEAT is sent when there=
 are no data to be transmitted or if the path is unreachable/unconfirmed, s=
o I think there is no deterministic way of finding out when to shorten the =
timeout. Of course, a user has the option of setting the ESTABLISHED state =
timeout to a more reasonable value, for e.g., same as the HEARTBEAT_ACKED s=
tate timeout (210 sec), OR we could reduce the default timeout of ESTABLISH=
ED to 210 sec.
>
> >
> > What I am missing are a more detailed list of issues with the existing
> > approach. Your patch description says "SCTP tracking with multihoming i=
s
> > difficult", probably a list of scenarios would help to understand the m=
otivation
> > to simplify the state machine.
>
> Thank you for reviewing and asking these questions, it made me step back =
and think. I list below some background
> - I want to simplify the state machine, because it is possible to track a=
n SCTP connection with fewer states, for e.g., SCTP with UDP encapsulation =
uses UDP conntrack with just UNREPLIED/REPLIED states and it works perfectl=
y fine

[*] (more below)

> - My stakeholders, at the behest of whom I am proposing these changes hit=
 some problems running SCTP client endpoints behind NAT (inside Kubernetes =
pods) towards multihomed SCTP server endpoints (1a-g) and (2a-c) below
> - Some upcoming SCTP protocol changes in IETF (if approved/implemented) w=
ill make it hard to read beyond the SCTP common header, for e.g., DTLS over=
 SCTP https://datatracker.ietf.org/doc/draft-ietf-tsvwg-dtls-over-sctp-bis/=
, proposes to encrypt all SCTP chunks, conntrack will only be able to see S=
CTP common header, these changes hopefully will make it easier to adapt to =
such changes in SCTP protocol

If this is really the case, then I'm confused by this new RFC (be
warned I don't know the gory details of DTLS). I don't see it
specifying that other chunk headers will be encrypted, but instead I
see texts like:

3.7.  Message Sizes

   ...
   The sequence of DTLS records is then fragmented into DATA or I-DATA
   Chunks to fit the path MTU by SCTP.  These changes ensure that DTLS/
   SCTP has the same capability as SCTP to support user messages of any
   size. ...

this is just packing encrypted payload.

Sections 4.1 and 4.5 also lead to that, and:

6.  DTLS over SCTP Service

   The adoption of DTLS over SCTP according to the current specification
   is meant to add to SCTP the option for transferring encrypted data.
   When DTLS over SCTP is used, all data being transferred MUST be
   protected by chunk authentication and DTLS encrypted.

and finally:

9.6.  Privacy Considerations

   For each SCTP user message, the user also provides a stream
   identifier, a flag to indicate whether the message is sent ordered or
   unordered, and a payload protocol identifier.  Although DTLS/SCTP
   provides privacy for the actual user message, the other three
   information fields are not confidentiality protected.  They are sent
   as clear text because they are part of the SCTP DATA chunk header.


So AFAICU the claim here is that a middle box wouldn't be able to
inspect SCTP payload, but the protocol itself is still possible.
Did I miss something maybe?

> - While at it, I also made some other "improvements"
> 	a) Avoid multiple walk-throughs of SCTP chunks in sctp_new(), sctp_basic=
_checks() and nf_conntrack_sctp_packet(), and parse it only once
> 	b) SCTP conntrack has the same state regardless of it is a primary or a =
secondary path

This a good change and may, actually, be the core reasoning behind the
change here. 'Primary' is more in the sense of 'active' than anything
else (and it gets more confusing with CMT-SCTP heh). It's not because
a path saw the INIT handshake that it is more reliable and so from
conntrack side.

With that, conntrack handling all paths similarly makes it more
consistent and closer with what the actual SCTP sockets are seeing for
such paths.

One easy example here of a bad situation due to the current difference
between paths is that an application can start an association through
a path and tear it down over another one. There's no shutdown seen by
the first path, and the conntrack entry will be left there af it is
was in Established state for 5 days. (this is also illustrated in
Sriram's example below, just easier to read)

Item I marked with [*] above is vague. You need to consider what it
would be loosing by such simplification and argument that it is okay.
We can't just cut the fat out and pray for the best later on, right?
But with this description here, it not only provides a solid
justification on why it (specificly the new solution) is needed but
also why it is currently already broken/not reliable in multi-homing
setups. Yay! :-)

Then, next question is: would it make sense to keep the current
processing for single path associations? That's a lot of
code/maintenance and I fail to see a reasoning that justifies it.

>
> Let's say there are two SCTP endpoints A and B with addresses A' and B, B=
'' correspondingly.
> Primary path is A' <----> B' that traverses middlebox C, and secondary pa=
th is A' <----> B'' that traverses middlebox D.
> 1) SHUTDOWN sent on secondary path
> 1a) SCTP endpoint A sets up an association towards SCTP endpoint B
> 1b) Middlebox C sees INIT sequence and creates "primary" conntrack entry =
(5 days)
> 1c) Middlebox D sees HEARTBEAT sequence and creates "secondary" conntrack=
 entry (210 seconds)
> 1d) Path failure between A and C, and SCTP endpoint A switches to seconda=
ry path and continues sending data on the association
> 1e) SCTP endpoint A decides to SHUTDOWN the connection
> 1f) Middlebox C is in ESTABLISHED state, doesn't see any SHUTDOWN sequenc=
e or HEARTBEAT, waits for timeout (5 days)
> 1g) Middlebox D is in HEARTBEAT_ACKED state, doesn't care about SHUTDOWN =
sequence, waits for timeout (210 seconds)
>
> 2) Recently fixed by bff3d0534804 ("netfilter: conntrack: add sctp DATA_S=
ENT state ")
> 2a) SCTP endpoint A sets up an association towards SCTP endpoint B
> 2b) Middlebox C sees INIT sequence and creates "primary" conntrack entry =
(5 days)
> 2c) Middlebox D sees DATA/SACK, and DROPS packets until HEARTBEAT is seen=
 to setup "secondary" conntrack entry (210 seconds)
>
> >
> > Thanks.

