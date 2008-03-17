From: "NICOLAS BOULIANE" <nicboul@gmail.com>
Subject: Re: Updated geoip patchlet for iptables 1.4.0 / 2.6.24.3
Date: Mon, 17 Mar 2008 07:30:29 -0400
Message-ID: <dd45289d0803170430p44127db2y9cd631a4cb149618@mail.gmail.com>
References: <1205410278.16631.0.camel@localhost>
	 <Pine.LNX.4.64.0803131351230.14822@fbirervta.pbzchgretzou.qr>
	 <ae6a86ba0803130601o3bd10021o69effed74c6cc86c@mail.gmail.com>
	 <Pine.LNX.4.64.0803131410170.14822@fbirervta.pbzchgretzou.qr>
	 <ae6a86ba0803130643j7b5a83b1ub6141f60e0e4739a@mail.gmail.com>
	 <Pine.LNX.4.64.0803132150210.14822@fbirervta.pbzchgretzou.qr>
	 <dd45289d0803140002q6a77394dsd821df10b5c6261b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Samuel Jean" <peejix@gmail.com>,
	"Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>,
	acidfu@people.netfilter.org
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.186]:1089 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbYCQLa3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Mar 2008 07:30:29 -0400
Received: by rv-out-0910.google.com with SMTP id k20so3162640rvb.1
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Mar 2008 04:30:29 -0700 (PDT)
In-Reply-To: <dd45289d0803140002q6a77394dsd821df10b5c6261b@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo,

# geoip, maintained by Samuel Jean <jix@bugmachine.ca>
http://people.netfilter.org/acidfu/patchlets/

Could you add me as the new official maintainer please ?
Nicolas Bouliane <acidfu@people.netfilter.org>

thanks,

Nick

On Fri, Mar 14, 2008 at 3:02 AM, NICOLAS BOULIANE <nicboul@gmail.com> wrote:
> Sorry guys I was in Varanasi for the last 2 weeks,
>  I will read the thread tomorrow.
>
>  thanks.
>
>  Nick
>
>
>
>  On Thu, Mar 13, 2008 at 1:12 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>  >
>  >  On Mar 13 2008 09:43, Samuel Jean wrote:
>  >  >On Thu, Mar 13, 2008 at 9:31 AM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>  >  >>
>  >  >>  On Mar 13 2008 09:01, Samuel Jean wrote:
>  >  >>  >Would you mind to send a patch to Patrick about this ?
>  >  >>
>  >  >>  I am not sure whether this would go into mainline kernel.
>  >  >
>  >  >Uhm.. I don't think it will ever go into mainline, geoip is
>  >  >fully dependant on 3rd parties databases.
>  >
>  >  Is the db redistributable; what does the license say?
>  >
>  >  BTW, geoip.c is coded like checkentry() could be called twice
>  >  without a destroy in between -- how is this possible anyway?
>  >
>  >         /*
>  >          * If info->refcount is not NULL, then it means that checkentry()
>  >          * already initialized this entry. Increase a refcount to prevent
>  >          * destroy() of this entry.
>  >          */
>  >
>
