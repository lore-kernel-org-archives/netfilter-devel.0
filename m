From: Patrick McHardy <kaber@trash.net>
Subject: Re: nat/conntrack helper locking problem?
Date: Thu, 20 Nov 2003 11:03:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FBC916A.8010501@trash.net>
References: <Pine.LNX.4.44.0311201050350.2112-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0311201050350.2112-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:

>Whenever I load/unload the ftp or irc nat/conntrack helpers with NF_DEBUG
>enabled in 2.4.22 with current p-o-m base I receive the following warning:
>
>ASSERT ip_conntrack_core.c:632 &ip_conntrack_lock not readlocked
>ASSERT ip_conntrack_core.c:632 &ip_conntrack_lock not readlocked
>
>Is this something to worry about or just a corner case which will not 
>cause any problems?
>  
>

I couldn't find the exact line in either 2.4 or 2.6, could you post it ?

Thanks,
Patrick
