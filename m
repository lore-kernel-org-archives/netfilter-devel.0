From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH nf-next] netfilter: ct: check return code from nla_parse_tested
Date: Thu, 20 Jun 2013 11:47:48 +0200
Message-ID: <51C2CFC4.4020302@redhat.com>
References: <1371052491-23863-1-git-send-email-dborkman@redhat.com> <20130620094500.GA6225@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756183Ab3FTJrz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:47:55 -0400
In-Reply-To: <20130620094500.GA6225@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06/20/2013 11:45 AM, Pablo Neira Ayuso wrote:
> On Wed, Jun 12, 2013 at 05:54:51PM +0200, Daniel Borkmann wrote:
>> These are the only calls under net/ that do not check nla_parse_nested()
>> for its error code, but simply continue execution. If parsing of netlink
>> attributes fails, we should return with an error instead of continuing.
>> In nearly all of these calls we have a policy attached, that is being
>> type verified during nla_parse_nested(), which we would miss checking
>> for otherwise.
>
> Applied, thanks Daniel.
>
> I'm going to run some tests, this may uncover wrong policies as they
> were not enforced.

Ok, sounds good, thanks Pablo !
