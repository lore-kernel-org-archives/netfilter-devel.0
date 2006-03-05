From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: Re: IPSET patches from pom-ng don't apply to 2.6.16-rc5
Date: Sun, 05 Mar 2006 12:43:41 +0100
Message-ID: <440ACEED.9050109@gmx.net>
References: <44043F49.7050304@gmx.net>
	<Pine.LNX.4.58.0603021228470.22987@blackhole.kfki.hu>
	<Pine.LNX.4.58.0603031018470.25603@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0603031018470.25603@blackhole.kfki.hu>
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

Jozsef Kadlecsik schrieb:
> On Thu, 2 Mar 2006, Jozsef Kadlecsik wrote:
> 
>>On Tue, 28 Feb 2006, Carl-Daniel Hailfinger wrote:
>>
>>>applying the ipset patch from patch-o-matic-ng doesn't work anymore:
>>>
>>>unable to find ladd slot in src /tmp/pom-26985/net/ipv4/netfilter/Makefile (./patchlets/set/linux-2.6/./net/ipv4/netfilter/Makefile.ladd)
>>
>>The marker points from net/ipv4/netfilter/Makefile were moved into
>>net/netfilter/Makefile thus those cannot be found anymore.
> 
> It is fixed in svn.

Thanks!

Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
