From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: unresolved symbol ip_conntrack_find_get
Date: 15 Sep 2003 13:22:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1063624939.2123.15.camel@henrik.marasystems.com>
References: <20030911155756.50469.qmail@web14915.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: sanoj mg <sanoj_mg@yahoo.com>
In-Reply-To: <20030911155756.50469.qmail@web14915.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

tor 2003-09-11 klockan 17.57 skrev sanoj mg:
> hi all,
>        just been playing with netfilter. When I try to insmod a module
> which uses
> ip_conntrack_find_get , i am getting the error message : "unresolved
> symbol -ip_conntrack_find_get" .

What kernel and iptables are you using? This error should only be seen
if you are using a old kernel with a old version of iptables.

Regards
Henrik

-- 
Henrik Nordstrom <hno@marasystems.com>
MARA Systems AB
