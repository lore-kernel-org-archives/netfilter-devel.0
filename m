From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] IPMARK - version with xtables (for 2.6.16 kernel)
Date: Wed, 29 Mar 2006 11:04:58 +0200
Message-ID: <442A4DBA.1070206@trash.net>
References: <Pine.GSO.4.63.0603201123260.27093@galaxy.agh.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Grzegorz Janoszka <Grzegorz@Janoszka.pl>
In-Reply-To: <Pine.GSO.4.63.0603201123260.27093@galaxy.agh.edu.pl>
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

Grzegorz Janoszka wrote:
> 
> Hello,
> 
> Attached is patch to patch-o-matic-ng-20060319 but it should apply
> clearly to any of current development snapshots. All the changes are to
> fulfill kernel 2.6.16 and xtables requirements.
> Please include it.

Why do you want to port it to x_tables? So far your port still only
works with IPv4. Are you planning to add IPv6 support?
