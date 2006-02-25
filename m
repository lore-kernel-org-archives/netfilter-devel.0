From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables target for libnetfilter_log
Date: Sat, 25 Feb 2006 09:39:14 +0100
Message-ID: <440017B2.2050504@trash.net>
References: <43FF8AA7.6000608@net.in.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gregor Maier <gregor@net.in.tum.de>
In-Reply-To: <43FF8AA7.6000608@net.in.tum.de>
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

Gregor Maier wrote:
> Hi,
> 
> I was wondering if there's already a target for the new libnetfilter_log
> mechanism or if anyone is currently writing one?

The LOG target uses is as a backend if it is loaded, but this is IMO
actually a mistake, the LOG target should keep working the same way
as it always did. Which reminds me that I wanted to restore the old
way before 2.6.16 is out ..

> If not I'd write one.

Mhh maybe we could add a flag to the LOG target to use whatever nf_log
backend is registered. I'd prefer that to a full new target.
