From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: Checkentry called twice?
Date: Tue, 31 Mar 2009 14:32:39 +0200
Message-ID: <17e3a8f80903310532v44eadf72we077a301d1199aa9@mail.gmail.com>
References: <17e3a8f80903310416w788a6379pb8184013a068c6a9@mail.gmail.com>
	 <17e3a8f80903310503r3fd630d6m7822f406e3694d9d@mail.gmail.com>
	 <alpine.LSU.2.00.0903311428080.14162@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:49853 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZCaMcm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Mar 2009 08:32:42 -0400
Received: by fxm2 with SMTP id 2so2410896fxm.37
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2009 05:32:40 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0903311428080.14162@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 31, 2009 at 2:28 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Tuesday 2009-03-31 14:03, Kristian Evensen wrote:
>
>>After looking more into this, it seems that checkentry is called for
>>every rule up to and including the one I added. For example, if give
>>each a unique ID and outputs the id, then the first three -A give me:
>
> checkentry is called for all rules, since whole tables are replaced
> every time you call iptables.
>

Ok, that explains it. Is there a way to avoid this or is it simply the
way it is? The reason I want to avoid this is that I want to keep some
of the values stored in the existing rule's data structures while
being able to add new rules.

-Kristian
