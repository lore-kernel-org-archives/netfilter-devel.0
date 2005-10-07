From: "Tadas" <tpt@pupa.da.ru>
Subject: what is the purpose of "filter" table?
Date: Sat, 8 Oct 2005 02:33:56 +0300
Message-ID: <004b01c5cb97$95fb6cf0$0200000a@T>
References: <20051005.234046.88863607.davem@davemloft.net><20051007040906.GC5953@rama><20051006.131408.24379607.davem@davemloft.net>
	<20051007213523.GD4719@rama>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

As I see flter table cant do anthing usefull, 99% of modules are for mangle
and nat tables.
also dropping packets at input or forward is useless,
because conntrack will kill the atacked machine anyway.

I think it would be good idea to merge raw and filter tables into one
or add all available hooks to filter table, like prerouting and postrouting
I dont undertand what was the original purpose of filter table
since everyhing can be done in mangle table even better.
