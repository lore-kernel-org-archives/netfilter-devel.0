From: Philip Craig <philipc@snapgear.com>
Subject: Re: /proc/net/ip_conntrack does not list all connections
Date: Mon, 25 Nov 2002 10:35:31 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DE17053.1070500@snapgear.com>
References: <1038075353.86497.yihyung@so-net.net.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

yihyung wrote:
> I made a patch to fix it for my 2.4.19 kernel.

/proc/net/ip_masquerade has similar problems, as does
/proc/net/ip_tables_names (although you will probably
never have enough table names for that one to occur).
I posted a patch for these a while ago:

http://lists.netfilter.org/pipermail/netfilter-devel/2002-February/006716.htm
