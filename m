From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: Passing data from user-space connections to Netfilter and back
Date: Thu, 08 Sep 2011 17:32:56 +1200
Message-ID: <4E685388.2040905@treenet.co.nz>
References: <alpine.DEB.2.00.1109061359360.25876@lap-x201>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Paolo Lucente <paolo@pmacct.net>,
  Squid Developers <squid-dev@squid-cache.org>
To: Chris Wilson <chris@aptivate.org>
Return-path: <squid-dev-return-25289-gcwsd-squid-dev=m.gmane.org@squid-cache.org>
List-Post: <mailto:squid-dev@squid-cache.org>
List-Help: <mailto:squid-dev-help@squid-cache.org>
List-Unsubscribe: <mailto:squid-dev-unsubscribe@squid-cache.org>
List-Subscribe: <mailto:squid-dev-subscribe@squid-cache.org>
In-Reply-To: <alpine.DEB.2.00.1109061359360.25876@lap-x201>
List-Id: netfilter-devel.vger.kernel.org

On 07/09/11 00:32, Chris Wilson wrote:
> Dear Netfilter and Squid developers,
>
> I'm working on software to help network administrators with slow
> Internet connections (e.g. in Africa) to monitor, understand and
> optimise their network's Internet usage.
>
> Currently we are running pmacct (reading from pcap/ULOG and generating
> flow records) and Squid (for caching and for recording the requested
> URLs, since web traffic is pretty opaque without them).
>
> We'd like to be able to record the traffic flows coming out of Squid
> towards the Internet, and associate the requested URL with a flow
> record. Unfortunately this is quite difficult because of the limited
> information available to match flow records to Squid logs:
>
> * flow accounting (pcap/ulog) sees: source IP+port (squid host+random
> high port), destination IP+port (web host, port 80 or 443), packet time;
>
> * recorded in database by flow accounting: source IP+port (squid
> host+random high port), destination IP+port (web host, port 80 or 443),
> flow timestamp (rounded to the nearest minute, multiple flow records for
> a long-lived connection);
>
> * squid sees and logs: source IP+port (squid host+random high port),
> destination IP+port (web host, port 80 or 443), connection start time, URL.
>
> We could achieve something by matching on source and destination IP and
> port, but this is not very reliable. In the case of a frequently
> accessed website (e.g. google, facebook) only the source port changes
> between connections, and this could be recycled quite quickly, leading
> to ambiguous or false accounting. This is even more true of the reverse
> proxy case (Squid in front of your web server).

Why do you call that false accounting? It is all flows from Squid to 
google, facebook, etc. Does it really matter if it was 1 flow or 10 when 
there is Mbps going through to the same place?

The problems as described appear to be side effects directly related to 
the 1 minute resolution in your database. Within any given minute 
upwards of 1,000 unique HTTP transactions may have occurred over one TCP 
flow.

>
> I think it would make sense for:
>
> * Squid to generate a (near) unique ID for the connection (or use the
> TCP ISN? 32 bit ISN + 16 bit source port = 48 bit random ID);
>
> * Squid to pass that information to Netfilter (e.g. with an ioctl() on
> the socket);
>
> * Netfilter to associate that ID with the connection (e.g. copy it into
> the CONNMARK);
>
> * Netfilter to log it to user space along with the connection's packets
> via ULOG;
>
> * pmacct to store it in the flow record in the database.
>
> Does this sound like a sensible plan? Is there any existing interface
> for a user-space application like Squid to associate opaque information
> with a connection that it makes, and for that information to make it
> back to user space via ULOG or similar? If not, where would you add it,
> and would the Netfilter and Squid teams in principle accept patches to
> make it possible?
>
> Can it be done without touching any part of the kernel except Netfilter?
> Is there already a way for a user-space application to query the ISN of
> its own TCP connections from the kernel, or communicate with Netfilter
> about them?
>
> Thanks in advance,
>
> Chris Wilson.

Regarding Squid,

  The logs contain time + duration, not just time, with a millisecond 
resolution. Reported at the termination of each request. So port 
rotation should not be relevant. For accuracy accounting needs only to 
associate the URL and IP:port tuples for all matching flow records 
across that specified duration.

  You may also want to have a look at the capabilities which we are 
currently stabilizing in squid 3.2.0.9 and later. They have more 
reliable IP:port details able to be logged regarding the connections. 
Along with flexible modules able to be added easily for realtime logging 
to any API you want.
  IPFIX logging has been requested, but not added yet. If you are 
interested in sponsoring or doing that modules implementation please 
contact me off-list.


Amos Jeffries
Squid HTTP Proxy Project
