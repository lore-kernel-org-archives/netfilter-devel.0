From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: can I map a specific priv. ip to a pub ip? How?
Date: Sun, 11 Apr 2004 12:40:24 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404111239480.19213-100000@filer.marasystems.com>
References: <1081674472.40790ae8a9361@mail.homeccess.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: aso@homeccess.com
In-Reply-To: <1081674472.40790ae8a9361@mail.homeccess.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 11 Apr 2004 aso@homeccess.com wrote:

> however, I want to give the following private ip address to the customer,  
> 192.168.6.10. This address has to be mapped to XXX.XXX.128.35 both internally 
> and externally so as to allow a two way on-going connection. How do I go about 
> this?  

Proxy-arp and routing. Not netfilter related.

Regards
Henrik
