From: =?ISO-8859-1?Q?=C1lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>
Subject: Re: [nft PATCH 3/4] datatype: add symbolic_constant_parse_table()
Date: Mon, 22 Sep 2014 11:05:58 +0200
Message-ID: <541FE676.6080807@gmail.com>
References: <1411327957-19379-1-git-send-email-alvaroneay@gmail.com> <1411327957-19379-3-git-send-email-alvaroneay@gmail.com> <20140922075902.GJ4971@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41814 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbaIVJFq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:05:46 -0400
Received: by mail-wi0-f180.google.com with SMTP id q5so2521169wiv.7
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Sep 2014 02:05:45 -0700 (PDT)
In-Reply-To: <20140922075902.GJ4971@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

El 22/09/14 09:59, Patrick McHardy escribi=F3:
> On Sun, Sep 21, 2014 at 09:32:36PM +0200, Alvaro Neira Ayuso wrote:
>> This function finds the symbol inside the table that you pass as par=
ameter.
>> If the symbol doesn't exist we use the basetype to parse it and
>> symbolic_constant_parse().
>
> I'm thinking that we should probably do this in all cases and not
> specific to mark and ICMP types. At least I can't see a reason not
> to.
>

Sorry Patrick, I don't understand your answer. Could you elaborate that=
?=20
Looks good for you?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
