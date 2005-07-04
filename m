From: Roberto Nibali <ratz@tac.ch>
Subject: Re: possible issues with blowing up struct ipt_log_info
Date: Mon, 04 Jul 2005 11:26:50 +0200
Message-ID: <42C900DA.5040906@tac.ch>
References: <42C2C053.3040707@tac.ch> <20050629154049.GA17717@oknodo.bof.de>
	<20050629160923.GF3331@eychenne.org>
	<20050703123650.GW3186@sunbeam.de.gnumonks.org>
	<20050703220525.GA3331@eychenne.org>
	<20050704055541.GA29624@oknodo.bof.de> <42C8F151.9080708@tac.ch>
	<20050704085913.GX3186@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>, Herve Eychenne <rv@wallfire.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050704085913.GX3186@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

>>This does not work in environments where you need high speed logging since
>>having a pointer, or hashmap value, would require an intermediate process to
>>translate it into parsable strings again. This is from an
>>architectural point of view and from a performance point of view not
>>possible, at least not in our environment.
> 
> If you care about performance, tou don't do hgh speed logging via
> syslog.  I have some numbers comparing LOG with ULOG in multiple setup,
> and it's in some cases a factor of 100 ...

We are also using ULOG but not everywhere, because not all the meta rules have
been converted to using it yet.

> OTOTH, ULOG also has a prefix, so the argument remains.  However, I'm
> happy if somebody wanted to contribute an ulogd plugin to do that kind
> of translation.

Interesting idea, haven't thought that far (as always on mondays).

> And anyways, you can defer such processing until the logs are actually
> being analyzed.  It doesn't have to happen at the time where you have
> your load spike and just want to get the data to disk.

True to a certain extent.

The problem is that a lot of different software systems have to be integrated
and we cannot afford or don't have access to all code to change all backend
logic to do this. And then imagine having a central logging system doing the log
evaluation for thousands of systems, among those, the packet filters running
netfilter. Now let's say we have 10 packet filter in location A, 15 in location
B. Location A has 3 sysadmins who work together and maintain a single mapping
file for all log prefixes, Location B has 5 sysadmins but 2 groups of them which
work completely orthogonal to each other when it comes to defining log prefixes.
The central logging infrastructure is maintained by a third party company. Due
to many facets of security and the complexity involved I'd say that it's close
to impossible to defer the analysis. I hope I don't have to give you a more
detailed example, because I'd be writing a whole paper to explain this situation
(which is real, we're deploying such information systems and central logging
infrastructures).

>>It would be a lot more fun to get the connection tracking table filled
>>with thousands of entries in less than 2 Minutes, so the monitoring
>>system does not have so many spikes.  Customers often ask if the
>>system is malfunctioning or down every 5-15 Minutes :).
> 
> Sorry, I don't understand what you want to convey....

My bad, it was a rather unfortunate and even wrong description. What I wanted to
do is to quote an internal bug report regarding the cat'ing of
/proc/net/ip_conntrack while having a heavily populated with entries:

"Our team reported periodic (minutely) problems with connections through the
firewall. During 2 to 3 seconds e.g. pings round trip times through the firewall
went up from several ms to more than 1 second. During the time, also working on
the packet filter was shortly interrupted. The error count on the respective
interfaces (where the ping went through) increased by about 300 to 500,
sometimes even more. If the ping was not running, the timeout were still there,
but error number did not increase on the interface."

This observation is a result of snmp polling each minute the connection tracking
table (as dumb as this may sound, but it was a requirement of a bank) and in
2.4.x the only way to do it is to basically cat the proc-fs entry which is ...
slow and error prone.

That's all, nothing to worry about for the netfilter people. We have a lot of
workarounds :).

Best regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
