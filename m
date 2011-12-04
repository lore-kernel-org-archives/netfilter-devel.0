From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: Rule counter update bug in ebtables-v2.0.10-2
Date: Sun, 04 Dec 2011 09:36:58 +0000
Message-ID: <4EDB3F3A.1000903@pandora.be>
References: <6E506E1B-00FB-4900-8EE3-9C72F26B8CD0@linode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: James Sinclair <james.sinclair@linode.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from brigitte.telenet-ops.be ([195.130.137.66]:35723 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab1LDJhH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Dec 2011 04:37:07 -0500
In-Reply-To: <6E506E1B-00FB-4900-8EE3-9C72F26B8CD0@linode.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 29-11-11 21:08, James Sinclair wrote:
> I was doing some testing with the latest ebtables and I think I've found a bug in ebt_deliver_counters that was introduced in the following commit:
> 
> http://ebtables.cvs.sourceforge.net/viewvc/ebtables/ebtables2/userspace/ebtables2/communication.c?r1=1.40&r2=1.41
> 
> It seems that the chainnr++ on line 308 is only reached when entries is NULL, causing the code to repeatedly loop over the rules for the first non-empty chain. This manifests as every chain having its counters copied from the first non-empty chain instead of getting the counters assigned with -c:

Thanks for the bug report. I've applied the following fix instead.

--- ebtables-v2.0.10-2/communication.c	2011-08-11 19:56:16.000000000 +0100
+++ ebtables-v2.0.10-3/communication.c	2011-12-04 09:29:23.000000000 +0000
@@ -309,6 +309,7 @@ void ebt_deliver_counters(struct ebt_u_r
 	new = newcounters;
 	while (cc != u_repl->cc) {
 		if (!next || next == entries->entries) {
+			chainnr++;
 			while (chainnr < u_repl->num_chains && (!(entries = u_repl->chains[chainnr]) ||
 			       (next = entries->entries->next) == entries->entries))
 				chainnr++;

cheers,
Bart



-- 
Bart De Schuymer
www.artinalgorithms.be
