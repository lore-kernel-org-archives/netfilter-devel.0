From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: where is the right entry point for matching a tracked related
 connection?
Date: Thu, 27 May 2004 12:45:42 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405271236210.11108-100000@filer.marasystems.com>
References: <40B52C94.20008@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matthias Dettling <m-dettling@gmx.de>
In-Reply-To: <40B52C94.20008@gmx.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 27 May 2004, Matthias Dettling wrote:

> I am searching the right place in my linux kernel source (v 2.4.26) for 
> extending the iptables command to match in a packet "RELATED" to a 
> specific connection, informations that were tracked before.


if (conntrack->master)
   master = conntrack->master->expectant

Do not forget proper locking. (I think this is needed. See helper match)

> But there is no possibility to test wheter the related connection is 
> really on port 21.

See the helper match. It is probably even closer to what you want to do..

> After reading the hacking-howto i thought that access is gained through 
> the pointer "nfct" of the "sk_buff" structure

No, this is the reference to the conntrack for this packet.. slightly 
obfuscated for various reasons..

Regards
Henrik
