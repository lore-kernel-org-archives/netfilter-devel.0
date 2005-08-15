From: David Stes <stes@pandora.be>
Subject: Re: port to Linux 2.6 of the RPC/RSH modules
Date: Mon, 15 Aug 2005 10:29:20 +0200
Message-ID: <43005260.809@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: jengelh@linux01.gwdg.de
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


 > What does this have to do with netfilter ?

RPC and RSH modules are connection tracking modules of netfilter.
For Sun RPC and BSD rexec/rcmd.
See patch-o-matic-ng extra

This is the excellent work of Marcelo Lima (RPC) and Ian Latter (RSH).

These modules should in my opinion be part of the standard netfilter 
modules (and not be in "patch-o-matig").  But netfilter is unfortunately 
changed so the modules (of 2.4) do not work any more.

For example, it appears that both modules do things like:

    rpc_helpers[port].timeout  = 0;

and the current (subversion latest source)  does

    ip_conntrack_core.c : BUGON(me->timeout == 0)

which means that as they are right now, both the RSH and the RPC modules 
"bug on" their timeout values (of zero) and obviously do not work.
