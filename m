From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Couldn't load match `pknock':(null)
Date: Sat, 22 Aug 2009 02:17:08 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908220211070.7095@fbirervta.pbzchgretzou.qr>
References: <7e36c7130908181531r3262c9b6kf3f038f9092cc34f@mail.gmail.com>  <alpine.LSU.2.00.0908190407200.24013@fbirervta.pbzchgretzou.qr>  <7e36c7130908190915j5faa812fy34fc70626de69761@mail.gmail.com>
 <7e36c7130908211431n538a0b3kf83051b77b0d5b56@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Luis Floreani <lucholaf@gmail.com>
To: fender <frozenspot@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44885 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932981AbZHVARI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Aug 2009 20:17:08 -0400
In-Reply-To: <7e36c7130908211431n538a0b3kf83051b77b0d5b56@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-08-21 23:31, fender wrote:
>
>I've tried with the version 1.4.4 and I've got the same result:
>
>iptables v1.4.4: Couldn't load match `pknock':(null)
>
>So, iptables finds the libipt_pknock module, but it isn't able to load
>the ipt_pknock.ko. Do you have any hint to solve this?

Have you built knock against a version >= 1.4.3.2?

(A commit just prior to the iptables 1.4.3.2 tries to ensure that
modules built against 1.4.3.2 or newer have matching internal ABIs,
which should hopefully ease in finding causes for errors like
(null).)

