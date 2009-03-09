From: Chris Hanson <chanson@bluebottle.com>
Subject: Suggestion: "--match recent --set --life-span <secs>"  to prevent
 table filling up
Date: Mon, 09 Mar 2009 15:48:39 -0700
Message-ID: <49B59CC7.7080002@bluebottle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mi0.bluebottle.com ([206.188.25.15]:48772 "EHLO
	mi0.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbZCIXZs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Mar 2009 19:25:48 -0400
Received: from fe2.bluebottle.com (internal.bluebottle.com [206.188.24.43])
	by mi0.bluebottle.com (8.13.1/8.13.1) with ESMTP id n29Mmh5P004823
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Mon, 9 Mar 2009 22:48:44 GMT
Received: from hulk.roslyn.dyndns.org (66-233-57-27.bel.clearwire-dns.net [66.233.57.27])
	(authenticated bits=0)
	by fe2.bluebottle.com (8.13.1/8.13.1) with ESMTP id n29MmdwQ031851
	for <netfilter-devel@vger.kernel.org>; Mon, 9 Mar 2009 22:48:43 GMT
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

A suggestion for the match recent part of netfilter. Include a life_span 
field in the table. A host is removed from a table after it hasn't been 
seen for x seconds.

I suggest this because of the number of botnet hosts that rapidly fill 
up the /proc/net/ipt_recent tables. Sometimes an attacking host is only 
seen once in a long probe/attack.


Additional related suggestions:

Perhaps just reuse the --seconds parameter on a --set. instead of adding 
a new parameter.

Give the field a default value. (3600?)

Have a module command line parameter for changing the default value.

Use 0 for an infinite life_span.


I apologize for not being able to submit code. I tried looking at the 
source and I soon realized that my coding skills are VERY rusty.

I hope this sounds useful to you all. Keep up the good work.

Chris Hanson
