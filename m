From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: How to get original destination port after REDIRECT of iptables?
Date: Wed, 14 Apr 2004 23:38:36 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404142337450.6683-100000@filer.marasystems.com>
References: <BAY7-F49ht3ZGAua7UV0004d0cb@hotmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Grace Li <zheyinli@hotmail.com>
In-Reply-To: <BAY7-F49ht3ZGAua7UV0004d0cb@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 14 Apr 2004, Grace Li wrote:

> I have know that using REDIRECT option of iptables could redirect traffic to 
> a specified remote port to another local port, for example iptables -t nat 
> -A PREROUTING -i eth0 -p tcp --dport 1888 -j REDIRECT --to-port 2000 .  The 
> original destination IP address is not changed, and could be obtained from 
> getsockopt call with specifiying SO_ORIGINAL_DST ( e.g. getsockopt (client, 
> SOL_IP, SO_ORIGINAL_DST, (struct sockaddr*)&addr, &len_t );) .

This also returns the port... the returned data is a sockaddr_in.

Regards
Henrik
