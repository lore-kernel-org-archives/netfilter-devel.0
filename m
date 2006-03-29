From: Grzegorz Janoszka <Grzegorz@Janoszka.pl>
Subject: Re: [PATCH] IPMARK - version with xtables (for 2.6.16 kernel)
Date: Wed, 29 Mar 2006 11:09:47 +0200 (CEST)
Message-ID: <Pine.GSO.4.63.0603291107140.16776@galaxy.agh.edu.pl>
References: <Pine.GSO.4.63.0603201123260.27093@galaxy.agh.edu.pl>
	<442A4DBA.1070206@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <442A4DBA.1070206@trash.net>
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

On Wed, 29 Mar 2006, Patrick McHardy wrote:

>> Attached is patch to patch-o-matic-ng-20060319 but it should apply
>> clearly to any of current development snapshots. All the changes are to
>> fulfill kernel 2.6.16 and xtables requirements.
>> Please include it.
> Why do you want to port it to x_tables? So far your port still only
> works with IPv4. Are you planning to add IPv6 support?

First - I thougt all netfilter targets must go to x_tables. I saw config 
of 2.6.16 and there is no such thing like iptables there.
Second - yes, I plan ipv6 when it will be commonly used.

Best regards,

-- 
Grzegorz Janoszka
