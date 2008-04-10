From: "Eric Leblond" <eric@inl.fr>
Subject: Re: SVN ULOG2
Date: Thu, 10 Apr 2008 13:00:28 +0200 (CEST)
Message-ID: <52708.62.160.220.138.1207825228.squirrel@mail.inl.fr>
References: <200804091520.28617.anton.vazir@gmail.com>
    <47FCA1F6.2000204@netfilter.org>
    <200804091624.19125.anton.vazir@gmail.com>
    <c4b050a10804100119m488a00a1hee1c3a2768ea736d@mail.gmail.com>
    <51855.62.160.220.138.1207819513.squirrel@mail.inl.fr>
    <c4b050a10804100355i2fafe654w8d33ef52eb0af71b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Eric Leblond" <eric@inl.fr>,
	"Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Anton VG" <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:47306 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbYDJLAb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2008 07:00:31 -0400
In-Reply-To: <c4b050a10804100355i2fafe654w8d33ef52eb0af71b@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

> In the case when "ulog2" instead "ulog" in the config - it fails even
> sooner. See output below... I noticed that there is no table ulog, but
> since it 's written so in sample config file, and there is a view,
> named "ulog" in the DB schema - I supposed that should be so. The
> "timestamp" row it's failing - passed normally when "ulog" table is
> used.

I wrote ulogd2_ct and not ulog2 ;)

The table argument contains the list of fields that will be needed as
INPUT key. In the SQL schema ulog and ulog2 are for packet based logging.
The flow based logging table is ulog2_ct.

>> Ok, it seems you've pointed to the wrong 'table' option. You should not
>>  point to ulog but to ulog2_ct.

BR,
--
Eric Leblond
INL : http://www.inl.fr
NuFW, Now User Filtering Works (http://www.nufw.org)

