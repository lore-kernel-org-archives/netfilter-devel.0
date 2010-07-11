From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCHv2] extensions: libxt_CHECKSUM extension
Date: Sun, 11 Jul 2010 22:03:44 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007112158020.10108@obet.zrqbmnf.qr>
References: <20100711151453.GA7563@redhat.com> <alpine.LSU.2.01.1007111755250.22644@obet.zrqbmnf.qr> <20100711190020.GA11244@redhat.com> <alpine.LSU.2.01.1007112141020.10108@obet.zrqbmnf.qr> <20100711195208.GB12202@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38652 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab0GKUDs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jul 2010 16:03:48 -0400
In-Reply-To: <20100711195208.GB12202@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2010-07-11 21:52, Michael S. Tsirkin wrote:
>> On Sunday 2010-07-11 21:00, Michael S. Tsirkin wrote:
>> >> >
>> >> >The problem happens in the field with virtualized applications. For 
>> >> >reference, see Red Hat bz 605555, as well as 
>> >> >http://www.spinics.net/lists/kvm/msg37660.html
>> >> 
>> >> Added to Xtables-addons.
>> >
>> >Please do not drop the explanation that bits were copied from ECN.c.
>> 
>> As far as I see it, there is nothing that deals with ECN in any way.
>
>No, the bits I copied deal with libxt boilerplate.

Falls into the category of triviality, doesn't reach a level of originality.
