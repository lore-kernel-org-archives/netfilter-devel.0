From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: Re: How to account traffic in IPTABLES?
Date: Mon, 31 Mar 2003 12:10:29 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E887685.9070000@videotron.ca>
References: <20030330134802.CF9351C462B39@sm204.163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7BIT
Cc: "netfilter-devel@lists.netfilter.org"
 <netfilter-devel@lists.netfilter.org>,
 "netfilter@lists.netfilter.org" <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bobo <boboaq@163.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Bobo wrote:

> HI
>
>      I use the iptables + squid as the gateway of one LAN,and it is very good in fact.
>
>   Now,I would like to get the traffic accounting of each IP of the LAN.
>
>  How to get these data ? Does IPtables contain these data?
>  
>

try this one:

iptables -nvL INPUT

>  Are there some tools for traffic accounting of iptables?
>  
>

The iptables command itself !!!

>  I could use perl and shell programing.Could I analyze the log file of iptables to account?
>  
>

in Perl:

open(CHAINS, "iptables -nvL INPUT|") or die "Error reading chains\n";

while(<CHAINS>)
{
# read the lines one by one, matching on the text you want
}

close(CHAINS);

>  Thanks
>
>
>
>
>
>  
>
