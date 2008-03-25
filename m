From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: Ebtables hook order anomaly
Date: Tue, 25 Mar 2008 12:02:32 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A226A028@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>,
	"Jan Engelhardt" <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.infrasupportetc.com ([66.173.97.5]:24682 "EHLO
	mail733.InfraSupportEtc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757882AbYCYRCe convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:02:34 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Thats indeed inconsistent. I don't believe this has changed however, 
> the IPv4 POSTROUTING hook was always called from the bridge 
> POSTROUTING hook (with similar priorities).

Well, OK - so I guess the most important question now is, are there any
other behavior changes of this nature coming up so I can get ready for
them in advance?  I'm kind of hoping for no more rude midnight
surprises.  :)

Thanks

- Greg
