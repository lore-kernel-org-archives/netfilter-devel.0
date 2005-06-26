From: Marcus Sundberg <marcus@ingate.com>
Subject: Re: Checksum of IP header
Date: Sun, 26 Jun 2005 20:13:33 +0200
Message-ID: <42BEF04D.8040708@ingate.com>
References: <ada605fb050626041856c71794@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: John Que <qwejohn@gmail.com>
In-Reply-To: <ada605fb050626041856c71794@mail.gmail.com>
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

John Que wrote:
>        Namely, what I change is :
>                skb->nh.iph->daddr = newIPAddress (in u32 ).
> 
>        Everything works OK and the packets are sent to the new
>        destination as I can see with the sniffer; except foo the csum.

Have a look at the ip_nat_cheat_check() function in ip_nat_core.c -
it does exactly what you want.

//Marcus
-- 
---------------------------------------+--------------------------
  Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
 Software Developer, Ingate Systems AB |  http://www.ingate.com/
