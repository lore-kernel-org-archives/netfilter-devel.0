From: "Daniel F. Chief Security Engineer -" <danielf@supportteam.net>
Subject: Fwd: Re: Interesting request. block x.x.0.0
Date: Thu, 23 Jan 2003 16:42:40 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200301231642.40937.danielf@supportteam.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

anyone on devel that can help me here. 

----------  Forwarded Message  ----------

Subject: Re: Interesting request. block x.x.0.0
Date: Thu, 23 Jan 2003 13:57:01 -0600
From: "Daniel F. Chief Security Engineer -" <danielf@supportteam.net>
To: Ilguiz Latypov <ilguiz@nit.ca>
Cc: netfilter <netfilter@lists.netfilter.org>

Here in lies the problem.

Im only getting traffic from x.x.0.0

I do not want to block every IP on say 45.208.0.0/16 just the ips ending in
0.0 as the last two octets.

I can write a tcpdump filter to find the traffic Im just not sure if we have
 a way to craft a netfilter rule to do so. Or maybe the "recent" patch could
 be of use. Although the dDoS included 65000 source IP addresses. all ending
 in 0.0 for the ip address.

the tcdump filter looks like this.

tcpdump -nn -i eth0 'ip[18:2] == 00'

this is pretty a simple match to make, was wondering if anyone has a patch or
addon that does this or if there is a way to do this with standard rules.

Thanks

On Thursday 23 January 2003 12:54, Ilguiz Latypov wrote:
> On Thu, 23 Jan 2003, Daniel F. Chief Security Engineer - wrote:
> > Anybody know of a way to block this traffic. Notice it's comming from
> > just the 0.0 addresses obviously spoofed. But can you block x.x.0.0 with
> > out blocking every thing else in the range with out a rule per IP.
>
> Can the CIDR approach to networking be of any help?  I heard that the
> traditional imaginary separation of networks into classes A, B, C,... is
> not quite useful, so it is now possible to specify network numbers in
> format
>
>    X.X.X.X/N
>
> where N is the number of most significant bits.
>
> Based on the above, will the 45.208.0.0/32 notation in an iptables rule
> filter the unwanted packets without rejecting any other possible valid
> packets coming from 45.208.0.0/16?

--
Daniel Fairchild - Chief Security Engineer | danielf@supportteam.net
The distance between nothing and infinity is always the same no matter how
close you get to nothing.

-------------------------------------------------------

-- 
Daniel Fairchild - Chief Security Engineer | danielf@supportteam.net
The distance between nothing and infinity is always the same no matter how 
close you get to nothing.
