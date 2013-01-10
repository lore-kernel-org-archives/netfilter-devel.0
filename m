From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [RELEASE] arptables v0.0.4
Date: Thu, 10 Jan 2013 21:46:55 +0100
Message-ID: <50EF28BF.2020001@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:44444 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066Ab3AJUq6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:46:58 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

As I promised, there's a new release of the arptables utility.

Changes:
- add xtables CLASSIFY target (Frederic Leroy)
- remove compile warnings
- install improvements in Makefile (Peter Volkov)
- let --proto-type also accept hexadecimal input
- update manpage (Peter Volkov)
- bug fixes:
   - also print the -i and -o interface if -v isn't specified
   - fix handling of inversion flag (Pablo Neira Ayuso)

See http://ebtables.sourceforge.net/downloads/latest.html

cheers,
Bart

