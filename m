Return-Path: <SRS0=kOBD=7V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6542C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jun 2020 17:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FB522100A
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jun 2020 17:31:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=openfortress.nl header.i=rick@openfortress.nl header.b="VNKPLmtL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387609AbgFHRbc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jun 2020 13:31:32 -0400
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:43759 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387607AbgFHRba (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jun 2020 13:31:30 -0400
Received: from popmini.vanrein.org ([IPv6:2001:980:93a5:1::7])
        by smtp-cloud7.xs4all.net with ESMTP
        id iLcMjOV9XNp2ziLcOjdSx3; Mon, 08 Jun 2020 19:31:28 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=openfortress.nl; 
 i=rick@openfortress.nl; q=dns/txt; s=fame; t=1591637486; 
 h=message-id : date : from : mime-version : to : cc : 
 subject : content-type : content-transfer-encoding : date 
 : from : subject; 
 bh=hyHMsNvyWniQ1TDgfwarCr6Rn5rjAvMHCISrv+SBq7U=; 
 b=VNKPLmtL9/MDXlVJ4fAm2HqncZJYSnln1wJaCNAeStmDLlEeKW81fnsp
 pungHHtXdV7xo/IMK1djFaUPCuf3gAqXCphjeJI+e0dFQh942U8DgtNHeR
 YUSt3yS4l/xOQhOtNpsPIhInOawBDGekOm2HepO9fbEFA5x6jrUKTVhJI=
Received: by fame.vanrein.org (Postfix, from userid 1006)
        id 895193D033; Mon,  8 Jun 2020 17:31:25 +0000 (UTC)
Received: from airhead.fritz.box (phantom.vanrein.org [83.161.146.46])
        by fame.vanrein.org (Postfix) with ESMTPA id 662763CCC1;
        Mon,  8 Jun 2020 17:31:22 +0000 (UTC)
Message-ID: <5EDE75D5.7020303@openfortress.nl>
Date:   Mon, 08 Jun 2020 19:31:01 +0200
From:   Rick van Rein <rick@openfortress.nl>
User-Agent: Postbox 3.0.11 (Macintosh/20140602)
MIME-Version: 1.0
To:     Patrick McHardy <kaber@trash.net>
CC:     netfilter-devel@vger.kernel.org
Subject: Extensions for ICMP[6] with sport, dport
X-Enigmail-Version: 1.2.3
Content-Type: text/plain; charset=UTF-8
X-Bogosity: Unsure, tests=bogofilter, spamicity=0.520000, version=1.2.4
Content-Transfer-Encoding: quoted-printable
X-CMAE-Envelope: MS4wfJtilnwbv3S93vF5IVm8PsDK8JhPqDV/EGchkv6JS+cbi8B1vsP3i61avpdPTi3CoWK0+XkjSLXC1c89UY/EqwhgLJWUxZkmlrFgZS65T0KHJ8sT2EYP
 963PrOiFuElQT7+PLu17vlADNgueX3BuGbjCh8oDGUTX3TeKW8sEHNpeUyW5Lg5f7wTIwmq8N1JMOqzf7UgT/SMdygUpKLLgudg=
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Patrick McHardy / NFT,

I'm using NetFilter for static firewalling.  Ideally with ICMP, for
which I found that a minor extension might be helpful, adding selectors
for icmp|icmp6|l4proto sport|dport.  This avoids painstaking detail to
carry ICMP, and may be helpful to have mature firewalls more easily.
Would you agree that this is a useful extension?

Interpretation of IP content is valid for error types; for ICMP, those
are 3,11,12,31, for ICMP6, those are 1,2,3,4; this should be checked
elsewhere in the ruleset.  The code supports "l4proto" selection of ICMP
with the same rules as TCP et al.  (But a better implementation of
"l4proto" in meta.c would skip IP option headers and ICMP headers with
error types to actually arrive at layer 4, IMHO).

A sketch of code is below; I am unsure about the [THDR_?PORT] but I
think the "sport" and "dport" should be interpreted in reverse for ICMP,
as it travels upstream.  That would match "l4proto sport" match ICMP
along with the TCP, UDP, SCTP and DCCP to which it relates.  It also
seems fair that ICMP with a "dport" targets the port at the ICMP target,
so the originator of the initial message.


If you want me to continue on this, I need to find a way into
git.kernel.org and how to offer code.  Just point me to howto's.  I also
could write a Wiki about Stateful Filter WHENTO-and-HOWTO.


Cheers,
 -Rick


struct icmphdr_udphdr {
	struct icmphdr ih;
	struct udphdr uh;
};

const struct proto_desc proto_icmp =3D {
	=E2=80=A6
        .templates      =3D {
		=E2=80=A6
		/* ICMP travels upstream; we reverse sport/dport for icmp/l4proto */
                [THDR_SPORT]            =3D INET_SERVICE(=E2=80=9Csport",=
 struct
icmphdr_udphdr, uh.dest  ),
                [THDR_DPORT]            =3D INET_SERVICE(=E2=80=9Cdport",=
 struct
icmphdr_udphdr, uh.source),
		// Unsure about these indexes=E2=80=A6
        },
	=E2=80=A6
};

struct icmp6hdr_udphdr {
	struct icmp6hdr ih;
	struct udphdr uh;
};


const struct proto_desc proto_icmp6 =3D {
	=E2=80=A6
        .templates      =3D {
		=E2=80=A6
		/* ICMP travels upstream; we reverse sport/dport for icmp6/l4proto */
                [THDR_SPORT]            =3D INET_SERVICE(=E2=80=9Csport",=
 struct
icmphdr_udphdr, uh.dest),
                [THDR_DPORT]            =3D INET_SERVICE(=E2=80=9Cdport",=
 struct
icmphdr_udphdr, uh.source),
		// Unsure about these indexes=E2=80=A6
        },
	=E2=80=A6
};
