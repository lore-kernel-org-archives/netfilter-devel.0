From: Jonas Berlin <jberlin@niksula.hut.fi>
Subject: Re: ULOG target for ipv6
Date: Tue, 15 Feb 2005 02:11:37 +0200
Message-ID: <42113E39.1030000@niksula.hut.fi>
References: <42086F50.9090504@niksula.hut.fi>
	<53965.213.236.112.75.1107867276.squirrel@213.236.112.75>
	<420BEAFB.9070405@niksula.hut.fi>
	<20050214232510.GK3829@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
In-Reply-To: <20050214232510.GK3829@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:

>;) I've merged it into pom-ng (Rev. 3694).  I'm not quite happy about
>ulogd from userspace having no idea whether the packet came from the
>ipv4 or ipv6 stack - but I think it's fine for now.
>  
>
Nice :)

I actually meant that ulogd probably isn't expecting ipv6 packets (since 
there was no ipv6 support before) and I thus don't know what ulogd will 
do when it gets one.

Ulogd can figure out which stack the packet came from simply by looking 
at the it (check if it contains an ipv4 or ipv6 header). Or at least 
that's how I think it should work :)

>Well, there are no instructions.  Patches to the HOWTO's or new
>documentation is always welcome.
>  
>
Sure.. I found README.newpatches in pom-ng which helped creating the 
patch but did not mention how to submit.. Is the proper way to send a 
message to netfilter-devel with a subject starting with [ANNOUNCE] or 
[PATCH] or something like that? And any wishes/requirements regarding 
the message content of the announcement?

-- 
- xkr47
