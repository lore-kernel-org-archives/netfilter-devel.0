From: don-netf@isis.cs3-inc.com (Don Cohen)
Subject: Fwd: Re: Interesting request. block x.x.0.0
Date: Thu, 23 Jan 2003 17:04:05 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <15920.37125.743591.125495@isis.cs3-inc.com>
References: <20030123232639.14408.11687.Mailman@kashyyyk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, <danielf@supportteam.net>,
   Ilguiz Latypov <ilguiz@nit.ca>
In-Reply-To: <20030123232639.14408.11687.Mailman@kashyyyk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

 > I do not want to block every IP on say 45.208.0.0/16 just the ips ending in
 > 0.0 as the last two octets.
 > 
 > I can write a tcpdump filter to find the traffic Im just not sure if we have
 >  a way to craft a netfilter rule to do so. Or maybe the "recent" patch could
 >  be of use. Although the dDoS included 65000 source IP addresses. all ending
 >  in 0.0 for the ip address.
 > 
 > the tcdump filter looks like this.
 > 
 > tcpdump -nn -i eth0 'ip[18:2] == 00'

The u32 match I recently posted can do this.
