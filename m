From: "NICOLAS BOULIANE" <nicboul@gmail.com>
Subject: Re: Updated geoip patchlet for iptables 1.4.0 / 2.6.24.3
Date: Thu, 13 Mar 2008 23:02:58 -0800
Message-ID: <dd45289d0803140002q6a77394dsd821df10b5c6261b@mail.gmail.com>
References: <1205410278.16631.0.camel@localhost>
	 <Pine.LNX.4.64.0803131351230.14822@fbirervta.pbzchgretzou.qr>
	 <ae6a86ba0803130601o3bd10021o69effed74c6cc86c@mail.gmail.com>
	 <Pine.LNX.4.64.0803131410170.14822@fbirervta.pbzchgretzou.qr>
	 <ae6a86ba0803130643j7b5a83b1ub6141f60e0e4739a@mail.gmail.com>
	 <Pine.LNX.4.64.0803132150210.14822@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Samuel Jean" <peejix@gmail.com>,
	"Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>,
	acidfu@people.netfilter.org
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:28715 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbYCNHC7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Mar 2008 03:02:59 -0400
Received: by rv-out-0910.google.com with SMTP id k20so2305082rvb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Mar 2008 00:02:58 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.64.0803132150210.14822@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry guys I was in Varanasi for the last 2 weeks,
I will read the thread tomorrow.

thanks.

Nick

On Thu, Mar 13, 2008 at 1:12 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
>  On Mar 13 2008 09:43, Samuel Jean wrote:
>  >On Thu, Mar 13, 2008 at 9:31 AM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>  >>
>  >>  On Mar 13 2008 09:01, Samuel Jean wrote:
>  >>  >Would you mind to send a patch to Patrick about this ?
>  >>
>  >>  I am not sure whether this would go into mainline kernel.
>  >
>  >Uhm.. I don't think it will ever go into mainline, geoip is
>  >fully dependant on 3rd parties databases.
>
>  Is the db redistributable; what does the license say?
>
>  BTW, geoip.c is coded like checkentry() could be called twice
>  without a destroy in between -- how is this possible anyway?
>
>         /*
>          * If info->refcount is not NULL, then it means that checkentry()
>          * already initialized this entry. Increase a refcount to prevent
>          * destroy() of this entry.
>          */
>
