From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Bug in rpc conntrack modules
Date: 29 Apr 2003 21:15:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051643733.8200.41.camel@tux.rsn.bth.se>
References: <1051483678.5944.223.camel@tux.rsn.bth.se>
	 <20030429145550.GH684@naboo.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030429145550.GH684@naboo.intranet.astaro.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2003-04-29 at 16:55, Harald Welte wrote:

> Hi Martin.  Please note that I don't expect Marcelo to comment on your
> email.  He has written this code about three years ago and I assume he
> has abandoned the code (which is perfectly fine, every author has the
> right to do so).
>
> As the comment on top of ip_conntrack_rpc_tcp.c indicates, rusty did
> some porting, I merged it with newnat (IIRC), and Ian.Latter finally
> re-worked it again.  He probably is the one most familiar with the code
> now.

Yeah, I failed to look at the changelog in the patch itself, I just read
.patch.help which turned out to be a mistake.

> Martin, you'll have to fix it by yourself (or I will have to do it).

Ian Latter has said he'll fix it.

> Please add a bug to bugzilla, accept it and mark it as FIXED just for
> keeping track of those issues.

I'll add the bug, accept it and then mark it fixed when the patches (rpc
and rsh it turns out) are fixed.

-- 
/Martin
