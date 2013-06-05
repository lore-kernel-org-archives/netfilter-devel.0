From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH v3] src: xml: add versioning
Date: Wed, 5 Jun 2013 13:06:10 +0200
Message-ID: <CAOkSjBhqT2Mn2a5CjtKRc3qf2_S4uhO-3q5cucK8kLumT1UBuQ@mail.gmail.com>
References: <20130603155815.19094.29178.stgit@nfdev.cica.es> <20130605033009.GA24974@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:54260 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab3FELGb convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:06:31 -0400
Received: by mail-lb0-f169.google.com with SMTP id d10so1739122lbj.28
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Jun 2013 04:06:30 -0700 (PDT)
In-Reply-To: <20130605033009.GA24974@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2013/6/5 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Mon, Jun 03, 2013 at 05:58:38PM +0200, Arturo Borrero wrote:
>> All XML chunks now have a "version" attribute to help in future chan=
ges.
>
> Not sure this is the best approach after reading this:
>
> http://stackoverflow.com/questions/2014237/what-are-the-best-practice=
s-for-versioning-xml-schemas
>
> Can you give it some read and get back to me with more feedback
> regarding the XML versioning approaches?
>

The version attribute could be add to the top level element (e.g.
<nftables> in the ruleset dump example I sent).
A drawback of this is that the version cannot be checked when parsing
loose/single elements.

--
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
