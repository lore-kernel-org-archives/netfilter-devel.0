From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Can iptables REDIRECT traffic to a range of ports in one command?
Date: Tue, 20 Apr 2004 10:53:57 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404200640380.29251-100000@filer.marasystems.com>
References: <BAY7-F619fiD0yzNrUD0005c8b5@hotmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Grace Li <zheyinli@hotmail.com>
In-Reply-To: <BAY7-F619fiD0yzNrUD0005c8b5@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 19 Apr 2004, Grace Li wrote:

> I would like to intercept traffic to a range of ports, say port 2000-3000 to 
> one port locally, say port 3333. I am wondering if there is a simple way to 
> do it, like specify a range in iptables instead of writing a script to 
> speficy for each port?


>From the manual:

  --destination-port [!] port[:port]
        Destination port or port range specification.  The flag 
        --dport is a convenient alias for this option.


Regards
Henrik
