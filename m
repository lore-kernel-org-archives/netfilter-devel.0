From: "Daniel F. Chief Security Engineer -" <danielf@supportteam.net>
Subject: Re: Fwd: Re: Interesting request. block x.x.0.0
Date: Fri, 24 Jan 2003 08:53:13 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200301240853.13635.danielf@supportteam.net>
References: <20030123232639.14408.11687.Mailman@kashyyyk> <15920.37125.743591.125495@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: don-netf@isis.cs3-inc.com (Don Cohen),
        netfilter <netfilter@lists.netfilter.org>,
        netfilter-devel@lists.netfilter.org
In-Reply-To: <15920.37125.743591.125495@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick Schaaf kindly pointed out that I could do this. 

iptables -I INPUT -s 0.0.0.0/0.0.255.255 -j DROP

That will drop any IP that ends in 0.0

Thanks for every ones help. 

I will also look into the u32 patch thanks again. 



On Thursday 23 January 2003 19:04, you wrote:
>  > I do not want to block every IP on say 45.208.0.0/16 just the ips ending
>  > in 0.0 as the last two octets.
>  >
>  > I can write a tcpdump filter to find the traffic Im just not sure if we
>  > have a way to craft a netfilter rule to do so. Or maybe the "recent"
>  > patch could be of use. Although the dDoS included 65000 source IP
>  > addresses. all ending in 0.0 for the ip address.
>  >
>  > the tcdump filter looks like this.
>  >
>  > tcpdump -nn -i eth0 'ip[18:2] == 00'
>
> The u32 match I recently posted can do this.

-- 
Daniel Fairchild - Chief Security Engineer | danielf@supportteam.net
The distance between nothing and infinity is always the same no matter how 
close you get to nothing.
