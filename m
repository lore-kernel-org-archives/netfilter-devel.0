From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: [PATCH] netfilter: ECN target corrupts packets (2.6 only)
Date: Sun, 2 Jan 2005 16:07:29 +0100
Message-ID: <1625859504.20050102160729@dns.toxicfilms.tv>
References: <1104664660.17292.19.camel@localhost.localdomain>
Reply-To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1104664660.17292.19.camel@localhost.localdomain>
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

Hello Rusty,

Sunday, January 2, 2005, 12:17:40 PM, you wrote:

> Name: ipt_ECN corrupt checksum fix
> Status: Tested under nfsim
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

> Nasty bug, caught while writing the ECN target test.  Corrupts
> checksums of packets when target is used on them.

> Let this be a warning on the evils of casts.
Heh, so that's why ECN stopped working for me :-)
I will check that out.

I did tcpdumps but for some strange reason I could not see
the problem there. Maybe tcpdump got premangled packets..

Regards,
Maciej
