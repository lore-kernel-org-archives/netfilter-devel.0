Return-Path: <SRS0=iBHO=7Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 498F8C433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Jun 2020 18:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA1B4206DC
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Jun 2020 18:43:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=openfortress.nl header.i=rick@openfortress.nl header.b="ILtLi4wl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgFLSnL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Jun 2020 14:43:11 -0400
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:55619 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726275AbgFLSnL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Jun 2020 14:43:11 -0400
Received: from popmini.vanrein.org ([IPv6:2001:980:93a5:1::7])
        by smtp-cloud9.xs4all.net with ESMTP
        id jodwjpxLOK7ldjodxjOEhO; Fri, 12 Jun 2020 20:43:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=openfortress.nl; 
 i=rick@openfortress.nl; q=dns/txt; s=fame; t=1591987388; 
 h=message-id : date : from : mime-version : to : cc : 
 subject : references : in-reply-to : content-type : 
 content-transfer-encoding : date : from : subject; 
 bh=StFYkCa7L34UJ+2h1vNW5X1R528+AhO8Kj6Idk0gaG0=; 
 b=ILtLi4wl4WFilW8sIJVUex4suaZbS+GJ6TRusfDzYfOEqmLfzescTzrZ
 L+R6+GP7J2uJh9mQE9VEda7LsM0IY/42bNfyLoyMkroOlCIf5YsAKzqfpq
 6qPa3xeQ+JRyfRGvjfrZWYx9QxklgYGsnXIyhNmjhqgk5qcJx6qS8SUJk=
Received: by fame.vanrein.org (Postfix, from userid 1006)
        id D68F43D4EE; Fri, 12 Jun 2020 18:43:06 +0000 (UTC)
Received: from airhead.fritz.box (phantom.vanrein.org [83.161.146.46])
        by fame.vanrein.org (Postfix) with ESMTPA id B5F6A3D4F0;
        Fri, 12 Jun 2020 18:43:06 +0000 (UTC)
Message-ID: <5EE3CCA5.5020405@openfortress.nl>
Date:   Fri, 12 Jun 2020 20:42:45 +0200
From:   Rick van Rein <rick@openfortress.nl>
User-Agent: Postbox 3.0.11 (Macintosh/20140602)
MIME-Version: 1.0
To:     Florian Westphal <fw@strlen.de>
CC:     netfilter-devel@vger.kernel.org
Subject: Re: Extensions for ICMP[6] with sport, dport
References: <5EDE75D5.7020303@openfortress.nl> <20200609094159.GA21317@breakpoint.cc> <5EDF687A.6020801@openfortress.nl> <20200612163457.GB16460@breakpoint.cc>
In-Reply-To: <20200612163457.GB16460@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Bogosity: Unsure, tests=bogofilter, spamicity=0.520000, version=1.2.4
X-CMAE-Envelope: MS4wfIFi2lQ8r6nexledSy3p4bM0PMTpyR6mVWAAH1W/QCpvkd4ve+Dk8RMOC9kXxpXp6G4nZsPmeItZKaHo0JzNqq4stfdh+ab+jVAtpH7luDs37xBlWlEZ
 pzIyQEyl3/+tTf/tV1k6A918aZOu6oYDkGBfSYlZKjUpqFTX5BRNGW2jIqKVr72jZl6Cn//sZbijY+8LIixKkIixEeaGdS4HL74=
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

>>  - ICMP-contained content must be NAT-reversed, unlike tunnel content
> nf_nat takes care of this automatically.

Hmyeah, I know.  I am really trying with stateless NAT, which I know is not the general advise.  Intending to push p2p applications, I fear that things like a TCP SYN from two ends at the same time are asking for trouble.

>> ip protocol icmp
>> icmp protocol { tcp, udp, sctp, dccp }
>
> What would that do?  "ip protocol" of embedded ip header?

Yes, that's what I meant with this.

>> icmp th daddr set
>>    icmp th dport map @my-nat-map
>
> th daddr looks weird to me, but syntax could
> be changed later.

Yes, I made a mistake.  It should have said "icmp ip daddr set".

On a side note, I found a good reason for "th daddr" instead of "@th,16,16" that goes beyond readability: its typing can be used in a map with inet_service, unlike @th,16,16 which is a variably-sized integer.

>> If this ends up being kernel work, then I'm afraid I will have to let go.
>
> It can probably be done using fixed offsets for this
> specific case but its likely a lot of work wrt. dependency
> checking and providing readable syntax for "nft list" again.

Thanks for warning me upfront.  I will try to stay away from it then until I really have the time.

Best,
 -Rick
