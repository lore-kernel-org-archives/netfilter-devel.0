From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: NAT breaks my TCP SYN/ACK?
Date: Tue, 16 Dec 2003 17:41:09 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FDF2795.500@netlab.hut.fi>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

Hei!

I've written a target module which for the moment performs only a simple 
redirection as follows (I took masquerade and redirect as examples to 
write this):

    newrange= ((struct ip_nat_multi_range)
    {
        1,
        {{
            IP_NAT_RANGE_PROTO_SPECIFIED | IP_NAT_RANGE_MAP_IPS,
            new_ip_target,
            new_ip_target,
            {sd_data->min_napt_port},
            {sd_data->max_napt_port}
        }}
    });

ip_nat_setup_info(conntrack, &newrange, hooknum)  /*hooknum is pre-routing*/


In my tests, I'm trying from a host at adress X to reach a website at 
address Y. However this website does not exist on that address but on 
address Z. Thus, basically in my target, I change address Y for Z. But 
the connection to the website is refused, and tcpdump shows the following:

17:25:21.568709 11.11.11.10.1262 > 10.10.10.10.www: SWE 
1338652779:1338652779(0) win 5840 <mss 1460,sackOK,timestamp 
8306468[|tcp]> (DF)
17:25:21.569136 10.10.10.10.www > 11.11.11.10.1262: R 0:0(0) ack 
1338652780 win 0 (DF)

(while if it was working it should be:
17:24:04.590007 11.11.11.10.1261 > 10.10.10.10.www: SWE 
1266184733:1266184733(0) win 5840 <mss 1460,sackOK,timestamp 
8298770[|tcp]> (DF)
17:24:04.590344 10.10.10.10.www > 11.11.11.10.1261: SE 
312659779:312659779(0) ack 1266184734 win 5792 <mss 
1460,sackOK,timestamp 8644814[|tcp]> (DF)
)

Does anyone has an idea about what happens to my SYN/ACK packet? Why is 
it modified like that?

               Emmanuel
