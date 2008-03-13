From: "Samuel Jean" <peejix@gmail.com>
Subject: Re: Updated geoip patchlet for iptables 1.4.0 / 2.6.24.3
Date: Thu, 13 Mar 2008 09:43:52 -0400
Message-ID: <ae6a86ba0803130643j7b5a83b1ub6141f60e0e4739a@mail.gmail.com>
References: <1205410278.16631.0.camel@localhost>
	 <Pine.LNX.4.64.0803131351230.14822@fbirervta.pbzchgretzou.qr>
	 <ae6a86ba0803130601o3bd10021o69effed74c6cc86c@mail.gmail.com>
	 <Pine.LNX.4.64.0803131410170.14822@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>,
	acidfu@people.netfilter.org
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:30912 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbYCMNnz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Mar 2008 09:43:55 -0400
Received: by fk-out-0910.google.com with SMTP id z23so3373078fkz.5
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2008 06:43:52 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.64.0803131410170.14822@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 13, 2008 at 9:31 AM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
>  On Mar 13 2008 09:01, Samuel Jean wrote:
>  >Would you mind to send a patch to Patrick about this ?
>
>  I am not sure whether this would go into mainline kernel.

Uhm.. I don't think it will ever go into mainline, geoip is
fully dependant on 3rd parties databases.

>  I can see that the
>  code does need cleanup, so I'll do that and import it into
>  xtables-addons for the time being.

Looks great but updating the patch-o-matic's sources.list file
with the proper URL and maintainer name will make people
stop wasting precious time hacking geoip unless they are
aware that geoip's been imported into xtables-addons.

And by the way, keep up the good work.

Samuel
