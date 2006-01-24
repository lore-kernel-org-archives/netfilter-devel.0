From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [feature request] Fixed timeout for conntrack entry
Date: Tue, 24 Jan 2006 17:11:33 +0000
Message-ID: <43D65FC5.4080205@ufomechanic.net>
References: <1138008265.11978.29.camel@localhost.localdomain>
	<43D57525.7080907@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: nufw-core-team@nufw.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
In-Reply-To: <43D57525.7080907@eurodev.net>
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

Pablo Neira Ayuso wrote:
> I think that we could add support for permanent conntracks, eg.
> conntracks that never expire. So the userspace program could have their
> own timers and kill it whenever it wants to. The problem is that the
> userspace program must behave correctly, otherwise we could get tons of
> zombie conntracks that never expire.

Maybe it could be the user process that resets the timeout so that it 
never expires. If the user process fails to do this, then it is an 
un-cared for zombie and so the kernel should kill it rather than fill 
the conntrack hash full of zombies.

Naturally the user process can kill the contrack when the user process 
thinks it should have expired.

Sam
