From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: How does iptables redirect a packet that is not addressed to
 its local machine
Date: Thu, 8 Apr 2004 00:48:33 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404080046400.31008-100000@filer.marasystems.com>
References: <BAY7-DAV19wEsGmjm0800027007@hotmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Grace Li <zheyinli@hotmail.com>
In-Reply-To: <BAY7-DAV19wEsGmjm0800027007@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 7 Apr 2004, Grace Li wrote:

> Hi,
> 
> I am just wondering if anybody could explain what happened in the following experiments:
> 
> Client (192.168.1.134) tries to connect to port 1888 of Server
> (192.168.1.115) through Gateway (192.168.1.1).  In the Gateway, the iptables
> has been instructed to redirect traffic on port 1888 to 2000 (iptables -t
> nat -A PREROUTING -i eth0 -p tcp --dport 1888 -j REDIRECT -to-port 2000 ).

Works here...


> The results of my experiments is that the application on Gateway who listens
> to port 2000 could not get anything, while Server receives everything
> expected on its port 1888. So my question is that did iptables do anything
> here?

No idea. This is a kind of thing which has always worked for me, but you
are the second person in a few days reporting this is not working..

Exacly what kernel and iptables version are you using on the gateway?

What does "iptables-save -t nat" give?

Regards
Henrik
