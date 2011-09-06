From: Chris Wilson <chris@aptivate.org>
Subject: Passing data from user-space connections to Netfilter and back
Date: Tue, 6 Sep 2011 14:32:18 +0200 (CAT)
Message-ID: <alpine.DEB.2.00.1109061359360.25876@lap-x201>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: Paolo Lucente <paolo@pmacct.net>,
	Squid Developers <squid-dev@squid-cache.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from one-mail.aptivate.org ([87.106.150.205]:57650 "EHLO
	one-mail.aptivate.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab1IFNac (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Sep 2011 09:30:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear Netfilter and Squid developers,

I'm working on software to help network administrators with slow Internet 
connections (e.g. in Africa) to monitor, understand and optimise their 
network's Internet usage.

Currently we are running pmacct (reading from pcap/ULOG and generating 
flow records) and Squid (for caching and for recording the requested URLs, 
since web traffic is pretty opaque without them).

We'd like to be able to record the traffic flows coming out of Squid 
towards the Internet, and associate the requested URL with a flow record. 
Unfortunately this is quite difficult because of the limited information 
available to match flow records to Squid logs:

* flow accounting (pcap/ulog) sees: source IP+port (squid host+random 
high port), destination IP+port (web host, port 80 or 443), packet time;

* recorded in database by flow accounting: source IP+port (squid 
host+random high port), destination IP+port (web host, port 80 or 443), 
flow timestamp (rounded to the nearest minute, multiple flow records for 
a long-lived connection);

* squid sees and logs: source IP+port (squid host+random high port), 
destination IP+port (web host, port 80 or 443), connection start time, 
URL.

We could achieve something by matching on source and destination IP and 
port, but this is not very reliable. In the case of a frequently accessed 
website (e.g. google, facebook) only the source port changes between 
connections, and this could be recycled quite quickly, leading to 
ambiguous or false accounting. This is even more true of the reverse proxy 
case (Squid in front of your web server).

I think it would make sense for:

* Squid to generate a (near) unique ID for the connection (or use the TCP 
ISN? 32 bit ISN + 16 bit source port = 48 bit random ID);

* Squid to pass that information to Netfilter (e.g. with an ioctl() on the 
socket);

* Netfilter to associate that ID with the connection (e.g. copy it into 
the CONNMARK);

* Netfilter to log it to user space along with the connection's packets 
via ULOG;

* pmacct to store it in the flow record in the database.

Does this sound like a sensible plan? Is there any existing interface for 
a user-space application like Squid to associate opaque information with a 
connection that it makes, and for that information to make it back to user 
space via ULOG or similar? If not, where would you add it, and would the 
Netfilter and Squid teams in principle accept patches to make it possible?

Can it be done without touching any part of the kernel except Netfilter? 
Is there already a way for a user-space application to query the ISN of 
its own TCP connections from the kernel, or communicate with Netfilter 
about them?

Thanks in advance,

Chris Wilson.
-- 
Aptivate | http://www.aptivate.org | Phone: +44 1223 760887
The Humanitarian Centre, Fenner's, Gresham Road, Cambridge CB1 2ES

Aptivate is a not-for-profit company registered in England and Wales
with company number 04980791.

