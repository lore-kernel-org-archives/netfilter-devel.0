From: Patrick McHardy <kaber@trash.net>
Subject: Re: Ebtables hook order anomaly
Date: Wed, 26 Mar 2008 08:16:11 +0100
Message-ID: <47E9F83B.1080503@trash.net>
References: <925A849792280C4E80C5461017A4B8A226A028@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Greg Scott <GregScott@InfraSupportEtc.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:13535 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbYCZHQT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2008 03:16:19 -0400
In-Reply-To: <925A849792280C4E80C5461017A4B8A226A028@mail733.InfraSupportEtc.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Greg Scott wrote:
>> Thats indeed inconsistent. I don't believe this has changed however, 
>> the IPv4 POSTROUTING hook was always called from the bridge 
>> POSTROUTING hook (with similar priorities).
> 
> Well, OK - so I guess the most important question now is, are there any
> other behavior changes of this nature coming up so I can get ready for
> them in advance?  I'm kind of hoping for no more rude midnight
> surprises.  :)

Looking at feature-removal-schedule, not from my side :)
